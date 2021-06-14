# frozen_string_literal: true

module RuboCop
  # This class parses the special `rubocop:disable` comments in a source
  # and provides a way to check if each cop is enabled at arbitrary line.
  class CommentConfig
    CopAnalysis = Struct.new(:line_ranges, :start_line_number)

    attr_reader :processed_source

    def initialize(processed_source)
      @processed_source = processed_source
    end

    def cop_enabled_at_line?(cop, line_number)
      cop = cop.cop_name if cop.respond_to?(:cop_name)
      disabled_line_ranges = cop_disabled_line_ranges[cop]
      return true unless disabled_line_ranges

      disabled_line_ranges.none? { |range| range.include?(line_number) }
    end

    def cop_disabled_line_ranges
      @cop_disabled_line_ranges ||= analyze
    end

    def extra_enabled_comments
      extra_enabled_comments_with_names(extras: Hash.new { |h, k| h[k] = [] }, names: Hash.new(0))
    end

    def comment_only_line?(line_number)
      non_comment_token_line_numbers.none?(line_number)
    end

    private

    def extra_enabled_comments_with_names(extras:, names:)
      each_directive do |directive|
        next unless comment_only_line?(directive.line_number)

        if directive.enabled_all?
          handle_enable_all(directive, names, extras)
        else
          handle_switch(directive, names, extras)
        end
      end

      extras
    end

    def analyze # rubocop:todo Metrics/AbcSize
      analyses = Hash.new { |hash, key| hash[key] = CopAnalysis.new([], nil) }

      each_directive do |directive|
        directive.cop_names.each do |cop_name|
          cop_name = qualified_cop_name(cop_name)
          analyses[cop_name] = analyze_cop(analyses[cop_name], directive)
        end
      end

      analyses.each_with_object({}) do |element, hash|
        cop_name, analysis = *element
        hash[cop_name] = cop_line_ranges(analysis)
      end
    end

    def analyze_cop(analysis, directive)
      # Disabling cops after comments like `#=SomeDslDirective` does not related to single line
      if !comment_only_line?(directive.line_number) || directive.single_line?
        analyze_single_line(analysis, directive)
      elsif directive.disabled_next_line?
        analyze_next_line(analysis, directive)
      elsif directive.disabled?
        analyze_disabled(analysis, directive)
      else
        analyze_rest(analysis, directive)
      end
    end

    def analyze_single_line(analysis, directive)
      return analysis unless directive.disabled?

      line = directive.line_number
      start_line = analysis.start_line_number

      CopAnalysis.new(analysis.line_ranges + [(line..line)], start_line)
    end

    def analyze_next_line(analysis, directive)
      line = directive.line_number + 1
      start_line = analysis.start_line_number

      CopAnalysis.new(analysis.line_ranges + [(line..line)], start_line)
    end

    def analyze_disabled(analysis, directive)
      line = directive.line_number
      start_line = analysis.start_line_number

      # Cop already disabled on this line, so we end the current disabled
      # range before we start a new range.
      return CopAnalysis.new(analysis.line_ranges + [start_line..line], line) if start_line

      CopAnalysis.new(analysis.line_ranges, line)
    end

    def analyze_rest(analysis, directive)
      line = directive.line_number
      start_line = analysis.start_line_number

      return CopAnalysis.new(analysis.line_ranges + [start_line..line], nil) if start_line

      CopAnalysis.new(analysis.line_ranges, nil)
    end

    def cop_line_ranges(analysis)
      return analysis.line_ranges unless analysis.start_line_number

      analysis.line_ranges + [(analysis.start_line_number..Float::INFINITY)]
    end

    def each_directive
      processed_source.comments.each do |comment|
        directive = DirectiveComment.new(comment)
        yield directive if directive.cop_names
      end
    end

    def qualified_cop_name(cop_name)
      Cop::Registry.qualified_cop_name(cop_name.strip, processed_source.file_path)
    end

    def non_comment_token_line_numbers
      @non_comment_token_line_numbers ||= begin
        non_comment_tokens = processed_source.tokens.reject(&:comment?)
        non_comment_tokens.map(&:line).uniq
      end
    end

    def handle_enable_all(directive, names, extras)
      enabled_cops = 0
      names.each do |name, counter|
        next unless counter.positive?

        names[name] -= 1
        enabled_cops += 1
      end

      extras[directive.comment] << 'all' if enabled_cops.zero?
    end

    # Collect cops that have been disabled or enabled by name in a directive comment
    # so that `Lint/RedundantCopEnableDirective` can register offenses correctly.
    def handle_switch(directive, names, extras)
      directive.cop_names.each do |name|
        next if directive.disabled_next_line?

        if directive.disabled?
          names[name] += 1
        elsif (names[name]).positive?
          names[name] -= 1
        else
          extras[directive.comment] << name
        end
      end
    end
  end
end
