# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop is designed to ensure your frozen string literal comments
      # are consistent throughout your code base.
      #
      # @example EnforcedStyle: snake (default)
      #   # The `snake` style will enforce that the frozen string literal
      #   # comment is written in snake case. (Words separated by underscores)
      #   # bad
      #   # frozen-string-literal: true
      #
      #   module Bar
      #     # ...
      #   end
      #
      #   # good
      #   # frozen_string_literal: false
      #
      #   module Bar
      #     # ...
      #   end
      #
      # @example EnforcedStyle: kebab
      #   # The `kebab` style will enforce that the frozen string literal
      #   # comment is written in kebab case. (Words separated by hyphens)
      #   # bad
      #   # frozen_string_literal: true
      #
      #   module Baz
      #     # ...
      #   end
      #
      #   # good
      #   # frozen-string-literal: true
      #
      #   module Baz
      #     # ...
      #   end
      class FrozenStringLiteralCommentCaseStyle < Base
        include ConfigurableEnforcedStyle
        extend AutoCorrector

        SNAKE_SEPARATOR = '_'
        KEBAB_SEPARATOR = '-'
        MSG_SNAKE_CASE = 'Frozen string literal comment must be in snake case.'
        MSG_KEBAB_CASE = 'Frozen string literal comment must be in kebab case.'
        FROZEN_STRING_LITERAL = /^# frozen[_-]string[_-]literal:/i.freeze

        def on_new_investigation
          return unless frozen_string_literal_comment

          case style
          when :snake
            ensure_snake_case
          when :kebab
            ensure_kebab_case
          end
        end

        private

        def ensure_snake_case
          return unless frozen_string_literal_comment.text[KEBAB_SEPARATOR]

          snake_case_offense
        end

        def ensure_kebab_case
          return unless frozen_string_literal_comment.text[SNAKE_SEPARATOR]

          kebab_case_offense
        end

        def snake_case_offense
          add_offense(frozen_string_literal_comment.pos, message: MSG_SNAKE_CASE) do |corrector|
            snakify_comment(corrector)
          end
        end

        def kebab_case_offense
          add_offense(frozen_string_literal_comment.pos, message: MSG_KEBAB_CASE) do |corrector|
            kebabify_comment(corrector)
          end
        end

        def frozen_string_literal_comment
          @frozen_string_literal_comment ||= processed_source.find_token do |token|
            token.text =~ FROZEN_STRING_LITERAL
          end
        end

        def snakify_comment(corrector)
          fix_comment(corrector, KEBAB_SEPARATOR, SNAKE_SEPARATOR)
        end

        def kebabify_comment(corrector)
          fix_comment(corrector, SNAKE_SEPARATOR, KEBAB_SEPARATOR)
        end

        def fix_comment(corrector, find, replace)
          comment = frozen_string_literal_comment

          corrector.replace(line_range(comment.line), comment.text.gsub(find, replace))
        end

        def line_range(line)
          processed_source.buffer.line_range(line)
        end
      end
    end
  end
end
