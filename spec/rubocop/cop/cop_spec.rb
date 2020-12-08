# frozen_string_literal: true

using RuboCop::Cop::Base::Internals

RSpec.describe RuboCop::Cop::Cop, :config do
  let(:source) { 'code = {some: :ruby}' }
  let(:location) { source_range(0...1) }

  before { cop.send(:begin_investigation, processed_source) }

  it 'initially has 0 offenses' do
    expect(cop.offenses.empty?).to be(true)
  end

  describe '.qualified_cop_name' do
    before do
      $stderr = StringIO.new
    end

    after do
      $stderr = STDERR
    end

    it 'adds namespace if the cop name is found in exactly one namespace' do
      expect(described_class.qualified_cop_name('LineLength', '--only'))
        .to eq('Layout/LineLength')
    end

    it 'returns the given cop name if it is not found in any namespace' do
      expect(described_class.qualified_cop_name('UnknownCop', '--only'))
        .to eq('UnknownCop')
    end

    it 'returns the given cop name if it already has a namespace' do
      expect(described_class.qualified_cop_name('Layout/LineLength', '--only'))
        .to eq('Layout/LineLength')
    end

    it 'returns the cop name in a different namespace if the provided ' \
       'namespace is incorrect' do
      expect(described_class.qualified_cop_name('Style/LineLength', '--only'))
        .to eq('Layout/LineLength')
    end

    # `Rails/SafeNavigation` was extracted to rubocop-rails gem,
    # there were no cop whose names overlapped.
    xit 'raises an error if the cop name is in more than one namespace' do
      expect { described_class.qualified_cop_name('SafeNavigation', '--only') }
        .to raise_error(RuboCop::Cop::AmbiguousCopName)
    end

    it 'returns the given cop name if it already has a namespace even when ' \
       'the cop exists in multiple namespaces' do
      qualified_cop_name =
        described_class.qualified_cop_name('Style/SafeNavigation', '--only')

      expect(qualified_cop_name).to eq('Style/SafeNavigation')
    end
  end

  describe '.documentation_url' do
    subject(:url) { cop_class.documentation_url }

    describe 'for a builtin cop class' do
      let(:cop_class) { RuboCop::Cop::Layout::BlockEndNewline }

      it { is_expected.to eq 'https://docs.rubocop.org/rubocop/cops_layout.html#layoutblockendnewline' } # rubocop:disable Layout/LineLength
    end

    describe 'for a custom cop class', :restore_registry do
      let(:cop_class) { stub_cop_class('Some::Cop') { def foo; end } }

      it { is_expected.to eq nil }
    end
  end

  it 'keeps track of offenses' do
    cop.add_offense(nil, location: location, message: 'message')

    expect(cop.offenses.size).to eq(1)
  end

  it 'will report registered offenses' do
    cop.add_offense(nil, location: location, message: 'message')

    expect(cop.offenses.empty?).to be(false)
  end

  it 'will set default severity' do
    cop.add_offense(nil, location: location, message: 'message')

    expect(cop.offenses.first.severity).to eq(:convention)
  end

  it 'will set custom severity if present' do
    cop.config[cop.name] = { 'Severity' => 'warning' }
    cop.add_offense(nil, location: location, message: 'message')

    expect(cop.offenses.first.severity).to eq(:warning)
  end

  it 'will warn if custom severity is invalid' do
    cop.config[cop.name] = { 'Severity' => 'superbad' }
    expect { cop.add_offense(nil, location: location, message: 'message') }
      .to output(/Warning: Invalid severity 'superbad'./).to_stderr
  end

  context 'when disabled by a comment' do
    subject(:offense_status) do
      cop.add_offense(nil, location: location, message: 'message')
      cop.offenses.first.status
    end

    before do
      allow(processed_source.comment_config).to receive(:cop_enabled_at_line?)
        .and_return(false)
    end

    context 'ignore_disable_comments is false' do
      let(:cop_options) { { ignore_disable_comments: false } }

      it 'will set offense as disabled' do
        expect(offense_status).to eq :disabled
      end
    end

    context 'ignore_disable_comments is true' do
      let(:cop_options) { { ignore_disable_comments: true } }

      it 'will not set offense as disabled' do
        expect(offense_status).not_to eq :disabled
      end
    end
  end

  describe 'for a cop with a name' do
    let(:cop_class) { RuboCop::Cop::Style::For }

    it 'registers offense with its name' do
      offenses = cop.add_offense(location, message: 'message')
      expect(offenses.first.cop_name).to eq('Style/For')
    end
  end

  describe 'setting of Offense#corrected attribute' do
    context 'when cop does not support autocorrection' do
      before do
        allow(cop).to receive(:support_autocorrect?).and_return(false)
      end

      it 'is not specified (set to nil)' do
        cop.add_offense(nil, location: location, message: 'message')
        expect(cop.offenses.first.corrected?).to be(false)
      end

      context 'when autocorrect is requested' do
        before do
          allow(cop).to receive(:autocorrect_requested?).and_return(true)
        end

        it 'is not specified (set to nil)' do
          cop.add_offense(nil, location: location, message: 'message')
          expect(cop.offenses.first.corrected?).to be(false)
        end

        context 'when disable_uncorrectable is enabled' do
          before do
            allow(cop).to receive(:disable_uncorrectable?).and_return(true)
          end

          let(:node) do
            instance_double(RuboCop::AST::Node,
                            location: instance_double(Parser::Source::Map,
                                                      expression: location,
                                                      line: 1))
          end

          it 'is set to true' do
            cop.add_offense(node, location: location, message: 'message')
            expect(cop.offenses.first.corrected?).to be(true)
            expect(cop.offenses.first.status).to be(:corrected_with_todo)
          end
        end
      end
    end

    context 'when cop supports autocorrection', :restore_registry do
      let(:cop_class) do
        stub_cop_class('RuboCop::Cop::Test::StubCop', inherit: described_class) do
          def autocorrect(node); end
        end
      end

      context 'when offense was corrected' do
        before do
          allow(cop).to receive(:autocorrect?).and_return(true)
          allow(cop).to receive(:autocorrect).and_return(lambda do |corrector|
            corrector.insert_before(location, 'hi!')
          end)
        end

        it 'is set to true' do
          cop.add_offense(nil, location: location, message: 'message')
          expect(cop.offenses.first.corrected?).to eq(true)
        end
      end

      context 'when autocorrection is not needed' do
        before do
          allow(cop).to receive(:autocorrect?).and_return(false)
        end

        it 'is set to false' do
          cop.add_offense(nil, location: location, message: 'message')
          expect(cop.offenses.first.corrected?).to eq(false)
        end
      end

      context 'when offense was not corrected because of an error' do
        before do
          allow(cop).to receive(:autocorrect?).and_return(true)
          allow(cop).to receive(:autocorrect).and_return(false)
        end

        it 'is set to false' do
          cop.add_offense(nil, location: location, message: 'message')
          expect(cop.offenses.first.corrected?).to eq(false)
        end
      end
    end
  end

  context 'with no submodule' do
    it('has right name') { expect(cop_class.cop_name).to eq('Cop/Cop') }
    it('has right department') { expect(cop_class.department).to eq(:Cop) }
  end

  context 'with style cops' do
    let(:cop_class) { RuboCop::Cop::Style::For }

    it('has right name') { expect(cop_class.cop_name).to eq('Style/For') }
    it('has right department') { expect(cop_class.department).to eq(:Style) }
  end

  context 'with lint cops' do
    let(:cop_class) { RuboCop::Cop::Lint::Loop }

    it('has right name') { expect(cop_class.cop_name).to eq('Lint/Loop') }
    it('has right department') { expect(cop_class.department).to eq(:Lint) }
  end

  describe 'Registry' do
    describe '#departments' do
      subject(:departments) { described_class.registry.departments }

      it('has departments') { expect(departments.length).not_to eq(0) }
      it { is_expected.to include(:Lint) }
      it { is_expected.to include(:Style) }

      it 'contains every value only once' do
        expect(departments.length).to eq(departments.uniq.length)
      end
    end

    describe '#with_department' do
      let(:departments) { described_class.registry.departments }

      it 'has at least one cop per department' do
        departments.each do |c|
          expect(described_class.registry.with_department(c).length).to be > 0
        end
      end

      it 'has each cop in exactly one type' do
        sum = 0
        departments.each do |c|
          sum += described_class.registry.with_department(c).length
        end
        expect(sum).to be described_class.registry.length
      end

      it 'returns 0 for an invalid type' do
        expect(described_class.registry.with_department('x').length).to be 0
      end
    end
  end

  describe '#autocorrect?' do
    subject { cop.autocorrect? }

    let(:support_autocorrect) { true }
    let(:disable_uncorrectable) { false }

    before do
      allow(cop.class).to receive(:support_autocorrect?) { support_autocorrect }
      allow(cop).to receive(:disable_uncorrectable?) { disable_uncorrectable }
    end

    context 'when the option is not given' do
      let(:cop_options) { {} }

      it { is_expected.to be(false) }
    end

    context 'when the option is given' do
      let(:cop_options) { { auto_correct: true } }

      it { is_expected.to be(true) }

      context 'when cop does not support autocorrection' do
        let(:support_autocorrect) { false }

        it { is_expected.to be(false) }

        context 'when disable_uncorrectable is enabled' do
          let(:disable_uncorrectable) { true }

          it { is_expected.to be(true) }
        end
      end

      context 'when the cop is set to not autocorrect' do
        let(:cop_options) { { 'AutoCorrect' => false } }

        it { is_expected.to be(false) }
      end
    end
  end

  describe '#relevant_file?' do
    subject { cop.relevant_file?(file) }

    let(:cop_config) { { 'Include' => ['foo.rb'] } }

    context 'when the file matches the Include configuration' do
      let(:file) { 'foo.rb' }

      it { is_expected.to be(true) }
    end

    context 'when the file doesn\'t match the Include configuration' do
      let(:file) { 'bar.rb' }

      it { is_expected.to be(false) }
    end

    context 'when the file is an anonymous source' do
      let(:file) { '(string)' }

      it { is_expected.to be(true) }
    end
  end

  describe '#safe_autocorrect?' do
    subject { cop.safe_autocorrect? }

    context 'when cop is declared unsafe' do
      let(:cop_config) { { 'Safe' => false } }

      it { is_expected.to be(false) }
    end

    context 'when auto-correction of the cop is declared unsafe' do
      let(:cop_config) { { 'SafeAutoCorrect' => false } }

      it { is_expected.to be(false) }
    end

    context 'when safety is undeclared' do
      let(:cop_config) { {} }

      it { is_expected.to be(true) }
    end
  end
end
