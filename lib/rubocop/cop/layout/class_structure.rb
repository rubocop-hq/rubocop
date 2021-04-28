# frozen_string_literal: true

require 'diff-lcs'

module RuboCop
  module Cop
    module Layout
      # Checks if the code style follows the ExpectedOrder configuration:
      #
      # `Categories` allows us to map macro names into a category.
      #
      # Consider an example of code style that covers the following order:
      #
      # * Module inclusion (include, prepend, extend)
      # * Constants
      # * Associations (has_one, has_many)
      # * Public attribute macros (attr_accessor, attr_writer, attr_reader)
      # * Other macros (validates, validate)
      # * Public class methods
      # * Initializer
      # * Public instance methods
      # * Protected attribute macros (attr_accessor, attr_writer, attr_reader)
      # * Protected instance methods
      # * Private attribute macros (attr_accessor, attr_writer, attr_reader)
      # * Private instance methods
      #
      # You can configure the following order:
      #
      # [source,yaml]
      # ----
      #  Layout/ClassStructure:
      #    ExpectedOrder:
      #      - module_inclusion
      #      - constants
      #      - association
      #      - public_attribute_macros
      #      - public_delegate
      #      - macros
      #      - public_class_methods
      #      - initializer
      #      - public_methods
      #      - protected_attribute_macros
      #      - protected_methods
      #      - private_attribute_macros
      #      - private_delegate
      #      - private_methods
      # ----
      #
      # Instead of putting all literals in the expected order, is also
      # possible to group categories of macros. Visibility levels are handled
      # automatically.
      #
      # [source,yaml]
      # ----
      #  Layout/ClassStructure:
      #    Categories:
      #      association:
      #        - has_many
      #        - has_one
      #      attribute_macros:
      #        - attr_accessor
      #        - attr_reader
      #        - attr_writer
      #      macros:
      #        - validates
      #        - validate
      #      module_inclusion:
      #        - include
      #        - prepend
      #        - extend
      # ----
      #
      # @example
      #   # bad
      #   # Expect extend be before constant
      #   class Person < ApplicationRecord
      #     has_many :orders
      #     ANSWER = 42
      #
      #     extend SomeModule
      #     include AnotherModule
      #   end
      #
      #   # good
      #   class Person
      #     # extend and include go first
      #     extend SomeModule
      #     include AnotherModule
      #
      #     # inner classes
      #     CustomError = Class.new(StandardError)
      #
      #     # constants are next
      #     SOME_CONSTANT = 20
      #
      #     # afterwards we have public attribute macros
      #     attr_reader :name
      #
      #     # followed by other macros (if any)
      #     validates :name
      #
      #     # then we have public delegate macros
      #     delegate :to_s, to: :name
      #
      #     # public class methods are next in line
      #     def self.some_method
      #     end
      #
      #     # initialization goes between class methods and instance methods
      #     def initialize
      #     end
      #
      #     # followed by other public instance methods
      #     def some_method
      #     end
      #
      #     # protected attribute macros and methods go next
      #     protected
      #
      #     attr_reader :protected_name
      #
      #     def some_protected_method
      #     end
      #
      #     # private attribute macros, delegate macros and methods
      #     # are grouped near the end
      #     private
      #
      #     attr_reader :private_name
      #
      #     delegate :some_private_delegate, to: :name
      #
      #     def some_private_method
      #     end
      #   end
      #
      # @see https://rubystyle.guide#consistent-classes
      class ClassStructure < Base
        include VisibilityHelp
        extend AutoCorrector

        MSG = '`%<category>s` is supposed to appear %<relation>s `%<other_category>s`.'
        DEFAULT_CATEGORIES = %i[methods class_methods constants class_singleton initializer].freeze

        ATTRIBUTES = %i[attr_accessor attr_reader attr_writer attr].to_set.freeze
        private_constant :ATTRIBUTES

        def self.support_multiple_source?
          true
        end

        def initialize(*)
          super
          @classifer = Utils::ClassChildrenClassifier.new(all_symbolized_categories)
          @expected_order_index = expected_order.map.with_index.to_h.transform_keys(&:to_sym)
          @remap_initializer = if @expected_order_index.key?(:initializer)
                                 :do_not_remap
                               else
                                 :initializer
                               end
        end

        # @!method dynamic_expression?(node)
        def_node_matcher :dynamic_expression?, <<~PATTERN
          `{
            (send {nil? self} ...)   # potential class method call
            lvar                    # local variable
            (const {nil? self} !{    # potentially local constant
              :Set :Struct :Class   # but exclude known ones
              :Module :Regexp :Dir :Ractor
              :String :Hash :Array
            })
          }
        PATTERN

        # @!method dynamic_constant?(node)
        def_node_matcher :dynamic_constant?, <<~PATTERN
          (casgn nil? _ #dynamic_expression?)
        PATTERN

        # Validates code style on class declaration.
        # Add offense when find a node out of expected order.
        def on_class(class_node)
          current = classify_all(class_node)
          ordered = current.sort_by.with_index { |n, i| [group_order(n), i] }
          return if current == ordered

          used_categories = ordered.map { |n| expected_order[group_order(n)] }.uniq

          each_move(current, ordered) do |node, relation, pos|
            add_offense(node, message: message(node, relation, used_categories)) do |corrector|
              move_code(corrector, node, relation, pos)
            end
          end
        end

        alias on_sclass on_class

        private

        def all_symbolized_categories
          @all_symbolized_categories ||= {
            **default_attribute_category,
            **ungrouped_categories.map { |categ| [categ, [categ]] }.to_h,
            **symbolized_categories
          }
        end

        # @return [Array<Symbol>] macros appearing directly in ExpectedOrder
        def ungrouped_categories
          @ungrouped_categories ||= expected_order
                                    .map { |str| str.sub(/^(public|protected|private)_/, '') }
                                    .uniq
                                    .map(&:to_sym) - DEFAULT_CATEGORIES
        end

        # @return [Hash<Symbol => Array<Symbol>>] config of Categories, using symbols
        def symbolized_categories
          @symbolized_categories ||= categories.map do |key, values|
            [key.to_sym, values.map(&:to_sym)]
          end.to_h
        end

        def default_attribute_category
          missing = missing_attributes
          return {} if missing.empty?

          { methods: missing }
        end

        # @return [Array<Symbol>] the attribute methods that are not present in the config
        def missing_attributes
          missing = ATTRIBUTES - ungrouped_categories
          symbolized_categories.values.inject(missing, :-)
        end

        def classify_all(class_node)
          @classification = @classifer.classify_children(class_node)
          @classification.map do |node, classification|
            node if complete_classification(node, classification)
          end.compact
        end

        def each_move(current, ordered) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
          removed = Set[]
          previous = Hash.new { |_h, k| k }
          changes = Diff::LCS.diff(current, ordered).flatten(1)

          changes.each do |kind, index, node|
            if kind == '-'
              removed << node
            else
              relation = removed.include?(node) ? :after : :before
              prev = previous[index] = previous[index - 1]
              if prev == -1
                pos = at(begin_pos_with_comment(current[0]))
              else
                pos = at(end_position_for(ordered[prev]))
                pos = succeeding_empty_line(pos) || pos if relation == :before
              end
              yield node, relation, pos
            end
          end
        end

        def at(pos)
          Parser::Source::Range.new(buffer, pos, pos)
        end

        def message(node, relation, used_categories)
          category = expected_order[group_order(node)]
          delta = relation == :before ? 1 : -1
          other_category = used_categories[used_categories.index(category) + delta]
          format(MSG, category: category, other_category: other_category, relation: relation)
        end

        def complete_classification(_node, classification) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          return unless classification

          affects = classification[:affects_categories] || []
          categ = classification[:category]
          categ = :methods if categ == @remap_initializer
          # post macros without a particular category and
          # refering only to unknowns are ignored
          # (e.g. `private :some_unknown_method`)
          return if classification[:macro] == :post && categ.nil? && affects.empty?

          categ ||= classification[:group]
          visibility = classification[:visibility]
          classification[:group_order] = \
            if affects.empty?
              find_group_order(visibility, categ)
            else
              all = affects.map { |name| find_group_order(visibility, name) }
              classification[:macro] == :pre ? all.min : all.max
            end
        end

        def find_group_order(visibility, categ)
          visibility_categ = :"#{visibility}_#{categ}"
          @expected_order_index[visibility_categ] || @expected_order_index[categ]
        end

        # Autocorrect by swapping between two nodes autocorrecting them
        def move_code(corrector, node, relation, position)
          return if dynamic_constant?(node)

          # We handle empty lines as follows:
          # if `current` is preceeded with an empty line, remove it
          # and add an empty line after `current`.
          #
          # This way:
          #   <previous><current> => <current><previous>
          #   <previous>\n<current> => <current>\n<previous>
          #
          # Of course, `current` and `previous` may not be adjacent,
          # but this heuristic should provide adequate results.
          current_range = source_range_with_comment(node)

          if relation == :after && (empty_line = succeeding_empty_line(current_range))
            corrector.remove(empty_line)
            corrector.insert_after(position, "\n")
          end
          corrector.insert_after(position, current_range.source)
          corrector.remove(current_range)
          if relation == :before && (empty_line = preceeding_empty_line(current_range))
            corrector.remove(empty_line)
            corrector.insert_after(position, "\n")
          end

          nil
        end

        # @return [Range | nil]
        def preceeding_empty_line(range)
          prec = buffer.line_range(range.line - 1).adjust(end_pos: +1)
          prec if prec.source.blank?
        end

        def succeeding_empty_line(range)
          succ = buffer.line_range(range.last_line).adjust(end_pos: +1)
          succ if succ.source.blank?
        end

        # @return [Integer | nil]
        def group_order(node)
          return unless (c = @classification[node])

          c[:group_order]
        end

        def ignore_for_autocorrect?(node, sibling)
          index = group_order(node)
          sibling_index = group_order(sibling)

          sibling_index.nil? || index == sibling_index
        end

        def source_range_with_comment(node)
          node.loc.expression.with(
            begin_pos: begin_pos_with_comment(node),
            end_pos: end_position_for(node)
          )
        end

        def end_position_for(node)
          heredoc = find_heredoc(node)
          return heredoc.location.heredoc_end.end_pos + 1 if heredoc

          end_line = buffer.line_for_position(node.loc.expression.end_pos)
          buffer.line_range(end_line).end_pos + 1
        end

        def begin_pos_with_comment(node)
          exclude_line = (node.first_line - 1).downto(1).find do |annotation_line|
            !buffer.source_line(annotation_line).match?(/^\s*#/)
          end || 0

          buffer.line_range(exclude_line + 1).begin_pos
        end

        def find_heredoc(node)
          node.each_node(:str, :dstr, :xstr).find(&:heredoc?)
        end

        def buffer
          processed_source.buffer
        end

        # Load expected order from `ExpectedOrder` config.
        # Define new terms in the expected order by adding new {categories}.
        def expected_order
          cop_config['ExpectedOrder']
        end

        # Setting categories hash allow you to group methods in group to match
        # in the {expected_order}.
        def categories
          cop_config['Categories'] || {}
        end
      end
    end
  end
end
