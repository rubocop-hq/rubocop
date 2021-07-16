# frozen_string_literal: true

module RuboCop
  module Cop
    # Common functionality for dealing with Shareable Constant Value
    module ShareableConstantValue
      module_function

      def recent_shareable_value?(node)
        shareable_constant_comment = magic_comment_in_scope node
        return false if shareable_constant_comment.nil?

        shareable_constant_value = MagicComment.parse(shareable_constant_comment)
                                               .shareable_constant_value
        shareable_constant_value_enabled? shareable_constant_value
      end

      # Identifies the most recent magic comment with valid shareable constant values
      # thats in scope for this node
      def magic_comment_in_scope(node)
        processed_source_till_node(node).reverse_each.find do |line|
          MagicComment.parse(line).valid_shareable_constant_value?
        end
      end

      private

      def processed_source_till_node(node)
        processed_source.lines[0..(node.last_line - 1)]
      end

      def shareable_constant_value_enabled?(value)
        %w[literal experimental_everything experimental_copy].include? value
      end
    end
  end
end
