# frozen_string_literal: true

require 'parallel'

module RuboCop
  # This class handles the processing of files, which includes dealing with
  # formatters and letting cops inspect the files.
  class Runner # rubocop:disable Metrics/ClassLength
    # An exception indicating that the inspection loop got stuck correcting
    # offenses back and forth.
    class InfiniteCorrectionLoop < RuntimeError
      def initialize(path, offenses_by_iteration, loop_start: -1)
        @offenses = offenses_by_iteration.flatten.uniq
        root_cause = offenses_by_iteration[loop_start..-1]
                     .map { |x| x.map(&:cop_name).uniq.join(', ') }
                     .join(' -> ')

        message = 'Infinite loop detected'
        message += " in #{path}" if path
        message += " and caused by #{root_cause}" if root_cause
        super message
      end

      attr_reader :offenses
    end

    # @api private
    MAX_ITERATIONS = 200

    def initialize(options, config_store)
      @options = options
      @config_store = config_store
      @errors = []
      @warnings = []
      @aborting = false
    end

    attr_reader :errors, :warnings
    attr_writer :aborting

    def run(paths)
      target_files = find_target_files(paths)
      if @options[:list_target_files]
        list_files(target_files)
      else
        warm_cache(target_files) if @options[:parallel]
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

    # Warms up the RuboCop cache by forking a suitable number of rubocop
    # instances that each inspects its allotted group of files.
    def warm_cache(target_files)
      puts 'Running parallel inspection' if @options[:debug]
      Parallel.each(target_files) { |target_file| file_offenses(target_file) }
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

    def inspect_files(files)
      inspected_files = []

      formatter_set.started(files)

      each_inspected_file(files) { |file| inspected_files << file }
    ensure
      # OPTIMIZE: Calling `ResultCache.cleanup` takes time. This optimization
      # mainly targets editors that integrates RuboCop. When RuboCop is run
      # by an editor, it should be inspecting only one file.
      if files.size > 1 && cached_run?
        ResultCache.cleanup(@config_store, @options[:debug], @options[:cache_root])
      end

      formatter_set.finished(inspected_files.freeze)
      formatter_set.close_output_files
    end

    def each_inspected_file(files)
      files.reduce(true) do |all_passed, file|
        offenses = process_file(file)
        yield file

        if offenses.any? { |o| considered_failure?(o) }
          break false if @options[:fail_fast]

          next false
        end

        all_passed
      end
    end

    def list_files(paths)
      paths.each { |path| puts PathUtil.relative_path(path) }
    end

    def process_file(file)
      file_started(file)
      offenses = file_offenses(file)
    rescue InfiniteCorrectionLoop => e
      offenses = e.offenses.compact.sort.freeze
      raise
    ensure
      file_finished(file, offenses || [])
    end

    def file_offenses(file)
      file_offense_cache(file) do
        source, offenses = do_inspection_loop(file)
        offenses = add_redundant_disables(file, offenses.compact.sort, source)
        offenses.sort.reject(&:disabled?).freeze
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
        # If we're running --auto-correct and the cache says there are
        # offenses, we need to actually inspect the file. If the cache shows no
        # offenses, we're good.
        real_run_needed = @options[:auto_correct] && offenses.any?
      else
        real_run_needed = true
      end

      if real_run_needed
        offenses = yield
        save_in_cache(cache, offenses)
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
          # have now become useless.
          _source, new_offenses = do_inspection_loop(file)
          offenses |= new_offenses
        end
      end
      offenses
    end

    def team_for_redundant_disables(file, offenses, source)
      return unless check_for_redundant_disables?(source)

      config = @config_store.for_file(file)
      team = Cop::Team.mobilize([Cop::Lint::RedundantCopDisableDirective], config, @options)
      return if team.cops.empty?

      team.cops.first.offenses_to_check = offenses
      yield team
    end

    def check_for_redundant_disables?(source)
      !source.disabled_line_ranges.empty? && !filtered_run?
    end

    def redundant_cop_disable_directive(file)
      config = @config_store.for_file(file)
      return unless config.for_cop(Cop::Lint::RedundantCopDisableDirective).fetch('Enabled')

      cop = Cop::Lint::RedundantCopDisableDirective.new(config, @options)
      yield cop if cop.relevant_file?(file)
    end

    def filtered_run?
      @options[:except] || @options[:only]
    end

    def file_started(file)
      puts "Scanning #{file}" if @options[:debug]
      formatter_set.file_started(file, cli_options: @options, config_store: @config_store)
    end

    def file_finished(file, offenses)
      if @options[:display_only_fail_level_offenses]
        offenses = offenses.select { |o| considered_failure?(o) }
      end
      formatter_set.file_finished(file, offenses)
    end

    def cached_run?
      @cached_run ||=
        (@options[:cache] == 'true' ||
         @options[:cache] != 'false' &&
         @config_store.for_pwd.for_all_cops['UseCache']) &&
        # When running --auto-gen-config, there's some processing done in the
        # cops related to calculating the Max parameters for Metrics cops. We
        # need to do that processing and cannot use caching.
        !@options[:auto_gen_config] &&
        # We can't cache results from code which is piped in to stdin
        !@options[:stdin]
    end

    def save_in_cache(cache, offenses)
      return unless cache
      # Caching results when a cop has crashed would prevent the crash in the
      # next run, since the cop would not be called then. We want crashes to
      # show up the same in each run.
      return if errors.any? || warnings.any?

      cache.save(offenses)
    end

    def do_inspection_loop(file)
      processed_source = get_processed_source(file)
      # This variable is 2d array used to track corrected offenses after each
      # inspection iteration. This is used to output meaningful infinite loop
      # error message.
      offenses_by_iteration = []

      # When running with --auto-correct, we need to inspect the file (which
      # includes writing a corrected version of it) until no more corrections
      # are made. This is because automatic corrections can introduce new
      # offenses. In the normal case the loop is only executed once.
      iterate_until_no_changes(processed_source, offenses_by_iteration) do
        # The offenses that couldn't be corrected will be found again so we
        # only keep the corrected ones in order to avoid duplicate reporting.
        !offenses_by_iteration.empty? && offenses_by_iteration.last.select!(&:corrected?)
        new_offenses, updated_source_file = inspect_file(processed_source)
        offenses_by_iteration.push(new_offenses)

        # We have to reprocess the source to pickup the changes. Since the
        # change could (theoretically) introduce parsing errors, we break the
        # loop if we find any.
        break unless updated_source_file

        processed_source = get_processed_source(file)
      end

      # Return summary of corrected offenses after all iterations
      offenses = offenses_by_iteration.flatten.uniq
      [processed_source, offenses]
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
      report = team.investigate(processed_source)
      @errors.concat(team.errors)
      @warnings.concat(team.warnings)
      [report.offenses, team.updated_source_file?]
    end

    def mobilize_team(processed_source)
      config = @config_store.for_file(processed_source.path)
      Cop::Team.mobilize(mobilized_cop_classes(config), config, @options)
    end

    def mobilized_cop_classes(config) # rubocop:disable Metrics/AbcSize
      @mobilized_cop_classes ||= {}.compare_by_identity
      @mobilized_cop_classes[config] ||= begin
        cop_classes = Cop::Registry.all

        # `@options[:only]` and `@options[:except]` are not qualified until
        # needed so that the Registry can be fully loaded, including any
        # cops added by `require`s.
        qualify_option_cop_names

        OptionsValidator.new(@options).validate_cop_options

        if @options[:only]
          cop_classes.select! { |c| c.match?(@options[:only]) }
        else
          filter_cop_classes(cop_classes, config)
        end

        cop_classes.reject! { |c| c.match?(@options[:except]) }

        Cop::Registry.new(cop_classes, @options)
      end
    end

    def qualify_option_cop_names
      %i[only except].each do |option|
        next unless @options[option]

        @options[option].map! do |cop_name|
          Cop::Registry.qualified_cop_name(cop_name, "--#{option} option")
        end
      end
    end

    def filter_cop_classes(cop_classes, config)
      # use only cops that link to a style guide if requested
      return unless style_guide_cops_only?(config)

      cop_classes.select! { |cop| config.for_cop(cop)['StyleGuide'] }
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
      # For :autocorrect level, any offense - corrected or not - is a failure.
      return false if offense.disabled?

      return true if @options[:fail_level] == :autocorrect

      !offense.corrected? && offense.severity >= minimum_severity_to_fail
    end

    def minimum_severity_to_fail
      @minimum_severity_to_fail ||= begin
        # Unless given explicitly as `fail_level`, `:info` severity offenses do not fail
        name = @options[:fail_level] || :refactor
        RuboCop::Cop::Severity.new(name)
      end
    end

    def get_processed_source(file)
      ruby_version = @config_store.for_file(file).target_ruby_version

      if @options[:stdin]
        ProcessedSource.new(@options[:stdin], ruby_version, file)
      else
        begin
          ProcessedSource.from_file(file, ruby_version)
        rescue Errno::ENOENT
          raise RuboCop::Error, "No such file or directory: #{file}"
        end
      end
    end

    # A Cop::Team instance is stateful and may change when inspecting.
    # The "standby" team for a given config is an initialized but
    # otherwise dormant team that can be used for config- and option-
    # level caching in ResultCache.
    def standby_team(config)
      @team_by_config ||= {}.compare_by_identity
      @team_by_config[config] ||=
        Cop::Team.mobilize(mobilized_cop_classes(config), config, @options)
    end
  end
end
