# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Checks for places where string concatenation
      # can be replaced with string interpolation.
      #
      # The cop can autocorrect simple cases but will skip autocorrecting
      # more complex cases where the resulting code would be harder to read.
      # In those cases, it might be useful to extract statements to local
      # variables or methods which you can then interpolate in a string.
      #
      # NOTE: When concatenation between two strings is broken over multiple
      # lines, this cop does not register an offense; instead,
      # `Style/LineEndConcatenation` will pick up the offense if enabled.
      #
      # This cop does not register an offense for concatenation with a heredoc
      # either, because interpolating the heredoc into a string literal would not
      # make the code easier to read.
      #
      # Two modes are supported:
      # 1. `aggressive` style checks and corrects all occurrences of `+` where
      # either the left or right side of `+` is a string literal.
      # 2. `conservative` style on the other hand, checks and corrects only if
      # left side (receiver of `+` method call) is a string literal.
      # This is useful when the receiver is some expression that returns string like `Pathname`
      # instead of a string literal.
      #
      # @safety
      #   This cop is unsafe in `aggressive` mode, as it cannot be guaranteed that
      #   the receiver is actually a string, which can result in a false positive.
      #
      # @example Mode: aggressive (default)
      #   # bad
      #   email_with_name = user.name + ' <' + user.email + '>'
      #   Pathname.new('/') + 'test'
      #
      #   # good
      #   email_with_name = "#{user.name} <#{user.email}>"
      #   email_with_name = format('%s <%s>', user.name, user.email)
      #   "#{Pathname.new('/')}test"
      #
      #   # accepted, line-end concatenation
      #   name = 'First' +
      #     'Last'
      #
      #   # accepted, concatenation with a heredoc
      #   'Hello' + <<~TEXT
      #     world
      #   TEXT
      #
      # @example Mode: conservative
      #   # bad
      #   'Hello' + user.name
      #
      #   # good
      #   "Hello #{user.name}"
      #   user.name + '!!'
      #   Pathname.new('/') + 'test'
      #
      class StringConcatenation < Base
        extend AutoCorrector

        MSG = 'Prefer string interpolation to string concatenation.'
        RESTRICT_ON_SEND = %i[+].freeze

        # @!method string_concatenation?(node)
        def_node_matcher :string_concatenation?, <<~PATTERN
          {
            (send str_type? :+ _)
            (send _ :+ str_type?)
          }
        PATTERN

        def on_new_investigation
          @corrected_nodes = nil
        end

        def on_send(node)
          return unless string_concatenation?(node)
          return if line_end_concatenation?(node)

          topmost_plus_node = find_topmost_plus_node(node)
          return if heredoc?(topmost_plus_node)

          parts = collect_parts(topmost_plus_node)
          return if mode == :conservative && !parts.first.str_type?

          register_offense(topmost_plus_node, parts)
        end

        private

        def register_offense(topmost_plus_node, parts)
          add_offense(topmost_plus_node) do |corrector|
            correctable_parts = parts.none? { |part| uncorrectable?(part) }
            if correctable_parts && !corrected_ancestor?(topmost_plus_node)
              corrector.replace(topmost_plus_node, replacement(parts))

              @corrected_nodes ||= Set.new.compare_by_identity
              @corrected_nodes.add(topmost_plus_node)
            end
          end
        end

        def line_end_concatenation?(node)
          # If the concatenation happens at the end of the line,
          # and both the receiver and argument are strings, allow
          # `Style/LineEndConcatenation` to handle it instead.
          node.receiver.str_type? &&
            node.first_argument.str_type? &&
            node.multiline? &&
            node.source.match?(/\+\s*\n/)
        end

        def find_topmost_plus_node(node)
          current = node
          while (parent = current.parent) && plus_node?(parent)
            current = parent
          end
          current
        end

        def heredoc?(node)
          node.each_descendant(:any_str).any?(&:heredoc?)
        end

        def collect_parts(node, parts = [])
          return unless node

          if plus_node?(node)
            collect_parts(node.receiver, parts)
            collect_parts(node.first_argument, parts)
          else
            parts << node
          end
        end

        def plus_node?(node)
          node.send_type? && node.method?(:+)
        end

        def uncorrectable?(part)
          part.multiline? || part.each_descendant(:any_block).any?
        end

        def corrected_ancestor?(node)
          node.each_ancestor(:send).any? { |ancestor| @corrected_nodes&.include?(ancestor) }
        end

        def replacement(parts)
          interpolated_parts = parts.map { |part| adjust_str(part) }

          "\"#{join_parts(handle_quotes(interpolated_parts))}\""
        end

        def join_parts(parts)
          parts.each_with_object(+'') do |part, result|
            result.insert(-2, '\\') if interpolation_formed?(result, part)
            result << part
          end
        end

        def interpolation_formed?(preceding, part)
          part.start_with?('{', '@', '$') && preceding.match?(/(?<!\\)(?:\\\\)*#\z/)
        end

        def adjust_str(part)
          case part.type
          when :str
            adjust_str_literal(part)
          when :dstr, :begin
            part.children.map do |child|
              adjust_str(child)
            end.join
          else
            "\#{#{part.source}}"
          end
        end

        def adjust_str_literal(part)
          if file_keyword?(part)
            "\#{#{part.source}}"
          elsif single_quoted?(part)
            part.value.gsub(/(\\|"|#\{|#@|#\$)/, '\\\\\&')
          elsif double_quoted?(part)
            # Reuse the source as written - rebuilding it from the value via
            # `inspect` would rewrite the author's escape notation
            # (e.g. `\x0a` into `\n`).
            part.source[1..-2]
          else
            part.value.inspect[1..-2]
          end
        end

        def handle_quotes(parts)
          parts.map do |part|
            part == '"' ? '\"' : part
          end
        end

        def file_keyword?(str_node)
          str_node.source == '__FILE__' && !str_node.parent.dstr_type?
        end

        def single_quoted?(str_node)
          str_node.loc.begin && str_node.source.start_with?("'")
        end

        def double_quoted?(str_node)
          str_node.loc.begin && str_node.source.start_with?('"')
        end

        def mode
          cop_config['Mode'].to_sym
        end
      end
    end
  end
end
