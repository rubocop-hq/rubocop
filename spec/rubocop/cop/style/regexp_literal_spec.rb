# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::RegexpLiteral, :config do
  let(:config) do
    supported_styles = { 'SupportedStyles' => %w[slashes percent_r mixed mixed_preserve] }
    RuboCop::Config.new('Style/PercentLiteralDelimiters' =>
                          percent_literal_delimiters_config,
                        'Style/RegexpLiteral' =>
                          cop_config.merge(supported_styles))
  end
  let(:percent_literal_delimiters_config) { { 'PreferredDelimiters' => { '%r' => '{}' } } }

  describe 'when regex contains slashes in interpolation' do
    let(:cop_config) { { 'EnforcedStyle' => 'slashes' } }

    it 'ignores the slashes that do not belong // regex' do
      expect_no_offenses('x =~ /\s{#{x[/\s+/].length}}/')
    end
  end

  describe '%r regex with other delimiters than curly braces' do
    let(:cop_config) { { 'EnforcedStyle' => 'slashes' } }

    it 'registers an offense' do
      expect_offense(<<~RUBY)
        %r_ls_
        ^^^^^^ Use `//` around regular expression.
      RUBY
    end
  end

  describe 'when PercentLiteralDelimiters is configured with brackets' do
    let(:cop_config) { { 'EnforcedStyle' => 'percent_r' } }
    let(:percent_literal_delimiters_config) { { 'PreferredDelimiters' => { '%r' => '[]' } } }

    it 'respects the configuration when auto-correcting' do
      expect_offense(<<~RUBY)
        /a/
        ^^^ Use `%r` around regular expression.
      RUBY

      expect_correction(<<~RUBY)
        %r[a]
      RUBY
    end
  end

  describe 'when PercentLiteralDelimiters is configured with slashes' do
    let(:cop_config) { { 'EnforcedStyle' => 'percent_r' } }
    let(:percent_literal_delimiters_config) { { 'PreferredDelimiters' => { '%r' => '//' } } }

    it 'respects the configuration when auto-correcting' do
      expect_offense(<<~'RUBY')
        /\//
        ^^^^ Use `%r` around regular expression.
      RUBY

      expect_correction(<<~'RUBY')
        %r/\//
      RUBY
    end
  end

  context 'when EnforcedStyle is set to slashes' do
    let(:cop_config) { { 'EnforcedStyle' => 'slashes' } }

    describe 'a single-line `//` regex without slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = /a/')
      end
    end

    describe 'a single-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /home\//
                ^^^^^^^^ Use `%r` around regular expression.
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{home/}
        RUBY
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'is accepted' do
          expect_no_offenses('foo = /home\\//')
        end
      end
    end

    describe 'a single-line `//` regex with slashes and interpolation' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /users\/#{user.id}\/forms/
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `%r` around regular expression.
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{users/#{user.id}/forms}
        RUBY
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'is accepted' do
          expect_no_offenses('foo = /users\/#{user.id}\/forms/')
        end
      end
    end

    describe 'a single-line `%r//` regex with slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = %r/\\//')
      end

      context 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'remains slashes after auto-correction' do
          expect_offense(<<~'RUBY')
            foo = %r/\//
                  ^^^^^^ Use `//` around regular expression.
          RUBY

          expect_correction(<<~'RUBY')
            foo = /\//
          RUBY
        end
      end
    end

    describe 'a multi-line `//` regex without slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = /
            foo
            bar
          /x
        RUBY
      end
    end

    describe 'a multi-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /
                ^ Use `%r` around regular expression.
            https?:\/\/
            example\.com
          /x
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'is accepted' do
          expect_no_offenses(<<~'RUBY')
            foo = /
              https?:\/\/
              example\.com
            /x
          RUBY
        end
      end
    end

    describe 'a single-line %r regex without slashes' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          foo = %r{a}
                ^^^^^ Use `//` around regular expression.
        RUBY

        expect_correction(<<~RUBY)
          foo = /a/
        RUBY
      end
    end

    describe 'a single-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = %r{home/}')
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'registers an offense' do
          expect_offense(<<~RUBY)
            foo = %r{home/}
                  ^^^^^^^^^ Use `//` around regular expression.
          RUBY

          expect_correction(<<~'RUBY')
            foo = /home\//
          RUBY
        end
      end
    end

    describe 'a multi-line %r regex without slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = %r{
                ^^^ Use `//` around regular expression.
            foo
            bar
          }x
        RUBY

        expect_correction(<<~'RUBY')
          foo = /
            foo
            bar
          /x
        RUBY
      end
    end

    describe 'a multi-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~'RUBY')
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'registers an offense' do
          expect_offense(<<~'RUBY')
            foo = %r{
                  ^^^ Use `//` around regular expression.
              https?://
              example\.com
            }x
          RUBY

          expect_correction(<<~'RUBY')
            foo = /
              https?:\/\/
              example\.com
            /x
          RUBY
        end
      end
    end
  end

  context 'when EnforcedStyle is set to percent_r' do
    let(:cop_config) { { 'EnforcedStyle' => 'percent_r' } }

    describe 'a single-line `//` regex without slashes' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          foo = /a/
                ^^^ Use `%r` around regular expression.
        RUBY

        expect_correction(<<~RUBY)
          foo = %r{a}
        RUBY
      end
    end

    describe 'a single-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /home\//
                ^^^^^^^^ Use `%r` around regular expression.
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{home/}
        RUBY
      end
    end

    describe 'a multi-line `//` regex without slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /
                ^ Use `%r` around regular expression.
            foo
            bar
          /x
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{
            foo
            bar
          }x
        RUBY
      end
    end

    describe 'a multi-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /
                ^ Use `%r` around regular expression.
            https?:\/\/
            example\.com
          /x
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end
    end

    describe 'a single-line %r regex without slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = %r{a}')
      end
    end

    describe 'a single-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = %r{home/}')
      end
    end

    describe 'a multi-line %r regex without slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{
            foo
            bar
          }x
        RUBY
      end
    end

    describe 'a multi-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end
    end
  end

  context 'when EnforcedStyle is set to mixed' do
    let(:cop_config) { { 'EnforcedStyle' => 'mixed' } }

    describe 'a single-line `//` regex without slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = /a/')
      end
    end

    describe 'a single-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /home\//
                ^^^^^^^^ Use `%r` around regular expression.
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{home/}
        RUBY
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'is accepted' do
          expect_no_offenses('foo = /home\\//')
        end
      end
    end

    describe 'a multi-line `//` regex without slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /
                ^ Use `%r` around regular expression.
            foo
            bar
          /x
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{
            foo
            bar
          }x
        RUBY
      end
    end

    describe 'a multi-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /
                ^ Use `%r` around regular expression.
            https?:\/\/
            example\.com
          /x
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end
    end

    describe 'a single-line %r regex without slashes' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          foo = %r{a}
                ^^^^^ Use `//` around regular expression.
        RUBY

        expect_correction(<<~RUBY)
          foo = /a/
        RUBY
      end
    end

    describe 'a single-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = %r{home/}')
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'registers an offense' do
          expect_offense(<<~RUBY)
            foo = %r{home/}
                  ^^^^^^^^^ Use `//` around regular expression.
          RUBY

          expect_correction(<<~'RUBY')
            foo = /home\//
          RUBY
        end
      end
    end

    describe 'a multi-line %r regex without slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{
            foo
            bar
          }x
        RUBY
      end
    end

    describe 'a multi-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end
    end
  end

  context 'when EnforcedStyle is set to mixed_preserve' do
    let(:cop_config) { { 'EnforcedStyle' => 'mixed_preserve' } }

    describe 'a single-line `//` regex without slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = /a/')
      end
    end

    describe 'a single-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /home\//
                ^^^^^^^^ Use `%r` around regular expression.
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{home/}
        RUBY
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'is accepted' do
          expect_no_offenses('foo = /home\\//')
        end
      end
    end

    describe 'a multi-line `//` regex without slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~'RUBY')
          foo = /
            foo
            bar
          /x
        RUBY
      end
    end

    describe 'a multi-line `//` regex with slashes' do
      it 'registers an offense' do
        expect_offense(<<~'RUBY')
          foo = /
                ^ Use `%r` around regular expression.
            https?:\/\/
            example\.com
          /x
        RUBY

        expect_correction(<<~'RUBY')
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end
    end

    describe 'a single-line %r regex without slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{a}
        RUBY
      end
    end

    describe 'a single-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses('foo = %r{home/}')
      end

      describe 'when configured to allow inner slashes' do
        before { cop_config['AllowInnerSlashes'] = true }

        it 'is accepted' do
          expect_no_offenses(<<~RUBY)
            foo = %r{home/}
          RUBY
        end
      end
    end

    describe 'a multi-line %r regex without slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{
            foo
            bar
          }x
        RUBY
      end
    end

    describe 'a multi-line %r regex with slashes' do
      it 'is accepted' do
        expect_no_offenses(<<~RUBY)
          foo = %r{
            https?://
            example\.com
          }x
        RUBY
      end
    end
  end
end
