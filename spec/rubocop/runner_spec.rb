# frozen_string_literal: true

require 'io/wait'

RSpec.describe RuboCop::Runner, :isolated_environment do
  include FileHelper

  let(:formatter_output_path) { 'formatter_output.txt' }
  let(:formatter_output) { File.read(formatter_output_path) }

  describe '#run when interrupted' do
    include_context 'cli spec behavior'

    let(:runner) { described_class.new({}, RuboCop::ConfigStore.new) }

    before { create_empty_file('example.rb') }

    def interrupt(pid)
      Process.kill 'INT', pid
    end

    def wait_for_input(io, timeout: 30)
      unless io.wait_readable(timeout)
        raise "the forked runner produced no output within #{timeout}s"
      end

      io.gets or raise 'the forked runner exited without writing a line'
    end

    around do |example|
      old_handler = Signal.trap('INT', 'DEFAULT')
      example.run
      Signal.trap('INT', old_handler)
    end

    context 'when a formatter raises while starting' do
      let(:interrupting_formatter) do
        Class.new(RuboCop::Formatter::ProgressFormatter) do
          def started(_target_files)
            raise Interrupt
          end
        end
      end

      it 'aborts cleanly instead of raising from the formatter' do
        runner = described_class.new({ formatters: [[interrupting_formatter]] },
                                     RuboCop::ConfigStore.new)

        expect(runner.run(['example.rb'])).to be(false)
        expect(runner).to be_aborting
      end

      it 'does not replace an error raised by an earlier formatter' do
        failing_formatter = Class.new(RuboCop::Formatter::ProgressFormatter) do
          def started(_target_files)
            raise 'formatter boom'
          end
        end
        runner = described_class.new(
          { formatters: [[failing_formatter], ['progress', formatter_output_path]] },
          RuboCop::ConfigStore.new
        )

        expect { runner.run(['example.rb']) }.to raise_error(RuntimeError, 'formatter boom')
      end
    end

    context 'with SIGINT' do
      it 'returns false' do
        skip '`Process` does not respond to `fork` method.' unless Process.respond_to?(:fork)

        rd, wr = IO.pipe

        # Make sure the runner works slowly and thus is interruptible, and signal when
        # the forked child is inside `Runner#run`, whose `rescue Interrupt` turns
        # the interrupt into an abort. An interrupt delivered before that point kills
        # the child before it can write anything.
        allow(runner).to receive(:process_file) do
          wr.puts 'PROCESSING'
          # The duration only has to outlast `wait_for_input`'s timeout, so that an interrupt
          # that never arrives is reported there instead of letting the run finish on its own
          # and write `true`.
          sleep 99
          []
        end

        pid = Process.fork do
          rd.close
          wr.puts 'READY'
          begin
            wr.puts runner.run(['example.rb'])
          rescue Exception => e # rubocop:disable Lint/RescueException -- all the deaths are unexpected, so we want to report it
            wr.puts "EXCEPTION #{e.class}: #{e.message} (cause: #{e.cause.class})"
          end
          wr.close
        end

        wr.close

        # Make sure the runner has started by waiting for a specific message
        line = wait_for_input(rd)
        expect(line.chomp).to eq('READY')

        # Wait until the runner is inside its interrupt-protected region.
        line = wait_for_input(rd)
        expect(line.chomp).to eq('PROCESSING')

        # Interrupt the runner
        interrupt(pid)

        # Make sure the runner returns false
        line = wait_for_input(rd)
        expect(line.chomp).to eq('false')
      ensure
        if pid
          begin
            Process.kill('KILL', pid)
            Process.waitpid(pid)
          rescue Errno::ESRCH, Errno::ECHILD
            nil
          end
        end
      end
    end
  end

  describe '#run' do
    subject(:runner) { described_class.new(options, RuboCop::ConfigStore.new) }

    before { create_file('example.rb', source) }

    let(:options) { { formatters: [['progress', formatter_output_path]] } }

    context 'if there are no offenses in inspected files' do
      let(:source) { <<~RUBY }
        # frozen_string_literal: true

        def valid_code; end
      RUBY

      it 'returns true' do
        expect(runner.run([])).to be true
      end
    end

    context 'with a cop supporting multiple sources', :restore_registry do
      let(:source) { '' }
      let!(:persisting_cop_class) do
        stub_cop_class('Custom::Persisting') do
          def self.support_multiple_source?
            true
          end
        end
      end
      let(:options) do
        super().merge(cache: 'false', only: ['Custom/Persisting'])
      end

      before do
        create_empty_file('example2.rb')
        create_file('.rubocop.yml', <<~YAML)
          Custom/Persisting:
            Enabled: true
        YAML
      end

      it 'uses the same cop instance for every file' do
        expect(persisting_cop_class).to receive(:new).once.and_call_original

        expect(runner.run([])).to be true
      end
    end

    context 'if there is an offense in an inspected file' do
      let(:source) { <<~RUBY }
        # frozen_string_literal: true

        def INVALID_CODE; end
      RUBY

      it 'returns false' do
        expect(runner.run([])).to be false
      end

      it 'sends the offense to a formatter' do
        runner.run([])
        expect(formatter_output).to eq <<~RESULT
          Inspecting 1 file
          C

          Offenses:

          example.rb:3:5: C: Naming/MethodName: Use snake_case for method names.
          def INVALID_CODE; end
              ^^^^^^^^^^^^

          1 file inspected, 1 offense detected
        RESULT
      end
    end

    context 'custom ruby extractors' do
      around do |example|
        described_class.ruby_extractors.unshift(custom_ruby_extractor)

        # Ignore platform differences.
        create_file('.rubocop.yml', <<~YAML)
          Layout/EndOfLine:
            Enabled: false
        YAML

        example.call
      ensure
        described_class.ruby_extractors.shift
      end

      context 'when the extractor matches' do
        # rubocop:disable-next Layout/LineLength -- the source under test is what it is
        let(:custom_ruby_extractor) do
          lambda do |_processed_source|
            [
              {
                offset: 1,
                processed_source: RuboCop::ProcessedSource.new(<<~RUBY, 3.3, 'dummy.rb', parser_engine: parser_engine)
                  # frozen_string_literal: true

                  def valid_code; end
                RUBY
              },
              {
                offset: 2,
                processed_source: RuboCop::ProcessedSource.new(source, 3.3, 'dummy.rb', parser_engine: parser_engine)
              }
            ]
          end
        end

        let(:source) do
          <<~RUBY
            # frozen_string_literal: true

            def INVALID_CODE; end
          RUBY
        end

        it 'sends the offense to a formatter' do
          runner.run([])
          expect(formatter_output).to eq <<~RESULT
            Inspecting 1 file
            C

            Offenses:

            example.rb:3:7: C: Naming/MethodName: Use snake_case for method names.
            def INVALID_CODE; end
                  ^^^^^^^^^^^^

            1 file inspected, 1 offense detected
          RESULT
        end
      end

      context 'when the extractor does not match' do
        let(:custom_ruby_extractor) do
          lambda do |_processed_source|
          end
        end

        let(:source) { <<~RUBY }
          # frozen_string_literal: true

          def INVALID_CODE; end
        RUBY

        it 'sends the offense to a formatter' do
          runner.run([])
          expect(formatter_output).to eq <<~RESULT
            Inspecting 1 file
            C

            Offenses:

            example.rb:3:5: C: Naming/MethodName: Use snake_case for method names.
            def INVALID_CODE; end
                ^^^^^^^^^^^^

            1 file inspected, 1 offense detected
          RESULT
        end
      end

      context 'when autocorrecting multiple extracted fragments' do
        let(:options) do
          {
            formatters: [['progress', formatter_output_path]],
            autocorrect: true,
            only: ['Style/StringLiterals']
          }
        end

        let(:template_source) do
          <<~ERB
            <%= "first" %>
            <%= "second" %>
            <%= #{third_fragment} %>
          ERB
        end
        let(:source) { template_source }

        let(:custom_ruby_extractor) do
          lambda do |processed_source|
            source = processed_source.buffer.source
            fragments = []

            source.scan(/<%= (?<ruby>.*?) %>/) do
              match = Regexp.last_match
              fragments << {
                offset: match.begin(:ruby),
                processed_source: RuboCop::ProcessedSource.new(
                  match[:ruby],
                  3.3,
                  'dummy.rb',
                  parser_engine: parser_engine
                )
              }
            end

            fragments
          end
        end

        context 'when all fragments have offenses' do
          let(:third_fragment) { '"third"' }

          it 'applies all corrections with a single write' do
            allow(RuboCop::Util).to receive(:replace_file_contents).and_call_original
            expect(RuboCop::Util).to receive(:replace_file_contents)
              .with(a_string_matching(/example\.rb\z/), anything)
              .once
              .and_call_original

            expect(runner.run([])).to be true
            expect(File.read('example.rb')).to eq(<<~ERB)
              <%= 'first' %>
              <%= 'second' %>
              <%= 'third' %>
            ERB
          end
        end

        context 'when the last fragment has no offense' do
          let(:third_fragment) { "'third'" }

          it 'still applies earlier fragment corrections in one run' do
            expect(runner.run([])).to be true
            expect(File.read('example.rb')).to eq(<<~ERB)
              <%= 'first' %>
              <%= 'second' %>
              <%= 'third' %>
            ERB
          end
        end
      end

      context 'when using stdin with offset 0 extractor fragments' do
        let(:options) do
          {
            formatters: [['progress', formatter_output_path]],
            autocorrect: true,
            stdin: "\"hello\"\n",
            only: ['Style/StringLiterals']
          }
        end
        let(:source) { '' }

        let(:custom_ruby_extractor) do
          lambda do |processed_source|
            ruby_source = processed_source.buffer.source

            [
              {
                offset: 0,
                processed_source: RuboCop::ProcessedSource.new(
                  ruby_source,
                  3.3,
                  'dummy.rb',
                  parser_engine: parser_engine
                )
              }
            ]
          end
        end

        it 'autocorrects without crashing' do
          expect { runner.run([]) }.not_to raise_error
          expect(runner.instance_variable_get(:@options)[:stdin]).to eq("'hello'\n")
        end
      end

      context 'when the extractor crashes' do
        let(:source) { <<~RUBY }
          # frozen_string_literal: true

          def foo; end
        RUBY

        shared_examples 'error handling' do
          it 'raises an error with the crashing extractor/file' do
            expect do
              runner.run([])
            end.to raise_error(RuboCop::Error, /runner_spec\.rb failed to process .*example\.rb/)
          end
        end

        context 'and it is a Proc' do
          let(:custom_ruby_extractor) do
            lambda do |_processed_source|
              raise 'Oh no!'
            end
          end

          it_behaves_like 'error handling'
        end

        context 'and it responds to `call`' do
          let(:custom_ruby_extractor) do
            Class.new do
              def self.call(_processed_source)
                raise 'Oh no!'
              end
            end
          end

          it_behaves_like 'error handling'
        end
      end
    end

    context 'when results should not be saved to the cache' do
      before do
        # The cache responds that it's not valid, which means that new results
        # should normally be collected and saved.
        cache = instance_double(RuboCop::ResultCache, 'valid?' => false)

        allow(RuboCop::ResultCache).to receive(:new) { cache }
      end

      context 'if a cop crashes on one of the files' do
        include FailingCopHelper

        include_context 'mock console output'

        let(:source) { "# frozen_string_literal: true\n\nputs 'crash'\n" }
        let(:later_file_cache) { instance_double(RuboCop::ResultCache, 'valid?' => false) }

        before do
          create_file('later.rb', "# frozen_string_literal: true\n\nputs 1\n")
          make_cop_fail(RuboCop::Cop::Style::StringLiterals, :on_str, RuntimeError, 'boom')

          # The crashing file's double doesn't define #save, so we'd get an
          # error if it were called.
          crashing_file_cache = instance_double(RuboCop::ResultCache, 'valid?' => false)
          allow(RuboCop::ResultCache).to receive(:new) do |file|
            file.end_with?('later.rb') ? later_file_cache : crashing_file_cache
          end
        end

        it 'still saves the results of the files that did not crash' do
          expect(later_file_cache).to receive(:save)

          runner.run([])

          expect(runner.errors).to contain_exactly(include('example.rb'))
        end
      end

      context 'if a warning is emitted for a file' do
        include_context 'cli spec behavior'

        let(:source) { 'x = 3 # rubocop:disable UselessAssignment' }

        it 'does not call ResultCache#save' do
          # The double doesn't define #save, so we'd get an error if it were called.
          expect(runner.run([])).to be false

          expect($stderr.string.chomp).to eq('example.rb: Warning: no department given for ' \
                                             'UselessAssignment. Run `rubocop -a --only ' \
                                             'Migration/DepartmentName` to fix.')
        end
      end
    end

    # A parallel worker inspects files in its own copy of the runner.
    if RUBY_ENGINE == 'ruby' && !RuboCop::Platform.windows?
      context 'when files are inspected in parallel' do
        include FailingCopHelper

        include_context 'mock console output'

        let(:options) { { parallel: true, formatters: [['progress', formatter_output_path]] } }
        let(:source) { "# frozen_string_literal: true\n\nputs 1\n" }

        before { create_file('other.rb', source) }

        it 'records the errors of a cop that crashes, in file order' do
          make_cop_fail(RuboCop::Cop::Style::FrozenStringLiteralComment, :on_new_investigation,
                        RuntimeError, 'boom')
          runner.run([])

          expect(runner.errors).to match([include('example.rb'), include('other.rb')])
        end

        it 'records the warnings a cop raises, in file order' do
          make_cop_fail(RuboCop::Cop::Style::FrozenStringLiteralComment, :on_new_investigation,
                        RuboCop::Warning, 'careful')
          runner.run([])

          expect(runner.warnings).to match([include('example.rb'), include('other.rb')])
        end

        context 'with the JSON formatter' do
          let(:options) { { parallel: true, formatters: [['json', formatter_output_path]] } }

          it 'lists the errors of each file in its entry' do
            make_cop_fail(RuboCop::Cop::Style::FrozenStringLiteralComment, :on_new_investigation,
                          RuntimeError, 'boom')
            runner.run([])

            expect(JSON.parse(formatter_output)['files']).to match(
              %w[example.rb other.rb].map do |path|
                include('path' => path,
                        'errors' => ['An error occurred while Style/FrozenStringLiteralComment ' \
                                     "cop was inspecting #{path}."])
              end
            )
          end
        end
      end
    end

    context 'when a cop crashes and a formatter reports it' do
      include FailingCopHelper

      include_context 'mock console output'

      let(:options) { { formatters: [['json', formatter_output_path]] } }
      let(:source) { "# frozen_string_literal: true\n\nputs 'crash'\n" }

      around do |example|
        Rainbow.enabled = true
        example.run
      ensure
        Rainbow.enabled = false
      end

      it 'gives the formatter the messages without terminal colors' do
        make_cop_fail(RuboCop::Cop::Style::StringLiterals, :on_str, RuntimeError, 'boom')
        runner.run([])

        expect(JSON.parse(formatter_output)['files']).to contain_exactly(
          include('errors' => ['An error occurred while Style/StringLiterals cop ' \
                               'was inspecting example.rb:3:5.'])
        )
      end
    end

    context 'if -s/--stdin is used with an offense' do
      before do
        # Make Style/EndOfLine give same output regardless of platform.
        create_file('.rubocop.yml', <<~YAML)
          Layout/EndOfLine:
            EnforcedStyle: lf
        YAML
      end

      let(:options) do
        {
          formatters: [['progress', formatter_output_path]],
          stdin: <<~RUBY
            # frozen_string_literal: true

            def INVALID_CODE; end
          RUBY
        }
      end
      let(:source) { '' }

      it 'returns false' do
        expect(runner.run([])).to be false
      end

      it 'sends the offense to a formatter' do
        runner.run([])
        expect(formatter_output).to eq <<~RESULT
          Inspecting 1 file
          C

          Offenses:

          example.rb:3:5: C: Naming/MethodName: Use snake_case for method names.
          def INVALID_CODE; end
              ^^^^^^^^^^^^

          1 file inspected, 1 offense detected
        RESULT
      end
    end
  end

  describe '#run with cops autocorrecting each-other' do
    include_context 'mock console output'

    let!(:source_file_path) { create_file('example.rb', source) }

    let(:options) { { autocorrect: true } }

    context 'with two conflicting cops' do
      subject(:runner) do
        runner_class = Class.new(RuboCop::Runner) do
          def mobilized_cop_classes(_config)
            RuboCop::Cop::Registry.new(
              [
                RuboCop::Cop::Test::ClassMustBeAModuleCop,
                RuboCop::Cop::Test::ModuleMustBeAClassCop
              ]
            )
          end
        end
        runner_class.new(options, RuboCop::ConfigStore.new)
      end

      context 'if there is an offense in an inspected file' do
        let(:source) { <<~RUBY }
          # frozen_string_literal: true
          class Klass
          end
        RUBY

        it 'records the infinite loop error' do
          runner.run([])
          expect(runner.errors.size).to be(1)
          expect(runner.errors[0].message).to eq(
            "Infinite loop detected in #{source_file_path} and caused by " \
            'Test/ClassMustBeAModuleCop -> Test/ModuleMustBeAClassCop'
          )
        end

        context 'when `raise_cop_error` is set' do
          let(:options) { { autocorrect: true, raise_cop_error: true } }

          it 'raises the infinite loop error' do
            expect do
              runner.run([])
            end.to raise_error(
              described_class::InfiniteCorrectionLoop,
              "Infinite loop detected in #{source_file_path} and caused by " \
              'Test/ClassMustBeAModuleCop -> Test/ModuleMustBeAClassCop'
            )
          end
        end

        if RUBY_ENGINE == 'ruby' && !RuboCop::Platform.windows?
          context 'when files are inspected in parallel' do
            let(:options) { { autocorrect: true, parallel: true } }
            let!(:other_file_path) { create_file('other.rb', source) }

            it 'records the infinite loop error of each file' do
              runner.run([])

              expect(runner.errors.map(&:message)).to eq(
                [source_file_path, other_file_path].map do |path|
                  "Infinite loop detected in #{path} and caused by " \
                    'Test/ClassMustBeAModuleCop -> Test/ModuleMustBeAClassCop'
                end
              )
            end
          end
        end
      end

      context 'if there are multiple offenses in an inspected file' do
        let(:source) { <<~RUBY }
          # frozen_string_literal: true
          class Klass
          end
          class AnotherKlass
          end
        RUBY

        it 'records the infinite loop error' do
          runner.run([])

          expect(runner.errors.size).to be(1)
          expect(runner.errors[0].message).to eq(
            "Infinite loop detected in #{source_file_path} and caused by " \
            'Test/ClassMustBeAModuleCop -> Test/ModuleMustBeAClassCop'
          )
        end
      end
    end

    context 'with two pairs of conflicting cops' do
      subject(:runner) do
        runner_class = Class.new(RuboCop::Runner) do
          def mobilized_cop_classes(_config)
            RuboCop::Cop::Registry.new(
              [
                RuboCop::Cop::Test::ClassMustBeAModuleCop,
                RuboCop::Cop::Test::ModuleMustBeAClassCop,
                RuboCop::Cop::Test::AtoB,
                RuboCop::Cop::Test::BtoA
              ]
            )
          end
        end
        runner_class.new(options, RuboCop::ConfigStore.new)
      end

      context 'if there is an offense in an inspected file' do
        let(:source) { <<~RUBY }
          # frozen_string_literal: true
          class A_A
          end
        RUBY

        it 'records the infinite loop error' do
          runner.run([])

          expect(runner.errors.size).to be(1)
          expect(runner.errors[0].message).to eq(
            "Infinite loop detected in #{source_file_path} and caused by " \
            'Test/ClassMustBeAModuleCop, Test/AtoB -> Test/ModuleMustBeAClassCop, Test/BtoA'
          )
        end
      end

      context 'with three cop cycle' do
        subject(:runner) do
          runner_class = Class.new(RuboCop::Runner) do
            def mobilized_cop_classes(_config)
              RuboCop::Cop::Registry.new(
                [
                  RuboCop::Cop::Test::AtoB,
                  RuboCop::Cop::Test::BtoC,
                  RuboCop::Cop::Test::CtoA
                ]
              )
            end
          end
          runner_class.new(options, RuboCop::ConfigStore.new)
        end

        context 'if there is an offense in an inspected file' do
          let(:source) { <<~RUBY }
            # frozen_string_literal: true
            class A
            end
          RUBY

          it 'records the infinite correction error' do
            runner.run([])

            expect(runner.errors.size).to be(1)
            expect(runner.errors[0].message).to eq(
              "Infinite loop detected in #{source_file_path} and caused by " \
              'Test/AtoB -> Test/BtoC -> Test/CtoA'
            )
          end
        end
      end

      context 'with display options' do
        subject(:runner) { described_class.new(options, RuboCop::ConfigStore.new) }

        before { create_file('example.rb', source) }

        context '--max-offenses-per-cop' do
          let(:options) do
            {
              formatters: [['progress', formatter_output_path]],
              max_offenses_per_cop: '1'
            }
          end
          let(:source) { <<~RUBY }
            # frozen_string_literal: true

            x = "a"
            y = "b"
            z = "c"
            puts x, y, z
          RUBY

          it 'reports only the first offense of a cop that fires repeatedly' do
            runner.run([])

            expect(formatter_output.scan('Style/StringLiterals').size).to eq(1)
          end

          it 'counts only the offenses it reported' do
            runner.run([])

            expect(formatter_output).to include('1 file inspected, 1 offense detected')
          end

          it 'still fails the run' do
            expect(runner.run([])).to be false
          end

          it 'names the cops it held back on stderr' do
            expect { runner.run([]) }.to output(
              %r{2 more offenses were not reported .*max-offenses-per-cop=1.*Style/StringLiterals}m
            ).to_stderr
          end

          context 'when no cop exceeds the limit' do
            let(:source) { <<~RUBY }
              # frozen_string_literal: true

              puts "a"
            RUBY

            it 'says nothing on stderr' do
              expect { runner.run([]) }.not_to output.to_stderr
            end
          end
        end

        context '--display-only-safe-correctable' do
          let(:options) do
            {
              formatters: [['progress', formatter_output_path]],
              display_only_safe_correctable: true
            }
          end
          let(:source) { <<~RUBY }

            def foo()
            end
          RUBY

          it 'returns false' do
            expect(runner.run([])).to be false
          end

          it 'omits unsafe correctable `Style/FrozenStringLiteral`' do
            runner.run([])
            expect(formatter_output).to eq <<~RESULT
              Inspecting 1 file
              C

              Offenses:

              example.rb:2:1: C: [Correctable] Layout/LeadingEmptyLines: Unnecessary blank line at the beginning of the source.
              def foo()
              ^^^
              example.rb:2:1: C: [Correctable] Style/EmptyMethod: Put empty method definitions on a single line.
              def foo() ...
              ^^^^^^^^^
              example.rb:2:8: C: [Correctable] Style/DefWithParentheses: Omit the parentheses in defs when the method doesn't accept any arguments.
              def foo()
                     ^^

              1 file inspected, 3 offenses detected, 3 offenses autocorrectable
            RESULT
          end
        end

        context '--display-only-correctable' do
          let(:options) do
            {
              formatters: [['progress', formatter_output_path]],
              display_only_correctable: true
            }
          end

          let(:source) { <<~RUBY }

            def foo()
            end

            'very-long-string-to-earn-un-autocorrectable-offense very-long-string-to-earn-un-autocorrectable-offense very-long-string-to-earn-un-autocorrectable-offense'
          RUBY

          it 'returns false' do
            expect(runner.run([])).to be false
          end

          it 'omits uncorrectable `Layout/LineLength`' do
            runner.run([])
            expect(formatter_output).to eq <<~RESULT
              Inspecting 1 file
              C

              Offenses:

              example.rb:1:1: C: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
              example.rb:2:1: C: [Correctable] Layout/LeadingEmptyLines: Unnecessary blank line at the beginning of the source.
              def foo()
              ^^^
              example.rb:2:1: C: [Correctable] Style/EmptyMethod: Put empty method definitions on a single line.
              def foo() ...
              ^^^^^^^^^
              example.rb:2:8: C: [Correctable] Style/DefWithParentheses: Omit the parentheses in defs when the method doesn't accept any arguments.
              def foo()
                     ^^

              1 file inspected, 4 offenses detected, 4 offenses autocorrectable
            RESULT
          end
        end
      end
    end
  end

  describe '#run with the project index', :project_index do
    it 'does not index RBS signatures that are target files' do
      create_file('lib/foo.rb', <<~RUBY)
        class Foo
          BAR = 1

          def baz; end
        end

        class Qux < Quux::Plugin::Base
        end
      RUBY

      create_file('sig/foo.rbs', <<~RBS)
        class Foo
          BAR: Integer

          def baz: () -> void
        end

        module Quux
          class PluginError < StandardError
          end
        end
      RBS

      write_rubocop_config(
        Dir.pwd,
        'AllCops' => { 'UseProjectIndex' => true, 'Include' => ['**/*.rb', '**/*.rbs'] },
        'Lint/ConstantReassignment' => { 'Enabled' => true },
        'Lint/NameTypo' => { 'Enabled' => true }
      )

      cop_names = project_index_offenses(Dir.pwd).map { |offense| offense['cop_name'] }

      expect(cop_names).not_to include(
        'Lint/ConstantReassignment', 'Lint/DuplicateMethods', 'Lint/NameTypo'
      )
    end
  end
end
