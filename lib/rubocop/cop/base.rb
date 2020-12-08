# frozen_string_literal: true

require_relative 'base/internals'

module RuboCop
  module Cop
    # A scaffold for concrete cops.
    #
    # The Cop::Base class is meant to be extended.
    #
    # Cops track offenses and can autocorrect them on the fly.
    #
    # A commissioner object is responsible for traversing the AST and invoking
    # the specific callbacks on each cop.
    #
    # First the callback `on_new_investigation` is called;
    # if a cop needs to do its own processing of the AST or depends on
    # something else.
    #
    # Then callbacks like `on_def`, `on_send` (see AST::Traversal) are called
    # with their respective nodes.
    #
    # Finally the callback `on_investigation_end` is called.
    #
    # Within these callbacks, cops are meant to call `add_offense` or
    # `add_global_offense`. Use the `processed_source` method to
    # get the currently processed source being investigated.
    #
    # In case of invalid syntax / unparseable content,
    # the callback `on_other_file` is called instead of all the other
    # `on_...` callbacks.
    #
    # Private methods are not meant for custom cops consumption,
    # nor are any instance variables.
    #
    class Base # rubocop:disable Metrics/ClassLength
      extend RuboCop::AST::Sexp
      extend NodePattern::Macros
      include RuboCop::AST::Sexp
      include Util
      include IgnoredNode
      include AutocorrectLogic
      using Internals

      attr_reader :config, :processed_source

      # Reports of an investigation.
      # Immutable
      # Consider creation API private
      InvestigationReport = Struct.new(:cop, :processed_source, :offenses, :corrector)

      # List of methods names to restrict calls for `on_send` / `on_csend`
      RESTRICT_ON_SEND = Set[].freeze

      # List of cops that should not try to autocorrect at the same
      # time as this cop
      #
      # @return [Array<RuboCop::Cop::Cop>]
      #
      # @api public
      def self.autocorrect_incompatible_with
        []
      end

      # Cops (other than builtin) are encouraged to implement this
      # @return [String, nil]
      #
      # @api public
      def self.documentation_url
        Documentation.url_for(self) if builtin?
      end

      def initialize(config = nil, options = nil)
        @config = config || Config.new
        @options = options || { debug: false }
        reset_investigation
      end

      # Called before all on_... have been called
      # When refining this method, always call `super`
      def on_new_investigation
        # Typically do nothing here
      end

      # Called after all on_... have been called
      # When refining this method, always call `super`
      def on_investigation_end
        # Typically do nothing here
      end

      # Called instead of all on_... callbacks for unrecognized files / syntax errors
      # When refining this method, always call `super`
      def on_other_file
        # Typically do nothing here
      end

      # Override and return the Force class(es) you need to join
      def self.joining_forces; end

      # Gets called if no message is specified when calling `add_offense` or
      # `add_global_offense`
      # Cops are discouraged to override this; instead pass your message directly
      def message(_range = nil)
        self.class::MSG
      end

      # Adds an offense that has no particular location.
      # No correction can be applied to global offenses
      def add_global_offense(message = nil, severity: nil)
        severity = find_severity(nil, severity)
        message = find_message(nil, message)
        @current_offenses <<
          Offense.new(severity, Offense::NO_LOCATION, message, name, :unsupported)
      end

      # Adds an offense on the specified range (or node with an expression)
      # Unless that offense is disabled for this range, a corrector will be yielded
      # to provide the cop the opportunity to autocorrect the offense.
      # If message is not specified, the method `message` will be called.
      def add_offense(node_or_range, message: nil, severity: nil, &block)
        range = range_from_node_or_range(node_or_range)
        return unless current_offense_locations.add?(range)

        range_to_pass = callback_argument(range)

        severity = find_severity(range_to_pass, severity)
        message = find_message(range_to_pass, message)

        status, corrector = enabled_line?(range.line) ? correct(range, &block) : :disabled

        @current_offenses << Offense.new(severity, range, message, name, status, corrector)
      end

      # This method should be overridden when a cop's behavior depends
      # on state that lives outside of these locations:
      #
      #   (1) the file under inspection
      #   (2) the cop's source code
      #   (3) the config (eg a .rubocop.yml file)
      #
      # For example, some cops may want to look at other parts of
      # the codebase being inspected to find violations. A cop may
      # use the presence or absence of file `foo.rb` to determine
      # whether a certain violation exists in `bar.rb`.
      #
      # Overriding this method allows the cop to indicate to RuboCop's
      # ResultCache system when those external dependencies change,
      # ie when the ResultCache should be invalidated.
      def external_dependency_checksum
        nil
      end

      def self.inherited(subclass)
        super
        Registry.global.enlist(subclass)
      end

      # Call for abstract Cop classes
      def self.exclude_from_registry
        Registry.global.dismiss(self)
      end

      # Returns if class supports auto_correct.
      # It is recommended to extend AutoCorrector instead of overriding
      def self.support_autocorrect?
        false
      end

      ### Naming

      def self.badge
        @badge ||= Badge.for(name)
      end

      def self.cop_name
        badge.to_s
      end

      def self.department
        badge.department
      end

      def self.lint?
        department == :Lint
      end

      # Returns true if the cop name or the cop namespace matches any of the
      # given names.
      def self.match?(given_names)
        return false unless given_names

        given_names.include?(cop_name) ||
          given_names.include?(department.to_s)
      end

      def cop_name
        @cop_name ||= self.class.cop_name
      end

      alias name cop_name

      ### Configuration Helpers

      def cop_config
        # Use department configuration as basis, but let individual cop
        # configuration override.
        @cop_config ||= @config.for_badge(self.class.badge)
      end

      def config_to_allow_offenses
        Formatter::DisabledConfigFormatter
          .config_to_allow_offenses[cop_name] ||= {}
      end

      def config_to_allow_offenses=(hash)
        Formatter::DisabledConfigFormatter.config_to_allow_offenses[cop_name] =
          hash
      end

      def target_ruby_version
        @config.target_ruby_version
      end

      def target_rails_version
        @config.target_rails_version
      end

      def relevant_file?(file)
        file == RuboCop::AST::ProcessedSource::STRING_SOURCE_NAME ||
          file_name_matches_any?(file, 'Include', true) &&
            !file_name_matches_any?(file, 'Exclude', false)
      end

      def excluded_file?(file)
        !relevant_file?(file)
      end

      ### Persistence

      # Override if your cop should be called repeatedly for multiple investigations
      # Between calls to `on_new_investigation` and `on_investigation_end`,
      # the result of `processed_source` will remain constant.
      # You should invalidate any caches that depend on the current `processed_source`
      # in the `on_new_investigation` callback.
      # If your cop does autocorrections, be aware that your instance may be called
      # multiple times with the same `processed_source.path` but different content.
      def self.support_multiple_source?
        false
      end

      # @api private
      def self.callbacks_needed
        @callbacks_needed ||= public_instance_methods.select do |m|
          m.match?(/^on_|^after_/) &&
            !Base.method_defined?(m) # exclude standard "callbacks" like 'on_begin_investigation'
        end
      end

      def self.builtin?
        return false unless (m = instance_methods(false).first) # any custom method will do

        path, _line = instance_method(m).source_location
        path.start_with?(__dir__)
      end
      private_class_method :builtin?


      private_class_method def self.restrict_on_send
        @restrict_on_send ||= self::RESTRICT_ON_SEND.to_a.freeze
      end
    end
  end
end
