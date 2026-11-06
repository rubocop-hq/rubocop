# frozen_string_literal: true

module RuboCop
  module Cop
    module Lint
      # Checks for operators, variables, literals, lambda, proc and nonmutating
      # methods used in void context.
      #
      # `each` blocks are allowed to prevent false positives.
      # For example, the expression inside the `each` block below.
      # It's not void, especially when the receiver is an `Enumerator`:
      #
      # [source,ruby]
      # ----
      # enumerator = [1, 2, 3].filter
      # enumerator.each { |item| item >= 2 } #=> [2, 3]
      # ----
      #
      # NOTE: The last expression in an assignment method definition such as `def foo=(arg)`
      # is not flagged. Ruby discards it (the method returns its argument), but the method can
      # still be called directly and its return value relied upon, so flagging it would be a
      # false positive for this lint.
      #
      # NOTE: A constant used in a void context is flagged but not autocorrected, since
      # referencing a constant can trigger autoloading side effects (e.g. forcing a file to
      # load before a monkey-patch), so removing it may change behavior.
      #
      # @example CheckForMethodsWithNoSideEffects: false (default)
      #   # bad
      #   def some_method
      #     some_num * 10
      #     do_something
      #   end
      #
      #   def some_method(some_var)
      #     some_var
      #     do_something
      #   end
      #
      # @example CheckForMethodsWithNoSideEffects: true
      #   # bad
      #   def some_method(some_array)
      #     some_array.sort
      #     do_something(some_array)
      #   end
      #
      #   # good
      #   def some_method
      #     do_something
      #     some_num * 10
      #   end
      #
      #   def some_method(some_var)
      #     do_something
      #     some_var
      #   end
      #
      #   def some_method(some_array)
      #     some_array.sort!
      #     do_something(some_array)
      #   end
      class Void < Base
        extend AutoCorrector

        include RangeHelp

        OP_MSG = 'Operator `%<op>s` used in void context.'
        VAR_MSG = 'Variable `%<var>s` used in void context.'
        CONST_MSG = 'Constant `%<var>s` used in void context.'
        LIT_MSG = 'Literal `%<lit>s` used in void context.'
        SELF_MSG = '`self` used in void context.'
        EXPRESSION_MSG = '`%<expression>s` used in void context.'
        NONMUTATING_MSG = 'Method `#%<method>s` used in void context. Did you mean `#%<suggest>s`?'

        BINARY_OPERATORS = %i[* / % + - == === != < > <= >= <=>].freeze
        UNARY_OPERATORS = %i[+@ -@ ~ !].freeze
        OPERATORS = (BINARY_OPERATORS + UNARY_OPERATORS).freeze
        NON_VALUE_ARGUMENT_TYPES = %i[splat block_pass forwarded_args forwarded_restarg].freeze
        NONMUTATING_METHODS_WITH_BANG_VERSION = %i[capitalize chomp chop compact
                                                   delete_prefix delete_suffix downcase
                                                   encode flatten gsub lstrip merge next
                                                   reject reverse rotate rstrip scrub select
                                                   shuffle slice sort sort_by squeeze strip sub
                                                   succ swapcase tr tr_s transform_values
                                                   unicode_normalize uniq upcase].freeze
        METHODS_REPLACEABLE_BY_EACH = %i[collect map].freeze

        NONMUTATING_METHODS = (NONMUTATING_METHODS_WITH_BANG_VERSION +
                               METHODS_REPLACEABLE_BY_EACH).freeze

        def on_block(node)
          return unless node.body && !node.body.begin_type?
          return unless in_void_context?(node.body)
          return if node.method?(:each)

          check_void_op(node.body)
          check_expression(node.body)
        end
        alias on_numblock on_block
        alias on_itblock on_block

        def on_begin(node)
          check_begin(node)
        end
        alias on_kwbegin on_begin

        def on_ensure(node)
          check_ensure(node)
        end

        private

        def check_begin(node)
          expressions = *node
          inside_each_block = node.each_ancestor(:any_block).first&.method?(:each)
          expressions.pop if !in_void_context?(node) || inside_each_block || setter_method?(node)
          expressions.each do |expr|
            check_void_op(expr) { inside_each_block }
            check_expression(expr)
          end
        end

        def check_expression(expr)
          return check_if_expression(expr) if expr.if_type?
          return check_case_expression(expr) if expr.case_type?
          return check_case_match_expression(expr) if expr.case_match_type?

          check_void_expression_nodes(expr)
        end

        def check_void_expression_nodes(expr)
          check_literal(expr)
          check_var(expr)
          check_self(expr)
          check_void_expression(expr)
          return unless cop_config['CheckForMethodsWithNoSideEffects']

          check_nonmutating(expr)
        end

        def check_if_expression(if_node)
          check_void_expression_nodes(if_node.body) if if_node.body
        end

        def check_case_expression(case_node)
          case_node.each_when { |when_node| check_expression(when_node.body) if when_node.body }
          check_expression(case_node.else_branch) if case_node.else_branch
        end

        def check_case_match_expression(case_node)
          case_node.each_in_pattern do |in_pattern_node|
            check_expression(in_pattern_node.body) if in_pattern_node.body
          end
          check_expression(case_node.else_branch) if case_node.else_branch
        end

        # rubocop:disable-next Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def check_void_op(node, &block)
          node = node.children.first while node&.begin_type?
          return unless node&.call_type? && OPERATORS.include?(node.method_name)
          return unless operation?(node)

          return if block && yield(node)

          add_offense(node.loc.selector,
                      message: format(OP_MSG, op: node.method_name)) do |corrector|
            autocorrect_void_op(corrector, node)
          end
        end

        def operation?(node)
          return UNARY_OPERATORS.include?(node.method_name) || !node.loc.dot if node.arguments.none?
          return false if !node.arguments.one? || trailing_comma?(node)

          argument = node.first_argument

          argument.hash_type? ? argument.braces? : !argument.type?(*NON_VALUE_ARGUMENT_TYPES)
        end

        def trailing_comma?(node)
          node.last_argument.source_range.end.join(node.source_range.end).source.include?(',')
        end

        def check_var(node)
          return unless node.variable? || node.const_type?

          if node.const_type?
            template = node.special_keyword? ? VAR_MSG : CONST_MSG

            offense_range = node
            message = format(template, var: node.source)
          else
            offense_range = node.loc.name
            message = format(VAR_MSG, var: node.loc.name.source)
          end

          add_offense(offense_range, message: message) do |corrector|
            autocorrect_void_expression(corrector, node)
          end
        end

        def check_literal(node)
          if !entirely_literal?(node) || node.xstr_type? || node.range_type? || node.nil_type?
            return
          end

          add_offense(node, message: format(LIT_MSG, lit: node.source)) do |corrector|
            next if node.each_descendant(:begin).any?

            autocorrect_void_expression(corrector, node)
          end
        end

        def check_self(node)
          return unless node.self_type?

          add_offense(node, message: SELF_MSG) do |corrector|
            autocorrect_void_expression(corrector, node)
          end
        end

        def check_void_expression(node)
          return unless node.defined_type? || node.lambda_or_proc?

          add_offense(node, message: format(EXPRESSION_MSG, expression: node.source)) do |corrector|
            autocorrect_void_expression(corrector, node)
          end
        end

        def check_nonmutating(node)
          return unless node.type?(:call, :any_block)

          method_name = node.method_name
          return unless NONMUTATING_METHODS.include?(method_name)

          suggestion = if METHODS_REPLACEABLE_BY_EACH.include?(method_name)
                         'each'
                       else
                         "#{method_name}!"
                       end
          add_offense(node,
                      message: format(NONMUTATING_MSG, method: method_name,
                                                       suggest: suggestion)) do |corrector|
            autocorrect_nonmutating_send(corrector, node, suggestion)
          end
        end

        def check_ensure(node)
          return unless (body = node.branch)
          # NOTE: the `begin` node case is already handled via `on_begin`
          return if body.begin_type?

          check_expression(body)
        end

        def in_void_context?(node)
          parent = node.parent
          return false unless parent && parent.children.last == node

          parent.respond_to?(:void_context?) && parent.void_context?
        end

        def setter_method?(node)
          node.parent&.any_def_type? && node.parent.assignment_method?
        end

        def autocorrect_void_op(corrector, node)
          if node.arguments.empty?
            corrector.replace(node, node.receiver.source)
          else
            corrector.remove(node.loc.dot) if node.loc.dot
            corrector.replace(
              range_with_surrounding_space(range: node.loc.selector, side: :both,
                                           newlines: false),
              "\n"
            )
          end
        end

        def autocorrect_void_expression(corrector, node)
          # Referencing a constant can trigger autoloading side effects (e.g. forcing a file
          # to load before a monkey-patch), so removing it may change behavior. Flag but don't
          # autocorrect, leaving it to the user.
          return if node.const_type? && !node.special_keyword?
          return if node.parent.type?(:if, :case, :when, :case_match, :in_pattern)
          return if (def_node = node.each_ancestor(:any_def).first) && def_node.assignment_method?

          range = range_with_surrounding_space(range: void_expression_range(node), side: :left)
          corrector.remove(range)
        end

        def void_expression_range(node)
          return node.source_range unless node.respond_to?(:heredoc?) && node.heredoc?

          node.source_range.join(node.loc.heredoc_end)
        end

        def autocorrect_nonmutating_send(corrector, node, suggestion)
          send_node = node.call_type? ? node : node.send_node

          corrector.replace(send_node.loc.selector, suggestion)
        end

        def entirely_literal?(node)
          case node.type
          when :array
            all_values_entirely_literal?(node)
          when :hash
            all_keys_entirely_literal?(node) && all_values_entirely_literal?(node)
          when :send, :csend
            node.method?(:freeze) && node.receiver && entirely_literal?(node.receiver)
          else
            node.literal?
          end
        end

        def all_keys_entirely_literal?(node)
          node.each_key.all? { |key| entirely_literal?(key) }
        end

        def all_values_entirely_literal?(node)
          node.each_value.all? { |value| entirely_literal?(value) }
        end
      end
    end
  end
end
