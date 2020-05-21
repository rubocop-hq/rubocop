# frozen_string_literal: true

module RuboCop
  module Cop
    module Bundler
      # Add a comment describing each gem in your Gemfile.
      #
      # Optionally, the "OnlyWhenUsingAnyOf" configuration
      # can be used to only register offenses when the gems
      # use certain options or have version specifiers.
      # Add "with_version_specifiers" and/or the option names
      # (e.g. 'required', 'github', etc) you want to check.
      #
      # @example OnlyWhenUsingAnyOf: [] (default)
      #   # bad
      #
      #   gem 'foo'
      #
      #   # good
      #
      #   # Helpers for the foo things.
      #   gem 'foo'
      #
      # @example OnlyWhenUsingAnyOf: ['with_version_specifiers']
      #   # bad
      #
      #   gem 'foo', '< 2.1'
      #
      #   # good
      #
      #   # Version 2.1 introduces breaking change baz
      #   gem 'foo', '< 2.1'
      #
      # @example OnlyWhenUsingAnyOf: ['with_version_specifiers', 'github']
      #   # bad
      #
      #   gem 'foo', github: 'some_account/some_fork_of_foo'
      #
      #   gem 'bar', '< 2.1'
      #
      #   # good
      #
      #   # Using this fork because baz
      #   gem 'foo', github: 'some_account/some_fork_of_foo'
      #
      #   # Version 2.1 introduces breaking change baz
      #   gem 'bar', '< 2.1'
      #
      class GemComment < Cop
        include DefNode

        MSG = 'Missing gem description comment.'
        CHECKED_OPTIONS_CONFIG = 'OnlyWhenUsingAnyOf'
        VERSION_SPECIFIERS_OPTION = 'with_version_specifiers'

        def_node_matcher :gem_declaration?, '(send nil? :gem str ...)'

        def on_send(node)
          return unless gem_declaration?(node)
          return if ignored_gem?(node)
          return if commented?(node)
          return if cop_config[CHECKED_OPTIONS_CONFIG].any? && !checked_options_present?(node)

          add_offense(node)
        end

        private

        def commented?(node)
          preceding_lines = preceding_lines(node)
          preceding_comment?(node, preceding_lines.last)
        end

        # The args node1 & node2 may represent a RuboCop::AST::Node
        # or a Parser::Source::Comment. Both respond to #loc.
        def precede?(node1, node2)
          node2.loc.line - node1.loc.line == 1
        end

        def preceding_lines(node)
          processed_source.ast_with_comments[node].select do |line|
            line.loc.line < node.loc.line
          end
        end

        def preceding_comment?(node1, node2)
          node1 && node2 && precede?(node2, node1) &&
            comment_line?(node2.loc.expression.source)
        end

        def ignored_gem?(node)
          ignored_gems = Array(cop_config['IgnoredGems'])
          ignored_gems.include?(node.first_argument.value)
        end

        def checked_options_present?(node)
          cop_config[CHECKED_OPTIONS_CONFIG].include?(VERSION_SPECIFIERS_OPTION) && version_specified_gem?(node) \
          or contains_checked_options?(node)
        end

        # Besides the gem name, all other *positional* arguments to `gem` are version specifiers,
        # as long as it has one we know there's at least one version specifier.
        def version_specified_gem?(node)
          # arguments[0] is the gem name
          node.arguments[1]&.str_type? == true
        end

        def contains_checked_options?(node)
          (Array(cop_config[CHECKED_OPTIONS_CONFIG]) & gem_options(node).map(&:to_s)).any?
        end

        def gem_options(node)
          return [] unless node.arguments.last&.type == :hash

          node.arguments.last.keys.map(&:value)
        end
      end
    end
  end
end
