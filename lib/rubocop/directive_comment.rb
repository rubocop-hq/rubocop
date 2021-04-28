# frozen_string_literal: true

module RuboCop
  # This class wraps the `Parser::Source::Comment` object that represents a
  # special `rubocop:disable` and `rubocop:enable` comment and exposes what
  # cops it contains.
  class DirectiveComment
    # @api private
    REDUNDANT_COP = 'Lint/RedundantCopDisableDirective'
    # @api private
    COP_NAME_PATTERN = '([A-Z]\w+/)*(?:[A-Z]\w+)'
    # @api private
    COP_NAMES_PATTERN = "(?:#{COP_NAME_PATTERN} , )*#{COP_NAME_PATTERN}"
    # @api private
    COPS_PATTERN = "(all|#{COP_NAMES_PATTERN})"
    # @api private
    DIRECTIVE_COMMENT_REGEXP = Regexp.new(
      "# rubocop : ((?:disable|enable|todo))\\b #{COPS_PATTERN}"
        .gsub(' ', '\s*')
    )

    def self.before_comment(line)
      line.split(DIRECTIVE_COMMENT_REGEXP).first
    end

    def initialize(comment)
      @comment = comment
      @mode, @cops = match_captures
    end

    attr_reader :comment, :mode, :cops

    # Checks if this directive relates to single line
    def single_line?
      !self.class.before_comment(comment.text).empty?
    end

    # Checks if this directive contains all the given cop names
    def match?(cop_names)
      parsed_cop_names.uniq.sort == cop_names.uniq.sort
    end

    def range
      comment.location.expression
    end

    # Returns match captures to directive comment pattern
    def match_captures
      @match_captures ||= comment.text.match(DIRECTIVE_COMMENT_REGEXP)&.captures
    end

    # Checks if this directive disables cops
    def disabled?
      %w[disable todo].include?(mode)
    end

    # Checks if this directive enables cops
    def enabled?
      mode == 'enable'
    end

    # Checks if this directive enables all cops
    def enabled_all?
      !disabled? && all_cops?
    end

    # Checks if all cops specified in this directive
    def all_cops?
      cops == 'all'
    end

    # Returns array of specified in this directive cop names
    def cop_names
      @cop_names ||= all_cops? ? all_cop_names : parsed_cop_names
    end

    # Returns line number for directive
    def line_number
      comment.loc.expression.line
    end

    private

    def parsed_cop_names
      (cops || '').split(/,\s*/)
    end

    def all_cop_names
      Cop::Registry.global.names - [REDUNDANT_COP]
    end
  end
end
