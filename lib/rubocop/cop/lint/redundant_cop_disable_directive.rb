# frozen_string_literal: true

# The Lint/RedundantCopDisableDirective cop needs to be disabled so as
# to be able to provide a (bad) example of a redundant disable.
# rubocop:disable Lint/RedundantCopDisableDirective
module RuboCop
  module Cop
    module Lint
      # This cop detects instances of rubocop:disable comments that can be
      # removed without causing any offenses to be reported. It's implemented
      # as a cop in that it inherits from the Cop base class and calls
      # add_offense. The unusual part of its implementation is that it doesn't
      # have any on_* methods or an investigate method. This means that it
      # doesn't take part in the investigation phase when the other cops do
      # their work. Instead, it waits until it's called in a later stage of the
      # execution. The reason it can't be implemented as a normal cop is that
      # it depends on the results of all other cops to do its work.
      #
      #
      # @example
      #   # bad
      #   # rubocop:disable Layout/LineLength
      #   x += 1
      #   # rubocop:enable Layout/LineLength
      #
      #   # good
      #   x += 1
      class RedundantCopDisableDirective < Base
        include RangeHelp
        extend AutoCorrector

        COP_NAME = 'Lint/RedundantCopDisableDirective'

        attr_accessor :offenses_to_check

        def initialize(config = nil, options = nil, offenses = nil)
          @offenses_to_check = offenses
          super(config, options)
        end

        def on_new_investigation
          return unless offenses_to_check

          cop_disabled_line_ranges = processed_source.disabled_line_ranges

          redundant_cops = Hash.new { |h, k| h[k] = Set.new }

          each_redundant_disable(cop_disabled_line_ranges,
                                 offenses_to_check) do |comment, redundant_cop|
            redundant_cops[comment].add(redundant_cop)
          end

          add_offenses(redundant_cops)
          super
        end

        private

        def previous_line_blank?(range)
          processed_source.buffer.source_line(range.line - 1).blank?
        end

        def comment_range_with_surrounding_space(directive_comment_range, line_comment_range)
          if previous_line_blank?(directive_comment_range) &&
             processed_source.comment_config.comment_only_line?(directive_comment_range.line) &&
             directive_comment_range.begin_pos == line_comment_range.begin_pos
            # When the previous line is blank, it should be retained
            range_with_surrounding_space(range: directive_comment_range, side: :right)
          else
            # Eat the entire comment, the preceding space, and the preceding
            # newline if there is one.
            original_begin = directive_comment_range.begin_pos
            range = range_with_surrounding_space(
              range: directive_comment_range, side: :left, newlines: true
            )

            range_with_surrounding_space(range: range,
                                         side: :right,
                                         # Special for a comment that
                                         # begins the file: remove
                                         # the newline at the end.
                                         newlines: original_begin.zero?)
          end
        end

        def directive_range_in_list(range, ranges)
          # Is there any cop between this one and the end of the line, which
          # is NOT being removed?
          if ends_its_line?(ranges.last) && trailing_range?(ranges, range)
            # Eat the comma on the left.
            range = range_with_surrounding_space(range: range, side: :left)
            range = range_with_surrounding_comma(range, :left)
          end

          range = range_with_surrounding_comma(range, :right)
          # Eat following spaces up to EOL, but not the newline itself.
          range_with_surrounding_space(range: range, side: :right, newlines: false)
        end

        def each_redundant_disable(cop_disabled_line_ranges, offenses,
                                   &block)
          disabled_ranges = cop_disabled_line_ranges[COP_NAME] || [0..0]

          cop_disabled_line_ranges.each do |cop, line_ranges|
            each_already_disabled(line_ranges, disabled_ranges) { |comment| yield comment, cop }

            each_line_range(line_ranges, disabled_ranges, offenses, cop, &block)
          end
        end

        def each_line_range(line_ranges, disabled_ranges, offenses, cop)
          line_ranges.each_with_index do |line_range, ix|
            comment = comment_for_line(line_range.begin)
            next if ignore_offense?(disabled_ranges, line_range)

            redundant_cop = find_redundant(comment, offenses, cop, line_range, line_ranges[ix + 1])
            yield comment, redundant_cop if redundant_cop
          end
        end

        def each_already_disabled(line_ranges, disabled_ranges)
          line_ranges.each_cons(2) do |previous_range, range|
            next if ignore_offense?(disabled_ranges, range)
            next if previous_range.end != range.begin

            # If a cop is disabled in a range that begins on the same line as
            # the end of the previous range, it means that the cop was
            # already disabled by an earlier comment. So it's redundant
            # whether there are offenses or not.
            comment = comment_for_line(range.begin)

            # Comments disabling all cops don't count since it's reasonable
            # to disable a few select cops first and then all cops further
            # down in the code.
            yield comment if comment && !all_disabled?(comment)
          end
        end

        # rubocop:todo Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def find_redundant(comment, offenses, cop, line_range, next_line_range)
          if all_disabled?(comment)
            # If there's a disable all comment followed by a comment
            # specifically disabling `cop`, we don't report the `all`
            # comment. If the disable all comment is truly redundant, we will
            # detect that when examining the comments of another cop, and we
            # get the full line range for the disable all.
            if (next_line_range.nil? || line_range.last != next_line_range.first) &&
               offenses.none? { |o| line_range.cover?(o.line) }
              'all'
            end
          else
            cop_offenses = offenses.select { |o| o.cop_name == cop }
            cop if cop_offenses.none? { |o| line_range.cover?(o.line) }
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def all_disabled?(comment)
          /rubocop\s*:\s*(?:disable|todo)\s+all\b/.match?(comment.text)
        end

        def ignore_offense?(disabled_ranges, line_range)
          disabled_ranges.any? do |range|
            range.cover?(line_range.min) && range.cover?(line_range.max)
          end
        end

        def directive_count(comment)
          _, cops_string = DirectiveComment.new(comment).match_captures
          cops_string.split(/,\s*/).size
        end

        def add_offenses(redundant_cops)
          redundant_cops.each do |comment, cops|
            if all_disabled?(comment) || directive_count(comment) == cops.size
              add_offense_for_entire_comment(comment, cops)
            else
              add_offense_for_some_cops(comment, cops)
            end
          end
        end

        def add_offense_for_entire_comment(comment, cops)
          location = DirectiveComment.new(comment).range
          cop_list = cops.sort.map { |c| describe(c) }

          add_offense(
            location,
            message: "Unnecessary disabling of #{cop_list.join(', ')}."
          ) do |corrector|
            range = comment_range_with_surrounding_space(location, comment.loc.expression)
            corrector.remove(range)
          end
        end

        def add_offense_for_some_cops(comment, cops)
          cop_ranges = cops.map { |c| [c, cop_range(comment, c)] }
          cop_ranges.sort_by! { |_, r| r.begin_pos }
          ranges = cop_ranges.map { |_, r| r }

          cop_ranges.each do |cop, range|
            add_offense(
              range,
              message: "Unnecessary disabling of #{describe(cop)}."
            ) do |corrector|
              range = directive_range_in_list(range, ranges)
              corrector.remove(range)
            end
          end
        end

        def cop_range(comment, cop)
          matching_range(comment.loc.expression, cop) ||
            matching_range(comment.loc.expression, Badge.parse(cop).cop_name) ||
            raise("Couldn't find #{cop} in comment: #{comment.text}")
        end

        def matching_range(haystack, needle)
          offset = haystack.source.index(needle)
          return unless offset

          offset += haystack.begin_pos
          Parser::Source::Range.new(haystack.source_buffer, offset, offset + needle.size)
        end

        def trailing_range?(ranges, range)
          ranges
            .drop_while { |r| !r.equal?(range) }
            .each_cons(2)
            .map { |range1, range2| range1.end.join(range2.begin).source }
            .all? { |intervening| /\A\s*,\s*\Z/.match?(intervening) }
        end

        def describe(cop)
          if cop == 'all'
            'all cops'
          elsif all_cop_names.include?(cop)
            "`#{cop}`"
          else
            similar = NameSimilarity.find_similar_name(cop, all_cop_names)
            if similar
              "`#{cop}` (did you mean `#{similar}`?)"
            else
              "`#{cop}` (unknown cop)"
            end
          end
        end

        def all_cop_names
          @all_cop_names ||= Registry.global.names
        end

        def ends_its_line?(range)
          line = range.source_buffer.source_line(range.last_line)
          (line =~ /\s*\z/) == range.last_column
        end

        def comment_for_line(line)
          # For case when `disable-next-line` is used
          processed_source.comment_at_line(line) || processed_source.comment_at_line(line - 1)
        end
      end
    end
  end
end
# rubocop:enable Lint/RedundantCopDisableDirective
