# frozen_string_literal: true

require 'parallel'

module RuboCop
  # This class handles the processing of files, which includes dealing with
  # formatters and letting cops inspect the files.
  class Runner # rubocop:disable Metrics/ClassLength
    # An exception indicating that the inspection loop got stuck correcting
    # offenses back and forth.
    class InfiniteCorrectionLoop < StandardError
      attr_reader :offenses

      def initialize(path, offenses_by_iteration, loop_start: -1)
        @offenses = offenses_by_iteration.flatten.uniq
        root_cause = offenses_by_iteration[loop_start..]
                     .map { |x| x.map(&:cop_name).uniq.join(', ') }
                     .join(' -> ')

        message = 'Infinite loop detected'
        message += " in #{path}" if path
        message += " and caused by #{root_cause}" if root_cause
        super(message)
      end
    end

    class << self
      # @return [Array<#call>]
      def ruby_extractors
        @ruby_extractors ||= [default_ruby_extractor]
      end

      private

      # @return [#call]
      def default_ruby_extractor
        lambda do |processed_source|
          [
            {
              offset: 0,
              processed_source: processed_source
            }
          ]
        end
      end
    end

    # @api private
    MAX_ITERATIONS = 200

    # @api private
    REDUNDANT_COP_DISABLE_DIRECTIVE_RULES = %w[
      Lint/RedundantCopDisableDirective RedundantCopDisableDirective Lint
    ].freeze

    attr_reader :errors, :warnings
    attr_writer :aborting

    def initialize(options, config_store)
      @options = options
      @config_store = config_store
      @errors = []
      @warnings = []
      @aborting = false
      @inspected_files = []
      @diff_sources = {}
      @report_queue = {}
    end

    # The `--diff` patches, one per file, from the source on disk (or stdin) to
    # the source once every correction, redundant directive removal included,
    # has been applied.
    def diffs
      @diffs ||= @diff_sources.filter_map do |file, (original_source, corrected_source)|
        diff = UnifiedDiff.new(PathUtil.smart_path(file), original_source, corrected_source).to_s
        diff unless diff.empty?
      end
    end

    def run(paths)
      @inspection_team_by_config = {}.compare_by_identity

      # Compute the cache source checksum once to avoid potential
      # inconsistencies between workers.
      ResultCache.source_checksum

      target_files = only_changed(find_target_files(paths))
      build_project_index(target_files)

      if @options[:list_target_files]
        list_files(target_files)
      else
        inspect_files(target_files)
      end
    rescue Interrupt
      self.aborting = true
      warn ''
      warn 'Exiting...'

      false
    end

    def aborting?
      @aborting
    end

    private

    # The project index is deliberately built from the unfiltered file list:
    # cross-file offenses must not depend on which files happen to have changed.
    def only_changed(target_files)
      return target_files unless @options[:changed]

      ChangedFiles.new(@options[:changed]).filter(target_files).freeze
    end

    def find_target_files(paths)
      target_finder = TargetFinder.new(@config_store, @options)
      mode = if @options[:only_recognized_file_types]
               :only_recognized_file_types
             else
               :all_file_types
             end
      target_files = target_finder.find(paths, mode)
      target_files.each(&:freeze).freeze
    end

    def build_project_index(target_files)
      return unless project_index_enabled?

      @project_index = ProjectIndexLoader.build_index(project_index_files(target_files))
    end

    # The index always covers the whole project, not just the files being
    # inspected: cross-file offenses must not depend on which files a
    # particular run happens to include, or single-file runs (editors, CI
    # sharding) would see different offenses than full runs. The project is
    # rooted at the directory of the configuration that enabled the index.
    #
    # The project's RBS signatures are left out: they declare methods and constants
    # rather than define them, and may declare only part of a namespace.
    def project_index_files(target_files)
      root = @config_store.for_pwd.base_dir_for_path_parameters
      project_files = begin
        find_target_files([root]) | target_files
      rescue Errno::ENOENT
        target_files
      end
      project_files = project_files.reject { |file| File.extname(file) == '.rbs' }

      (project_files | bundled_gem_files).sort
    end

    def bundled_gem_files
      return [] unless @config_store.for_pwd.for_all_cops['ProjectIndexIncludesGems']

      ProjectIndexLoader.bundled_gem_source_files
    end

    def project_index_enabled?
      return false unless @config_store.for_pwd.for_all_cops['UseProjectIndex']

      unless ProjectIndexLoader.available?
        ProjectIndexLoader.warn_unavailable
        return false
      end

      true
    end

    def inspect_files(files) # rubocop:disable Metrics/AbcSize
      formatter_set.started(files)
      formatters_started = true
      file_iterator(files) do |file|
        offenses, problems = collect_problems { process_file(file) }
        succeeded = offenses.none? { |o| considered_failure?(o) && offense_displayed?(o) }

        [offenses, succeeded, problems]
      end
    ensure
      # OPTIMIZE: Calling `ResultCache.cleanup` takes time. This optimization
      # mainly targets editors that integrates RuboCop. When RuboCop is run
      # by an editor, it should be inspecting only one file.
      if files.size > 1 && cached_run?
        ResultCache.cleanup(@config_store, @options[:debug], @options[:cache_root])
      end
      formatter_set.finished(@inspected_files.freeze) if formatters_started
      formatter_set.close_output_files
      warn_about_elided_offenses
    end

    def file_iterator(files, &block)
      all_passed = true

      on_start = ->(file, _index) { file_started(file) }
      on_finish = lambda do |file, index, (offenses, passed, problems)|
        all_passed &&= passed
        finished_report(file, index, offenses, problems)
      end

      if run_in_parallel?(files)
        parallel_file_iterator(files, on_start, on_finish, &block)
      else
        serial_file_iterator(files, on_start, on_finish, &block)
      end

      process_remaining_report_queue

      all_passed
    end

    def finished_report(file, index, offenses, problems)
      @report_queue[index] = [file, offenses, problems]
      @next_index_to_report ||= 0
      while @report_queue.key?(@next_index_to_report)
        process_report_queue_entry(@next_index_to_report)
        @next_index_to_report += 1
      end
    end

    def process_report_queue_entry(index)
      file, offenses, (errors, warnings) = @report_queue.delete(index)
      @errors.concat(errors)
      @warnings.concat(warnings)
      file_problems(file, errors, warnings) unless errors.empty? && warnings.empty?
      file_finished(file, offenses)
    end

    def process_remaining_report_queue
      @report_queue.keys.sort.each do |index|
        process_report_queue_entry(index)
      end
    end

    def run_in_parallel?(files)
      return false unless parallel_supported_by_options?

      if files.size <= 1
        puts 'Skipping parallel inspection: only a single file needs inspection' if @options[:debug]
        return false
      end

      return false if project_index_disables_parallel?

      puts 'Running parallel inspection' if @options[:debug]

      true
    end

    # `--auto-gen-config` needs the offenses of every file in one place, and
    # `--diff` collects the diffs in this process, where a worker's copy of
    # them would be lost.
    def parallel_supported_by_options?
      @options[:parallel] && !@options[:auto_gen_config] && !@options[:diff]
    end

    def project_index_disables_parallel?
      return false if @project_index.nil? || !Gem.win_platform?

      if @options[:debug]
        puts 'Skipping parallel inspection: the project index is enabled and parallel ' \
             'inspection is not yet supported on Windows.'
      end

      true
    end

    def parallel_file_iterator(files, on_start, on_finish, &block)
      Parallel.each(files, start: on_start, finish: on_finish, &block)
    end

    def serial_file_iterator(files, on_start, on_finish, &block)
      files.each_with_index do |file, index|
        on_start.call(file, index)
        result = yield file
        on_finish.call(file, index, result)

        # Report and count the offending file before stopping so `--fail-fast`
        # still shows its offenses and exits with a failing status.
        _offenses, succeeded = result
        break if @options[:fail_fast] && !succeeded
      end
    end

    def list_files(paths)
      paths.each { |path| puts PathUtil.relative_path(path) }
    end

    # Keeps the errors and warnings a file causes apart from the rest of the
    # run's. A parallel worker inspects files in a copy of the runner that is
    # thrown away, so they have to travel back with the file's offenses.
    def collect_problems
      errors = @errors
      warnings = @warnings
      @errors = []
      @warnings = []

      [yield, [@errors, @warnings]]
    ensure
      @errors = errors
      @warnings = warnings
    end

    def process_file(file)
      file_offenses(file)
    rescue InfiniteCorrectionLoop => e
      raise e if @options[:raise_cop_error]

      errors << e
      warn Rainbow(e.message).red
      e.offenses.compact.sort.freeze
    end

    def file_offenses(file)
      file_offense_cache(file) do
        source, offenses = do_inspection_loop(file)
        offenses = add_redundant_disables(file, offenses.compact.sort, source)
        offenses = offenses.reject(&:disabled?) unless @options[:display_suppressed]
        offenses.sort.freeze
      end
    end

    def cached_result(file, team)
      ResultCache.new(file, team, @options, @config_store)
    end

    def file_offense_cache(file)
      config = @config_store.for_file(file)
      cache = cached_result(file, standby_team(config)) if cached_run?

      if cache&.valid?
        offenses = cache.load
        # If we're running --autocorrect and the cache says there are
        # offenses, we need to actually inspect the file. If the cache shows no
        # offenses, we're good.
        real_run_needed = @options[:autocorrect] && offenses.any?
      else
        real_run_needed = true
      end

      if real_run_needed
        offenses = yield
        save_in_cache(cache, offenses) unless Cop::Registry.global.warnings?(file)
      end

      offenses
    end

    def add_redundant_disables(file, offenses, source)
      team_for_redundant_disables(file, offenses, source) do |team|
        new_offenses, redundant_updated = inspect_file(source, team)
        offenses += new_offenses
        if redundant_updated
          # Do one extra inspection loop if any redundant disables were
          # removed. This is done in order to find rubocop:enable directives that
          # have now become useless. It finds the offenses that are left again,
          # located in the corrected source, so only the corrected ones are kept
          # from before, as `inspect_and_correct` does.
          _source, new_offenses = do_inspection_loop(file, team.updated_source)
          offenses = offenses.select(&:corrected?) | new_offenses
        end
      end
      offenses
    end

    def team_for_redundant_disables(file, offenses, source)
      return unless check_for_redundant_disables?(source)

      config = @config_store.for_file(file)
      team = Cop::Team.mobilize([Cop::Lint::RedundantCopDisableDirective], config, @options)
      return if team.cops.empty?

      team.defer_corrections = @options[:diff]
      team.cops.first.offenses_to_check = offenses.reject(&:corrected?)

      yield team
    end

    def check_for_redundant_disables?(source)
      return false if except_redundant_cop_disable_directive?
      # Detached `disable-next` directives produce no disabled ranges but must
      # still be reported as redundant.
      if source.disabled_line_ranges.empty? &&
         source.comment_config.detached_next_directives.empty?
        return false
      end

      !@options[:only]
    end

    def redundant_cop_disable_directive(file)
      config = @config_store.for_file(file)
      return unless config.for_cop(Cop::Lint::RedundantCopDisableDirective).fetch('Enabled')

      cop = Cop::Lint::RedundantCopDisableDirective.new(config, @options)
      yield cop if cop.relevant_file?(file)
    end

    def except_redundant_cop_disable_directive?
      @options[:except] && (@options[:except] & REDUNDANT_COP_DISABLE_DIRECTIVE_RULES).any?
    end

    def file_started(file)
      puts "Scanning #{file}" if @options[:debug]
      formatter_set.file_started(file, cli_options: @options, config_store: @config_store)
    end

    # Formatters get the messages without the colors added for the terminal.
    def file_problems(file, errors, warnings)
      formatter_set.file_problems(file, plain_messages(errors), plain_messages(warnings))
    end

    def plain_messages(problems)
      problems.map { |problem| Rainbow::StringUtils.uncolor(problem.to_s) }
    end

    def file_finished(file, offenses)
      @inspected_files << file
      offenses = offenses_to_report(offenses)
      formatter_set.file_finished(file, offenses)
    end

    def cached_run?
      @cached_run ||=
        (@options[:cache] == 'true' ||
         (@options[:cache] != 'false' && @config_store.for_pwd.for_all_cops['UseCache'])) &&
        # We can't cache results from code which is piped in to stdin
        !@options[:stdin]
    end

    def save_in_cache(cache, offenses)
      return unless cache
      # Caching results when a cop has crashed would prevent the crash in the
      # next run, since the cop would not be called then. We want crashes to
      # show up the same in each run. Only this file's errors and warnings are
      # visible here, see `collect_problems`.
      return if errors.any? || warnings.any?

      cache.save(offenses)
    end

    def do_inspection_loop(file, source = nil)
      processed_source = initial_processed_source(file, source)
      original_source = processed_source.raw_source
      # This variable is 2d array used to track corrected offenses after each
      # inspection iteration. This is used to output meaningful infinite loop
      # error message.
      offenses_by_iteration = []
      corrected_source = nil

      # When running with --autocorrect, we need to inspect the file until no
      # more corrections are made. This is because automatic corrections can
      # introduce new offenses. In the normal case the loop is only executed
      # once. The corrections are kept in memory while iterating and written
      # back to the file when the loop is done.
      iterate_until_no_changes(processed_source, offenses_by_iteration) do
        team, updated_source_file = inspect_and_correct(processed_source, offenses_by_iteration)

        # We have to reprocess the source to pickup the changes. Since the
        # change could (theoretically) introduce parsing errors, we break the
        # loop if we find any.
        break unless updated_source_file

        # Autocorrect has happened, don't use the prism result since it is stale.
        # With --stdin the corrected source is kept in @options[:stdin] instead.
        corrected_source = team.updated_source
        processed_source = get_processed_source(file, nil, source: corrected_source)
      end

      # Return summary of corrected offenses after all iterations
      [processed_source, offenses_by_iteration.flatten.uniq]
    ensure
      finalize_corrections(file, original_source, corrected_source)
    end

    # `source` is the corrected source to continue from when the corrections
    # are kept in memory rather than written to the file (`--diff`).
    def initial_processed_source(file, source)
      return get_processed_source(file, nil, source: source) if source

      # We can reuse the prism result since the source did not change yet.
      get_processed_source(file, @prism_result)
    end

    def inspect_and_correct(processed_source, offenses_by_iteration)
      # The offenses that couldn't be corrected will be found again so we
      # only keep the corrected ones in order to avoid duplicate reporting.
      !offenses_by_iteration.empty? && offenses_by_iteration.last.select!(&:corrected?)
      team, new_offenses, updated_source_file = inspect_iteration(processed_source)
      offenses_by_iteration.push(new_offenses)

      [team, updated_source_file]
    end

    # Write the file once, even when the loop was left through an exception
    # (e.g. an infinite correction loop), like the per-iteration writes used
    # to be. Under `--diff` nothing is written at all.
    def finalize_corrections(file, original_source, corrected_source)
      if @options[:diff]
        record_diff(file, original_source, corrected_source)
      elsif corrected_source
        Util.replace_file_contents(file, corrected_source)
      end
    end

    # `--diff` reports what autocorrection would do instead of doing it. With
    # `--stdin` the corrected source is handed back through the options rather
    # than deferred, so that is where the new source comes from. A file can go
    # through more than one inspection loop, so the diff runs from the source
    # the first loop started with to the one the last loop ended with.
    def record_diff(file, original_source, corrected_source)
      return unless original_source

      new_source = @options[:stdin] || corrected_source
      # The original source is the file as it is on disk, so the corrected one
      # has to go through the same line ending conversion `File.write` would
      # apply, or on Windows every single line reads as changed.
      new_source = new_source ? Util.emulate_write_read_cycle(new_source) : original_source

      sources = (@diff_sources[file] ||= [original_source])
      sources[1] = new_source
    end

    def inspect_iteration(processed_source)
      team = mobilize_team(processed_source)
      team.defer_corrections = @options[:diff] || in_memory_corrections_possible?
      offenses, updated_source_file = inspect_file(processed_source, team)
      [team, offenses, updated_source_file]
    end

    # Custom ruby extractors may derive their fragments from the file on
    # disk rather than from the passed processed source, so corrections can
    # only be kept in memory when the default extractor is used.
    def in_memory_corrections_possible?
      self.class.ruby_extractors.one?
    end

    def iterate_until_no_changes(source, offenses_by_iteration)
      # Keep track of the state of the source. If a cop modifies the source
      # and another cop undoes it producing identical source we have an
      # infinite loop.
      @processed_sources = []

      # It is also possible for a cop to keep adding indefinitely to a file,
      # making it bigger and bigger. If the inspection loop runs for an
      # excessively high number of iterations, this is likely happening.
      iterations = 0

      loop do
        check_for_infinite_loop(source, offenses_by_iteration)

        if (iterations += 1) > MAX_ITERATIONS
          raise InfiniteCorrectionLoop.new(source.path, offenses_by_iteration)
        end

        source = yield
        break unless source
      end
    end

    # Check whether a run created source identical to a previous run, which
    # means that we definitely have an infinite loop.
    def check_for_infinite_loop(processed_source, offenses_by_iteration)
      checksum = processed_source.checksum

      if (loop_start_index = @processed_sources.index(checksum))
        raise InfiniteCorrectionLoop.new(
          processed_source.path,
          offenses_by_iteration,
          loop_start: loop_start_index
        )
      end

      @processed_sources << checksum
    end

    def inspect_file(processed_source, team = mobilize_team(processed_source))
      extracted_ruby_sources = extract_ruby_sources(processed_source)
      offenses = team.investigate_fragments(extracted_ruby_sources, original: processed_source)
      @errors.concat(team.errors)
      @warnings.concat(team.warnings)
      [offenses, team.updated_source_file?]
    end

    def extract_ruby_sources(processed_source)
      self.class.ruby_extractors.find do |ruby_extractor|
        result = ruby_extractor.call(processed_source)
        break result if result
      rescue StandardError
        location = if ruby_extractor.is_a?(Proc)
                     ruby_extractor.source_location
                   else
                     ruby_extractor.method(:call).source_location
                   end
        raise Error, "Ruby extractor #{location[0]} failed to process #{processed_source.path}."
      end
    end

    def mobilize_team(processed_source)
      config = @config_store.for_file(processed_source.path)
      @inspection_team_by_config ||= {}.compare_by_identity
      @inspection_team_by_config[config] ||= assemble_team(config)
    end

    def mobilized_cop_classes(config)
      @mobilized_cop_classes ||= {}.compare_by_identity
      @mobilized_cop_classes[config] ||= begin
        # `@options[:only]` and `@options[:except]` are not qualified until
        # needed so that the registry contains any cops added by `require`s,
        # which register eagerly when their files are loaded.
        qualify_option_cop_names

        OptionsValidator.new(@options).validate_cop_options

        # Filtering by badge keeps lazy-loaded cops unloaded; only the cops
        # that survive the filter and are enabled will be loaded.
        Cop::Registry.global.filter_by_badge(@options) { |badge| mobilize_cop_badge?(badge, config) }
      end
    end

    # Lets a runner that is reused from run to run pick up a different `--only`
    # or `--except`.
    def forget_mobilized_cops
      @mobilized_cop_classes = nil
    end

    def mobilize_cop_badge?(badge, config)
      return false if badge.department == :Test
      return false if badge.match_name?(@options[:except])
      return false if config.missing_default_config_for?(badge)

      if @options[:only]
        badge.match_name?(@options[:only])
      else
        # use only cops that link to a style guide if requested.
        !style_guide_cops_only?(config) || config.for_cop(badge.to_s)['StyleGuide']
      end
    end

    def qualify_option_cop_names
      %i[only except].each do |option|
        next unless @options[option]

        @options[option] = @options[option].map do |cop_name|
          Cop::Registry.qualified_cop_name(cop_name, "--#{option} option")
        end
      end
    end

    def style_guide_cops_only?(config)
      @options[:only_guide_cops] || config.for_all_cops['StyleGuideCopsOnly']
    end

    def formatter_set
      @formatter_set ||= begin
        set = Formatter::FormatterSet.new(@options)
        pairs = @options[:formatters] || [['progress']]
        pairs.each { |formatter_key, output_path| set.add_formatter(formatter_key, output_path) }
        set
      end
    end

    def considered_failure?(offense)
      return false if offense.disabled?

      # For :autocorrect level, any correctable offense is a failure, regardless of severity
      return true if @options[:fail_level] == :autocorrect && offense.correctable?

      !offense.corrected? && offense.severity >= minimum_severity_to_fail
    end

    def offense_displayed?(offense)
      if @options[:display_only_fail_level_offenses]
        considered_failure?(offense)
      elsif @options[:display_only_safe_correctable]
        supports_safe_autocorrect?(offense)
      elsif @options[:display_only_correctable]
        offense.correctable?
      else
        true
      end
    end

    def offenses_to_report(offenses)
      offenses = offenses.select { |o| offense_displayed?(o) }
      offenses = offense_limit.filter(offenses) if offense_limit
      offenses
    end

    # Files are reported in order, so which offenses survive the limit does not
    # depend on how the run was parallelized.
    def offense_limit
      return @offense_limit if defined?(@offense_limit)

      max = @options[:max_offenses_per_cop]
      @offense_limit = (OffenseLimit.new(max.to_i) if max)
    end

    def warn_about_elided_offenses
      elided = offense_limit&.elided_per_cop
      return unless elided&.any?

      warn Rainbow(
        "#{elided.values.sum} more offenses were not reported because of " \
        "--max-offenses-per-cop=#{offense_limit.max} (#{elided.keys.join(', ')})."
      ).yellow
    end

    def supports_safe_autocorrect?(offense)
      cop_class = Cop::Registry.global.find_by_cop_name(offense.cop_name)
      default_cfg = default_config(offense.cop_name)

      offense.correctable? &&
        cop_class&.support_autocorrect? && mark_as_safe_by_config?(default_cfg)
    end

    def mark_as_safe_by_config?(config)
      config.nil? || (config.fetch('Safe', true) && config.fetch('SafeAutoCorrect', true))
    end

    def default_config(cop_name)
      RuboCop::ConfigLoader.default_configuration[cop_name]
    end

    def minimum_severity_to_fail
      @minimum_severity_to_fail ||=
        RuboCop::Cop::Severity.minimum_to_fail(@options, @config_store.for_pwd)
    end

    # rubocop:disable-next Metrics/MethodLength
    def get_processed_source(file, prism_result, source: nil)
      config = @config_store.for_file(file)
      ruby_version = config.target_ruby_version
      parser_engine = config.parser_engine

      processed_source = if source
                           ProcessedSource.new(
                             Util.emulate_write_read_cycle(source),
                             ruby_version,
                             file,
                             parser_engine: parser_engine
                           )
                         elsif @options[:stdin]
                           ProcessedSource.new(
                             @options[:stdin],
                             ruby_version,
                             file,
                             parser_engine: parser_engine,
                             prism_result: prism_result
                           )
                         else
                           begin
                             ProcessedSource.from_file(
                               file, ruby_version, parser_engine: parser_engine
                             )
                           rescue Errno::ENOENT
                             raise RuboCop::Error, "No such file or directory: #{file}"
                           end
                         end
      processed_source.config = config
      processed_source.registry = mobilized_cop_classes(config)
      processed_source
    end

    # A Cop::Team instance is stateful and may change when inspecting.
    # The "standby" team for a given config is an initialized but
    # otherwise dormant team that can be used for config- and option-
    # level caching in ResultCache.
    def standby_team(config)
      @standby_team_by_config ||= {}.compare_by_identity
      @standby_team_by_config[config] ||= assemble_team(config)
    end

    def assemble_team(config)
      team = Cop::Team.mobilize(mobilized_cop_classes(config), config, @options)

      if @project_index
        team.cops.each do |cop|
          cop.project_index = @project_index
        end
      end

      team
    end
  end
end
