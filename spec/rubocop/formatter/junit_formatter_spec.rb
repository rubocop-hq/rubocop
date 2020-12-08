# frozen_string_literal: true
using RuboCop::Cop::Base::Internals

RSpec.describe RuboCop::Formatter::JUnitFormatter, :config do
  subject(:formatter) { described_class.new(output) }

  let(:output) { StringIO.new }
  let(:cop_class) { RuboCop::Cop::Layout::SpaceInsideBlockBraces }
  let(:source) { %w[foo bar baz].join("\n") }

  before { cop.send(:begin_investigation, processed_source) }

  describe '#file_finished' do
    before do
      cop.add_offense(
        Parser::Source::Range.new(source_buffer, 0, 1),
        message: 'message 1'
      )
      offenses = cop.add_offense(
        Parser::Source::Range.new(source_buffer, 9, 10),
        message: 'message 2'
      )

      formatter.file_finished('test_1', offenses)
      formatter.file_finished('test_2', offenses)

      formatter.finished(nil)
    end

    it 'displays start of parsable text' do
      expect(output.string).to start_with(<<~XML)
        <?xml version='1.0'?>
        <testsuites>
          <testsuite name='rubocop'>
      XML
    end

    it 'displays end of parsable text' do
      expect(output.string).to end_with(<<~XML.chop)
          </testsuite>
        </testsuites>
      XML
    end

    it "displays an offfense for `classname='test_1` in parsable text" do
      expect(output.string).to include(<<-XML)
    <testcase classname='test_1' name='Layout/SpaceInsideBlockBraces'>
      <failure type='Layout/SpaceInsideBlockBraces' message='message 1'>
        test:1:1
      </failure>
      <failure type='Layout/SpaceInsideBlockBraces' message='message 2'>
        test:3:2
      </failure>
    </testcase>
      XML
    end

    it "displays an offfense for `classname='test_2` in parsable text" do
      expect(output.string).to include(<<-XML)
    <testcase classname='test_2' name='Layout/SpaceInsideBlockBraces'>
      <failure type='Layout/SpaceInsideBlockBraces' message='message 1'>
        test:1:1
      </failure>
      <failure type='Layout/SpaceInsideBlockBraces' message='message 2'>
        test:3:2
      </failure>
    </testcase>
      XML
    end

    it 'displays a non-offfense element in parsable text' do
      expect(output.string).to include(<<~XML)
        <testcase classname='test_1' name='Style/Alias'/>
      XML
    end
  end
end
