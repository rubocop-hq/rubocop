# frozen_string_literal: true

module RuboCop
  module Cop
    module Utils
      # Classifies the children nodes of a `class`
      class ClassChildrenClassifier
        VISIBILITY_MACROS = {
          public: { visibility: :public, group: :methods, change_state: true }.freeze,
          protected: { visibility: :protected, group: :methods, change_state: true }.freeze,
          private: { visibility: :private, group: :methods, change_state: true }.freeze,
          public_class_method: { visibility: :public, group: :class_methods }.freeze,
          private_class_method: { visibility: :private, group: :class_methods }.freeze,
          public_constant: { visibility: :public, group: :constants }.freeze,
          private_constant: { visibility: :private, group: :constants }.freeze
        }.freeze
        private_constant :VISIBILITY_MACROS

        # @param categories [Hash<String, String>] mapping method name to a category
        def initialize(categories)
          @categories = categories
        end

        # @return [Hash<Node, Classification>] where Classification is a Hash
        # with the following information:
        #  * group: :methods, :class_methods, :constants, :class_singleton
        #  * visibility: :public, :protected, :private
        #  * macro: nil, :pre, :post, :inline, :generic
        #  * names: names of methods being defined / affected, if any
        #  * category: macro category, if any  (:generic)
        #  * affects_categories: macro categories affected (:pre/:post)

        def classify_children(class_node)
          @classification = {}
          @cur_visibility = { visibility: :public, names: [] }
          @classification_index = Hash.new { |h, k| h[k] = {} }
          elements = class_elements(class_node)
          elements.each do |node|
            if (classification = classify_child(node))
              classification[:names]&.each do |name|
                @classification_index[classification[:group]][name] = node
              end
            end
            @classification[node] = classification
          end
          @classification
        end

        private

        def class_elements(class_node)
          elems = [class_node.body].compact

          loop do
            single = elems.first
            return elems unless elems.size == 1 && (single.begin_type? || single.kwbegin_type?)

            elems = single.children
          end
        end

        def classify_child(class_child_node)
          classification = classify(class_child_node)
          return unless classification

          classification[:visibility] ||= \
            case classification[:group]
            when nil then nil
            when :methods
              add_categories(@cur_visibility, [classification])
              @cur_visibility[:visibility]
            else
              :public
            end

          classification
        end

        # @param node to be analysed
        # @return Classification | nil
        def classify(node) # rubocop:disable Metrics/CyclomaticComplexity
          node = node.send_node if node.block_type?

          case node.type
          when :send
            classify_macro(node) unless node.receiver
          when :def
            classify_def(node)
          when :defs
            { group: :class_methods, names: [node.method_name] }
          when :casgn
            { group: :constants, names: [node.children[1]] }
          when :sclass
            { group: :class_singleton }
          end
        end

        def classify_def(node)
          name = node.method_name
          classification = { group: :methods, names: [name] }
          classification[:category] = :initializer if name == :initialize

          classification
        end

        # @param node to be analysed.
        # @return [String] with the key category or the `method_name` as string
        def classify_macro(node)
          name = node.method_name
          classification = VISIBILITY_MACROS[name]

          return classify_generic_macro(node) unless classification

          classify_visibility_macro(classification.dup, node)
        end

        def classify_generic_macro(node)
          method = node.method_name
          category = find_category(method)
          group = :methods if category
          result = { category: category, macro: :generic, group: group }
          if (names = args_to_symbol_literals(node.arguments))
            case method
            when :attr_writer then names.map! { |n| :"#{n}:" }
            when :attr_accessor then names.concat(names.map { |n| :"#{n}:" })
            end
            result[:names] = names
          end

          result
        end

        def find_category(method)
          category, = @categories.find { |_, name_list| name_list.include?(method) }
          category
        end

        def classify_visibility_macro(classification, node)
          args = node.arguments
          # Deal with `private` etc. with no arguments
          if classification[:change_state] && args.empty?
            classify_visibility_macro_without_argument(classification)
          elsif (symbols = args_to_symbol_literals(args)) # Deal with `private :foo, :bar`, etc.
            classify_visibility_macro_with_symbols(classification, symbols)
          elsif args.size > 1 # strange construct...
            nil
          else
            # Deal with `private def foo`, etc.
            inner = classify(args.first)
            { **classification, **inner, macro: :inline } unless unrecognized?(inner)
          end
        end

        def unrecognized?(classification)
          classification[:macro] == :generic && classification[:category].nil?
        end

        def classify_visibility_macro_without_argument(classification)
          @cur_visibility = classification
          classification[:names] = []
          classification[:macro] = :pre
          classification[:affects_categories] = []

          classification
        end

        def classify_visibility_macro_with_symbols(classification, symbols)
          classification[:names] = symbols
          classification[:macro] = :post
          classification[:affects_categories] = []
          change_visibility(classification, symbols)

          classification
        end

        # @return overall classification (:post)
        def change_visibility(classification, symbols)
          affected = @classification_index[classification[:group]].values_at(*symbols).compact
          return if affected.empty?

          affected_classifications = affected.map { |node| @classification[node] }
          affected_classifications.each { |c| c[:visibility] = classification[:visibility] }
          add_categories(classification, affected_classifications)
        end

        # @modifies :affects_categories in place (:pre / :post)
        def add_categories(classification, of)
          categories = of.map { |c| c[:category] || c[:group] }
          classification[:affects_categories] |= categories
        end

        # @return [Array<Symbol>, nil]
        def args_to_symbol_literals(arg_nodes)
          if arg_nodes.size == 1 && (only_arg = arg_nodes.first).array_type?
            arg_nodes = only_arg.children
          end

          arg_nodes.map do |arg|
            case arg.type
            when :sym, :str then arg.value.to_sym
            when :dsym, :dstr, :lvar, :hash then nil
            else # Otherwise assume this is not a list of symbols/strings
              return nil
            end
          end.compact
        end
      end
    end
  end
end
