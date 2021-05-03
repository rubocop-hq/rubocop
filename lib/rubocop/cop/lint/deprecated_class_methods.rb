# frozen_string_literal: true

module RuboCop
  module Cop
    module Lint
      # This cop checks for uses of the deprecated class method usages.
      #
      # @example
      #
      #   # bad
      #
      #   File.exists?(some_path)
      #   Dir.exists?(some_path)
      #   iterator?
      #
      # @example
      #
      #   # good
      #
      #   File.exist?(some_path)
      #   Dir.exist?(some_path)
      #   block_given?
      class DeprecatedClassMethods < Base
        extend AutoCorrector

        # Inner class to DeprecatedClassMethods.
        # This class exists to add abstraction and clean naming to the
        # objects that are going to be operated on.
        class DeprecatedClassMethod
          include RuboCop::AST::Sexp

          def initialize(deprecated:, replacement:, class_constant: nil)
            @deprecated_method = deprecated
            @replacement_method = replacement
            @class_constant = class_constant
          end

          attr_reader :class_constant, :deprecated_method, :replacement_method

          def class_nodes
            @class_nodes ||=
              if class_constant
                [
                  s(:const, nil, class_constant),
                  s(:const, s(:cbase), class_constant)
                ]
              else
                [nil]
              end
          end
        end

        MSG = '`%<current>s` is deprecated in favor of `%<prefer>s`.'
        DEPRECATED_METHODS_OBJECT = [
          DeprecatedClassMethod.new(deprecated: :exists?,
                                    replacement: :exist?,
                                    class_constant: :File),
          DeprecatedClassMethod.new(deprecated: :exists?,
                                    replacement: :exist?,
                                    class_constant: :Dir),
          DeprecatedClassMethod.new(deprecated: :iterator?, replacement: :block_given?)
        ].freeze

        RESTRICT_ON_SEND = DEPRECATED_METHODS_OBJECT.map(&:deprecated_method).freeze

        def on_send(node)
          check(node) do |data|
            message = format(MSG, current: deprecated_method(data),
                                  prefer: replacement_method(data))

            add_offense(node.loc.selector, message: message) do |corrector|
              corrector.replace(node.loc.selector, data.replacement_method.to_s)
            end
          end
        end

        private

        def check(node)
          DEPRECATED_METHODS_OBJECT.each do |data|
            next unless data.class_nodes.include?(node.receiver)
            next unless node.method?(data.deprecated_method)

            yield data
          end
        end

        def deprecated_method(data)
          method_call(data.class_constant, data.deprecated_method)
        end

        def replacement_method(data)
          method_call(data.class_constant, data.replacement_method)
        end

        def method_call(class_constant, method)
          if class_constant
            format('%<constant>s.%<method>s', constant: class_constant, method: method)
          else
            format('%<method>s', method: method)
          end
        end
      end
    end
  end
end
