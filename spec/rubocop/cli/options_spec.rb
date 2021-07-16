# frozen_string_literal: true

RSpec.describe 'RuboCop::CLI options', :isolated_environment do # rubocop:disable RSpec/DescribeClass
  subject(:cli) { RuboCop::CLI.new }

  include_context 'cli spec behavior'

  let(:rubocop) { "#{RuboCop::ConfigLoader::RUBOCOP_HOME}/exe/rubocop" }

  before { RuboCop::ConfigLoader.default_configuration = nil }

  describe '--parallel' do
    if RuboCop::Platform.windows?
      context 'on Windows' do
        it 'prints a warning' do
          cli.run ['-P']
          expect($stderr.string).to include('Process.fork is not supported by this Ruby')
        end
      end
    else
      context 'combined with AllCops:UseCache:false' do
        before { create_file('.rubocop.yml', ['AllCops:', '  UseCache: false']) }

        it 'fails with an error message' do
          cli.run %w[-P]
          expect($stderr.string)
            .to include('-P/--parallel uses caching to speed up execution, ' \
                        'so combining with AllCops: UseCache: false is not ' \
                        'allowed.')
        end
      end

      context 'on Unix-like systems' do
        it 'prints a message if --debug is specified' do
          cli.run ['--parallel', '--debug']
          expect($stdout.string).to match(/Running parallel inspection/)
        end

        it 'does not print a message if --debug is not specified' do
          cli.run ['--parallel']
          expect($stdout.string).not_to match(/Running parallel inspection/)
        end
      end

      context 'in combination with --ignore-parent-exclusion' do
        before do
          create_file('.rubocop.yml', ['AllCops:', '  Exclude:', '    - subdir/*'])
          create_file('subdir/.rubocop.yml', ['AllCops:', '  Exclude:', '    - foobar'])
          create_file('subdir/test.rb', 'puts 1')
        end

        it 'does ignore the exclusion in the parent directory configuration' do
          Dir.chdir('subdir') { cli.run ['--parallel', '--ignore-parent-exclusion'] }
          expect($stdout.string).to match(/Inspecting 1 file/)
        end
      end

      context 'in combination with --force-default-config' do
        before do
          create_file('.rubocop.yml', ['ALLCOPS:', # Faulty configuration
                                       '  Exclude:',
                                       '    - subdir/*'])
          create_file('test.rb', 'puts 1')
        end

        it 'does not parse local configuration' do
          cli.run ['--parallel', '--force-default-config']
          expect($stdout.string).to match(/Inspecting 1 file/)
        end
      end
    end
  end

  describe '--list-target-files' do
    context 'when there are no files' do
      it 'prints nothing with -L' do
        cli.run ['-L']
        expect($stdout.string.empty?).to be(true)
      end

      it 'prints nothing with --list-target-files' do
        cli.run ['--list-target-files']
        expect($stdout.string.empty?).to be(true)
      end
    end

    context 'when there are some files' do
      before do
        create_file('show.rabl2', 'object @user => :person')
        create_file('show.rabl', 'object @user => :person')
        create_file('app.rb', 'puts "hello world"')
        create_file('Gemfile', <<~RUBY)
          source "https://rubygems.org"
          gem "rubocop"
        RUBY
        create_file('lib/helper.rb', 'puts "helpful"')
      end

      context 'when there are no includes or excludes' do
        it 'prints known ruby files' do
          cli.run ['-L']
          expect($stdout.string.split("\n")).to contain_exactly(
            'app.rb', 'Gemfile', 'lib/helper.rb', 'show.rabl'
          )
        end
      end

      context 'when there is an include and exclude' do
        before do
          create_file('.rubocop.yml', <<~YAML)
            AllCops:
              Exclude:
                - Gemfile
              Include:
                - "**/*.rb"
                - "**/*.rabl"
                - "**/*.rabl2"
          YAML
        end

        it 'prints the included files and not the excluded ones' do
          cli.run ['--list-target-files']
          expect($stdout.string.split("\n")).to contain_exactly(
            'app.rb', 'lib/helper.rb', 'show.rabl', 'show.rabl2'
          )
        end
      end
    end
  end

  describe '--version' do
    it 'exits cleanly' do
      expect(cli.run(['-v'])).to eq(0)
      expect(cli.run(['--version'])).to eq(0)
      expect($stdout.string).to eq("#{RuboCop::Version::STRING}\n" * 2)
    end
  end

  describe '-V' do
    it 'exits cleanly' do
      expect(cli.run(['-V'])).to eq(0)
      expect($stdout.string).to include(RuboCop::Version::STRING)
      expect($stdout.string).to match(/Parser \d+\.\d+\.\d+/)
      expect($stdout.string).to match(/rubocop-ast \d+\.\d+\.\d+/)
    end

    context 'when requiring extension cops' do
      before do
        create_file('.rubocop.yml', <<~YAML)
          require:
            - rubocop-performance
            - rubocop-rspec
        YAML
      end

      it 'shows with version of extension cops' do
        # Run in different process that requiring rubocop-performance and rubocop-rspec
        # does not affect other testing processes.
        output = `ruby -I . "#{rubocop}" -V --disable-pending-cops`
        expect(output).to include(RuboCop::Version::STRING)
        expect(output).to match(/Parser \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-ast \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-performance \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-rspec \d+\.\d+\.\d+/)
      end
    end

    context 'when requiring extension cops in multiple layers' do
      before do
        create_file('.rubocop-parent.yml', <<~YAML)
          require:
            - rubocop-performance
        YAML

        create_file('.rubocop.yml', <<~YAML)
          inherit_from: ./.rubocop-parent.yml
          require:
            - rubocop-rspec
        YAML
      end

      it 'shows with version of extension cops' do
        # Run in different process that requiring rubocop-performance and rubocop-rspec
        # does not affect other testing processes.
        output = `ruby -I . "#{rubocop}" -V --disable-pending-cops`
        expect(output).to include(RuboCop::Version::STRING)
        expect(output).to match(/Parser \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-ast \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-performance \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-rspec \d+\.\d+\.\d+/)
      end
    end

    context 'when requiring redundant extension cop' do
      before do
        create_file('ext.yml', <<~YAML)
          require:
            - rubocop-rspec
        YAML
        create_file('.rubocop.yml', <<~YAML)
          inherit_from: ext.yml
          require:
            - rubocop-performance
            - rubocop-rspec
        YAML
      end

      it 'shows with version of each extension cop once' do
        output = `ruby -I . "#{rubocop}" -V --disable-pending-cops`
        expect(output).to include(RuboCop::Version::STRING)
        expect(output).to match(/Parser \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-ast \d+\.\d+\.\d+/)
        expect(output).to match(
          /- rubocop-performance \d+\.\d+\.\d+\n  - rubocop-rspec \d+\.\d+\.\d+\n\z/
        )
      end
    end

    context 'when there are pending cops' do
      let(:pending_cop_warning) { <<~PENDING_COP_WARNING }
        The following cops were added to RuboCop, but are not configured. Please set Enabled to either `true` or `false` in your `.rubocop.yml` file.
      PENDING_COP_WARNING

      before do
        create_file('.rubocop.yml', <<~YAML)
          require: rubocop_ext

          AllCops:
            NewCops: pending

          Style/SomeCop:
            Description: Something
            Enabled: pending
            VersionAdded: '1.6'
        YAML

        create_file('rubocop_ext.rb', <<~RUBY)
          module RuboCop
            module Cop
              module Style
                class SomeCop < Cop
                end
              end
            end
          end
        RUBY

        create_file('redirect.rb', '$stderr = STDOUT')
      end

      it 'does not show warnings for pending cops' do
        output = `ruby -I . "#{rubocop}" --require redirect.rb -V`
        expect(output).to include(RuboCop::Version::STRING)
        expect(output).to match(/Parser \d+\.\d+\.\d+/)
        expect(output).to match(/rubocop-ast \d+\.\d+\.\d+/)
        expect(output).not_to include(pending_cop_warning)
      end
    end
  end

  describe '--only' do
    context 'when one cop is given' do
      it 'runs just one cop' do
        # The disable comment should not be reported as unnecessary (even if
        # it is) since --only overrides configuration.
        create_file('example.rb', ['# rubocop:disable LineLength', 'if x== 0 ', "\ty", 'end'])
        # IfUnlessModifier depends on the configuration of LineLength.

        expect(cli.run(['--format', 'simple',
                        '--only', 'Style/IfUnlessModifier',
                        'example.rb'])).to eq(1)
        expect($stdout.string)
          .to eq(['== example.rb ==',
                  'C:  2:  1: [Correctable] Style/IfUnlessModifier: Favor modifier if ' \
                  'usage when having a single-line body. Another good ' \
                  'alternative is the usage of control flow &&/||.',
                  '',
                  '1 file inspected, 1 offense detected, 1 offense auto-correctable',
                  ''].join("\n"))
      end

      it 'exits with error if an incorrect cop name is passed' do
        create_file('example.rb', ['if x== 0 ', "\ty", 'end'])
        expect(cli.run(['--only', 'Style/123'])).to eq(2)
        expect($stderr.string).to include('Unrecognized cop or department: Style/123.')
      end

      it 'displays correction candidate if an incorrect cop name is given' do
        create_file('example.rb', ['x'])
        expect(cli.run(['--only', 'Style/BlockComment'])).to eq(2)
        expect($stderr.string).to include('Unrecognized cop or department: Style/BlockComment.')
        expect($stderr.string).to include('Did you mean? Style/BlockComments')
      end

      it 'exits with error if an empty string is given' do
        create_file('example.rb', 'x')
        expect(cli.run(['--only', ''])).to eq(2)
        expect($stderr.string).to include('Unrecognized cop or department: .')
      end

      %w[Syntax Lint/Syntax].each do |name|
        it "only checks syntax if #{name} is given" do
          create_file('example.rb', 'x ')
          expect(cli.run(['--only', name])).to eq(0)
          expect($stdout.string).to include('no offenses detected')
        end
      end

      %w[Lint/RedundantCopDisableDirective
         RedundantCopDisableDirective].each do |name|
        it "exits with error if cop name #{name} is passed" do
          create_file('example.rb', ['if x== 0 ', "\ty", 'end'])
          expect(cli.run(['--only', 'RedundantCopDisableDirective'])).to eq(2)
          expect($stderr.string)
            .to include(
              'Lint/RedundantCopDisableDirective cannot be used with --only.'
            )
        end
      end

      it 'accepts cop names from plugins' do
        create_file('.rubocop.yml', <<~YAML)
          require: rubocop_ext

          Style/SomeCop:
            Description: Something
            Enabled: true
        YAML
        create_file('rubocop_ext.rb', <<~RUBY)
          module RuboCop
            module Cop
              module Style
                class SomeCop < Cop
                end
              end
            end
          end
        RUBY
        create_file('redirect.rb', '$stderr = STDOUT')
        rubocop = "#{RuboCop::ConfigLoader::RUBOCOP_HOME}/exe/rubocop"
        # Since we define a new cop class, we have to do this in a separate
        # process. Otherwise, the extra cop will affect other specs.
        output = `ruby -I . "#{rubocop}" --require redirect.rb --only Style/SomeCop`
        # Excludes a warning when new `Enabled: pending` status cop is specified
        # in config/default.yml.
        output_excluding_warn_for_pending_cops = output.split("\n").last(4).join("\n") << "\n"
        expect(output_excluding_warn_for_pending_cops)
          .to eq(<<~RESULT)
            Inspecting 2 files
            ..

            2 files inspected, no offenses detected
          RESULT
      end

      context 'when specifying a pending cop' do
        # Since we define a new cop class, we have to do this in a separate
        # process. Otherwise, the extra cop will affect other specs.
        let(:output) { `ruby -I . "#{rubocop}" --require redirect.rb --only Style/SomeCop` }

        let(:pending_cop_warning) { <<~PENDING_COP_WARNING }
          The following cops were added to RuboCop, but are not configured. Please set Enabled to either `true` or `false` in your `.rubocop.yml` file.
        PENDING_COP_WARNING

        let(:inspected_output) { <<~INSPECTED_OUTPUT }
          Inspecting 2 files
          ..

          2 files inspected, no offenses detected
        INSPECTED_OUTPUT

        let(:versioning_manual_url) { <<~VERSIONING_MANUAL_URL.chop }
          For more information: https://docs.rubocop.org/rubocop/versioning.html
        VERSIONING_MANUAL_URL

        before do
          create_file('rubocop_ext.rb', <<~RUBY)
            module RuboCop
              module Cop
                module Style
                  class SomeCop < Cop
                  end
                end
              end
            end
          RUBY

          create_file('redirect.rb', '$stderr = STDOUT')
        end

        context 'when Style department is enabled' do
          let(:new_cops_option) { '' }
          let(:version_added) { "VersionAdded: '0.80'" }

          before do
            create_file('.rubocop.yml', <<~YAML)
              require: rubocop_ext

              AllCops:
                DefaultFormatter: progress
                #{new_cops_option}

              Style/SomeCop:
                Description: Something
                Enabled: pending
                #{version_added}
            YAML
          end

          context 'when `VersionAdded` is specified' do
            it 'accepts cop names from plugins with a pending cop warning' do
              expect(output).to start_with(pending_cop_warning)
              expect(output).to end_with(inspected_output)

              remaining_range = pending_cop_warning.length..-(inspected_output.length + 1)
              pending_cops = output[remaining_range]

              expect(pending_cops).to include("Style/SomeCop: # (new in 0.80)\n  Enabled: true")

              manual_url = output[remaining_range].split("\n").last

              expect(manual_url).to eq(versioning_manual_url)
            end
          end

          context 'when `VersionAdded` is not specified' do
            let(:version_added) { '' }

            it 'accepts cop names from plugins with a pending cop warning' do
              expect(output).to start_with(pending_cop_warning)
              expect(output).to end_with(inspected_output)

              remaining_range = pending_cop_warning.length..-(inspected_output.length + 1)
              pending_cops = output[remaining_range]

              expect(pending_cops).to include("Style/SomeCop: # (new in N/A)\n  Enabled: true")

              manual_url = output[remaining_range].split("\n").last

              expect(manual_url).to eq(versioning_manual_url)
            end
          end

          context 'when using `--disable-pending-cops` command-line option' do
            let(:option) { '--disable-pending-cops' }

            let(:output) { `ruby -I . "#{rubocop}" --require redirect.rb #{option}` }

            it 'does not display a pending cop warning' do
              expect(output).not_to start_with(pending_cop_warning)
            end
          end

          context 'when using `--enable-pending-cops` command-line option' do
            let(:option) { '--enable-pending-cops' }

            let(:output) { `ruby -I . "#{rubocop}" --require redirect.rb #{option}` }

            it 'does not display a pending cop warning' do
              expect(output).not_to start_with(pending_cop_warning)
            end
          end

          context 'when specifying `NewCops: pending` in .rubocop.yml' do
            let(:new_cops_option) { 'NewCops: pending' }

            let(:output) { `ruby -I . "#{rubocop}" --require redirect.rb` }

            it 'displays a pending cop warning' do
              expect(output).to start_with(pending_cop_warning)
            end
          end

          context 'when specifying `NewCops: disable` in .rubocop.yml' do
            let(:new_cops_option) { 'NewCops: disable' }

            let(:output) { `ruby -I . "#{rubocop}" --require redirect.rb` }

            it 'does not display a pending cop warning' do
              expect(output).not_to start_with(pending_cop_warning)
            end
          end

          context 'when specifying `NewCops: enable` in .rubocop.yml' do
            let(:new_cops_option) { 'NewCops: enable' }

            let(:output) { `ruby -I . "#{rubocop}" --require redirect.rb` }

            it 'does not display a pending cop warning' do
              expect(output).not_to start_with(pending_cop_warning)
            end
          end
        end

        context 'when Style department is disabled' do
          before do
            create_file('.rubocop.yml', <<~YAML)
              require: rubocop_ext

              Lint:
                Enabled: false
              Style:
                Enabled: false
              Layout:
                Enabled: false
              Gemspec:
                Enabled: false
              Naming:
                Enabled: false

              Style/SomeCop:
                Description: Something
                Enabled: pending
            YAML
          end

          it 'does not show pending cop warning' do
            expect(output).to eq(inspected_output)
          end
        end
      end

      context 'without using namespace' do
        it 'runs just one cop' do
          create_file('example.rb', ['if x== 0 ', "\ty", 'end'])

          expect(cli.run(['--format', 'simple',
                          '--display-cop-names',
                          '--only', 'IfUnlessModifier',
                          'example.rb'])).to eq(1)
          expect($stdout.string)
            .to eq(['== example.rb ==',
                    'C:  1:  1: [Correctable] Style/IfUnlessModifier: Favor modifier if ' \
                    'usage when having a single-line body. Another good ' \
                    'alternative is the usage of control flow &&/||.',
                    '',
                    '1 file inspected, 1 offense detected, 1 offense auto-correctable',
                    ''].join("\n"))
        end
      end

      it 'enables the given cop' do
        create_file('example.rb',
                    ['x = 0 ',
                     # Disabling comments still apply.
                     '# rubocop:disable Layout/TrailingWhitespace',
                     'y = 1  '])

        create_file('.rubocop.yml', <<~YAML)
          Layout/TrailingWhitespace:
            Enabled: false
        YAML

        expect(cli.run(['--format', 'simple',
                        '--only', 'Layout/TrailingWhitespace',
                        'example.rb'])).to eq(1)
        expect($stderr.string).to eq('')
        expect($stdout.string)
          .to eq(<<~RESULT)
            == example.rb ==
            C:  1:  6: [Correctable] Layout/TrailingWhitespace: Trailing whitespace detected.

            1 file inspected, 1 offense detected, 1 offense auto-correctable
          RESULT
      end
    end

    context 'when several cops are given' do
      it 'runs the given cops' do
        create_file('example.rb', ['if x== 100000000000000 ', "\ty", 'end'])
        expect(cli.run(['--format', 'simple',
                        '--only',
                        'Style/IfUnlessModifier,Layout/IndentationStyle,' \
                        'Layout/SpaceAroundOperators',
                        'example.rb'])).to eq(1)
        expect($stderr.string).to eq('')
        expect($stdout.string).to eq(<<~RESULT)
          == example.rb ==
          C:  1:  1: [Correctable] Style/IfUnlessModifier: Favor modifier if usage when having a single-line body. Another good alternative is the usage of control flow &&/||.
          C:  1:  5: [Correctable] Layout/SpaceAroundOperators: Surrounding space missing for operator ==.
          C:  2:  1: [Correctable] Layout/IndentationStyle: Tab detected in indentation.

          1 file inspected, 3 offenses detected, 3 offenses auto-correctable
        RESULT
      end

      context 'and --lint' do
        it 'runs the given cops plus all enabled lint cops' do
          create_file('example.rb', ['if x== 100000000000000 ', "\ty = 3", '  end'])
          create_file('.rubocop.yml', <<~YAML)
            Layout/EndAlignment:
              Enabled: false
          YAML
          expect(cli.run(['--format', 'simple', '--only',
                          'Layout/IndentationStyle,Layout/SpaceAroundOperators',
                          '--lint', 'example.rb'])).to eq(1)
          expect($stdout.string)
            .to eq(<<~RESULT)
              == example.rb ==
              C:  1:  5: [Correctable] Layout/SpaceAroundOperators: Surrounding space missing for operator ==.
              C:  2:  1: [Correctable] Layout/IndentationStyle: Tab detected in indentation.
              W:  2:  2: Lint/UselessAssignment: Useless assignment to variable - y.

              1 file inspected, 3 offenses detected, 2 offenses auto-correctable
            RESULT
        end
      end
    end

    context 'when a namespace is given' do
      it 'runs all enabled cops in that namespace' do
        create_file('example.rb', ['if x== 100000000000000 ', "  #{'#' * 130}", "\ty", 'end'])
        expect(cli.run(%w[-f offenses --only Layout example.rb])).to eq(1)
        expect($stdout.string).to eq(<<~RESULT)

          1  Layout/CommentIndentation
          1  Layout/IndentationStyle
          1  Layout/IndentationWidth
          1  Layout/LineLength
          1  Layout/SpaceAroundOperators
          1  Layout/TrailingWhitespace
          --
          6  Total

        RESULT
      end
    end

    context 'when three namespaces are given' do
      it 'runs all enabled cops in those namespaces' do
        create_file('example.rb', ['if x== 100000000000000 ', "  # #{'-' * 130}", "\ty", 'end'])
        create_file('.rubocop.yml', <<~YAML)
          Layout/SpaceAroundOperators:
            Enabled: false
        YAML
        expect(cli.run(%w[-f o --only Metrics,Style,Layout example.rb])).to eq(1)
        expect($stdout.string)
          .to eq(<<~RESULT)

            1  Layout/CommentIndentation
            1  Layout/IndentationStyle
            1  Layout/IndentationWidth
            1  Layout/LineLength
            1  Layout/TrailingWhitespace
            1  Style/FrozenStringLiteralComment
            1  Style/NumericLiterals
            --
            7  Total

          RESULT
      end
    end

    context 'when a cop name is not specified' do
      it 'displays how to use `--only` option' do
        expect(cli.run(%w[--except -a Lint/NumberConverion])).to eq(2)
        expect($stderr.string).to eq(<<~MESSAGE)
          --except argument should be [COP1,COP2,...].
        MESSAGE
      end
    end

    context 'when the cop is defined in a require', :restore_registry do
      before do
        create_file('.rubocop.yml', <<~YAML)
          require:
            - './custom_cops.rb'
        YAML

        create_file('example.rb', 'foo(:bar)')
      end

      context 'when the cop name is not duplicated' do
        before do
          create_file('custom_cops.rb', <<~RUBY)
            module CustomCops
              class NoMethods < RuboCop::Cop::Base
                MSG = 'Methods are not allowed.'

                def on_send(node)
                  add_offense(node)
                end
              end
            end
          RUBY
        end

        it 'runs the cop without warnings' do
          expect(cli.run(['--format', 'simple',
                          '--only', 'CustomCops/NoMethods',
                          'example.rb'])).to eq(1)

          expect($stdout.string).to eq(<<~RESULT)
            == example.rb ==
            C:  1:  1: CustomCops/NoMethods: Methods are not allowed.

            1 file inspected, 1 offense detected
          RESULT
          expect($stderr.string).not_to match(%r{CustomCops/NoMethods has the wrong namespace})
        end
      end

      context 'when the cop name duplicates a built-in cop' do
        before do
          create_file('custom_cops.rb', <<~RUBY)
            module CustomCops
              class MethodLength < RuboCop::Cop::Base
                MSG = 'Method is too long.'

                def on_send(node)
                  add_offense(node)
                end
              end
            end
          RUBY
        end

        it 'runs the correct cop without warnings' do
          expect(cli.run(['--format', 'simple',
                          '--only', 'CustomCops/MethodLength',
                          'example.rb'])).to eq(1)

          expect($stdout.string).to eq(<<~RESULT)
            == example.rb ==
            C:  1:  1: CustomCops/MethodLength: Method is too long.

            1 file inspected, 1 offense detected
          RESULT
          expect($stderr.string).not_to match(%r{CustomCops/MethodLength has the wrong namespace})
        end
      end
    end
  end

  describe '--except' do
    context 'when one name is given' do
      it 'exits with error if the cop name is incorrect' do
        create_file('example.rb', ['if x== 0 ', "\ty", 'end'])
        expect(cli.run(['--except', 'Style/123'])).to eq(2)
        expect($stderr.string).to include('Unrecognized cop or department: Style/123.')
      end

      it 'exits with error if an empty string is given' do
        create_file('example.rb', 'x')
        expect(cli.run(['--except', ''])).to eq(2)
        expect($stderr.string).to include('Unrecognized cop or department: .')
      end

      it 'displays correction candidate if an incorrect cop name is given' do
        create_file('example.rb', 'x')
        expect(cli.run(['--except', 'Style/BlockComment'])).to eq(2)
        expect($stderr.string).to include('Unrecognized cop or department: Style/BlockComment.')
        expect($stderr.string).to include('Did you mean? Style/BlockComments')
      end

      %w[Syntax Lint/Syntax].each do |name|
        it "exits with error if #{name} is given" do
          create_file('example.rb', 'x ')
          expect(cli.run(['--except', name])).to eq(2)
          expect($stderr.string).to include('Syntax checking cannot be turned off.')
        end
      end
    end

    context 'when one cop plus one namespace are given' do
      it 'runs all cops except the given' do
        # The disable comment should not be reported as unnecessary (even if
        # it is) since --except overrides configuration.
        create_file('example.rb', ['# rubocop:disable LineLength', 'if x== 0 ', "\ty = 3", 'end'])
        expect(cli.run(['--format', 'offenses',
                        '--except', 'Style/IfUnlessModifier,Lint',
                        'example.rb'])).to eq(1)
        # NOTE: No Lint/UselessAssignment offense.
        expect($stdout.string)
          .to eq(<<~RESULT)

            1  Layout/IndentationStyle
            1  Layout/IndentationWidth
            1  Layout/SpaceAroundOperators
            1  Layout/TrailingWhitespace
            1  Migration/DepartmentName
            1  Style/FrozenStringLiteralComment
            1  Style/NumericPredicate
            --
            7  Total

          RESULT
      end
    end

    context 'when one cop is given without namespace' do
      it 'disables the given cop' do
        create_file('example.rb', ['if x== 0 ', "\ty", 'end'])

        cli.run(['--format', 'offenses', '--except', 'Style/IfUnlessModifier', 'example.rb'])
        with_option = $stdout.string
        $stdout = StringIO.new
        cli.run(['--format', 'offenses', 'example.rb'])
        without_option = $stdout.string

        expect($stderr.string).to eq('')
        expect(without_option.split($RS) - with_option.split($RS))
          .to eq(['1  Style/IfUnlessModifier', '7  Total'])
      end
    end

    context 'when several cops are given' do
      %w[RedundantCopDisableDirective
         Lint/RedundantCopDisableDirective Lint].each do |cop_name|
        it "disables the given cops including #{cop_name}" do
          create_file('example.rb', ['if x== 100000000000000 ', "\ty", 'end # rubocop:disable all'])
          expect(cli.run(['--format', 'offenses',
                          '--except',
                          'Style/IfUnlessModifier,Layout/IndentationStyle,' \
                          "Layout/SpaceAroundOperators,#{cop_name}",
                          'example.rb'])).to eq(1)
          if cop_name == 'RedundantCopDisableDirective'
            expect($stderr.string.chomp)
              .to eq('--except option: Warning: no department given for ' \
                     'RedundantCopDisableDirective.')
          end
          expect($stdout.string)
            .to eq(<<~RESULT)

              1  Layout/IndentationWidth
              1  Layout/TrailingWhitespace
              1  Style/FrozenStringLiteralComment
              1  Style/NumericLiterals
              --
              4  Total

            RESULT
        end
      end
    end

    context 'when a cop name is not specified' do
      it 'displays how to use `--except` option' do
        expect(cli.run(%w[--except])).to eq(2)
        expect($stderr.string).to eq(<<~MESSAGE)
          --except argument should be [COP1,COP2,...].
        MESSAGE
      end
    end
  end

  describe '--lint' do
    it 'runs only lint cops' do
      create_file('example.rb',
                  ['if 0 ',
                   "\ty",
                   "\tz # rubocop:disable Layout/IndentationStyle",
                   'end'])
      # IfUnlessModifier depends on the configuration of LineLength.

      expect(cli.run(['--format', 'simple', '--lint', 'example.rb'])).to eq(1)
      expect($stdout.string)
        .to eq(<<~RESULT)
          == example.rb ==
          W:  1:  4: Lint/LiteralAsCondition: Literal 0 appeared as a condition.

          1 file inspected, 1 offense detected
        RESULT
    end
  end

  describe '-d/--debug' do
    before { RuboCop::ConfigLoader.default_configuration = nil }

    it 'shows config files' do
      create_file('example1.rb', "\tputs 0")
      expect(cli.run(['--debug', 'example1.rb'])).to eq(1)
      home = File.dirname(File.dirname(File.dirname(File.dirname(__FILE__))))
      expect($stdout.string.lines.grep(/configuration/).map(&:chomp))
        .to eq(["For #{abs('')}:" \
                " Default configuration from #{home}/config/default.yml"])
    end

    it 'shows cop names' do
      create_file('example1.rb', 'puts 0 ')
      file = abs('example1.rb')

      expect(cli.run(['--format', 'emacs', '--debug', 'example1.rb'])).to eq(1)
      expect($stdout.string.lines.to_a[-1])
        .to eq("#{file}:1:7: C: [Correctable] Layout/TrailingWhitespace: Trailing " \
               "whitespace detected.\n")
    end
  end

  describe '--display-time' do
    before { create_file('example1.rb', '') }

    regex = /Finished in [0-9]*\.[0-9]* seconds/

    context 'without --display-time' do
      it 'does not display elapsed time in seconds' do
        expect(`rubocop example1.rb`).not_to match(regex)
      end
    end

    context 'with --display-time' do
      it 'displays elapsed time in seconds' do
        expect(`rubocop --display-time example1.rb`).to match(regex)
      end
    end
  end

  describe '-D/--display-cop-names' do
    before { create_file('example1.rb', 'puts 0 # rubocop:disable NumericLiterals ') }

    let(:file) { abs('example1.rb') }

    it 'shows cop names' do
      expect(cli.run(['--format', 'emacs', '--display-cop-names', 'example1.rb'])).to eq(1)
      expect($stdout.string).to eq(<<~RESULT)
        #{file}:1:1: C: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
        #{file}:1:8: W: [Correctable] Lint/RedundantCopDisableDirective: Unnecessary disabling of `Style/NumericLiterals`.
        #{file}:1:26: C: [Correctable] Migration/DepartmentName: Department name is missing.
        #{file}:1:41: C: [Correctable] Layout/TrailingWhitespace: Trailing whitespace detected.
      RESULT
    end

    context '--no-display-cop-names' do
      it 'does not show cop names' do
        expect(cli.run(['--format', 'emacs', '--no-display-cop-names', 'example1.rb'])).to eq(1)
        expect($stdout.string).to eq(<<~RESULT)
          #{file}:1:1: C: [Correctable] Missing frozen string literal comment.
          #{file}:1:8: W: [Correctable] Unnecessary disabling of `Style/NumericLiterals`.
          #{file}:1:26: C: [Correctable] Department name is missing.
          #{file}:1:41: C: [Correctable] Trailing whitespace detected.
        RESULT
      end
    end

    context 'DisplayCopNames: false in .rubocop.yml' do
      before do
        create_file('.rubocop.yml', <<~YAML)
          AllCops:
            DisplayCopNames: false
        YAML
      end

      it 'shows cop names' do
        expect(cli.run(['--format', 'emacs', '--display-cop-names', 'example1.rb'])).to eq(1)
        expect($stdout.string).to eq(<<~RESULT)
          #{file}:1:1: C: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
          #{file}:1:8: W: [Correctable] Lint/RedundantCopDisableDirective: Unnecessary disabling of `Style/NumericLiterals`.
          #{file}:1:26: C: [Correctable] Migration/DepartmentName: Department name is missing.
          #{file}:1:41: C: [Correctable] Layout/TrailingWhitespace: Trailing whitespace detected.
        RESULT
      end

      context 'without --display-cop-names' do
        it 'does not show cop names' do
          expect(cli.run(['--format', 'emacs', 'example1.rb'])).to eq(1)
          expect($stdout.string).to eq(<<~RESULT)
            #{file}:1:1: C: [Correctable] Missing frozen string literal comment.
            #{file}:1:8: W: [Correctable] Unnecessary disabling of `Style/NumericLiterals`.
            #{file}:1:26: C: [Correctable] Department name is missing.
            #{file}:1:41: C: [Correctable] Trailing whitespace detected.
          RESULT
        end
      end
    end
  end

  describe '-E/--extra-details' do
    it 'shows extra details' do
      create_file('example1.rb', 'puts 0 # rubocop:disable Style/NumericLiterals ')
      create_file('.rubocop.yml', <<~YAML)
        Layout/TrailingWhitespace:
          Details: Trailing space is just sloppy.
      YAML
      file = abs('example1.rb')

      expect(cli.run(['--format', 'emacs', '--extra-details', 'example1.rb'])).to eq(1)
      expect($stdout.string).to eq(<<~RESULT)
        #{file}:1:1: C: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
        #{file}:1:8: W: [Correctable] Lint/RedundantCopDisableDirective: Unnecessary disabling of `Style/NumericLiterals`.
        #{file}:1:47: C: [Correctable] Layout/TrailingWhitespace: Trailing whitespace detected. Trailing space is just sloppy.
      RESULT

      expect($stderr.string).to eq('')
    end
  end

  describe '-S/--display-style-guide' do
    it 'shows style guide entry' do
      create_file('example1.rb', 'puts 0 ')
      file = abs('example1.rb')
      url = 'https://rubystyle.guide#no-trailing-whitespace'

      expect(cli.run(['--format', 'emacs', '--display-style-guide', 'example1.rb'])).to eq(1)
      expect($stdout.string.lines.to_a[-1])
        .to eq("#{file}:1:7: C: [Correctable] Layout/TrailingWhitespace: " \
               "Trailing whitespace detected. (#{url})\n")
    end

    it 'shows reference entry' do
      create_file('example1.rb', "JSON.load('{}')")
      file = abs('example1.rb')
      url = 'https://ruby-doc.org/stdlib-2.7.0/libdoc/json/rdoc/JSON.html#method-i-load'

      expect(cli.run(['--format', 'emacs', '--display-style-guide', 'example1.rb'])).to eq(1)

      output = "#{file}:1:6: C: Security/JSONLoad: Prefer `JSON.parse` over `JSON.load`. (#{url})"
      expect($stdout.string.lines.to_a[-1]).to eq([output, ''].join("\n"))
    end

    it 'shows style guide and reference entries' do
      create_file('example1.rb', '$foo = 1')
      file = abs('example1.rb')
      style_guide_link = 'https://rubystyle.guide#instance-vars'
      reference_link = 'https://www.zenspider.com/ruby/quickref.html'

      expect(cli.run(['--format', 'emacs', '--display-style-guide', 'example1.rb'])).to eq(1)

      output = "#{file}:1:1: C: Style/GlobalVars: " \
               'Do not introduce global variables. ' \
               "(#{style_guide_link}, #{reference_link})"
      expect($stdout.string.lines.to_a[-1]).to eq([output, ''].join("\n"))
    end
  end

  describe '--show-cops' do
    shared_examples('prints config') do
      it 'prints the current configuration' do
        out = stdout.lines.to_a
        printed_config = if defined?(YAML.unsafe_load) # RUBY_VERSION >= '3.1.0'
                           YAML.unsafe_load(out.join)
                         else
                           YAML.load(out.join) # rubocop:disable Security/YAMLLoad
                         end
        cop_names = (arguments[0] || '').split(',')
        cop_names.each do |cop_name|
          global_conf[cop_name].each do |key, value|
            printed_value = printed_config[cop_name][key]
            expect(printed_value).to eq(value)
          end
        end
      end
    end

    let(:cops) { RuboCop::Cop::Registry.all }
    let(:registry) { RuboCop::Cop::Registry.global }

    let(:global_conf) do
      config_path = RuboCop::ConfigLoader.configuration_file_for(Dir.pwd.to_s)
      RuboCop::ConfigLoader.configuration_from_file(config_path)
    end

    let(:stdout) { $stdout.string }

    before do
      create_file('.rubocop.yml', <<~YAML)
        Layout/LineLength:
          Max: 110
      YAML
      # expect(cli.run(['--show-cops'] + arguments)).to eq(0)
      cli.run(['--show-cops'] + arguments)
    end

    context 'with no args' do
      let(:arguments) { [] }

      # Extracts the first line out of the description
      def short_description_of_cop(cop)
        desc = full_description_of_cop(cop)
        desc ? desc.lines.first.strip : ''
      end

      # Gets the full description of the cop or nil if no description is set.
      def full_description_of_cop(cop)
        cop_config = global_conf.for_cop(cop)
        cop_config['Description']
      end

      it 'prints all available cops and their description' do
        cops.each do |cop|
          expect(stdout).to include cop.cop_name
          # Because of line breaks, we will only find the beginning.
          expect(stdout).to include short_description_of_cop(cop)[0..60]
        end
      end

      it 'prints all departments' do
        registry.departments.each { |department| expect(stdout).to include(department.to_s) }
      end

      it 'prints all cops in their right department listing' do
        lines = stdout.lines
        lines.slice_before(/Department /).each do |slice|
          departments = registry.departments.map(&:to_s)
          current = departments.delete(slice.shift[/Department '(?<c>[^']+)'/, 'c'])

          # all cops in their department listing
          registry.with_department(current).each do |cop|
            expect(slice.any? { |l| l.include? cop.cop_name }).to be_truthy
          end

          # no cop in wrong department listing
          departments.each do |department|
            registry.with_department(department).each do |cop|
              expect(slice.any? { |l| l.include? cop.cop_name }).to be_falsey
            end
          end
        end
      end

      include_examples 'prints config'
    end

    context 'with one cop given' do
      let(:arguments) { ['Layout/IndentationStyle'] }

      it 'prints that cop and nothing else' do
        expect(stdout).to match(
          ['# Supports --auto-correct',
           'Layout/IndentationStyle:',
           '  Description: Consistent indentation either with tabs only or spaces only.',
           /^  StyleGuide: ('|")#spaces-indentation('|")$/,
           '  Enabled: true',
           /^  VersionAdded: '[0-9.]+'$/,
           /^  VersionChanged: '[0-9.]+'$/,
           '  IndentationWidth:'].join("\n")
        )
      end

      include_examples 'prints config'
    end

    context 'with two cops given' do
      let(:arguments) { ['Layout/IndentationStyle,Layout/LineLength'] }

      include_examples 'prints config'
    end

    context 'with one of the cops misspelled' do
      let(:arguments) { ['Layout/IndentationStyle,Lint/X123'] }

      it 'skips the unknown cop' do
        expect(stdout).to match(
          ['# Supports --auto-correct',
           'Layout/IndentationStyle:',
           '  Description: Consistent indentation either with tabs only or spaces only.',
           /^  StyleGuide: ('|")#spaces-indentation('|")$/,
           '  Enabled: true'].join("\n")
        )
      end
    end

    context 'with --force-default-config' do
      let(:arguments) { ['Layout/LineLength', '--force-default-config'] }

      it 'prioritizes default config' do
        expect(YAML.safe_load(stdout)['Layout/LineLength']['Max']).to eq(120)
      end
    end
  end

  describe '-f/--format' do
    let(:target_file) { 'example.rb' }

    before { create_file(target_file, '#' * 130) }

    describe 'builtin formatters' do
      context 'when simple format is specified' do
        it 'outputs with simple format' do
          cli.run(['--format', 'simple', 'example.rb'])
          expect($stdout.string)
            .to include(<<~RESULT)
              == #{target_file} ==
              C:  1:  1: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
              C:  1:121: Layout/LineLength: Line is too long. [130/120]

              1 file inspected, 2 offenses detected, 1 offense auto-correctable
            RESULT
        end
      end

      %w[html json].each do |format|
        context "when #{format} format is specified" do
          context 'and offenses come from the cache' do
            context 'and a message has binary encoding' do
              let(:message_from_cache) do
                (+'Cyclomatic complexity for 文 is too high. [8/6]')
                  .force_encoding('ASCII-8BIT')
              end
              let(:data_from_cache) do
                [
                  {
                    'severity' => 'convention',
                    'location' => { 'begin_pos' => 18, 'end_pos' => 21 },
                    'message' => message_from_cache,
                    'cop_name' => 'Metrics/CyclomaticComplexity',
                    'status' => 'unsupported'
                  }
                ]
              end

              it "outputs #{format.upcase} code without crashing" do
                create_file('example.rb', <<~RUBY)
                  def 文
                    b if a
                    b if a
                    b if a
                    b if a
                    b if a
                    b if a
                    b if a
                  end
                RUBY
                # Stub out the JSON.load call used by the cache mechanism, so
                # we can test what happens when an offense message has
                # ASCII-8BIT encoding and contains a non-7bit-ascii character.
                allow(JSON).to receive(:load).and_return(data_from_cache)

                2.times do
                  # The second run (and possibly the first) should hit the
                  # cache.
                  expect(cli.run(['--format', format,
                                  '--only', 'Metrics/CyclomaticComplexity']))
                    .to eq(1)
                end
                expect($stderr.string).to eq('')
              end
            end
          end
        end
      end

      context 'when clang format is specified' do
        it 'outputs with clang format' do
          create_file('example1.rb', ['x= 0 ', '#' * 130, 'y ', 'puts x'])
          create_file('example2.rb', <<~RUBY)
            # frozen_string_literal: true

            \tx
            def a
               puts
            end
          RUBY
          create_file('example3.rb', <<~RUBY)
            def badName
              if something
                test
                end
            end
          RUBY
          expect(cli.run(['--format', 'clang', 'example1.rb',
                          'example2.rb', 'example3.rb']))
            .to eq(1)
          expect($stdout.string).to eq([
            'example1.rb:1:1: C: [Correctable] Style/FrozenStringLiteralComment: ' \
            'Missing frozen string literal comment.',
            'x= 0 ',
            '^',
            'example1.rb:1:2: C: [Correctable] Layout/SpaceAroundOperators: ' \
            'Surrounding space missing for operator =.',
            'x= 0 ',
            ' ^',
            'example1.rb:1:5: C: [Correctable] Layout/TrailingWhitespace: ' \
            'Trailing whitespace detected.',
            'x= 0 ',
            '    ^',
            'example1.rb:2:121: C: Layout/LineLength: ' \
            'Line is too long. [130/120]',
            '###################################################' \
            '###################################################' \
            '############################',
            '                                                   ' \
            '                                                   ' \
            '                  ^^^^^^^^^^',
            'example1.rb:3:2: C: [Correctable] Layout/TrailingWhitespace: ' \
            'Trailing whitespace detected.',
            'y ',
            ' ^',
            'example2.rb:1:1: C: [Correctable] Layout/CommentIndentation: ' \
            'Incorrect indentation detected (column 0 instead of 1).',
            '# frozen_string_literal: true',
            '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^',
            'example2.rb:3:1: C: [Correctable] Layout/IndentationStyle: '\
            'Tab detected in indentation.',
            "\tx",
            '^',
            'example2.rb:3:2: C: [Correctable] Layout/InitialIndentation: ' \
            'Indentation of first line in file detected.',
            "\tx",
            ' ^',
            'example2.rb:4:1: C: [Correctable] Layout/IndentationConsistency: ' \
            'Inconsistent indentation detected.',
            'def a ...',
            '^^^^^',
            'example2.rb:5:1: C: [Correctable] Layout/IndentationWidth: ' \
            'Use 2 (not 3) spaces for indentation.',
            '   puts',
            '^^^',
            'example3.rb:1:1: C: [Correctable] Style/FrozenStringLiteralComment: ' \
            'Missing frozen string literal comment.',
            'def badName',
            '^',
            'example3.rb:1:5: C: Naming/MethodName: ' \
            'Use snake_case for method names.',
            'def badName',
            '    ^^^^^^^',
            'example3.rb:2:3: C: Style/GuardClause: ' \
            'Use a guard clause (return unless something) instead of ' \
            'wrapping the code inside a conditional expression.',
            '  if something',
            '  ^^',
            'example3.rb:2:3: C: [Correctable] Style/IfUnlessModifier: ' \
            'Favor modifier if usage when having a single-line body. ' \
            'Another good alternative is the usage of control flow &&/||.',
            '  if something',
            '  ^^',
            'example3.rb:4:5: W: [Correctable] Layout/EndAlignment: ' \
            'end at 4, 4 is not aligned with if at 2, 2.',
            '    end',
            '    ^^^',
            '',
            '3 files inspected, 15 offenses detected, 12 offenses auto-correctable',
            ''
          ].join("\n"))
        end
      end

      context 'when emacs format is specified' do
        it 'outputs with emacs format' do
          create_file('example1.rb', ['# frozen_string_literal: true', '', 'x= 0 ', 'y ', 'puts x'])
          create_file('example2.rb', <<~RUBY)
            # frozen_string_literal: true

            \tx = 0
            puts x
          RUBY
          expect(cli.run(['--format', 'emacs', 'example1.rb', 'example2.rb'])).to eq(1)
          expected_output = <<~RESULT
            #{abs('example1.rb')}:3:2: C: [Correctable] Layout/SpaceAroundOperators: Surrounding space missing for operator `=`.
            #{abs('example1.rb')}:3:5: C: [Correctable] Layout/TrailingWhitespace: Trailing whitespace detected.
            #{abs('example1.rb')}:4:2: C: [Correctable] Layout/TrailingWhitespace: Trailing whitespace detected.
            #{abs('example2.rb')}:1:1: C: [Correctable] Layout/CommentIndentation: Incorrect indentation detected (column 0 instead of 1).
            #{abs('example2.rb')}:3:1: C: [Correctable] Layout/IndentationStyle: Tab detected in indentation.
            #{abs('example2.rb')}:3:2: C: [Correctable] Layout/InitialIndentation: Indentation of first line in file detected.
            #{abs('example2.rb')}:4:1: C: [Correctable] Layout/IndentationConsistency: Inconsistent indentation detected.
          RESULT
          expect($stdout.string).to eq(expected_output)
        end
      end

      context 'when unknown format name is specified' do
        it 'aborts with error message' do
          expect(cli.run(['--format', 'unknown', 'example.rb'])).to eq(2)
          expect($stderr.string).to include('No formatter for "unknown"')
        end
      end
    end

    describe 'custom formatter' do
      let(:target_file) { abs('example.rb') }

      context 'when a class name is specified' do
        it 'uses the class as a formatter' do
          stub_const('MyTool::RuboCopFormatter',
                     Class.new(RuboCop::Formatter::BaseFormatter) do
                       def started(all_files)
                         output.puts "started: #{all_files.join(',')}"
                       end

                       def file_started(file, _options)
                         output.puts "file_started: #{file}"
                       end

                       def file_finished(file, _offenses)
                         output.puts "file_finished: #{file}"
                       end

                       def finished(processed_files)
                         output.puts "finished: #{processed_files.join(',')}"
                       end
                     end)

          cli.run(['--format', 'MyTool::RuboCopFormatter', 'example.rb'])
          expect($stdout.string).to eq(<<~RESULT)
            started: #{target_file}
            file_started: #{target_file}
            file_finished: #{target_file}
            finished: #{target_file}
          RESULT
        end
      end

      context 'when unknown class name is specified' do
        it 'aborts with error message' do
          args = '--format UnknownFormatter example.rb'
          expect(cli.run(args.split)).to eq(2)
          expect($stderr.string).to include('UnknownFormatter')
        end
      end
    end

    it 'can be used multiple times' do
      cli.run(['--format', 'simple', '--format', 'emacs', 'example.rb'])
      expect($stdout.string).to include(<<~RESULT)
        == #{target_file} ==
        C:  1:  1: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
        C:  1:121: Layout/LineLength: Line is too long. [130/120]
        #{abs(target_file)}:1:1: C: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
        #{abs(target_file)}:1:121: C: Layout/LineLength: Line is too long. [130/120]
      RESULT
    end
  end

  describe '-o/--out option' do
    let(:target_file) { 'example.rb' }

    before { create_file(target_file, '#' * 130) }

    it 'redirects output to the specified file' do
      cli.run(['--out', 'output.txt', target_file])
      expect(File.read('output.txt')).to include('Line is too long.')
    end

    it 'is applied to the previously specified formatter' do
      cli.run(['--format', 'simple', '--format', 'emacs', '--out', 'emacs_output.txt', target_file])

      expect($stdout.string).to eq(<<~RESULT)
        == #{target_file} ==
        C:  1:  1: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
        C:  1:121: Layout/LineLength: Line is too long. [130/120]

        1 file inspected, 2 offenses detected, 1 offense auto-correctable
      RESULT

      expect(File.read('emacs_output.txt'))
        .to eq(<<~RESULT)
          #{abs(target_file)}:1:1: C: [Correctable] Style/FrozenStringLiteralComment: Missing frozen string literal comment.
          #{abs(target_file)}:1:121: C: Layout/LineLength: Line is too long. [130/120]
      RESULT
    end
  end

  describe '--fail-level option' do
    let(:target_file) { 'example.rb' }

    before do
      create_file(target_file, <<~RUBY)
        def f
         x
        end
      RUBY
    end

    def expect_offense_detected
      expect($stderr.string).to eq('')
      expect($stdout.string).to include('1 file inspected, 1 offense detected')
      expect($stdout.string).to include 'Layout/IndentationWidth'
    end

    it 'fails when option is less than the severity level' do
      expect(cli.run(['--fail-level', 'refactor',
                      '--only', 'Layout/IndentationWidth',
                      target_file])).to eq(1)
      expect(cli.run(['--fail-level', 'autocorrect', target_file])).to eq(1)
      expect_offense_detected
    end

    it 'fails when option is equal to the severity level' do
      expect(cli.run(['--fail-level', 'convention',
                      '--only', 'Layout/IndentationWidth',
                      target_file])).to eq(1)
      expect_offense_detected
    end

    it 'succeeds when option is greater than the severity level' do
      expect(cli.run(['--fail-level', 'warning',
                      '--only', 'Layout/IndentationWidth',
                      target_file])).to eq(0)
      expect_offense_detected
    end

    context 'with --display-only-fail-level-offenses' do
      it 'outputs offense message when fail-level is less than the severity' do
        expect(cli.run(['--fail-level', 'refactor',
                        '--display-only-fail-level-offenses',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq(1)
        expect(cli.run(['--fail-level', 'autocorrect',
                        '--display-only-fail-level-offenses',
                        target_file])).to eq(1)
        expect_offense_detected
      end

      it 'outputs offense message when fail-level is equal to the severity' do
        expect(cli.run(['--fail-level', 'convention',
                        '--display-only-fail-level-offenses',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq(1)
        expect_offense_detected
      end

      it "doesn't output offense message when less than the fail-level" do
        expect(cli.run(['--fail-level', 'warning',
                        '--display-only-fail-level-offenses',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq 0
        expect($stderr.string).to eq('')
        expect($stdout.string).to include('1 file inspected, no offenses detected')
        expect($stdout.string).not_to include 'Layout/IndentationWidth'
      end

      context 'with disabled line' do
        it "doesn't consider a unprinted offense to be a redundant disable" do
          create_file(target_file, <<~RUBY)
            def f
             x # rubocop:disable Layout/IndentationWidth
            end
          RUBY

          expect(cli.run(['--fail-level', 'warning',
                          '--display-only-fail-level-offenses',
                          target_file])).to eq 0
          expect($stderr.string).to eq('')
          expect($stdout.string).to include('1 file inspected, no offenses detected')
          expect($stdout.string).not_to include 'Layout/IndentationWidth'
          expect($stdout.string).not_to include 'Lint/RedundantCopDisableDirective'
        end

        it "still checks unprinted offense if they're a redundant disable" do
          create_file(target_file, <<~RUBY)
            def f
              x # rubocop:disable Layout/IndentationWidth
            end
          RUBY

          expect(cli.run(['--fail-level', 'warning',
                          '--display-only-fail-level-offenses',
                          target_file])).to eq 1
          expect($stderr.string).to eq('')
          expect($stdout.string).to include('1 file inspected, 1 offense detected')
          expect($stdout.string).to include 'RedundantCopDisableDirective'
        end
      end
    end

    context 'with --auto-correct-all' do
      def expect_auto_corrected
        expect_offense_detected
        expect($stdout.string.lines.to_a.last)
          .to eq('1 file inspected, 1 offense detected, ' \
                 "1 offense corrected\n")
      end

      it 'fails when option is autocorrect and all offenses are autocorrected' do
        expect(cli.run(['--auto-correct-all', '--format', 'simple',
                        '--fail-level', 'autocorrect',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq(1)
        expect_auto_corrected
      end

      it 'fails when option is A and all offenses are autocorrected' do
        expect(cli.run(['--auto-correct-all', '--format', 'simple',
                        '--fail-level', 'A',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq(1)
        expect_auto_corrected
      end

      it 'succeeds when option is not given and all offenses are autocorrected' do
        expect(cli.run(['--auto-correct-all', '--format', 'simple',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq(0)
        expect_auto_corrected
      end

      it 'succeeds when option is refactor and all offenses are autocorrected' do
        expect(cli.run(['--auto-correct-all', '--format', 'simple',
                        '--fail-level', 'refactor',
                        '--only', 'Layout/IndentationWidth',
                        target_file])).to eq(0)
        expect_auto_corrected
      end
    end
  end

  describe 'with --auto-correct-all and disabled offense' do
    let(:target_file) { 'example.rb' }

    before do
      create_file('.rubocop.yml', <<~YAML)
        Style/FrozenStringLiteralComment:
          Enabled: false
      YAML
    end

    it 'succeeds when there is only a disabled offense' do
      create_file(target_file, <<~RUBY)
        def f
         x # rubocop:disable Layout/IndentationWidth
        end
      RUBY

      expect(cli.run(['--auto-correct-all', '--format', 'simple',
                      '--fail-level', 'autocorrect',
                      target_file])).to eq(0)

      expect($stdout.string.lines.to_a.last).to eq("1 file inspected, no offenses detected\n")
    end
  end

  describe 'with --auto-correct' do
    let(:target_file) { 'example.rb' }

    context 'all offenses are corrected' do
      before do
        create_file('.rubocop.yml', <<~YAML)
          Style/FrozenStringLiteralComment:
            Enabled: false
        YAML
      end

      it 'succeeds when there is only a disabled offense' do
        create_file(target_file, <<~RUBY)
          a = "Hello"
        RUBY

        expect(cli.run(['--auto-correct', '--format', 'simple', target_file])).to eq(1)

        expect($stdout.string.lines.to_a.last)
          .to eq('1 file inspected, 2 offenses detected, 1 offense corrected' \
                 "\n")
      end
    end

    context 'no offense corrected, 1 offense auto-correctable' do
      it 'succeeds when there is only a disabled offense' do
        create_file(target_file, <<~RUBY)
          a = 'Hello'.freeze
          puts a
        RUBY

        expect(cli.run(['--auto-correct', '--format', 'simple', target_file])).to eq(1)

        expect($stdout.string.lines.to_a.last).to eq(
          '1 file inspected, 1 offense detected, 1 more offense '\
          "can be corrected with `rubocop -A`\n"
        )
      end
    end

    context 'a offense corrected, a offense auto-correctable' do
      it 'succeeds when there is only a disabled offense' do
        create_file(target_file, <<~RUBY)
          a = "Hello".freeze
          puts a
        RUBY

        expect(cli.run(['--auto-correct', '--format', 'simple', target_file])).to eq(1)

        expect($stdout.string.lines.to_a.last).to eq(
          '1 file inspected, 2 offenses detected, 1 offense corrected, 1 more offense '\
          "can be corrected with `rubocop -A`\n"
        )
      end
    end

    context 'when setting `AutoCorrect: false` for `Style/StringLiterals`' do
      before do
        create_file('.rubocop.yml', <<~YAML)
          Style/StringLiterals:
            AutoCorrect: false
        YAML
      end

      it 'does not suggest `1 more offense can be corrected with `rubocop -A` for `Style/StringLiterals`' do
        create_file(target_file, <<~RUBY)
          # frozen_string_literal: true

          a = "Hello"
        RUBY

        expect(cli.run(['--auto-correct', '--format', 'simple', target_file])).to eq(1)
        expect($stdout.string.lines.to_a.last).to eq("1 file inspected, 2 offenses detected\n")
      end
    end
  end

  describe '--force-exclusion' do
    context 'when explicitly excluded' do
      let(:target_file) { 'example.rb' }

      before do
        create_file(target_file, '#' * 130)

        create_file('.rubocop.yml', <<~YAML)
          AllCops:
            Exclude:
              - #{target_file}
        YAML
      end

      it 'excludes files specified in the configuration Exclude ' \
         'even if they are explicitly passed as arguments' do
        expect(cli.run(['--force-exclusion', target_file])).to eq(0)
      end
    end

    context 'with already excluded by default' do
      let(:target_file) { 'TODO.md' }

      before { create_file(target_file, '- one') }

      it 'excludes files excluded by default even if they are explicitly passed as arguments' do
        expect(cli.run(['--force-exclusion', target_file])).to eq(0)
      end
    end
  end

  describe '--only-recognized-file-types' do
    let(:target_file) { 'example.something' }
    let(:exit_code) { cli.run(['--only-recognized-file-types', target_file]) }

    before { create_file(target_file, '#' * 130) }

    context 'when explicitly included' do
      before do
        create_file('.rubocop.yml', <<~YAML)
          AllCops:
            Include:
              - #{target_file}
        YAML
      end

      it 'includes the file given on the command line' do
        expect(exit_code).to eq(1)
      end
    end

    context 'when not explicitly included' do
      it 'does not include the file given on the command line' do
        expect(exit_code).to eq(0)
      end

      context 'but option is not given' do
        it 'includes the file given on the command line' do
          expect(cli.run([target_file])).to eq(1)
        end
      end
    end
  end

  describe '--stdin' do
    it 'causes source code to be read from stdin' do
      $stdin = StringIO.new('p $/')
      argv   = ['--only=Style/SpecialGlobalVars', '--format=simple', '--stdin', 'fake.rb']
      expect(cli.run(argv)).to eq(1)
      expect($stdout.string).to eq(<<~RESULT)
        == fake.rb ==
        C:  1:  3: [Correctable] Style/SpecialGlobalVars: Prefer $INPUT_RECORD_SEPARATOR or $RS from the stdlib 'English' module (don't forget to require it) over $/.

        1 file inspected, 1 offense detected, 1 offense auto-correctable
      RESULT
    ensure
      $stdin = STDIN
    end

    it 'requires a file path' do
      $stdin = StringIO.new('p $/')
      argv   = ['--only=Style/SpecialGlobalVars', '--format=simple', '--stdin']
      expect(cli.run(argv)).to eq(2)
      expect($stderr.string).to include('missing argument: --stdin')
    ensure
      $stdin = STDIN
    end

    it 'does not accept more than one file path' do
      $stdin = StringIO.new('p $/')
      argv   = ['--only=Style/SpecialGlobalVars',
                '--format=simple',
                '--stdin',
                'fake1.rb',
                'fake2.rb']
      expect(cli.run(argv)).to eq(2)
      expect($stderr.string).to include('-s/--stdin requires exactly one path')
    ensure
      $stdin = STDIN
    end

    it 'prints corrected code to stdout if --auto-correct-all is used' do
      $stdin = StringIO.new('p $/')
      argv   = ['--auto-correct-all',
                '--only=Style/SpecialGlobalVars',
                '--format=simple',
                '--stdin',
                'fake.rb']
      expect(cli.run(argv)).to eq(0)
      expect($stdout.string).to eq(<<~RESULT.chomp)
        == fake.rb ==
        C:  1:  3: [Corrected] Style/SpecialGlobalVars: Prefer $INPUT_RECORD_SEPARATOR or $RS from the stdlib 'English' module (don't forget to require it) over $/.

        1 file inspected, 1 offense detected, 1 offense corrected
        ====================
        require 'English'
        p $INPUT_RECORD_SEPARATOR
      RESULT
    ensure
      $stdin = STDIN
    end

    it 'prints offense reports to stderr and corrected code to stdout if --auto-correct-all and --stderr are used' do
      $stdin = StringIO.new('p $/')
      argv   = ['--auto-correct-all',
                '--only=Style/SpecialGlobalVars',
                '--format=simple',
                '--stderr',
                '--stdin',
                'fake.rb']
      expect(cli.run(argv)).to eq(0)
      expect($stderr.string).to eq(<<~RESULT)
        == fake.rb ==
        C:  1:  3: [Corrected] Style/SpecialGlobalVars: Prefer $INPUT_RECORD_SEPARATOR or $RS from the stdlib 'English' module (don't forget to require it) over $/.

        1 file inspected, 1 offense detected, 1 offense corrected
        ====================
      RESULT
      expect($stdout.string).to eq(<<~RESULT.chomp)
        require 'English'
        p $INPUT_RECORD_SEPARATOR
      RESULT
    ensure
      $stdin = STDIN
    end

    it 'can parse JSON result when specifying `--format=json` and `--stdin` options' do
      $stdin = StringIO.new('p $/')
      argv   = ['--auto-correct-all',
                '--only=Style/SpecialGlobalVars',
                '--format=json',
                '--stdin',
                'fake.rb']
      expect(cli.run(argv)).to eq(0)
      expect { JSON.parse($stdout.string) }.not_to raise_error(JSON::ParserError)
    ensure
      $stdin = STDIN
    end

    it 'can parse JSON result when specifying `--format=j` and `--stdin` options' do
      $stdin = StringIO.new('p $/')
      argv   = ['--auto-correct-all',
                '--only=Style/SpecialGlobalVars',
                '--format=j',
                '--stdin',
                'fake.rb']
      expect(cli.run(argv)).to eq(0)
      expect { JSON.parse($stdout.string) }.not_to raise_error(JSON::ParserError)
    ensure
      $stdin = STDIN
    end

    it 'detects CR at end of line' do
      create_file('example.rb', "puts 'hello world'\r")
      # Make Style/EndOfLine give same output regardless of platform.
      create_file('.rubocop.yml', <<~YAML)
        Layout/EndOfLine:
          EnforcedStyle: lf
      YAML
      File.open('example.rb') do |file|
        # We must use a File object to simulate the behavior of
        # STDIN, which is an IO object. StringIO won't do in this
        # case, as its read() method doesn't handle line endings the
        # same way IO#read() does.
        $stdin = file
        argv = ['--only=Layout/EndOfLine', '--format=simple', '--stdin', 'fake.rb']
        expect(cli.run(argv)).to eq(1)
        expect($stdout.string)
          .to eq(<<~RESULT)
            == fake.rb ==
            C:  1:  1: Layout/EndOfLine: Carriage return character detected.

            1 file inspected, 1 offense detected
          RESULT
      end
    ensure
      $stdin = STDIN
    end
  end

  describe '--require', :restore_registry do
    context 'when adding an extension' do
      before do
        create_file('.rubocop.yml', <<~YAML)
          Rails/NotNullColumn:
            Enabled: false
        YAML

        create_file('rubocop-rails.rb', <<~RUBY)
          module RuboCop
            module Cop
              module Rails
                class NotNullColumn < Base
                end
              end
            end
          end
        RUBY

        # Add the temporary dir to the load path so that the fake extension
        # can be found.
        $LOAD_PATH.unshift(File.dirname('rubocop-rails.rb'))

        RuboCop::ConfigLoader.clear_options
      end

      it 'does not show an obsoletion error' do
        opts = ['--format', 'simple', '--require', 'rubocop-rails', '--only', 'Rails']

        expect(cli.run(opts)).to eq(0)
        expect(RuboCop::ConfigLoader.loaded_features).to contain_exactly('rubocop-rails')
        expect($stdout.string.strip).to eq('1 file inspected, no offenses detected')
        expect($stderr.string).to eq('')
      end
    end
  end

  describe 'option is invalid' do
    it 'suggests to use the --help flag' do
      invalid_option = '--invalid-option'

      expect(cli.run([invalid_option])).to eq(2)
      expect($stderr.string).to eq(<<~RESULT)
        invalid option: #{invalid_option}
        For usage information, use --help
      RESULT
    end
  end
end
