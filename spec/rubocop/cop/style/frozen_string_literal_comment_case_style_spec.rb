# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::FrozenStringLiteralCommentCaseStyle, :config do
  subject(:cop) { described_class.new(config) }

  context 'snake case' do
    let(:cop_config) do
      { 'Enabled'       => true,
        'EnforcedStyle' => 'snake' }
    end

    it 'accepts a frozen string literal in snake case' do
      expect_no_offenses(<<~RUBY)
        # frozen_string_literal: true

        puts 1
      RUBY
    end

    it 'accepts an empty source' do
      expect_no_offenses('')
    end

    it 'accepts a source with no tokens' do
      expect_no_offenses(' ')
    end

    it 'accepts a source with a different magic comment' do
      expect_no_offenses(<<~RUBY)
        # encoding: UTF-8
      RUBY
    end

    it 'registers an offence for kebab case' do
      expect_offense(<<~RUBY)
        # frozen-string-literal: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Frozen string literal comment must be in snake case.

        puts 1
      RUBY

      expect_correction(<<~RUBY)
        # frozen_string_literal: true

        puts 1
      RUBY
    end

    it 'registers an offence for mixed case' do
      expect_offense(<<~RUBY)
        # frozen-string_literal: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Frozen string literal comment must be in snake case.

        puts 1
      RUBY

      expect_correction(<<~RUBY)
        # frozen_string_literal: true

        puts 1
      RUBY
    end
  end

  context 'kebab case style' do
    let(:cop_config) do
      { 'Enabled'       => true,
        'EnforcedStyle' => 'kebab' }
    end

    it 'accepts a frozen string literal in kebab case' do
      expect_no_offenses(<<~RUBY)
        # frozen-string-literal: true

        puts 1
      RUBY
    end

    it 'accepts an empty source' do
      expect_no_offenses('')
    end

    it 'accepts a source with no tokens' do
      expect_no_offenses(' ')
    end

    it 'accepts a source with a different magic comment' do
      expect_no_offenses(<<~RUBY)
        # encoding: UTF-8
      RUBY
    end

    it 'registers an offence for snake case' do
      expect_offense(<<~RUBY)
        # frozen_string_literal: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Frozen string literal comment must be in kebab case.

        puts 1
      RUBY

      expect_correction(<<~RUBY)
        # frozen-string-literal: true

        puts 1
      RUBY
    end

    it 'registers an offence for mixed case' do
      expect_offense(<<~RUBY)
        # frozen-string_literal: true
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Frozen string literal comment must be in kebab case.

        puts 1
      RUBY

      expect_correction(<<~RUBY)
        # frozen-string-literal: true

        puts 1
      RUBY
    end
  end
end
