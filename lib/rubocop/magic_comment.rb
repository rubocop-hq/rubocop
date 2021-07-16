# frozen_string_literal: true

module RuboCop
  # Parse different formats of magic comments.
  #
  # @abstract parent of three different magic comment handlers
  class MagicComment
    # @see https://git.io/vMC1C IRB's pattern for matching magic comment tokens
    TOKEN = /[[:alnum:]\-_]+/.freeze

    # Detect magic comment format and pass it to the appropriate wrapper.
    #
    # @param comment [String]
    #
    # @return [RuboCop::MagicComment]
    def self.parse(comment)
      case comment
      when EmacsComment::FORMAT then EmacsComment.new(comment)
      when VimComment::FORMAT   then VimComment.new(comment)
      else
        SimpleComment.new(comment)
      end
    end

    def initialize(comment)
      @comment = comment
    end

    def any?
      frozen_string_literal_specified? || encoding_specified? || shareable_constant_value_specified?
    end

    # Does the magic comment enable the frozen string literal feature.
    #
    # Test whether the frozen string literal value is `true`. Cannot
    # just return `frozen_string_literal` since an invalid magic comment
    # like `# frozen_string_literal: yes` is possible and the truthy value
    # `'yes'` does not actually enable the feature
    #
    # @return [Boolean]
    def frozen_string_literal?
      frozen_string_literal == true
    end

    def valid_literal_value?
      [true, false].include?(frozen_string_literal)
    end

    def valid_shareable_constant_value?
      %w[none literal experimental_everything experimental_copy].include?(shareable_constant_value)
    end

    # Was a magic comment for the frozen string literal found?
    #
    # @return [Boolean]
    def frozen_string_literal_specified?
      specified?(frozen_string_literal)
    end

    # Was a shareable_constant_value specified?
    #
    # @return [Boolean]
    def shareable_constant_value_specified?
      specified?(shareable_constant_value)
    end

    # Expose the `frozen_string_literal` value coerced to a boolean if possible.
    #
    # @return [Boolean] if value is `true` or `false`
    # @return [nil] if frozen_string_literal comment isn't found
    # @return [String] if comment is found but isn't true or false
    def frozen_string_literal
      return unless (setting = extract_frozen_string_literal)

      case setting
      when 'true'  then true
      when 'false' then false
      else
        setting
      end
    end

    # Expose the `shareable_constant_value` value coerced to a boolean if possible.
    #
    # @return [String] for shareable_constant_value config
    def shareable_constant_value
      extract_shareable_constant_value
    end

    def encoding_specified?
      specified?(encoding)
    end

    private

    def specified?(value)
      !value.nil?
    end

    # Match the entire comment string with a pattern and take the first capture.
    #
    # @param pattern [Regexp]
    #
    # @return [String] if pattern matched
    # @return [nil] otherwise
    def extract(pattern)
      @comment[pattern, 1]
    end

    # Parent to Vim and Emacs magic comment handling.
    #
    # @abstract
    class EditorComment < MagicComment
      private

      # Find a token starting with the provided keyword and extract its value.
      #
      # @param keyword [String]
      #
      # @return [String] extracted value if it is found
      # @return [nil] otherwise
      def match(keyword)
        pattern = /\A#{keyword}\s*#{self.class::OPERATOR}\s*(#{TOKEN})\z/

        tokens.each do |token|
          next unless (value = token[pattern, 1])

          return value.downcase
        end

        nil
      end

      # Individual tokens composing an editor specific comment string.
      #
      # @return [Array<String>]
      def tokens
        extract(self.class::FORMAT).split(self.class::SEPARATOR).map(&:strip)
      end
    end

    # Wrapper for Emacs style magic comments.
    #
    # @example Emacs style comment
    #   comment = RuboCop::MagicComment.parse(
    #     '# -*- encoding: ASCII-8BIT -*-'
    #   )
    #
    #   comment.encoding # => 'ascii-8bit'
    #
    # @see https://www.gnu.org/software/emacs/manual/html_node/emacs/Specify-Coding.html
    # @see https://git.io/vMCXh Emacs handling in Ruby's parse.y
    class EmacsComment < EditorComment
      FORMAT    = /-\*-(.+)-\*-/.freeze
      SEPARATOR = ';'
      OPERATOR  = ':'

      def encoding
        match('(?:en)?coding')
      end

      private

      def extract_frozen_string_literal
        match('frozen[_-]string[_-]literal')
      end

      def extract_shareable_constant_value
        match('shareable[_-]constant[_-]value')
      end
    end

    # Wrapper for Vim style magic comments.
    #
    # @example Vim style comment
    #   comment = RuboCop::MagicComment.parse(
    #     '# vim: filetype=ruby, fileencoding=ascii-8bit'
    #   )
    #
    #   comment.encoding # => 'ascii-8bit'
    class VimComment < EditorComment
      FORMAT    = /#\s*vim:\s*(.+)/.freeze
      SEPARATOR = ', '
      OPERATOR  = '='

      # For some reason the fileencoding keyword only works if there
      # is at least one other token included in the string. For example
      #
      #    # works
      #      # vim: foo=bar, fileencoding=ascii-8bit
      #
      #    # does nothing
      #      # vim: foo=bar, fileencoding=ascii-8bit
      #
      def encoding
        match('fileencoding') if tokens.size > 1
      end

      # Vim comments cannot specify frozen string literal behavior.
      def frozen_string_literal; end

      # Vim comments cannot specify shareable constant values behavior.
      def shareable_constant_value; end
    end

    # Wrapper for regular magic comments not bound to an editor.
    #
    # Simple comments can only specify one setting per comment.
    #
    # @example frozen string literal comments
    #   comment1 = RuboCop::MagicComment.parse('# frozen_string_literal: true')
    #   comment1.frozen_string_literal # => true
    #   comment1.encoding              # => nil
    #
    # @example encoding comments
    #   comment2 = RuboCop::MagicComment.parse('# encoding: utf-8')
    #   comment2.frozen_string_literal # => nil
    #   comment2.encoding              # => 'utf-8'
    class SimpleComment < MagicComment
      # Match `encoding` or `coding`
      def encoding
        extract(/\A\s*\#.*\b(?:en)?coding: (#{TOKEN})/io)
      end

      private

      # Extract `frozen_string_literal`.
      #
      # The `frozen_string_literal` magic comment only works if it
      # is the only text in the comment.
      #
      # Case-insensitive and dashes/underscores are acceptable.
      # @see https://git.io/vM7Mg
      def extract_frozen_string_literal
        extract(/\A\s*#\s*frozen[_-]string[_-]literal:\s*(#{TOKEN})\s*\z/io)
      end

      def extract_shareable_constant_value
        extract(/\A\s*#\s*shareable[_-]constant[_-]value:\s*(#{TOKEN})\s*\z/io)
      end
    end
  end
end
