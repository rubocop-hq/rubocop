# frozen_string_literal: true

require 'rspec/core'
require 'test_queue'
require 'test_queue/runner/rspec'

module RuboCop
  # Helper for running specs with a temporary external encoding.
  # This is a bit risky, since strings defined before the block may have a
  # different encoding than strings defined inside the block.
  # The specs will be run in parallel if the system implements `fork`.
  # If ENV['COVERAGE'] is truthy, code coverage will be measured.
  class SpecRunner
    def initialize(rspec_args = %w[spec], parallel: true,
                   external_encoding: 'UTF-8', internal_encoding: nil)
      @rspec_args = rspec_args
      @previous_external_encoding = Encoding.default_external
      @previous_internal_encoding = Encoding.default_internal

      @temporary_external_encoding = external_encoding
      @temporary_internal_encoding = internal_encoding
      @parallel = parallel
    end

    attr_reader :rspec_args

    def run_specs
      n_failures = with_encoding do
        if @parallel && Process.respond_to?(:fork)
          parallel_runner_klass.new(rspec_args).execute
        else
          ::RSpec::Core::Runner.run(rspec_args)
        end
      end

      exit!(n_failures) unless n_failures.zero?
    end

    private

    def with_encoding
      Encoding.default_external = @temporary_external_encoding
      Encoding.default_internal = @temporary_internal_encoding
      yield
    ensure
      Encoding.default_external = @previous_external_encoding
      Encoding.default_internal = @previous_internal_encoding
    end

    def parallel_runner_klass
      if ENV['COVERAGE']
        ParallelCoverageRunner
      else
        ParallelRunner
      end
    end

    # A parallel spec runner implementation, heavily inspired by
    # `TestQueue::Runner::RSpec`, but modified so that it takes an argument
    # (an array of paths of specs to run) instead of relying on ARGV.
    class ParallelRunner < ::TestQueue::Runner
      def initialize(rspec_args)
        super(Framework.new(rspec_args))

        @exit_when_done = false
      end

      def run_worker(iterator)
        rspec = ::RSpec::Core::QueueRunner.new
        rspec.run_each(iterator).to_i
      end

      def summarize_worker(worker)
        worker.summary = worker.lines.grep(/\A\d+ examples?, /).first
        worker.failure_output = worker.output[/^Failures:\n\n(.*)\n^Finished/m, 1]
      end
    end

    # A custom runner for measuring code coverage in parallel.
    class ParallelCoverageRunner < ParallelRunner
      def after_fork(num)
        SimpleCov.command_name "rspec-#{num}"
      end

      def cleanup_worker
        SimpleCov.result
      end

      def summarize
        SimpleCov.at_exit.call
      end
    end

    # A TestQueue framework that is explicitly given RSpec arguments instead of
    # implicitly reading ARGV.
    class Framework < ::TestQueue::TestFramework::RSpec
      def initialize(rspec_args)
        super()
        @rspec_args = rspec_args
      end

      def all_suite_files
        options = ::RSpec::Core::ConfigurationOptions.new(@rspec_args)
        options.parse_options if options.respond_to?(:parse_options)
        options.configure(::RSpec.configuration)

        ::RSpec.configuration.files_to_run.uniq
      end
    end
  end
end

desc 'Run RSpec code examples'
task :spec do
  RuboCop::SpecRunner.new.run_specs
end

desc 'Run RSpec code examples with ASCII encoding'
task :ascii_spec do
  RuboCop::SpecRunner.new(external_encoding: 'ASCII').run_specs
end
