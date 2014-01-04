# encoding: utf-8

module Rubocop
  module Cop
    # This module contains a collection of useful utility methods.
    module Util
      extend AST::Sexp

      PROC_NEW_NODE = s(:send, s(:const, nil, :Proc), :new)
      EQUALS_ASGN_NODES = [:lvasgn, :ivasgn, :cvasgn, :gvasgn, :casgn, :masgn]
      SHORTHAND_ASGN_NODES = [:op_asgn, :or_asgn, :and_asgn]
      ASGN_NODES = EQUALS_ASGN_NODES + SHORTHAND_ASGN_NODES

      module_function

      def strip_quotes(str)
        if str[0] == '"' || str[0] == "'"
          str[0] = ''
          str[-1] = ''
        else
          # we're dealing with %q or %Q
          str[0, 3] = ''
          str[-1] = ''
        end

        str
      end

      def block_length(block_node)
        block_node.loc.end.line - block_node.loc.begin.line
      end

      def comment_line?(line_source)
        line_source =~ /^\s*#/
      end

      def line_range(arg)
        source_range = case arg
                       when Parser::Source::Range
                         arg
                       when Parser::AST::Node
                         arg.loc.expression
                       else
                         fail ArgumentError, "Invalid argument #{arg}"
                       end

        source_range.begin.line..source_range.end.line
      end

      def const_name(node)
        return nil if node.nil? || node.type != :const

        const_names = []
        const_node = node

        loop do
          namespace_node, name = *const_node
          const_names << name
          break unless namespace_node
          break unless namespace_node.is_a?(Parser::AST::Node)
          break if namespace_node.type == :cbase
          const_node = namespace_node
        end

        const_names.reverse.join('::')
      end

      def command?(name, node)
        return unless node.type == :send

        receiver, method_name, _args = *node

        # commands have no explicit receiver
        !receiver && method_name == name
      end

      def lambda?(node)
        fail 'Not a block node' unless node.type == :block

        send_node, _block_args, _block_body = *node

        command?(:lambda, send_node)
      end

      def proc?(node)
        fail 'Not a block node' unless node.type == :block

        send_node, _block_args, _block_body = *node

        command?(:proc, send_node) || send_node == PROC_NEW_NODE
      end

      def lambda_or_proc?(node)
        lambda?(node) || proc?(node)
      end

      def on_node(syms, sexp, excludes = [])
        yield sexp if Array(syms).include?(sexp.type)

        return if Array(excludes).include?(sexp.type)

        sexp.children.each do |elem|
          if elem.is_a?(Parser::AST::Node)
            on_node(syms, elem, excludes) { |s| yield s }
          end
        end
      end

      # Returns for example a bare `if` node if the given node is an `if` whith
      # calls chained to the end of it.
      def first_part_of_call_chain(node)
        while node
          case node.type
          when :send
            receiver, _method_name, _args = *node
            node = receiver
          when :block
            method, _args, _body = *node
            node = method
          else
            break
          end
        end
        node
      end
    end
  end
end
