# frozen_string_literal: true

module RuboCop
  module Cop
    class VariableForce
      # This class represents each assignment of a variable.
      class Assignment
        include Branchable

        MULTIPLE_LEFT_HAND_SIDE_TYPE = :mlhs

        def initialize(node, variable)
          unless VARIABLE_ASSIGNMENT_TYPES.include?(node.type)
            raise ArgumentError,
                  "Node type must be any of #{VARIABLE_ASSIGNMENT_TYPES}, " \
                  "passed #{node.type}"
          end

          @node = node
          @variable = variable
          @referenced = false
          @references = []
        end

        attr_reader :node, :variable, :referenced, :references

        alias referenced? referenced

        def name
          @node.children.first
        end

        def scope
          @variable.scope
        end

        def reference!(node)
          @references << node
          @referenced = true
        end

        def used?
          @variable.captured_by_block? || @referenced
        end

        def regexp_named_capture?
          @node.type == REGEXP_NAMED_CAPTURE_TYPE
        end

        def operator_assignment?
          return false unless meta_assignment_node

          OPERATOR_ASSIGNMENT_TYPES.include?(meta_assignment_node.type)
        end

        def multiple_assignment?
          return false unless meta_assignment_node

          meta_assignment_node.type == MULTIPLE_ASSIGNMENT_TYPE
        end

        def operator
          assignment_node = meta_assignment_node || @node
          assignment_node.loc.operator.source
        end

        def meta_assignment_node
          unless instance_variable_defined?(:@meta_assignment_node)
            @meta_assignment_node = operator_assignment_node || multiple_assignment_node
          end

          @meta_assignment_node
        end

        private

        def operator_assignment_node
          return nil unless node.parent
          return nil unless OPERATOR_ASSIGNMENT_TYPES.include?(node.parent.type)
          return nil unless node.sibling_index.zero?

          node.parent
        end

        def multiple_assignment_node
          grandparent_node = node.parent ? node.parent.parent : nil
          return nil unless grandparent_node
          return nil unless grandparent_node.type == MULTIPLE_ASSIGNMENT_TYPE
          return nil unless node.parent.type == MULTIPLE_LEFT_HAND_SIDE_TYPE

          grandparent_node
        end
      end
    end
  end
end
