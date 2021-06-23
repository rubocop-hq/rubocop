# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks the style of children definitions at classes and
      # modules. Basically there are two different styles:
      #
      # @example EnforcedStyle: nested (default)
      #   # good
      #   # have each child on its own line
      #   class Foo
      #     class Bar
      #     end
      #   end
      #
      # @example EnforcedStyle: compact
      #   # good
      #   # combine definitions as much as possible
      #   class Foo::Bar
      #   end
      #
      # The compact style is only forced for classes/modules with one child.
      #
      # @example EnforcedStyle: namespaced
      #   # good
      #   # combine namespacing modules as much as possible,
      #   # but keep the constant definition on its own line
      #   module Foo::Bar::Baz::Qux::Quux::Quuz::Corge::Grault::Garply
      #     module Waldo
      #     end
      #   end
      class ClassAndModuleChildren < Base
        include ConfigurableEnforcedStyle
        include RangeHelp
        extend AutoCorrector

        NESTED_MSG = 'Use nested module/class definitions instead of compact style.'
        NAMESPACING_MSG = 'Keep namespacing module in compact style.'
        NAMESPACED_MODULE_MSG = 'Keep module definition separate from namespacing module.'
        NAMESPACED_CLASS_MSG = 'Keep class definition separate from namespacing module.'
        USING_CLASS_AS_NAMESPACE_MSG = 'Don\'t use classes as a namespace.'
        COMPACT_MSG = 'Use compact module/class definition instead of nested style.'

        def on_class(node)
          return if skip_compact?(node)

          check_style(node, node.body)
        end

        def on_module(node)
          check_style(node, node.body)
        end

        private

        def nest_or_compact(corrector, node)
          if style == :nested
            nest_definition(corrector, node)
          else
            compact_definition(corrector, node)
          end
        end

        def nest_definition(corrector, node)
          padding = ((' ' * indent_width) + leading_spaces(node)).to_s
          padding_for_trailing_end = padding.sub(' ' * node.loc.end.column, '')

          replace_namespace_keyword(corrector, node)
          split_on_double_colon(corrector, node, padding)
          add_trailing_end(corrector, node, padding_for_trailing_end)
        end

        def replace_namespace_keyword(corrector, node)
          class_definition = node.left_sibling&.each_node(:class)&.find do |class_node|
            class_node.identifier == node.identifier.namespace
          end
          namespace_keyword = class_definition ? 'class' : 'module'

          corrector.replace(node.loc.keyword, namespace_keyword)
        end

        def split_on_double_colon(corrector, node, padding)
          children_definition = node.children.first
          range = range_between(children_definition.loc.double_colon.begin_pos,
                                children_definition.loc.double_colon.end_pos)
          replacement = "\n#{padding}#{node.loc.keyword.source} "

          corrector.replace(range, replacement)
        end

        def add_trailing_end(corrector, node, padding)
          replacement = "#{padding}end\n#{leading_spaces(node)}end"
          corrector.replace(node.loc.end, replacement)
        end

        def namespace_definition(corrector, node)
          compact_node(corrector, node)
          remove_end(corrector, node.body)
        end

        def compact_definition(corrector, node)
          compact_node(corrector, node)
          remove_end(corrector, node.body)
        end

        def compact_node(corrector, node)
          range = range_between(node.loc.keyword.begin_pos, node.body.loc.name.end_pos)
          corrector.replace(range, compact_replacement(node))
        end

        def compact_replacement(node)
          replacement = "#{node.body.type} #{compact_identifier_name(node)}"

          body_comments = processed_source.ast_with_comments[node.body]
          unless body_comments.empty?
            replacement = body_comments.map(&:text).push(replacement).join("\n")
          end
          replacement
        end

        def compact_identifier_name(node)
          "#{node.identifier.const_name}::" \
            "#{node.body.children.first.const_name}"
        end

        def remove_end(corrector, body)
          range = range_between(
            body.loc.end.begin_pos - leading_spaces(body).size,
            body.loc.end.end_pos + 1
          )
          corrector.remove(range)
        end

        def leading_spaces(node)
          node.source_range.source_line[/\A\s*/]
        end

        def indent_width
          @config.for_cop('Layout/IndentationWidth')['Width'] || 2
        end

        def check_style(node, body)
          return if node.identifier.children[0]&.cbase_type?

          case style
          when :nested
            check_nested_style(node)
          when :namespace
            check_namespaced_style(node)
          when :compact
            check_compact_style(node, body)
          end
        end

        def check_nested_style(node)
          return unless compact_node_name?(node)

          add_offense(node.loc.name, message: NESTED_MSG) do |corrector|
            autocorrect(corrector, node)
          end
        end

        def check_namespaced_style(node)
          return if already_warned_about_class_as_namespace?(node)

          if LowestLevelConstantDefinition.check(node)
            check_class_or_module_definition_namespacing(node)
          else
            check_namespacing_node?(node)
          end
        end

        def check_namespacing_node?(node)
          return if class_as_namespace(node)
          return if NamespacingModule.check(node)
          return if LowestLevelConstantDefinition.check(node)
          return if already_warned_about_namespace?(node)

          warn_about_namespace(node)
          add_offense(node.loc.name, message: NAMESPACING_MSG) do |corrector|
            namespace_definition(corrector, node)
          end

          nil
        end

        def class_as_namespace(node)
          return false unless UsingClassAsNamespace.check(node)

          warn_about_class_as_namespace(node)
          add_offense(node.loc.name, message: USING_CLASS_AS_NAMESPACE_MSG)

          true
        end

        def warn_about_namespace(node)
          already_warned_about_namespace.add node
        end

        def already_warned_about_namespace?(node)
          node.ancestors.any? { |n| already_warned_about_namespace.include?(n) }
        end

        def already_warned_about_namespace
          @already_warned_about_namespace ||= Set.new
        end

        def already_warned_about_class_as_namespace?(node)
          node.ancestors.any? { |n| already_warned_about_class_as_namespace.include?(n) }
        end

        def warn_about_class_as_namespace(node)
          already_warned_about_class_as_namespace.add node
        end

        def already_warned_about_class_as_namespace
          @already_warned_about_class_as_namespace ||= Set.new
        end

        def check_class_or_module_definition_namespacing(node)
          return true if DefinitionNamespacedCorrectly.check(node)

          message = node.class_type? ? NAMESPACED_CLASS_MSG : NAMESPACED_MODULE_MSG

          add_offense(node.loc.name, message: message)
        end

        def check_compact_style(node, body)
          parent = node.parent
          return if parent&.class_type? || parent&.module_type?

          return unless needs_compacting?(body)

          add_offense(node.loc.name, message: COMPACT_MSG) do |corrector|
            autocorrect(corrector, node)
          end
        end

        def autocorrect(corrector, node)
          return if node.class_type? && skip_compact?(node)

          nest_or_compact(corrector, node)
        end

        def skip_compact?(node)
          node.parent_class && style == :compact
        end

        def needs_compacting?(body)
          body && %i[module class].include?(body.type)
        end

        def compact_node_name?(node)
          /::/.match?(node.identifier.source)
        end

        # A base class for some checks performed whilst checking modules and their children
        class CheckBase
          def self.check(node)
            new(node).check
          end

          attr_reader :node

          def initialize(node)
            @node = node
          end

          def constant_has_no_colon?
            node.children.first.loc.double_colon.nil?
          end

          def class_or_module_children?
            node.descendants.any? { |d| d.module_type? || d.class_type? }
          end

          def class_or_module
            @class_or_module ||= node.class_type? || node.module_type?
          end

          def top_level_constant
            class_or_module && empty_parent?
          end

          def empty_parent?
            node.parent.nil? || (begin_block? && node.parent.parent.nil?)
          end

          def non_namespaced_top_level_constant
            top_level_constant && constant_has_no_colon?
          end

          def begin_block?
            node.parent&.begin_type?
          end
        end

        private_constant :CheckBase

        # Checks that a module is correctly namespaced
        class NamespacingModule < CheckBase
          def check
            non_namespaced_children? &&
              ((node.module_type? && non_namespaced_top_level_constant) ||
               correctly_namespaced_top_level_module)
          end

          def non_namespaced_children?
            module_without_double_colon_and_without_module_descendants?(node) &&
              no_module_or_class_grandchildren?
          end

          def no_module_or_class_grandchildren?
            node.children.all? do |n|
              n.descendants.none? do |g|
                g.module_type? || g.class_type?
              end
            end
          end

          def module_without_double_colon_and_without_module_descendants?(node)
            module_descendants = node.descendants.select(&:module_type?)

            module_descendants.all? do |n|
              module_without_double_colon_and_without_module_descendants?(n)
            end
          end

          def correctly_namespaced_top_level_module
            top_level_constant && node.module_type? && class_or_module_children?
          end
        end

        private_constant :NamespacingModule

        # Checks that a constant node is at the lowest level of the AST constant hierarchy
        class LowestLevelConstantDefinition < CheckBase
          def check
            class_or_module && !class_or_module_children?
          end
        end

        private_constant :LowestLevelConstantDefinition

        # Checks that a leaf node constant is within the correct namespace
        class DefinitionNamespacedCorrectly < CheckBase
          def check
            non_namespaced_top_level_constant || parent_ok? && constant_has_no_colon?
          end

          def parent_ok?
            node.parent && node.parent.defined_module_name == node.parent_module_name
          end
        end

        private_constant :DefinitionNamespacedCorrectly

        # Checks that a class is not being used as a namespace
        class UsingClassAsNamespace < CheckBase
          def check
            node.class_type? && class_or_module_children?
          end
        end
        private_constant :UsingClassAsNamespace
      end
    end
  end
end
