# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::TrailingWhitespace, :config do
  let(:cop_config) { { 'AllowInHeredoc' => false } }

  it 'registers an offense for a line ending with space' do
    expect_offense(<<~RUBY)
      x = 0#{trailing_whitespace}
           ^ Trailing whitespace detected.
    RUBY
  end

  it 'registers an offense for a blank line with space' do
    expect_offense(<<~RUBY)
      #{trailing_whitespace * 2}
      ^^ Trailing whitespace detected.
    RUBY
  end

  it 'registers an offense for a line ending with tab' do
    expect_offense(<<~RUBY)
      x = 0\t
           ^ Trailing whitespace detected.
    RUBY
  end

  it 'registers an offense for trailing whitespace in a heredoc string' do
    expect_offense(<<~RUBY)
      x = <<HEREDOC
        Hi#{trailing_whitespace * 3}
          ^^^ Trailing whitespace detected.
      HEREDOC
    RUBY
  end

  it 'registers offenses before __END__ but not after' do
    expect_offense(<<~RUBY)
      x = 0\t
           ^ Trailing whitespace detected.
      #{trailing_whitespace}
      ^ Trailing whitespace detected.
      __END__
      x = 0\t
    RUBY
  end

  it 'is not fooled by __END__ within a documentation comment' do
    expect_offense(<<~RUBY)
      x = 0\t
           ^ Trailing whitespace detected.
      =begin
      __END__
      =end
      x = 0\t
           ^ Trailing whitespace detected.
    RUBY
  end

  it 'is not fooled by heredoc containing __END__' do
    expect_offense(<<~RUBY)
      x1 = <<HEREDOC#{trailing_whitespace}
                    ^ Trailing whitespace detected.
      __END__
      x2 = 0\t
            ^ Trailing whitespace detected.
      HEREDOC
      x3 = 0\t
            ^ Trailing whitespace detected.
    RUBY
  end

  it 'is not fooled by heredoc containing __END__ within a doc comment' do
    expect_offense(<<~RUBY)
      x1 = <<HEREDOC#{trailing_whitespace}
                    ^ Trailing whitespace detected.
      =begin#{trailing_whitespace * 2}
            ^^ Trailing whitespace detected.
      __END__
      =end
      x2 = 0\t
            ^ Trailing whitespace detected.
      HEREDOC
      x3 = 0\t
            ^ Trailing whitespace detected.
    RUBY
  end

  it 'accepts a line without trailing whitespace' do
    expect_no_offenses('x = 0')
  end

  it 'auto-corrects unwanted space' do
    expect_offense(<<~RUBY)
      x = 0#{trailing_whitespace}
           ^ Trailing whitespace detected.
      x = 0\t
           ^ Trailing whitespace detected.
    RUBY

    expect_correction(<<~RUBY)
      x = 0
      x = 0
    RUBY
  end

  context 'when `AllowInHeredoc` is set to true' do
    let(:cop_config) { { 'AllowInHeredoc' => true } }

    it 'accepts trailing whitespace in a heredoc string' do
      expect_no_offenses(<<~RUBY)
        x = <<HEREDOC
          Hi#{trailing_whitespace * 3}
        HEREDOC
      RUBY
    end

    it 'registers an offense for trailing whitespace at the heredoc begin' do
      expect_offense(<<~RUBY)
        x = <<HEREDOC#{trailing_whitespace}
                     ^ Trailing whitespace detected.
          Hi#{trailing_whitespace * 3}
        HEREDOC
      RUBY
    end
  end
end
