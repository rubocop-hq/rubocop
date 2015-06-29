# encoding: utf-8

require 'spec_helper'
require 'stringio'
require 'ostruct'

module RuboCop
  module Formatter
    describe DisabledConfigFormatter do
      subject(:formatter) { described_class.new(output) }
      let(:output) do
        o = StringIO.new
        def o.path
          '.rubocop_todo.yml'
        end
        o
      end
      let(:offenses) do
        [RuboCop::Cop::Offense.new(:convention, location, 'message', 'Cop1'),
         RuboCop::Cop::Offense.new(:convention, location, 'message', 'Cop2')]
      end
      let(:location) { OpenStruct.new(line: 1, column: 5) }
      before { $stdout = StringIO.new }

      describe '#finished' do
        it 'displays YAML configuration disabling all cops with offenses' do
          formatter.file_finished('test_a.rb', offenses)
          formatter.file_finished('test_b.rb', [offenses.first])
          formatter.finished(['test_a.rb', 'test_b.rb'])
          expect(output.string).to eq(described_class::HEADING +
                                      ['',
                                       '',
                                       '# Offense count: 2',
                                       'Cop1:',
                                       '  Exclude:',
                                       "    - 'test_a.rb'",
                                       "    - 'test_b.rb'",
                                       '',
                                       '# Offense count: 1',
                                       'Cop2:',
                                       '  Exclude:',
                                       "    - 'test_a.rb'",
                                       ''].join("\n"))
          expect($stdout.string)
            .to eq(['Created .rubocop_todo.yml.',
                    'Run `rubocop --config .rubocop_todo.yml`, or',
                    'add inherit_from: .rubocop_todo.yml in a .rubocop.yml ' \
                    'file.',
                    ''].join("\n"))
        end

        it 'displays a file exclusion list up to a maximum of 15 offences' do
          exclusion_list = []
          file_list = []

          15.times do |index|
            file_name = format('test_%02d.rb', index)
            formatter.file_finished(file_name, offenses)
            file_list << file_name
            exclusion_list << "    - '#{file_name}'"
          end

          file_list << 'test.rb'
          formatter.file_finished('test.rb', [offenses.first])
          formatter.finished(file_list)
          expect(output.string).to eq(described_class::HEADING +
                                      ['',
                                       '',
                                       '# Offense count: 16',
                                       'Cop1:',
                                       '  Enabled: false',
                                       '',
                                       '# Offense count: 15',
                                       'Cop2:',
                                       '  Exclude:',
                                       exclusion_list,
                                       ''].flatten.join("\n"))
        end

        it 'file exclusion offense count can be configured' do
          exclusion_list = []
          file_list = []
          old_maximum_exclusion_items =
            RuboCop::Formatter::DisabledConfigFormatter::MAXIMUM_EXCLUSION_ITEMS
          RuboCop::Formatter::DisabledConfigFormatter
            .send(:remove_const, 'MAXIMUM_EXCLUSION_ITEMS')
          RuboCop::Formatter::DisabledConfigFormatter
            .const_set('MAXIMUM_EXCLUSION_ITEMS', 5)

          15.times do |index|
            file_name = format('test_%02d.rb', index)
            formatter.file_finished(file_name, offenses)
            file_list << file_name
            exclusion_list << "    - '#{file_name}'"
          end

          file_list << 'test.rb'
          formatter.file_finished('test.rb', [offenses.first])
          formatter.finished(file_list)
          expect(output.string).to eq(described_class::HEADING +
                                      ['',
                                       '',
                                       '# Offense count: 16',
                                       'Cop1:',
                                       '  Enabled: false',
                                       '',
                                       '# Offense count: 15',
                                       'Cop2:',
                                       '  Enabled: false',
                                       ''].flatten.join("\n"))

          RuboCop::Formatter::DisabledConfigFormatter
            .send(:remove_const, 'MAXIMUM_EXCLUSION_ITEMS')
          RuboCop::Formatter::DisabledConfigFormatter
            .const_set('MAXIMUM_EXCLUSION_ITEMS', old_maximum_exclusion_items)
        end
      end
    end
  end
end
