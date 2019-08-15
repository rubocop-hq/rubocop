# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # This cop checks whether the end keywords are aligned properly for do
      # end blocks.
      #
      # Three modes are supported through the `EnforcedStyleAlignWith`
      # configuration parameter:
      #
      # `start_of_block` : the `end` shall be aligned with the
      # start of the line where the `do` appeared.
      #
      # `start_of_line` : the `end` shall be aligned with the
      # start of the line where the expression started.
      #
      # `either` (which is the default) : the `end` is allowed to be in either
      # location. The autofixer will default to `start_of_line`.
      #
      # @example EnforcedStyleAlignWith: either (default)
      #   # bad
      #
      #   foo.bar
      #      .each do
      #        baz
      #          end
      #
      #   begin
      #     baz
      #     end
      #
      #   # good
      #
      #   variable = lambda do |i|
      #     i
      #   end
      #
      #   variable = begin
      #     baz
      #   end
      #
      # @example EnforcedStyleAlignWith: start_of_block
      #   # bad
      #
      #   foo.bar
      #      .each do
      #        baz
      #          end
      #
      #   x =
      #     begin
      #       baz
      #   end
      #
      #   # good
      #
      #   foo.bar
      #     .each do
      #       baz
      #     end
      #
      #   x =
      #     begin
      #       baz
      #     end
      #
      # @example EnforcedStyleAlignWith: start_of_line
      #   # bad
      #
      #   foo.bar
      #      .each do
      #        baz
      #          end
      #
      #   x = begin
      #         baz
      #       end
      #
      #   # good
      #
      #   foo.bar
      #     .each do
      #        baz
      #   end
      #
      #   x = begin
      #     baz
      #   end
      class BlockAlignment < Cop
        include ConfigurableEnforcedStyle
        include RangeHelp

        MSG = '%<current>s is not aligned with %<prefer>s%<alt_prefer>s.'

        def_node_matcher :block_end_align_target?, <<~PATTERN
          {assignment?
           splat
           and
           or
           (send _ :<<  ...)
           (send equal?(%1) !:[] ...)}
        PATTERN

        def on_block(node)
          check_block_alignment(start_for_block_node(node), node)
        end
        alias on_kwbegin on_block

        def style_parameter_name
          'EnforcedStyleAlignWith'
        end

        def autocorrect(node)
          ancestor_node = start_for_block_node(node)
          start_col = compute_start_col(ancestor_node, node)
          loc_end = node.loc.end
          delta = start_col - loc_end.column

          if delta.positive?
            add_space_before(loc_end, delta)
          elsif delta.negative?
            remove_space_before(loc_end.begin_pos, -delta)
          end
        end

        private

        def start_for_block_node(block_node)
          # Which node should we align the 'end' with?
          result = block_end_align_target(block_node)

          # In offense message, we want to show the assignment LHS rather than
          # the entire assignment
          result, = *result while result.op_asgn_type? || result.masgn_type?
          result
        end

        def block_end_align_target(node)
          lineage = [node, *node.ancestors]

          target = lineage.each_cons(2) do |current, parent|
            break current if end_align_target?(current, parent)
          end

          target || lineage.last
        end

        def end_align_target?(node, parent)
          disqualified_parent?(parent, node) ||
            !block_end_align_target?(parent, node)
        end

        def disqualified_parent?(parent, node)
          parent&.loc && parent.first_line != node.first_line &&
            !parent.masgn_type?
        end

        def check_block_alignment(start_node, block_node)
          end_loc = block_node.loc.end
          return unless begins_its_line?(end_loc)

          start_loc = start_node.source_range
          return unless start_loc.column != end_loc.column ||
                        style == :start_of_block

          do_source_line_column =
            compute_do_source_line_column(block_node, end_loc)
          return unless do_source_line_column

          register_offense(
            block_node,
            start_loc,
            end_loc,
            do_source_line_column
          )
        end

        def register_offense(block_node,
                             start_loc,
                             end_loc,
                             do_source_line_column)

          error_source_line_column = if style == :start_of_block
                                       do_source_line_column
                                     else
                                       loc_to_source_line_column(start_loc)
                                     end

          message = format_message(start_loc, end_loc, do_source_line_column,
                                   error_source_line_column)

          add_offense(block_node, location: end_loc, message: message)
        end

        def format_message(start_loc, end_loc, do_source_line_column,
                           error_source_line_column)
          format(
            MSG,
            current: format_source_line_column(
              loc_to_source_line_column(end_loc)
            ),
            prefer: format_source_line_column(error_source_line_column),
            alt_prefer: alt_start_msg(start_loc, do_source_line_column)
          )
        end

        def compute_do_source_line_column(node, end_loc)
          do_loc = node.loc.begin # Actually it's either do or {.

          # We've found that "end" is not aligned with the start node (which
          # can be a block, a variable assignment, etc). But we also allow
          # the "end" to be aligned with the start of the line where the "do"
          # is, which is a style some people use in multi-line chains of
          # blocks.
          match = /\S.*/.match(do_loc.source_line)
          indentation_of_do_line = match.begin(0)
          return unless end_loc.column != indentation_of_do_line ||
                        style == :start_of_line

          {
            source: match[0],
            line: do_loc.line,
            column: indentation_of_do_line
          }
        end

        def loc_to_source_line_column(loc)
          {
            source: loc.source.lines.to_a.first.chomp,
            line: loc.line,
            column: loc.column
          }
        end

        def alt_start_msg(start_loc, source_line_column)
          if style != :either
            ''
          elsif start_loc.line == source_line_column[:line] &&
                start_loc.column == source_line_column[:column]
            ''
          else
            ' or ' + format_source_line_column(source_line_column)
          end
        end

        def format_source_line_column(source_line_column)
          "`#{source_line_column[:source]}` at #{source_line_column[:line]}, " \
          "#{source_line_column[:column]}"
        end

        def compute_start_col(ancestor_node, node)
          if style == :start_of_block
            do_loc = node.loc.begin
            return do_loc.source_line =~ /\S/
          end
          (ancestor_node || node).source_range.column
        end

        def add_space_before(loc, delta)
          ->(corrector) { corrector.insert_before(loc, ' ' * delta) }
        end

        def remove_space_before(end_pos, delta)
          range = range_between(end_pos - delta, end_pos)
          ->(corrector) { corrector.remove(range) }
        end
      end
    end
  end
end
