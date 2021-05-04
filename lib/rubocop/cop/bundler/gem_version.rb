# frozen_string_literal: true

module RuboCop
  module Cop
    module Bundler
      # Enforce that Gem version specifications are either required
      # or forbidden.
      #
      # @example EnforcedStyle: required (default)
      #  # bad
      #  gem 'rubocop'
      #
      #  # good
      #  gem 'rubocop', '~> 1.12'
      #
      #  # good
      #  gem 'rubocop', '>= 1.10.0'
      #
      #  # good
      #  gem 'rubocop', '>= 1.5.0', '< 1.10.0'
      #
      # @example EnforcedStyle: forbidden
      #  # good
      #  gem 'rubocop'
      #
      #  # bad
      #  gem 'rubocop', '~> 1.12'
      #
      #  # bad
      #  gem 'rubocop', '>= 1.10.0'
      #
      #  # bad
      #  gem 'rubocop', '>= 1.5.0', '< 1.10.0'
      #
      class GemVersion < Base
        include ConfigurableEnforcedStyle
        include GemDeclaration

        REQUIRED_MSG = 'Gem version specification is required.'
        FORBIDDEN_MSG = 'Gem version specification is forbidden.'
        VERSION_SPECIFICATION_REGEX = /^[~<>=]*\s?[0-9.]+/.freeze

        # @!method includes_version_specification?(node)
        def_node_matcher :includes_version_specification?, <<~PATTERN
          (send nil? :gem <(str #version_specification?) ...>)
        PATTERN

        def on_send(node)
          return unless gem_declaration?(node)
          return if allowed_gem?(node)

          if offense?(node)
            add_offense(node)
            opposite_style_detected
          else
            correct_style_detected
          end
        end

        private

        def allowed_gem?(node)
          allowed_gems.include?(node.first_argument.value)
        end

        def allowed_gems
          Array(cop_config['AllowedGems'])
        end

        def message(range)
          gem_specification = range.source

          if required_style?
            format(REQUIRED_MSG, gem_specification: gem_specification)
          elsif forbidden_style?
            format(FORBIDDEN_MSG, gem_specification: gem_specification)
          end
        end

        def offense?(node)
          (required_style? && !includes_version_specification?(node)) ||
            (forbidden_style? && includes_version_specification?(node))
        end

        def forbidden_style?
          style == :forbidden
        end

        def required_style?
          style == :required
        end

        def version_specification?(expression)
          expression.match?(VERSION_SPECIFICATION_REGEX)
        end
      end
    end
  end
end
