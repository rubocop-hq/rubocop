# frozen_string_literal: true

RSpec.describe RuboCop::ConfigLoader do
  include FileHelper

  include_context 'cli spec behavior'

  before do
    described_class.debug = true
    # Force reload of default configuration
    described_class.default_configuration = nil
  end

  after do
    described_class.debug = false
    # Remove custom configuration
    described_class.default_configuration = nil
  end

  let(:default_config) { described_class.default_configuration }

  describe '.configuration_file_for', :isolated_environment do
    subject(:configuration_file_for) { described_class.configuration_file_for(dir_path) }

    context 'when no config file exists in ancestor directories' do
      let(:dir_path) { 'dir' }

      before { create_empty_file('dir/example.rb') }

      context 'but a config file exists in home directory' do
        before { create_empty_file('~/.rubocop.yml') }

        it 'returns the path to the file in home directory' do
          expect(configuration_file_for).to end_with('home/.rubocop.yml')
        end
      end

      context 'but a config file exists in default XDG config directory' do
        before { create_empty_file('~/.config/rubocop/config.yml') }

        it 'returns the path to the file in XDG directory' do
          expect(configuration_file_for).to end_with('home/.config/rubocop/config.yml')
        end
      end

      context 'but a config file exists in a custom XDG config directory' do
        before do
          ENV['XDG_CONFIG_HOME'] = '~/xdg-stuff'
          create_empty_file('~/xdg-stuff/rubocop/config.yml')
        end

        it 'returns the path to the file in XDG directory' do
          expect(configuration_file_for).to end_with('home/xdg-stuff/rubocop/config.yml')
        end
      end

      context 'but a config file exists in both home and XDG directories' do
        before do
          create_empty_file('~/.config/rubocop/config.yml')
          create_empty_file('~/.rubocop.yml')
        end

        it 'returns the path to the file in home directory' do
          expect(configuration_file_for).to end_with('home/.rubocop.yml')
        end
      end

      context 'and no config file exists in home or XDG directory' do
        it 'falls back to the provided default file' do
          expect(configuration_file_for).to end_with('config/default.yml')
        end
      end

      context 'and ENV has no `HOME` defined' do
        before { ENV.delete 'HOME' }

        it 'falls back to the provided default file' do
          expect(configuration_file_for).to end_with('config/default.yml')
        end
      end
    end

    context 'when there is a spurious rubocop config outside of the project', root: 'dir' do
      let(:dir_path) { 'dir' }

      before do
        # Force reload of project root
        described_class.project_root = nil
        create_empty_file('Gemfile')
        create_empty_file('../.rubocop.yml')
      end

      after do
        # Don't leak project root change
        described_class.project_root = nil
      end

      it 'ignores the spurious config and falls back to the provided default file if run from the project' do
        expect(configuration_file_for).to end_with('config/default.yml')
      end
    end

    context 'when a config file exists in the parent directory' do
      let(:dir_path) { 'dir' }

      before do
        create_empty_file('dir/example.rb')
        create_empty_file('.rubocop.yml')
      end

      it 'returns the path to that configuration file' do
        expect(configuration_file_for).to end_with('work/.rubocop.yml')
      end
    end

    context 'when multiple config files exist in ancestor directories' do
      let(:dir_path) { 'dir' }

      before do
        create_empty_file('dir/example.rb')
        create_empty_file('dir/.rubocop.yml')
        create_empty_file('.rubocop.yml')
      end

      it 'prefers closer config file' do
        expect(configuration_file_for).to end_with('dir/.rubocop.yml')
      end
    end
  end

  describe '.configuration_from_file', :isolated_environment do
    subject(:configuration_from_file) { described_class.configuration_from_file(file_path) }

    context 'with any config file' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file(file_path, <<~YAML)
          Style/Encoding:
            Enabled: false
        YAML
      end

      it 'returns a configuration inheriting from default.yml' do
        config = default_config['Style/Encoding'].dup
        config['Enabled'] = false
        expect(configuration_from_file.to_h)
          .to eql(default_config.merge('Style/Encoding' => config))
      end
    end

    context 'when multiple config files exist in ancestor directories' do
      let(:file_path) { 'dir/.rubocop.yml' }

      before do
        create_file('.rubocop.yml', <<~YAML)
          AllCops:
            Exclude:
              - vendor/**
        YAML

        create_file(file_path, <<~YAML)
          AllCops:
            Exclude: []
        YAML
      end

      it 'gets AllCops/Exclude from the highest directory level' do
        excludes = configuration_from_file['AllCops']['Exclude']
        expect(excludes).to eq([File.expand_path('vendor/**')])
      end

      context 'and there is a personal config file in the home folder' do
        before do
          create_file('~/.rubocop.yml', <<~YAML)
            AllCops:
              Exclude:
                - tmp/**
          YAML
        end

        it 'ignores personal AllCops/Exclude' do
          excludes = configuration_from_file['AllCops']['Exclude']
          expect(excludes).to eq([File.expand_path('vendor/**')])
        end
      end
    end

    context 'when configuration has a custom name' do
      let(:file_path) { '.custom_rubocop.yml' }

      before do
        create_file(file_path, <<~YAML)
          AllCops:
            Exclude:
              - vendor/**
        YAML
      end

      context 'and there is a personal config file in the home folder' do
        before do
          create_file('~/.rubocop.yml', <<~YAML)
            AllCops:
              Exclude:
                - tmp/**
          YAML
        end

        it 'ignores personal AllCops/Exclude' do
          excludes = configuration_from_file['AllCops']['Exclude']
          expect(excludes).to eq([File.expand_path('vendor/**')])
        end
      end
    end

    context 'when project has a Gemfile', :project_inside_home do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_empty_file('Gemfile')

        create_file(file_path, <<~YAML)
          AllCops:
            Exclude:
              - vendor/**
        YAML
      end

      context 'and there is a personal config file in the home folder' do
        before do
          create_file('~/.rubocop.yml', <<~YAML)
            AllCops:
              Exclude:
                - tmp/**
          YAML
        end

        it 'ignores personal AllCops/Exclude' do
          excludes = configuration_from_file['AllCops']['Exclude']
          expect(excludes).to eq([File.expand_path('vendor/**')])
        end
      end
    end

    context 'when a parent file specifies DisabledByDefault: true' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file('disable.yml', <<~YAML)
          AllCops:
            DisabledByDefault: true
        YAML

        create_file(file_path, ['inherit_from: disable.yml'])
      end

      it 'disables cops by default' do
        cop_options = configuration_from_file['Style/Alias']
        expect(cop_options.fetch('Enabled')).to be(false)
      end
    end

    context 'when a file inherits from a parent file' do
      let(:file_path) { 'dir/.rubocop.yml' }

      before do
        create_file('.rubocop.yml', <<~YAML)
          AllCops:
            Exclude:
              - vendor/**
              - !ruby/regexp /[A-Z]/
          Style/StringLiterals:
            Include:
              - dir/**/*.rb
        YAML

        create_file(file_path, ['inherit_from: ../.rubocop.yml'])
      end

      it 'gets an absolute AllCops/Exclude' do
        excludes = configuration_from_file['AllCops']['Exclude']
        expect(excludes).to eq([File.expand_path('vendor/**'), /[A-Z]/])
      end

      it 'gets an Include that is relative to the subdirectory' do
        expect(configuration_from_file['Style/StringLiterals']['Include']).to eq(['**/*.rb'])
      end

      it 'ignores parent AllCops/Exclude if ignore_parent_exclusion is true' do
        sub_file_path = 'vendor/.rubocop.yml'
        create_file(sub_file_path, <<~YAML)
          AllCops:
            Exclude:
              - 'foo'
        YAML
        # dup the class so that setting ignore_parent_exclusion doesn't
        # interfere with other specs
        config_loader = described_class.dup
        config_loader.ignore_parent_exclusion = true

        configuration = config_loader.configuration_from_file(sub_file_path)
        excludes = configuration['AllCops']['Exclude']
        expect(excludes).not_to include(File.expand_path('vendor/**'))
        expect(excludes).to include(File.expand_path('vendor/foo'))
      end
    end

    context 'when a file inherits from an empty parent file' do
      let(:file_path) { 'dir/.rubocop.yml' }

      before do
        create_file('.rubocop.yml', [''])

        create_file(file_path, ['inherit_from: ../.rubocop.yml'])
      end

      it 'does not fail to load' do
        expect { configuration_from_file }.not_to raise_error
      end
    end

    context 'when a file inherits from a sibling file' do
      let(:file_path) { 'dir/.rubocop.yml' }

      before do
        create_file('src/.rubocop.yml', <<~YAML)
          AllCops:
            Exclude:
              - vendor/**
          Style/StringLiterals:
            Include:
              - '**/*.rb'
        YAML

        create_file(file_path, ['inherit_from: ../src/.rubocop.yml'])
      end

      it 'gets an absolute AllCops/Exclude' do
        excludes = configuration_from_file['AllCops']['Exclude']
        expect(excludes).to eq([File.expand_path('src/vendor/**')])
      end

      it 'gets an Include that is relative to the subdirectory' do
        expect(configuration_from_file['Style/StringLiterals']['Include']).to eq(['../src/**/*.rb'])
      end
    end

    context 'when a file inherits and overrides an Exclude' do
      let(:file_path) { '.rubocop.yml' }
      let(:message) do
        '.rubocop.yml: Style/For:Exclude overrides the same parameter in ' \
          '.rubocop_2.yml'
      end

      before do
        create_file(file_path, <<~YAML)
          inherit_from:
            - .rubocop_1.yml
            - .rubocop_2.yml

          Style/For:
            Exclude:
              - spec/requests/group_invite_spec.rb
        YAML

        create_file('.rubocop_1.yml', <<~YAML)
          Style/StringLiterals:
            Exclude:
              - 'spec/models/group_spec.rb'
        YAML

        create_file('.rubocop_2.yml', <<~YAML)
          Style/For:
            Exclude:
              - 'spec/models/expense_spec.rb'
        YAML
      end

      it 'gets the Exclude overriding the inherited one with a warning' do
        expect do
          excludes = configuration_from_file['Style/For']['Exclude']
          expect(excludes).to eq([File.expand_path('spec/requests/group_invite_spec.rb')])
        end.to output(/#{message}/).to_stdout
      end
    end

    context 'when a file inherits and overrides a hash with nil' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file('.rubocop_parent.yml', <<~YAML)
          Style/InverseMethods:
            InverseMethods:
              :any?: :none?
              :even?: :odd?
              :==: :!=
              :=~: :!~
              :<: :>=
              :>: :<=
        YAML

        create_file('.rubocop.yml', <<~YAML)
          inherit_from: .rubocop_parent.yml

          Style/InverseMethods:
            InverseMethods:
              :<: ~
              :>: ~
              :foo: :bar
        YAML
      end

      it 'removes hash keys with nil values' do
        inverse_methods = configuration_from_file['Style/InverseMethods']['InverseMethods']
        expect(inverse_methods).to eq('==': :!=, '=~': :!~, any?: :none?, even?: :odd?, foo: :bar)
      end
    end

    context 'when inherit_mode is set to merge for Exclude' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file(file_path, <<~YAML)
          inherit_from: .rubocop_parent.yml
          inherit_mode:
            merge:
              - Exclude
          AllCops:
            Exclude:
              - spec/requests/expense_spec.rb
          Style/For:
            Exclude:
              - spec/requests/group_invite_spec.rb
          Style/Documentation:
            Include:
              - extra/*.rb
            Exclude:
              - junk/*.rb
        YAML

        create_file('.rubocop_parent.yml', <<~YAML)
          Style/For:
            Exclude:
              - 'spec/models/expense_spec.rb'
              - 'spec/models/group_spec.rb'
          Style/Documentation:
            inherit_mode:
              merge:
                - Exclude
            Exclude:
              - funk/*.rb
        YAML
      end

      it 'unions the two lists of Excludes from the parent and child configs ' \
         'and does not output a warning' do
        expect do
          excludes = configuration_from_file['Style/For']['Exclude']
          expect(excludes.sort)
            .to eq([File.expand_path('spec/requests/group_invite_spec.rb'),
                    File.expand_path('spec/models/expense_spec.rb'),
                    File.expand_path('spec/models/group_spec.rb')].sort)
        end.not_to output(/overrides the same parameter/).to_stdout
      end

      it 'merges AllCops:Exclude with the default configuration' do
        expect(configuration_from_file['AllCops']['Exclude'].sort)
          .to eq(([File.expand_path('spec/requests/expense_spec.rb')] +
                  default_config['AllCops']['Exclude']).sort)
      end

      it 'merges Style/Documentation:Exclude with parent and default configuration' do
        expect(configuration_from_file['Style/Documentation']['Exclude'].sort)
          .to eq(([File.expand_path('funk/*.rb'),
                   File.expand_path('junk/*.rb')] +
                  default_config['Style/Documentation']['Exclude']).sort)
      end

      it 'overrides Style/Documentation:Include' do
        expect(configuration_from_file['Style/Documentation']['Include'].sort)
          .to eq(['extra/*.rb'].sort)
      end
    end

    context 'when inherit_mode overrides the global inherit_mode setting' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file(file_path, <<~YAML)
          inherit_from: .rubocop_parent.yml
          inherit_mode:
            merge:
              - Exclude

          Style/For:
            Exclude:
              - spec/requests/group_invite_spec.rb

          Style/Dir:
            inherit_mode:
              override:
                - Exclude
            Exclude:
              - spec/requests/group_invite_spec.rb

        YAML

        create_file('.rubocop_parent.yml', <<~YAML)
          Style/For:
            Exclude:
              - 'spec/models/expense_spec.rb'
              - 'spec/models/group_spec.rb'

          Style/Dir:
            Exclude:
              - 'spec/models/expense_spec.rb'
              - 'spec/models/group_spec.rb'
        YAML
      end

      it 'unions the two lists of Excludes from the parent and child configs ' \
         'for cops that do not override the inherit_mode' do
        expect do
          excludes = configuration_from_file['Style/For']['Exclude']
          expect(excludes.sort)
            .to eq([File.expand_path('spec/requests/group_invite_spec.rb'),
                    File.expand_path('spec/models/expense_spec.rb'),
                    File.expand_path('spec/models/group_spec.rb')].sort)
        end.not_to output(/overrides the same parameter/).to_stdout
      end

      it 'overwrites the Exclude from the parent when the cop overridesthe global inherit_mode' do
        expect do
          excludes = configuration_from_file['Style/Dir']['Exclude']
          expect(excludes).to eq([File.expand_path('spec/requests/group_invite_spec.rb')])
        end.not_to output(/overrides the same parameter/).to_stdout
      end
    end

    context 'when a department is disabled', :restore_registry do
      let(:file_path) { '.rubocop.yml' }

      shared_examples 'resolves enabled/disabled for all ' \
                      'cops' do |enabled_by_default, disabled_by_default, custom_dept_to_disable|
        before { stub_cop_class('RuboCop::Cop::Foo::Bar::Baz') }

        it "handles EnabledByDefault: #{enabled_by_default}, " \
           "DisabledByDefault: #{disabled_by_default} with disabled #{custom_dept_to_disable}" do
          create_file('grandparent_rubocop.yml', <<~YAML)
            Naming/FileName:
              Enabled: pending

            Metrics/AbcSize:
              Enabled: true

            Metrics/PerceivedComplexity:
              Enabled: true

            Lint:
              Enabled: false

            Foo/Bar/Baz:
              Enabled: true
          YAML
          create_file('parent_rubocop.yml', <<~YAML)
            inherit_from: grandparent_rubocop.yml

            Metrics:
              Enabled: false

            Metrics/AbcSize:
              Enabled: false

            Naming:
              Enabled: false

            #{custom_dept_to_disable}:
              Enabled: false
          YAML
          create_file(file_path, <<~YAML)
            inherit_from: parent_rubocop.yml

            AllCops:
              EnabledByDefault: #{enabled_by_default}
              DisabledByDefault: #{disabled_by_default}

            Style:
              Enabled: false

            Metrics/MethodLength:
              Enabled: true

            Metrics/ClassLength:
              Enabled: false

            Lint/RaiseException:
              Enabled: true

            Style/AndOr:
              Enabled: true
          YAML

          def enabled?(cop)
            configuration_from_file.for_cop(cop)['Enabled']
          end

          if custom_dept_to_disable == 'Foo'
            message = <<~'OUTPUT'.chomp
              unrecognized cop or department Foo found in parent_rubocop.yml
              Foo is not a department. Use `Foo/Bar`.
            OUTPUT
            expect { enabled?('Foo/Bar/Baz') }.to raise_error(RuboCop::ValidationError, message)
            next
          end

          # Department disabled in parent config, cop enabled in child.
          expect(enabled?('Metrics/MethodLength')).to be(true)

          # Department disabled in parent config, cop disabled in child.
          expect(enabled?('Metrics/ClassLength')).to be(false)

          # Enabled in grandparent config, disabled in parent.
          expect(enabled?('Metrics/AbcSize')).to be(false)

          # Enabled in grandparent config, department disabled in parent.
          expect(enabled?('Metrics/PerceivedComplexity')).to be(false)

          # Pending in grandparent config, department disabled in parent.
          expect(enabled?('Naming/FileName')).to be(false)

          # Department disabled in child config.
          expect(enabled?('Style/Alias')).to be(false)

          # Department disabled in child config, cop enabled in child.
          expect(enabled?('Style/AndOr')).to be(true)

          # Department disabled in grandparent, cop enabled in child config.
          expect(enabled?('Lint/RaiseException')).to be(true)

          # Cop enabled in grandparent, nested department disabled in parent.
          expect(enabled?('Foo/Bar/Baz')).to be(false)

          # Cop with similar prefix to disabled nested department.
          expect(enabled?('Foo/BarBaz')).to eq(!disabled_by_default)

          # Cop enabled in default config, department disabled in grandparent.
          expect(enabled?('Lint/StructNewOverride')).to be(false)

          # Cop enabled in default config, but not mentioned in user config.
          expect(enabled?('Bundler/DuplicatedGem')).to eq(!disabled_by_default)
        end
      end

      include_examples 'resolves enabled/disabled for all cops', false, false, 'Foo/Bar'
      include_examples 'resolves enabled/disabled for all cops', false, true, 'Foo/Bar'
      include_examples 'resolves enabled/disabled for all cops', true, false, 'Foo/Bar'
      include_examples 'resolves enabled/disabled for all cops', false, false, 'Foo'
    end

    context 'when a third party require defines a new gem', :restore_registry do
      context 'when the gem is not loaded' do
        before do
          create_file('.rubocop.yml', <<~YAML)
            Custom/Loop:
              Enabled: false
          YAML
        end

        it 'emits a warning' do
          expect { described_class.configuration_from_file('.rubocop.yml') }
            .to output(
              a_string_including(
                '.rubocop.yml: Custom/Loop has the ' \
                "wrong namespace - should be Lint\n"
              )
            ).to_stderr
        end
      end

      context 'when the gem is loaded' do
        before do
          create_file('third_party/gem.rb', <<~RUBY)
            module RuboCop
              module Cop
                module Custom
                  class Loop < Cop
                  end
                end
              end
            end
          RUBY

          create_file('.rubocop_with_require.yml', <<~YAML)
            require: ./third_party/gem
            Custom/Loop:
              Enabled: false
          YAML
        end

        it 'does not emit a warning' do
          expect do
            described_class.configuration_from_file('.rubocop_with_require.yml')
          end.not_to output.to_stderr
        end
      end
    end

    context 'when a file inherits from a parent and grandparent file' do
      let(:file_path) { 'dir/subdir/.rubocop.yml' }

      before do
        create_empty_file('dir/subdir/example.rb')

        create_file('.rubocop.yml', <<~YAML)
          Layout/LineLength:
            Enabled: false
            Max: 77
        YAML

        create_file('dir/.rubocop.yml', <<~YAML)
          inherit_from: ../.rubocop.yml

          Metrics/MethodLength:
            Enabled: true
            CountComments: false
            Max: 10
        YAML

        create_file(file_path, <<~YAML)
          inherit_from: ../.rubocop.yml

          Layout/LineLength:
            Enabled: true

          Metrics/MethodLength:
            Max: 5
        YAML
      end

      it 'returns the ancestor configuration plus local overrides' do
        config =
          default_config.merge(
            'Layout/LineLength' => {
              'Description' =>
              default_config['Layout/LineLength']['Description'],
              'StyleGuide' => '#max-line-length',
              'Enabled' => true,
              'VersionAdded' =>
              default_config['Layout/LineLength']['VersionAdded'],
              'VersionChanged' =>
              default_config['Layout/LineLength']['VersionChanged'],
              'AutoCorrect' => true,
              'Max' => 77,
              'AllowHeredoc' => true,
              'AllowURI' => true,
              'URISchemes' => %w[http https],
              'IgnoreCopDirectives' => true,
              'IgnoredPatterns' => []
            },
            'Metrics/MethodLength' => {
              'Description' =>
              default_config['Metrics/MethodLength']['Description'],
              'StyleGuide' => '#short-methods',
              'Enabled' => true,
              'VersionAdded' =>
              default_config['Metrics/MethodLength']['VersionAdded'],
              'VersionChanged' =>
              default_config['Metrics/MethodLength']['VersionChanged'],
              'CountComments' => false,
              'Max' => 5,
              'CountAsOne' => [],
              'IgnoredMethods' => [],
              'ExcludedMethods' => []
            }
          )
        expect { expect(configuration_from_file.to_h).to eq(config) }.to output('').to_stderr
      end
    end

    context 'when a file inherits from two configurations' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_empty_file('example.rb')

        create_file('normal.yml', <<~YAML)
          Metrics/MethodLength:
            Enabled: false
            CountComments: true
            Max: 80
        YAML

        create_file('special.yml', <<~YAML)
          Metrics/MethodLength:
            Enabled: false
            Max: 200
        YAML

        create_file(file_path, <<~YAML)
          inherit_from:
            - normal.yml
            - special.yml

          Metrics/MethodLength:
            Enabled: true
        YAML
      end

      it 'returns values from the last one when possible' do
        expected = { 'Enabled' => true,        # overridden in .rubocop.yml
                     'CountComments' => true,  # only defined in normal.yml
                     'Max' => 200 }            # special.yml takes precedence
        expect do
          expect(configuration_from_file['Metrics/MethodLength']
                   .to_set.superset?(expected.to_set)).to be(true)
        end.to output(Regexp.new(<<~OUTPUT)).to_stdout
          .rubocop.yml: Metrics/MethodLength:Enabled overrides the same parameter in special.yml
          .rubocop.yml: Metrics/MethodLength:Enabled overrides the same parameter in normal.yml
          .rubocop.yml: Metrics/MethodLength:Max overrides the same parameter in normal.yml
        OUTPUT
      end
    end

    context 'when a file inherits and overrides with non-namedspaced cops' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_empty_file('example.rb')

        create_file('line_length.yml', <<~YAML)
          LineLength:
            Max: 120
        YAML

        create_file(file_path, <<~YAML)
          inherit_from:
            - line_length.yml

          LineLength:
            AllowHeredoc: false
        YAML
      end

      it 'returns includes both of the cop changes' do
        config =
          default_config.merge(
            'Layout/LineLength' => {
              'Description' =>
              default_config['Layout/LineLength']['Description'],
              'StyleGuide' => '#max-line-length',
              'Enabled' => true,
              'VersionAdded' =>
              default_config['Layout/LineLength']['VersionAdded'],
              'VersionChanged' =>
              default_config['Layout/LineLength']['VersionChanged'],
              'AutoCorrect' => true,
              'Max' => 120,             # overridden in line_length.yml
              'AllowHeredoc' => false,  # overridden in rubocop.yml
              'AllowURI' => true,
              'URISchemes' => %w[http https],
              'IgnoreCopDirectives' => true,
              'IgnoredPatterns' => []
            }
          )

        expect(configuration_from_file.to_h).to eq(config)
      end
    end

    context 'when a file inherits from an expanded path' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file('~/.rubocop.yml', [''])
        create_file(file_path, ['inherit_from: ~/.rubocop.yml'])
      end

      it 'does not fail to load expanded path' do
        expect { configuration_from_file }.not_to raise_error
      end
    end

    context 'when a file inherits from an unknown gem' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file(file_path, <<~YAML)
          inherit_gem:
            not_a_real_gem: config/rubocop.yml
        YAML
      end

      it 'fails to load' do
        expect { configuration_from_file }.to raise_error(Gem::LoadError)
      end
    end

    context 'when a file inherits from the rubocop gem' do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file(file_path, <<~YAML)
          inherit_gem:
            rubocop: config/default.yml
        YAML
      end

      it 'fails to load' do
        expect { configuration_from_file }.to raise_error(ArgumentError)
      end
    end

    context 'when a file inherits from a known gem' do
      let(:file_path) { '.rubocop.yml' }
      let(:gem_root) { File.expand_path('gems') }

      before do
        create_file("#{gem_root}/gemone/config/rubocop.yml",
                    <<~YAML)
                      Metrics/MethodLength:
                        Enabled: false
                        Max: 200
                        CountComments: false
                    YAML
        create_file("#{gem_root}/gemtwo/config/default.yml",
                    <<~YAML)
                      Layout/LineLength:
                        Enabled: true
                    YAML
        create_file("#{gem_root}/gemtwo/config/strict.yml",
                    <<~YAML)
                      Layout/LineLength:
                        Max: 72
                        AllowHeredoc: false
                    YAML
        create_file('local.yml', <<~YAML)
          Metrics/MethodLength:
            CountComments: true
        YAML
        create_file(file_path, <<~YAML)
          inherit_gem:
            gemone: config/rubocop.yml
            gemtwo:
              - config/default.yml
              - config/strict.yml

          inherit_from: local.yml

          Metrics/MethodLength:
            Enabled: true

          Layout/LineLength:
            AllowURI: false
        YAML
      end

      context 'and the gem is globally installed' do
        before do
          gem_class = Struct.new(:gem_dir)
          %w[gemone gemtwo].each do |gem_name|
            mock_spec = gem_class.new(File.join(gem_root, gem_name))
            allow(Gem::Specification).to receive(:find_by_name)
              .with(gem_name).and_return(mock_spec)
          end
          allow(Gem).to receive(:path).and_return([gem_root])
        end

        it 'returns values from the gem config with local overrides' do
          expected = { 'Enabled' => true, # overridden in .rubocop.yml
                       'CountComments' => true,  # overridden in local.yml
                       'Max' => 200 }            # inherited from somegem
          expect do
            expect(configuration_from_file['Metrics/MethodLength']
                    .to_set.superset?(expected.to_set)).to be(true)
          end.to output('').to_stderr

          expected = { 'Enabled' => true, # gemtwo/config/default.yml
                       'Max' => 72,              # gemtwo/config/strict.yml
                       'AllowHeredoc' => false,  # gemtwo/config/strict.yml
                       'AllowURI' => false }     # overridden in .rubocop.yml
          expect(
            configuration_from_file['Layout/LineLength']
              .to_set.superset?(expected.to_set)
          ).to be(true)
        end
      end

      context 'and the gem is bundled' do
        before do
          require 'bundler'

          specs = {
            'gemone' => [OpenStruct.new(full_gem_path: File.join(gem_root, 'gemone'))],
            'gemtwo' => [OpenStruct.new(full_gem_path: File.join(gem_root, 'gemtwo'))]
          }

          allow(Bundler).to receive(:load).and_return(OpenStruct.new(specs: specs))
        end

        it 'returns values from the gem config with local overrides' do
          expected = { 'Enabled' => true, # overridden in .rubocop.yml
                       'CountComments' => true,  # overridden in local.yml
                       'Max' => 200 }            # inherited from somegem
          expect do
            expect(configuration_from_file['Metrics/MethodLength']
                    .to_set.superset?(expected.to_set)).to be(true)
          end.to output('').to_stderr

          expected = { 'Enabled' => true, # gemtwo/config/default.yml
                       'Max' => 72,              # gemtwo/config/strict.yml
                       'AllowHeredoc' => false,  # gemtwo/config/strict.yml
                       'AllowURI' => false }     # overridden in .rubocop.yml
          expect(
            configuration_from_file['Layout/LineLength']
              .to_set.superset?(expected.to_set)
          ).to be(true)
        end
      end
    end

    context 'when a file inherits from a url inheriting from a gem' do
      let(:file_path) { '.rubocop.yml' }
      let(:cache_file) { '.rubocop-http---example-com-default-yml' }
      let(:gem_root) { File.expand_path('gems') }
      let(:gem_name) { 'somegem' }

      before do
        create_file(file_path, ['inherit_from: http://example.com/default.yml'])

        stub_request(:get, %r{example.com/default})
          .to_return(status: 200, body: "inherit_gem:\n    #{gem_name}: default.yml")

        create_file("#{gem_root}/#{gem_name}/default.yml", ["Layout/LineLength:\n    Max: 48"])

        mock_spec = OpenStruct.new(gem_dir: File.join(gem_root, gem_name))
        allow(Gem::Specification).to receive(:find_by_name).with(gem_name).and_return(mock_spec)
        allow(Gem).to receive(:path).and_return([gem_root])
      end

      after do
        File.unlink cache_file if File.exist? cache_file
      end

      it 'resolves the inherited config' do
        expect(configuration_from_file['Layout/LineLength']['Max']).to eq(48)
      end
    end

    context 'when a file inherits from a url' do
      let(:file_path) { '.rubocop.yml' }
      let(:cache_file) { '.rubocop-http---example-com-rubocop-yml' }

      before do
        stub_request(:get, /example.com/)
          .to_return(status: 200, body: <<~YAML)
            Style/Encoding:
              Enabled: true
            Style/StringLiterals:
              EnforcedStyle: double_quotes
          YAML
        create_file(file_path, <<~YAML)
          inherit_from: http://example.com/rubocop.yml

          Style/StringLiterals:
            EnforcedStyle: single_quotes
        YAML
      end

      after do
        File.unlink cache_file if File.exist? cache_file
      end

      it 'creates the cached file alongside the owning file' do
        expect { configuration_from_file }.to output('').to_stderr
        expect(File.exist?(cache_file)).to be true
      end
    end

    context 'when a file inherits from a url inheriting from another file' do
      let(:file_path) { '.rubocop.yml' }
      let(:cache_file) { '.rubocop-http---example-com-rubocop-yml' }
      let(:cache_file2) { '.rubocop-http---example-com-inherit-yml' }

      before do
        stub_request(:get, %r{example.com/rubocop})
          .to_return(status: 200, body: "inherit_from:\n    - inherit.yml")

        stub_request(:get, %r{example.com/inherit})
          .to_return(status: 200, body: "Style/Encoding:\n    Enabled: true")

        create_file(file_path, ['inherit_from: http://example.com/rubocop.yml'])
      end

      after do
        [cache_file, cache_file2].each do |f|
          File.unlink f if File.exist? f
        end
      end

      it 'downloads the inherited file from the same url and caches it' do
        configuration_from_file
        expect(File.exist?(cache_file)).to be true
        expect(File.exist?(cache_file2)).to be true
      end
    end

    context 'EnabledByDefault / DisabledByDefault' do
      def cop_enabled?(cop_class)
        configuration_from_file.for_cop(cop_class).fetch('Enabled')
      end

      let(:file_path) { '.rubocop.yml' }

      before { create_file(file_path, config) }

      context 'when DisabledByDefault is true' do
        let(:config) do
          <<~YAML
            AllCops:
              DisabledByDefault: true
            Style/Copyright:
              Exclude:
              - foo
          YAML
        end

        it 'enables cops that are explicitly in the config file '\
           'even if they are disabled by default' do
          cop_class = RuboCop::Cop::Style::Copyright
          expect(cop_enabled?(cop_class)).to be true
        end

        it 'disables cops that are normally enabled by default' do
          cop_class = RuboCop::Cop::Layout::TrailingWhitespace
          expect(cop_enabled?(cop_class)).to be false
        end

        context 'and a department is enabled' do
          let(:config) do
            <<~YAML
              AllCops:
                DisabledByDefault: true
              Style:
                Enabled: true
            YAML
          end

          it 'enables cops in that department' do
            cop_class = RuboCop::Cop::Style::Alias
            expect(cop_enabled?(cop_class)).to be true
          end

          it 'disables cops in other departments' do
            cop_class = RuboCop::Cop::Layout::HashAlignment
            expect(cop_enabled?(cop_class)).to be false
          end

          it 'keeps cops that are disabled in default configuration disabled' do
            cop_class = RuboCop::Cop::Style::AutoResourceCleanup
            expect(cop_enabled?(cop_class)).to be false
          end
        end
      end

      context 'when EnabledByDefault is true' do
        let(:config) do
          <<~YAML
            AllCops:
              EnabledByDefault: true
            Layout/TrailingWhitespace:
              Enabled: false
          YAML
        end

        it 'enables cops that are disabled by default' do
          cop_class = RuboCop::Cop::Layout::FirstMethodArgumentLineBreak
          expect(cop_enabled?(cop_class)).to be true
        end

        it 'respects cops that are disbled in the config' do
          cop_class = RuboCop::Cop::Layout::TrailingWhitespace
          expect(cop_enabled?(cop_class)).to be false
        end
      end
    end

    context 'when a new cop is introduced' do
      def cop_enabled?(cop_class)
        configuration_from_file.for_cop(cop_class).fetch('Enabled')
      end

      let(:file_path) { '.rubocop.yml' }
      let(:cop_class) { RuboCop::Cop::Metrics::MethodLength }

      before do
        stub_const('RuboCop::ConfigLoader::RUBOCOP_HOME', 'rubocop')
        stub_const('RuboCop::ConfigLoader::DEFAULT_FILE',
                   File.join('rubocop', 'config', 'default.yml'))
        create_file('rubocop/config/default.yml',
                    <<~YAML)
                      AllCops:
                        AnythingGoes: banana
                      Metrics/MethodLength:
                        Enabled: pending
                    YAML
        create_file(file_path, config)
      end

      context 'when not configured explicitly' do
        let(:config) { '' }

        it 'is disabled' do
          expect(cop_enabled?(cop_class)).to eq 'pending'
        end
      end

      context 'when enabled explicitly in config' do
        let(:config) do
          <<~YAML
            Metrics/MethodLength:
              Enabled: true
          YAML
        end

        it 'is enabled' do
          expect(cop_enabled?(cop_class)).to be true
        end
      end

      context 'when disabled explicitly in config' do
        let(:config) do
          <<~YAML
            Metrics/MethodLength:
              Enabled: false
          YAML
        end

        it 'is disabled' do
          expect(cop_enabled?(cop_class)).to be false
        end
      end

      context 'when DisabledByDefault is true' do
        let(:config) do
          <<~YAML
            AllCops:
              DisabledByDefault: true
          YAML
        end

        it 'is disabled' do
          expect(cop_enabled?(cop_class)).to be false
        end
      end

      context 'when EnabledByDefault is true' do
        let(:config) do
          <<~YAML
            AllCops:
              EnabledByDefault: true
          YAML
        end

        it 'is enabled' do
          expect(cop_enabled?(cop_class)).to be true
        end
      end
    end

    context 'when a department is configured without an Enable value specified', :restore_registry do
      let(:file_path) { '.rubocop.yml' }

      before do
        create_file('third_party/default.yml', <<~YAML)
          Custom:
            Foo: Bar
        YAML

        stub_cop_class('RuboCop::Cop::Custom::Cop')
      end

      def cop_enabled?(cop_class)
        configuration_from_file.for_cop(cop_class).fetch('Enabled')
      end

      context 'inline' do
        before do
          create_file('.rubocop.yml', <<~YAML)
            AllCops:
              DisabledByDefault: true

            Custom:
              Foo: Bar

            Custom/Cop:
              Enabled: true
          YAML
        end

        it 'enables the cop' do
          expect(cop_enabled?('Custom/Cop')).to be true
        end
      end

      context 'via inherit_from' do
        before do
          create_file('.rubocop.yml', <<~YAML)
            inherit_from:
              - 'third_party/default.yml'

            AllCops:
              DisabledByDefault: true

            Custom/Cop:
              Enabled: true
          YAML
        end

        it 'enables the cop' do
          expect(cop_enabled?('Custom/Cop')).to be true
        end
      end

      context 'by an extension' do
        before do
          create_file('third_party.rb', <<~RUBY)
            module RuboCop
              module Custom
                def self.inject!
                  path = 'third_party/default.yml'

                  # Injection code currently used in extensions
                  hash = ConfigLoader.send(:load_yaml_configuration, path)
                  config = Config.new(hash, path)
                  config = ConfigLoader.merge_with_default(config, path)
                  ConfigLoader.instance_variable_set(:@default_configuration, config)
                end
              end
            end

            RuboCop::Custom.inject!
          RUBY

          create_file('.rubocop.yml', <<~YAML)
            require:
              - ./third_party.rb

            AllCops:
              DisabledByDefault: true

            Custom/Cop:
              Enabled: true
          YAML
        end

        it 'enables the cop' do
          expect(cop_enabled?('Custom/Cop')).to be true
        end
      end
    end
  end

  describe '.load_file', :isolated_environment do
    subject(:load_file) { described_class.load_file(configuration_path, check: check) }

    let(:configuration_path) { '.rubocop.yml' }
    let(:check) { true }

    it 'returns a configuration loaded from the passed path' do
      create_file(configuration_path, <<~YAML)
        Style/Encoding:
          Enabled: true
      YAML
      configuration = load_file
      expect(configuration['Style/Encoding']).to eq('Enabled' => true)
    end

    it 'does ERB pre-processing of the configuration file' do
      %w[a.rb b.rb].each { |file| create_file(file, 'puts 1') }
      create_file(configuration_path, <<~YAML)
        Style/Encoding:
          Enabled: <%= 1 == 1 %>
          Exclude:
          <% Dir['*.rb'].sort.each do |name| %>
            - <%= name %>
          <% end %>
      YAML
      configuration = load_file
      expect(configuration['Style/Encoding'])
        .to eq('Enabled' => true,
               'Exclude' => [abs('a.rb'), abs('b.rb')])
    end

    it 'does ERB pre-processing of a configuration file in a subdirectory' do
      create_file('dir/c.rb', 'puts 1')
      create_file('dir/.rubocop.yml', <<~YAML)
        Style/Encoding:
          Exclude:
          <% Dir['*.rb'].each do |name| %>
            - <%= name %>
          <% end %>
      YAML
      configuration = described_class.load_file('dir/.rubocop.yml')
      expect(configuration['Style/Encoding']).to eq('Exclude' => [abs('dir/c.rb')])
    end

    it 'fails with a TypeError when loading a malformed configuration file' do
      create_file(configuration_path, 'This string is not a YAML hash')
      expect { load_file }.to raise_error(
        TypeError, /^Malformed configuration in .*\.rubocop\.yml$/
      )
    end

    it 'loads configuration properly when it includes non-ascii characters ' do
      create_file(configuration_path, <<~YAML)
        # All these cops of mine are ❤
        Style/Encoding:
          Enabled: false
      YAML

      expect(load_file.to_h).to eq('Style/Encoding' => { 'Enabled' => false })
    end

    it 'returns an empty configuration loaded from an empty file' do
      create_empty_file(configuration_path)
      configuration = load_file
      expect(configuration.to_h).to eq({})
    end

    context 'set neither true nor false to value to Enabled' do
      before do
        create_file(configuration_path, <<~YAML)
          Layout/ArrayAlignment:
            Enabled: disable
        YAML
      end

      it 'gets a warning message' do
        expect do
          load_file
        end.to raise_error(
          RuboCop::ValidationError,
          /supposed to be a boolean and disable is not/
        )
      end
    end

    context 'does not set `pending`, `disable`, or `enable` to `NewCops`' do
      before do
        create_file(configuration_path, <<~YAML)
          AllCops:
            NewCops: true
        YAML
      end

      it 'gets a warning message' do
        expect do
          load_file
        end.to raise_error(
          RuboCop::ValidationError,
          /invalid true for `NewCops` found in/
        )
      end
    end

    context 'when the file does not exist' do
      let(:configuration_path) { 'file_that_does_not_exist.yml' }

      it 'prints a friendly (concise) message to stderr and exits' do
        expect { load_file }.to(
          raise_error(RuboCop::ConfigNotFoundError) do |e|
            expect(e.message).to(match(/\AConfiguration file not found: .+\z/))
          end
        )
      end
    end

    context '< Ruby 2.5', if: RUBY_VERSION < '2.5' do
      context 'when the file has duplicated keys' do
        it 'outputs a warning' do
          create_file(configuration_path, <<~YAML)
            Style/Encoding:
              Enabled: true

            Style/Encoding:
              Enabled: false
          YAML

          expect { load_file }.to output(%r{`Style/Encoding` is concealed by duplicat}).to_stderr
        end
      end
    end

    context '>= Ruby 2.5', if: RUBY_VERSION >= '2.5' do
      context 'when the file has duplicated keys' do
        it 'outputs a warning' do
          create_file(configuration_path, <<~YAML)
            Style/Encoding:
              Enabled: true

            Style/Encoding:
              Enabled: false
          YAML

          expect { load_file }.to output(%r{`Style/Encoding` is concealed by line 4}).to_stderr
        end
      end
    end

    context 'when the config file contains an obsolete config' do
      before do
        create_file(configuration_path, <<~YAML)
          Style/MethodMissing:
            Enabled: true
        YAML
      end

      context 'and check is true' do
        it 'raises an error' do
          expect { load_file }.to raise_error(
            RuboCop::ValidationError,
            %r{`Style/MethodMissing` cop has been split}
          )
        end
      end

      context 'and check is false' do
        let(:check) { false }

        it 'does not raise an error' do
          expect { load_file }.not_to raise_error
        end
      end
    end
  end

  describe '.merge' do
    subject(:merge) { described_class.merge(base, derived) }

    let(:base) do
      {
        'AllCops' => {
          'Include' => ['**/*.gemspec', '**/Rakefile'],
          'Exclude' => []
        }
      }
    end
    let(:derived) { { 'AllCops' => { 'Exclude' => ['example.rb', 'exclude_*'] } } }

    it 'returns a recursive merge of its two arguments' do
      expect(merge).to eq('AllCops' => {
                            'Include' => ['**/*.gemspec', '**/Rakefile'],
                            'Exclude' => ['example.rb', 'exclude_*']
                          })
    end
  end

  describe 'configuration for CharacterLiteral', :isolated_environment do
    let(:dir_path) { 'test/blargh' }

    let(:config) do
      config_path = described_class.configuration_file_for(dir_path)
      described_class.configuration_from_file(config_path)
    end

    context 'when .rubocop.yml inherits from a file with a name starting with .rubocop' do
      before do
        create_file('test/.rubocop_rules.yml', <<~YAML)
          Style/CharacterLiteral:
            Exclude:
              - blargh/blah.rb
        YAML
        create_file('test/.rubocop.yml', 'inherit_from: .rubocop_rules.yml')
      end

      it 'gets an Exclude relative to the inherited file converted to absolute' do
        expect(config.for_cop(RuboCop::Cop::Style::CharacterLiteral)['Exclude'])
          .to eq([File.join(Dir.pwd, 'test/blargh/blah.rb')])
      end
    end
  end

  describe 'when pending cops exist', :isolated_environment do
    subject(:from_file) { described_class.configuration_from_file('.rubocop.yml') }

    before do
      create_empty_file('.rubocop.yml')

      # Setup similar to https://github.com/rubocop/rubocop-rspec/blob/master/lib/rubocop/rspec/inject.rb#L16
      # and https://github.com/runtastic/rt_rubocop_defaults/blob/master/lib/rt_rubocop_defaults/inject.rb#L21
      config = RuboCop::Config.new(parent_config)
      described_class.instance_variable_set(:@default_configuration, config)
    end

    context 'when NewCops is set in a required file' do
      let(:parent_config) { { 'AllCops' => { 'NewCops' => 'enable' } } }

      it 'does not print a warning' do
        expect(described_class).not_to receive(:warn_on_pending_cops)
        from_file
      end
    end

    context 'when NewCops is not configured in a required file' do
      let(:parent_config) { { 'AllCops' => { 'Exclude:' => ['coverage/**/*'] } } }

      it 'prints a warning' do
        expect(described_class).to receive(:warn_on_pending_cops)
        from_file
      end
    end
  end

  describe 'configuration for AssignmentInCondition' do
    describe 'AllowSafeAssignment' do
      it 'is enabled by default' do
        default_config = described_class.default_configuration
        symbol_name_config = default_config.for_cop('Lint/AssignmentInCondition')
        expect(symbol_name_config['AllowSafeAssignment']).to be_truthy
      end
    end
  end

  describe 'when a requirement is defined', :isolated_environment do
    let(:required_file_path) { './required_file.rb' }

    before do
      create_file('.rubocop.yml', ['require:', "  - #{required_file_path}"])
      create_file(required_file_path, ['class MyClass', 'end'])
    end

    it 'requires the passed path' do
      config_path = described_class.configuration_file_for('.')
      described_class.configuration_from_file(config_path)
      expect(defined?(MyClass)).to be_truthy
    end

    it 'uses paths relative to the .rubocop.yml, not cwd' do
      config_path = described_class.configuration_file_for('.')
      Dir.chdir '..' do
        described_class.configuration_from_file(config_path)
        expect(defined?(MyClass)).to be_truthy
      end
    end
  end

  describe 'when a unqualified requirement is defined', :isolated_environment do
    let(:required_file_path) { 'required_file' }

    before do
      create_file('.rubocop.yml', ['require:', "  - #{required_file_path}"])
      create_file("#{required_file_path}.rb", ['class MyClass', 'end'])
    end

    it 'works without a starting .' do
      config_path = described_class.configuration_file_for('.')
      $LOAD_PATH.unshift(File.dirname(config_path))
      Dir.chdir '..' do
        described_class.configuration_from_file(config_path)
        expect(defined?(MyClass)).to be_truthy
      end
    end
  end
end
