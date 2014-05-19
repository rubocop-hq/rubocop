# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # This cop checks for END blocks.
      class EndBlock < Cop
        MSG = 'Avoid the use of `END` blocks. Use `Kernel#at_exit` instead.'
        private_constant :MSG

        def on_postexe(node)
          add_offense(node, :keyword, MSG)
        end
      end
    end
  end
end
