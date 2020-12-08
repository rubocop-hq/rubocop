# frozen_string_literal: true

module RuboCop
  module Cop
    class Base
      module Internals
        refine Base do
          # @api private
          # Called between investigations
          def ready
            return self if self.class.support_multiple_source?

            self.class.new(@config, @options)
          end

          ### Reserved for Cop::Cop

          # @deprecated Make potential errors with previous API more obvious
          def offenses
            raise 'The offenses are not directly available; ' \
              'they are returned as the result of the investigation'
          end

          ### Reserved for Commissioner

          # @api private
          def callbacks_needed
            self.class.callbacks_needed
          end

          private

          ### Reserved for Cop::Cop

          def callback_argument(range)
            range
          end

          def apply_correction(corrector)
            @current_corrector&.merge!(corrector) if corrector
          end

          def correction_strategy
            return :unsupported unless correctable?
            return :uncorrected unless autocorrect?

            :attempt_correction
          end

          ### Reserved for Commissioner:

          def current_offense_locations
            @current_offense_locations ||= Set.new
          end

          def currently_disabled_lines
            @currently_disabled_lines ||= Set.new
          end

          # Called before any investigation
          def begin_investigation(processed_source)
            @current_offenses = []
            @current_offense_locations = nil
            @currently_disabled_lines = nil
            @processed_source = processed_source
            @current_corrector = Corrector.new(@processed_source) if @processed_source.valid_syntax?
          end

          # Called to complete an investigation
          def complete_investigation
            InvestigationReport.new(self, processed_source, @current_offenses, @current_corrector)
          ensure
            reset_investigation
          end

          ### Actually private methods

          def reset_investigation
            @currently_disabled_lines = @current_offenses = @processed_source = @current_corrector = nil
          end

          # @return [Symbol, Corrector] offense status
          def correct(range)
            status = correction_strategy

            if block_given?
              corrector = Corrector.new(self)
              yield corrector
              if !corrector.empty? && !self.class.support_autocorrect?
                raise "The Cop #{name} must `extend AutoCorrector` to be able to autocorrect"
              end
            end

            status = attempt_correction(range, corrector) if status == :attempt_correction

            [status, corrector]
          end

          # @return [Symbol] offense status
          def attempt_correction(range, corrector)
            if corrector && !corrector.empty?
              status = :corrected
            elsif disable_uncorrectable?
              corrector = disable_uncorrectable(range)
              status = :corrected_with_todo
            else
              return :uncorrected
            end

            apply_correction(corrector) if corrector
            status
          end

          def disable_uncorrectable(range)
            line = range.line
            return unless currently_disabled_lines.add?(line)

            disable_offense(range)
          end

          def range_from_node_or_range(node_or_range)
            if node_or_range.respond_to?(:loc)
              node_or_range.loc.expression
            elsif node_or_range.is_a?(::Parser::Source::Range)
              node_or_range
            else
              extra = ' (call `add_global_offense`)' if node_or_range.nil?
              raise "Expected a Source::Range, got #{node_or_range.inspect}#{extra}"
            end
          end

          def find_message(range, message)
            annotate(message || message(range))
          end

          def annotate(message)
            RuboCop::Cop::MessageAnnotator.new(
              config, cop_name, cop_config, @options
            ).annotate(message)
          end

          def file_name_matches_any?(file, parameter, default_result)
            patterns = cop_config[parameter]
            return default_result unless patterns

            path = nil
            patterns.any? do |pattern|
              # Try to match the absolute path, as Exclude properties are absolute.
              next true if match_path?(pattern, file)

              # Try with relative path.
              path ||= config.path_relative_to_config(file)
              match_path?(pattern, path)
            end
          end

          def enabled_line?(line_number)
            return true if @options[:ignore_disable_comments] || !@processed_source

            @processed_source.comment_config.cop_enabled_at_line?(self, line_number)
          end

          def find_severity(_range, severity)
            custom_severity || severity || default_severity
          end

          def default_severity
            self.class.lint? ? :warning : :convention
          end

          def custom_severity
            severity = cop_config['Severity']
            return unless severity

            if Severity::NAMES.include?(severity.to_sym)
              severity.to_sym
            else
              message = "Warning: Invalid severity '#{severity}'. " \
                "Valid severities are #{Severity::NAMES.join(', ')}."
              warn(Rainbow(message).red)
            end
          end
        end
      end
    end
  end
end
