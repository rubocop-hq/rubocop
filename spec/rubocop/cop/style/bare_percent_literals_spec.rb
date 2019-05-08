# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::BarePercentLiterals, :config do
  subject(:cop) { described_class.new(config) }

  shared_examples 'accepts other delimiters' do
    it 'accepts __FILE__' do
      expect_no_offenses('__FILE__')
    end

    it 'accepts regular expressions' do
      expect_no_offenses('/%Q?/')
    end

    it 'accepts ""' do
      expect_no_offenses('""')
    end

    it 'accepts "" string with interpolation' do
      expect_no_offenses('"#{file}hi"')
    end

    it "accepts ''" do
      expect_no_offenses("'hi'")
    end

    it 'accepts %q' do
      expect_no_offenses('%q(hi)')
    end

    it 'accepts heredoc' do
      expect_no_offenses(<<~RUBY)
        func <<HEREDOC
        hi
        HEREDOC
      RUBY
    end
  end

  context 'when EnforcedStyle is percent_q' do
    let(:cop_config) { { 'EnforcedStyle' => 'percent_q' } }

    context 'and strings are static' do
      it 'registers an offense for %()' do
        expect_offense(<<~RUBY)
          %(hi)
          ^^ Use `%Q` instead of `%`.
        RUBY
      end

      it 'auto-corrects' do
        new_source = autocorrect_source('%(hi)')
        expect(new_source).to eq('%Q(hi)')
      end

      it 'accepts %Q()' do
        expect_no_offenses('%Q(hi)')
      end

      include_examples 'accepts other delimiters'
    end

    context 'and strings are dynamic' do
      it 'registers an offense for %()' do
        expect_offense(<<~'RUBY')
          %(#{x})
          ^^ Use `%Q` instead of `%`.
        RUBY
      end

      it 'auto-corrects' do
        new_source = autocorrect_source('%(#{x})')
        expect(new_source).to eq('%Q(#{x})')
      end

      it 'accepts %Q()' do
        expect_no_offenses('%Q(#{x})')
      end

      include_examples 'accepts other delimiters'
    end
  end

  context 'when EnforcedStyle is bare_percent' do
    let(:cop_config) { { 'EnforcedStyle' => 'bare_percent' } }

    context 'and strings are static' do
      it 'registers an offense for %Q()' do
        expect_offense(<<~RUBY)
          %Q(hi)
          ^^^ Use `%` instead of `%Q`.
        RUBY
      end

      it 'auto-corrects' do
        new_source = autocorrect_source('%Q(hi)')
        expect(new_source).to eq('%(hi)')
      end

      it 'accepts %()' do
        expect_no_offenses('%(hi)')
      end

      include_examples 'accepts other delimiters'
    end

    context 'and strings are dynamic' do
      it 'registers an offense for %Q()' do
        expect_offense(<<~'RUBY')
          %Q(#{x})
          ^^^ Use `%` instead of `%Q`.
        RUBY
      end

      it 'auto-corrects' do
        new_source = autocorrect_source('%Q(#{x})')
        expect(new_source).to eq('%(#{x})')
      end

      it 'accepts %()' do
        expect_no_offenses('%(#{x})')
      end

      include_examples 'accepts other delimiters'
    end
  end
end
