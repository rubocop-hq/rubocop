# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Style::MultilineMemoization, :config do
  subject(:cop) { described_class.new(config) }

  before do
    inspect_source(cop, source)
  end

  shared_examples 'code with offense' do |code, expected = nil|
    let(:source) { code }

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.messages).to eq([message])
    end

    if expected
      it 'auto-corrects' do
        expect(autocorrect_source(cop, code)).to eq(expected)
      end
    else
      it 'does not auto-correct' do
        expect(autocorrect_source(cop, code)).to eq(code)
      end
    end
  end

  shared_examples 'code without offense' do |code|
    let(:source) { code }

    it 'does not register an offense' do
      expect(cop.offenses).to be_empty
    end
  end

  let(:message) { described_class::MSG }

  context 'with a single line memoization' do
    it_behaves_like 'code without offense',
                    'foo ||= bar'

    it_behaves_like 'code without offense',
                    ['foo ||=',
                     '  bar'].join("\n")
  end

  context 'with a multiline memoization' do
    context 'without a `begin` and `end` block' do
      context 'when the expression is wrapped in parentheses' do
        it_behaves_like 'code with offense',
                        ['foo ||= (',
                         '  bar',
                         '  baz',
                         ')'].join("\n"),
                        ['foo ||= begin',
                         '  bar',
                         '  baz',
                         'end'].join("\n")

        it_behaves_like 'code with offense',
                        ['foo ||=',
                         '  (',
                         '    bar',
                         '    baz',
                         '  )'].join("\n"),
                        ['foo ||=',
                         '  begin',
                         '    bar',
                         '    baz',
                         '  end'].join("\n")
      end

      context 'when there is another block on the first line' do
        it_behaves_like 'code without offense',
                        ['foo ||= bar.each do |b|',
                         '  b.baz',
                         '  bb.ax',
                         'end'].join("\n")
      end

      context 'when there is another block on the following line' do
        it_behaves_like 'code without offense',
                        ['foo ||=',
                         '  bar.each do |b|',
                         '    b.baz',
                         '    b.bax',
                         '  end'].join("\n")
      end

      context 'when there is a conditional on the first line' do
        it_behaves_like 'code without offense',
                        ['foo ||= if bar',
                         '          baz',
                         '        else',
                         '          bax',
                         '        end'].join("\n")
      end

      context 'when there is a conditional on the following line' do
        it_behaves_like 'code without offense',
                        ['foo ||=',
                         '  if bar',
                         '    baz',
                         '  else',
                         '    bax',
                         '  end'].join("\n")
      end
    end

    context 'with a `begin` and `end` block on the first line' do
      it_behaves_like 'code without offense',
                      ['foo ||= begin',
                       '  bar',
                       '  baz',
                       'end'].join("\n")
    end

    context 'with a `begin` and `end` block on the following line' do
      it_behaves_like 'code without offense',
                      ['foo ||=',
                       '  begin',
                       '  bar',
                       '  baz',
                       'end'].join("\n")
    end
  end
end
