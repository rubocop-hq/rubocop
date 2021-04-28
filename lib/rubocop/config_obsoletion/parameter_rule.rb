# frozen_string_literal: true

module RuboCop
  class ConfigObsoletion
    # Base class for ConfigObsoletion rules relating to parameters
    # @api private
    class ParameterRule < Rule
      def initialize(config, cop, parameter, metadata)
        super(config)
        @cop = cop
        @parameter = parameter
        @metadata = metadata
      end

      attr_reader :cop, :parameter, :metadata

      def parameter_rule?
        true
      end

      def violated?
        config[cop]&.key?(parameter)
      end

      def warning?
        severity == 'warning'
      end

      private

      def alternative
        metadata['alternative']
      end

      def reason
        metadata['reason']
      end

      def severity
        metadata['severity']
      end
    end
  end
end
