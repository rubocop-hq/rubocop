# frozen_string_literal: true

module RuboCop
  module Cop
    # Common functionality for dealing with shareable constant value.
    module ShareableConstantValue
      module_function

      LITERAL = :literal
      EXPERIMENTAL_ANYTHING = :experimental_everything

      def shareable_constant_value?
        target_ruby_version >= 3.0 && shareable_constant_value_comment_exists?
      end

      def shareable_constant_value_comment_exists?
        leading_comments.any? do |line|
          shareable_constant_value = MagicComment.parse(line).shareable_constant_value

          [LITERAL, EXPERIMENTAL_ANYTHING].include?(shareable_constant_value)
        end
      end

      private

      def leading_comments
        processed_source
          .tokens
          .take_while(&:comment?)
          .map(&:text)
      end
    end
  end
end
