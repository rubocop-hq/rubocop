# frozen_string_literal: true

RSpec.describe RuboCop::DirectiveComment do
  subject(:directive_comment) { described_class.new(comment) }

  let(:comment) { instance_double(Parser::Source::Comment, text: text) }
  let(:comment_cop_names) { 'all' }
  let(:text) { "#rubocop:enable #{comment_cop_names}" }

  describe '.before_comment' do
    subject { described_class.before_comment(text) }

    [
      ['when line has code', 'def foo # rubocop:disable all', 'def foo '],
      ['when line has NO code', '# rubocop:disable all', '']
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#match?' do
    subject(:match) { directive_comment.match?(cop_names) }

    let(:comment_cop_names) { 'Metrics/AbcSize, Metrics/PerceivedComplexity, Style/Not' }

    context 'no comment_cop_names' do
      let(:cop_names) { [] }

      it 'returns false' do
        expect(match).to eq(false)
      end
    end

    context 'same cop names as in the comment' do
      let(:cop_names) { %w[Metrics/AbcSize Metrics/PerceivedComplexity Style/Not] }

      it 'returns true' do
        expect(match).to eq(true)
      end
    end

    context 'same cop names as in the comment in a different order' do
      let(:cop_names) { %w[Style/Not Metrics/AbcSize Metrics/PerceivedComplexity] }

      it 'returns true' do
        expect(match).to eq(true)
      end
    end

    context 'subset of names' do
      let(:cop_names) { %w[Metrics/AbcSize Style/Not] }

      it 'returns false' do
        expect(match).to eq(false)
      end
    end

    context 'superset of names' do
      let(:cop_names) { %w[Lint/Void Metrics/AbcSize Metrics/PerceivedComplexity Style/Not] }

      it 'returns false' do
        expect(match).to eq(false)
      end
    end

    context 'duplicate names' do
      let(:cop_names) { %w[Metrics/AbcSize Metrics/AbcSize Metrics/PerceivedComplexity Style/Not] }

      it 'returns true' do
        expect(match).to eq(true)
      end
    end

    context 'all' do
      let(:comment_cop_names) { 'all' }
      let(:cop_names) { %w[all] }

      it 'returns true' do
        expect(match).to eq(true)
      end
    end
  end

  describe '#match_captures' do
    subject { directive_comment.match_captures }

    [
      ['when disable', '# rubocop:disable all', ['disable', 'all', nil, nil]],
      ['when enable', '# rubocop:enable Foo/Bar', ['enable', 'Foo/Bar', nil, 'Foo/']],
      ['when todo', '# rubocop:todo all', ['todo', 'all', nil, nil]],
      ['when typo', '# rudocop:todo Dig/ThisMine', nil]
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#single_line?' do
    subject { directive_comment.single_line? }

    [
      ['when relates to single line', 'def foo # rubocop:disable all', true],
      ['when does NOT relate to single line', '# rubocop:disable all', false]
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#disabled?' do
    subject { directive_comment.disabled? }

    [
      ['when disable', '# rubocop:disable all', true],
      ['when enable', '# rubocop:enable Foo/Bar', false],
      ['when todo', '# rubocop:todo all', true]
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#enabled?' do
    subject { directive_comment.enabled? }

    [
      ['when disable', '# rubocop:disable all', false],
      ['when enable', '# rubocop:enable Foo/Bar', true],
      ['when todo', '# rubocop:todo all', false]
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#all_cops?' do
    subject { directive_comment.all_cops? }

    [
      ['when mentioned all', '# rubocop:disable all', true],
      ['when mentioned specific cops', '# rubocop:enable Foo/Bar', false]
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#cop_names' do
    subject(:cop_names) { directive_comment.cop_names }

    context 'when all cops mentioned' do
      let(:comment_cop_names) { 'all' }
      let(:global) { instance_double(RuboCop::Cop::Registry, names: names) }
      let(:names) { %w[all_names Lint/RedundantCopDisableDirective] }

      before { allow(RuboCop::Cop::Registry).to receive(:global).and_return(global) }

      it 'returns all cop names except redundant' do
        expect(cop_names).to eq(%w[all_names])
      end
    end

    context 'when cop specified' do
      let(:comment_cop_names) { 'Foo/Bar' }

      it 'returns parsed cop names' do
        expect(cop_names).to eq(%w[Foo/Bar])
      end
    end
  end

  describe '#line_number' do
    let(:comment) { instance_double(Parser::Source::Comment, text: text, loc: loc) }
    let(:loc) { instance_double(Parser::Source::Map, expression: expression) }
    let(:expression) { instance_double(Parser::Source::Range, line: 1) }

    it 'returns line number for directive' do
      expect(directive_comment.line_number).to be 1
    end
  end

  describe '#enabled_all?' do
    subject { directive_comment.enabled_all? }

    [
      ['when enabled all cops', 'def foo # rubocop:enable all', true],
      ['when enabled specific cops', '# rubocop:enable Foo/Bar', false],
      ['when disabled all cops', '# rubocop:disable all', false],
      ['when disabled specific cops', '# rubocop:disable Foo/Bar', false]
    ].each do |example|
      context example[0] do
        let(:text) { example[1] }

        it { is_expected.to eq example[2] }
      end
    end
  end

  describe '#disabled_next_line?' do
    subject { directive_comment.disabled_next_line? }

    shared_examples 'checks disabled_next_line?' do |explanation, comment, result|
      context explanation do
        let(:text) { comment }

        it { is_expected.to eq result }
      end
    end

    include_examples 'checks disabled_next_line?',
                     'when disabled next line', '# rubocop:disable-next-line all', true
    include_examples 'checks disabled_next_line?',
                     'when "todoed" next line', '# rubocop:todo-next-line all', true
    include_examples 'checks disabled_next_line?',
                     'when disabled current line', 'def foo # rubocop:disable all', false
    include_examples 'checks disabled_next_line?',
                     'when disabled few lines', '# rubocop:disable Foo/Bar', false
  end
end
