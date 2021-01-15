# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      # This cop checks that the indentation method is consistent.
      # Either tabs only or spaces only are used for indentation.
      #
      # The `IndentationWidth` attribute is ignored when `EnforcedStyle` is `tabs`.
      #
      # When `EnforcedStyle` is set to `tabs` it is recommended to also set
      # `Layout/IndentationWidth`'s `Width` attribute to `1`.
      #
      # @example EnforcedStyle: spaces (default)
      #   # bad
      #   # This example uses a tab to indent bar.
      #   def foo
      #     bar
      #   end
      #
      #   # good
      #   # This example uses spaces to indent bar.
      #   def foo
      #     bar
      #   end
      #
      # @example EnforcedStyle: tabs
      #   # bad
      #   # This example uses spaces to indent bar.
      #   def foo
      #     bar
      #   end
      #
      #   # good
      #   # This example uses a tab to indent bar.
      #   def foo
      #     bar
      #   end
      class IndentationStyle < Cop
        include Alignment
        include ConfigurableEnforcedStyle
        include RangeHelp

        MSG = '%<type>s detected in indentation.'

        def investigate(processed_source)
          str_ranges = string_literal_ranges(processed_source.ast)

          processed_source.lines.each.with_index(1) do |line, lineno|
            match = find_offence(line)
            next unless match

            range = source_range(processed_source.buffer,
                                 lineno,
                                 match.begin(0)...match.end(0))
            next if in_string_literal?(str_ranges, range)

            add_offense(range, location: range)
          end
        end

        def autocorrect(range)
          if range.source.include?("\t")
            autocorrect_lambda_for_tabs(range)
          else
            autocorrect_lambda_for_spaces(range)
          end
        end

        private

        def find_offence(line)
          if style == :spaces
            line.match(/\A\s*\t+/)
          else
            line.match(/\A\s* +/)
          end
        end

        def autocorrect_lambda_for_tabs(range)
          lambda do |corrector|
            spaces = ' ' * configured_indentation_width
            corrector.replace(range, range.source.gsub(/\t/, spaces))
          end
        end

        def autocorrect_lambda_for_spaces(range)
          lambda do |corrector|
            corrector.replace(range, range.source.gsub(/\A\s+/) do |match|
              "\t" * match.size
            end)
          end
        end

        def in_string_literal?(ranges, tabs_range)
          ranges.any? { |range| range.contains?(tabs_range) }
        end

        def string_literal_ranges(ast)
          # which lines start inside a string literal?
          return [] if ast.nil?

          ast.each_node(:str, :dstr).each_with_object(Set.new) do |str, ranges|
            loc = str.location

            if str.heredoc?
              ranges << loc.heredoc_body
            elsif loc.respond_to?(:begin) && loc.begin
              ranges << loc.expression
            end
          end
        end

        def message(_node)
          format(MSG, type: style == :spaces ? 'Tab' : 'Space')
        end
      end
    end
  end
end
