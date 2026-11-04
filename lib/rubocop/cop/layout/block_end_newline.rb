# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # Checks whether the end statement of a do..end block
      # is on its own line.
      #
      # @example
      #   # bad
      #   blah do |i|
      #     foo(i) end
      #
      #   # good
      #   blah do |i|
      #     foo(i)
      #   end
      #
      #   # bad
      #   blah { |i|
      #     foo(i) }
      #
      #   # good
      #   blah { |i|
      #     foo(i)
      #   }
      class BlockEndNewline < Base
        include Alignment
        extend AutoCorrector

        MSG = 'Expression at %<line>d, %<column>d should be on its own line.'

        def on_block(node)
          return if node.single_line?

          # If the end is on its own line, there is no offense
          return if begins_its_line?(node.loc.end)

          offense_range = offense_range(node)
          return if offense_range.source.lstrip.start_with?(';')

          register_offense(node, offense_range)
        end

        alias on_numblock on_block
        alias on_itblock on_block

        private

        def register_offense(node, offense_range)
          add_offense(node.loc.end, message: message(node)) do |corrector|
            next if overlaps_inner_heredoc_correction?(node)

            if (heredoc = last_heredoc_argument(node.body))
              correct_with_heredoc(corrector, offense_range, heredoc)
            else
              corrector.replace(offense_range, "\n#{offense_range.source.lstrip}")
            end
          end
        end

        def message(node)
          format(MSG, line: node.loc.end.line, column: node.loc.end.column + 1)
        end

        def overlaps_inner_heredoc_correction?(node)
          node.each_descendant(:any_block).any? do |block|
            same_line?(block.loc.end, node.loc.end) && heredoc_correction?(block)
          end
        end

        def heredoc_correction?(node)
          return false if node.single_line?
          return false if begins_its_line?(node.loc.end)

          !last_heredoc_argument(node.body).nil?
        end

        def last_heredoc_argument(node)
          return unless node&.call_type?
          return unless (arguments = node&.arguments)

          heredoc = arguments.reverse.detect { |arg| arg.str_type? && arg.heredoc? }
          return heredoc if heredoc

          last_heredoc_argument(node.children.first)
        end

        def correct_with_heredoc(corrector, offense_range, heredoc)
          range = offense_range.with(end_pos: code_end_pos(offense_range))

          corrector.remove(range)
          corrector.insert_after(heredoc.loc.heredoc_end, "\n#{range.source.strip}")
        end

        def code_end_pos(range)
          comment = processed_source.comment_at_line(range.last_line)
          return range.source_buffer.line_range(range.last_line).end_pos if comment.nil?

          code_range = range.with(end_pos: comment.source_range.begin_pos)
          code_range.begin_pos + code_range.source.rstrip.length
        end

        def offense_range(node)
          node.children.compact.last.source_range.end.join(node.loc.end)
        end
      end
    end
  end
end
