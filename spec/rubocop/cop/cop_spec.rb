# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::Cop do
  subject(:cop) { described_class.new }
  let(:location) do
    source_buffer = Parser::Source::Buffer.new('test', 1)
    source_buffer.source = "a\n"
    Parser::Source::Range.new(source_buffer, 0, 1)
  end

  it 'initially has 0 offenses' do
    expect(cop.offenses).to be_empty
  end

  it 'keeps track of offenses' do
    cop.add_offense(nil, location, 'message')

    expect(cop.offenses.size).to eq(1)
  end

  it 'will report registered offenses' do
    cop.add_offense(nil, location, 'message')

    expect(cop.offenses).not_to be_empty
  end

  it 'will set default severity' do
    cop.add_offense(nil, location, 'message')

    expect(cop.offenses.first.severity).to eq(:convention)
  end

  it 'will set custom severity if present' do
    cop.config[cop.name] = { 'Severity' => 'warning' }
    cop.add_offense(nil, location, 'message')

    expect(cop.offenses.first.severity).to eq(:warning)
  end

  it 'will warn if custom severity is invalid' do
    cop.config[cop.name] = { 'Severity' => 'superbad' }
    expect(cop).to receive(:warn)
    cop.add_offense(nil, location, 'message')
  end

  it 'registers offense with its name' do
    cop = Rubocop::Cop::Style::For.new
    cop.add_offense(nil, location, 'message')
    expect(cop.offenses.first.cop_name).to eq('For')
  end

  context 'with no submodule' do
    subject(:cop) { described_class }
    it('has right name') { expect(cop.cop_name).to eq('Cop') }
    it('has right type') { expect(cop.cop_type).to eq(:cop) }
  end

  context 'with style cops' do
    subject(:cop) { Rubocop::Cop::Style::For }
    it('has right name') { expect(cop.cop_name).to eq('For') }
    it('has right type') { expect(cop.cop_type).to eq(:style) }
  end

  context 'with lint cops' do
    subject(:cop) { Rubocop::Cop::Lint::Loop }
    it('has right name') { expect(cop.cop_name).to eq('Loop') }
    it('has right type') { expect(cop.cop_type).to eq(:lint) }
  end

  context 'with rails cops' do
    subject(:cop) { Rubocop::Cop::Rails::Validation }
    it('has right name') { expect(cop.cop_name).to eq('Validation') }
    it('has right type') { expect(cop.cop_type).to eq(:rails) }
  end

  describe '#message' do
    context 'without configured message' do
      it 'returns default message' do
        message = 'A default message'
        Rubocop::Cop::Style::For::MSG = message
        cop = Rubocop::Cop::Style::For.new

        expect(cop.message).to eq message
      end
    end

    context 'with configured message' do
      it 'returns configured message' do
        message = 'A configured message'
        config = Rubocop::Config.new('For' => { 'Message' => message })
        cop = Rubocop::Cop::Style::For.new(config)

        expect(cop.message).to eq message
      end
    end
  end

  describe 'CopStore' do
    context '#types' do
      subject { described_class.all.types }
      it('has types') { expect(subject.length).not_to eq(0) }
      it { should include :lint }
      it do
        should include :rails
      end
      it { should include :style }
      it 'contains every value only once' do
        expect(subject.length).to eq(subject.uniq.length)
      end
    end
    context '#with_type' do
      let(:types) { described_class.all.types }
      it 'has at least one cop per type' do
        types.each do |c|
          expect(described_class.all.with_type(c).length).to be > 0
        end
      end

      it 'has each cop in exactly one type' do
        sum = 0
        types.each do |c|
          sum += described_class.all.with_type(c).length
        end
        expect(sum).to be described_class.all.length
      end

      it 'returns 0 for an invalid type' do
        expect(described_class.all.with_type('x').length).to be 0
      end
    end
  end
end
