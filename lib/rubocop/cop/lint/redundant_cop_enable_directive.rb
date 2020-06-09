# frozen_string_literal: true

# The Lint/RedundantCopEnableDirective and Lint/RedundantCopDisableDirective
# cops need to be disabled so as to be able to provide a (bad) example of an
# unneeded enable.

# rubocop:disable Lint/RedundantCopEnableDirective
# rubocop:disable Lint/RedundantCopDisableDirective
module RuboCop
  module Cop
    module Lint
      # This cop detects instances of rubocop:enable comments that can be
      # removed.
      #
      # When comment enables all cops at once `rubocop:enable all`
      # that cop checks whether any cop was actually enabled.
      # @example
      #   # bad
      #   foo = 1
      #   # rubocop:enable Layout/LineLength
      #
      #   # good
      #   foo = 1
      # @example
      #   # bad
      #   # rubocop:disable Style/StringLiterals
      #   foo = "1"
      #   # rubocop:enable Style/StringLiterals
      #   baz
      #   # rubocop:enable all
      #
      #   # good
      #   # rubocop:disable Style/StringLiterals
      #   foo = "1"
      #   # rubocop:enable all
      #   baz
      class RedundantCopEnableDirective < Cop
        include RangeHelp
        include SurroundingSpace

        MSG = 'Unnecessary enabling of %<cop>s.'

        def investigate(processed_source)
          return if processed_source.blank?

          offenses = processed_source.comment_config.extra_enabled_comments
          offenses.each do |comment, name|
            add_offense(
              [comment, name],
              location: range_of_offense(comment, name),
              message: format(MSG, cop: all_or_name(name))
            )
          end
        end

        def autocorrect(comment_and_name)
          lambda do |corrector|
            corrector.remove(range_with_comma(*comment_and_name))
          end
        end

        private

        def range_of_offense(comment, name)
          start_pos = comment_start(comment) + cop_name_indention(comment, name)
          range_between(start_pos, start_pos + name.size)
        end

        def comment_start(comment)
          comment.loc.expression.begin_pos
        end

        def cop_name_indention(comment, name)
          comment.text.index(name)
        end

        def find_comma_position(source, begin_pos, end_pos)
          if source[begin_pos - 1] == ','
            :before
          elsif source[end_pos] == ','
            :after
          else
            :none
          end
        end

        def range_with_comma(comment, name)
          source = comment.loc.expression.source

          begin_pos = cop_name_indention(comment, name)
          end_pos = begin_pos + name.size
          begin_pos = reposition(source, begin_pos, -1)
          end_pos = reposition(source, end_pos, 1)

          comma_pos = find_comma_position(source, begin_pos, end_pos)

          range_to_remove(begin_pos, end_pos, comma_pos, comment)
        end

        def range_to_remove(begin_pos, end_pos, comma_pos, comment)
          start = comment_start(comment)

          case comma_pos
          when :before
            range_between(start + begin_pos - 1, start + end_pos)
          when :after
            range_between_for_after(start, begin_pos, end_pos, comment)
          else
            range_between(start, comment.loc.expression.end_pos)
          end
        end

        # If the list of cops is comma-separated, but without a empty space after the comma,
        # we should **not** remove the prepending empty space, thus begin_pos += 1
        def range_between_for_after(start, begin_pos, end_pos, comment)
          begin_pos += 1 if comment.loc.expression.source[end_pos + 1] != ' '

          range_between(start + begin_pos, start + end_pos + 1)
        end

        def all_or_name(name)
          name == 'all' ? 'all cops' : name
        end
      end
    end
  end
end

# rubocop:enable Lint/RedundantCopDisableDirective
# rubocop:enable Lint/RedundantCopEnableDirective
