# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::IndentationStyle, :config do
  let(:config) do
    supported_styles = { 'SupportedStyles' => %w[spaces tabs] }
    RuboCop::Config.new(
      'Layout/IndentationWidth' => { 'Width' => 2 },
      'Layout/IndentationStyle' => cop_config.merge(supported_styles)
    )
  end

  context 'when EnforcedStyle is spaces' do
    let(:cop_config) { { 'EnforcedStyle' => 'spaces' } }

    it 'registers and corrects an offense for a line indented with tab' do
      expect_offense(<<~RUBY)
        \tx = 0
        ^ Tab detected in indentation.
      RUBY

      expect_correction(<<-RUBY.strip_margin('|'))
        |  x = 0
      RUBY
    end

    it 'registers and corrects an offense for a line indented with multiple tabs' do
      expect_offense(<<~RUBY)
        \t\t\tx = 0
        ^^^ Tab detected in indentation.
      RUBY

      expect_correction(<<-RUBY.strip_margin('|'))
        |      x = 0
      RUBY
    end

    it 'registers and corrects an offense for a line indented with mixed whitespaces' do
      expect_offense(<<~RUBY)
         \tx = 0
        ^^ Tab detected in indentation.
      RUBY

      expect_correction(<<-RUBY.strip_margin('|'))
        |   x = 0
      RUBY
    end

    it 'registers offenses before __END__ but not after' do
      expect_offense(<<~RUBY)
        \tx = 0
        ^ Tab detected in indentation.
        __END__
        \tx = 0
      RUBY

      expect_correction(<<~RUBY)
        #{' ' * 2}x = 0
        __END__
        \tx = 0
      RUBY
    end

    it 'accepts a line with a tab other than indentation' do
      expect_no_offenses("foo \t bar")
    end

    it 'accepts a line with a tab between string literals' do
      expect_no_offenses("'foo'\t'bar'")
    end

    it 'accepts a line with tab in a string' do
      expect_no_offenses("(x = \"\t\")")
    end

    it 'accepts a line which begins with tab in a string' do
      expect_no_offenses("x = '\n\thello'")
    end

    it 'accepts a line which begins with tab in a heredoc' do
      expect_no_offenses("x = <<HELLO\n\thello\nHELLO")
    end

    it 'accepts a line which begins with tab in a multiline heredoc' do
      expect_no_offenses("x = <<HELLO\n\thello\n\t\n\t\t\nhello\nHELLO")
    end

    it 'registers and corrects an offense for a line with tab in a string indented with tab' do
      expect_offense(<<~RUBY)
        \t(x = "\t")
        ^ Tab detected in indentation.
      RUBY

      expect_correction(<<-RUBY.strip_margin('|'))
        |  (x = "\t")
      RUBY
    end

    context 'custom indentation width' do
      let(:cop_config) { { 'IndentationWidth' => 3, 'EnforcedStyle' => 'spaces' } }

      it 'uses the configured number of spaces to replace a tab' do
        expect_offense(<<~RUBY)
          \tx = 0
          ^ Tab detected in indentation.
        RUBY

        expect_correction(<<-RUBY.strip_margin('|'))
          |   x = 0
        RUBY
      end
    end
  end

  context 'when EnforcedStyle is tabs' do
    let(:cop_config) { { 'EnforcedStyle' => 'tabs' } }

    it 'registers and corrects an offense for a line indented with space' do
      expect_offense(<<~RUBY)
          x = 0
        ^^ Space detected in indentation.
      RUBY

      expect_correction(<<~RUBY)
        \tx = 0
      RUBY
    end

    it 'registers and corrects an offense for a line indented with multiple spaces' do
      expect_offense(<<~RUBY)
              x = 0
        ^^^^^^ Space detected in indentation.
      RUBY

      expect_correction(<<~RUBY)
        \t\t\tx = 0
      RUBY
    end

    it 'registers an offense for a line indented with mixed whitespace' do
      expect_offense(<<~RUBY)
         \tx = 0
        ^ Space detected in indentation.
      RUBY

      expect_correction(<<~RUBY)
        \tx = 0
      RUBY
    end

    it 'registers offenses before __END__ but not after' do
      expect_offense(<<~RUBY)
          x = 0
        ^^ Space detected in indentation.
        __END__
          x = 0
      RUBY

      expect_correction(<<~RUBY)
        \tx = 0
        __END__
          x = 0
      RUBY
    end

    it 'accepts spaces that align a line after the indenting tab' do
      expect_no_offenses(<<~RUBY)
        a = {
        \tbb: 1,
        \t c: 2
        }
      RUBY
    end

    it 'accepts a line a tab other than indentation' do
      expect_no_offenses("\tfoo \t bar")
    end

    it 'accepts a line with tabs between string literals' do
      expect_no_offenses("'foo'\t'bar'")
    end

    it 'accepts a line with tab in a string' do
      expect_no_offenses("(x = \"\t\")")
    end

    it 'accepts a line which begins with tab in a string' do
      expect_no_offenses("x = '\n\thello'")
    end

    it 'accepts a line which begins with tab in a heredoc' do
      expect_no_offenses("x = <<HELLO\n\thello\nHELLO")
    end

    it 'accepts a line which begins with tab in a multiline heredoc' do
      expect_no_offenses("x = <<HELLO\n\thello\n\t\n\t\t\nhello\nHELLO")
    end

    it 'accepts a line with tab indentation followed by spaces for alignment' do
      expect_no_offenses(<<~RUBY)
        \ts.description = 'Use foo' \\
        \t                ' as bar.'
      RUBY
    end

    it 'registers and corrects an offense for a line indented with fractional number of' \
       'indentation groups by rounding down' do
      expect_offense(<<~RUBY)
           x = 0
        ^^^ Space detected in indentation.
      RUBY

      expect_correction(<<~RUBY)
        \tx = 0
      RUBY
    end

    it 'registers and corrects an offense for a line with tab in a string indented with space' do
      expect_offense(<<~RUBY)
          (x = "\t")
        ^^ Space detected in indentation.
      RUBY

      expect_correction(<<~RUBY)
        \t(x = "\t")
      RUBY
    end

    context 'custom indentation width' do
      let(:cop_config) { { 'IndentationWidth' => 3, 'EnforcedStyle' => 'tabs' } }

      it 'uses the configured number of spaces to replace with a tab' do
        expect_offense(<<~RUBY)
                x = 0
          ^^^^^^ Space detected in indentation.
        RUBY

        expect_correction(<<~RUBY)
          \t\tx = 0
        RUBY
      end
    end
  end
end
