# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::StringConcatenation, :config do
  it 'registers an offense and corrects for string concatenation' do
    expect_offense(<<~RUBY)
      email_with_name = user.name + ' <' + user.email + '>'
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~RUBY)
      email_with_name = "\#{user.name} <\#{user.email}>"
    RUBY
  end

  it 'registers an offense and corrects for string concatenation as part of other expression' do
    expect_offense(<<~RUBY)
      users = (user.name + ' ' + user.email) * 5
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~RUBY)
      users = ("\#{user.name} \#{user.email}") * 5
    RUBY
  end

  it 'correctly handles strings with special characters' do
    expect_offense(<<~RUBY)
      email_with_name = "\\n" + user.name + ' ' + user.email + '\\n'
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~RUBY)
      email_with_name = "\\n\#{user.name} \#{user.email}\\\\n"
    RUBY
  end

  it 'preserves the escape notation of double-quoted strings' do
    expect_offense(<<~'RUBY')
      "\x0a" + "test" + "A" + "\xff"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~'RUBY')
      "\x0atestA\xff"
    RUBY
  end

  it 'escapes a `#` that would start an interpolation with the next part' do
    expect_offense(<<~'RUBY')
      "#" + "{" + '#' + '@foo' + "#" + "$bar" + "\#" + "{"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~'RUBY')
      "\#{\#@foo\#$bar\#{"
    RUBY
  end

  it 'correctly handles nested concatenatable parts' do
    expect_offense(<<~RUBY)
      (user.vip? ? greeting + ', ' : '') + user.name + ' <' + user.email + '>'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
                   ^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~RUBY)
      "\#{user.vip? ? "\#{greeting}, " : ''}\#{user.name} <\#{user.email}>"
    RUBY
  end

  it 'correctly handles nested concatenatable parts and escaped double-quotes' do
    expect_offense(<<~'RUBY')
      "foo" + "\"#{bar}\"" + 'baz'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~'RUBY')
      "foo\"#{bar}\"baz"
    RUBY
  end

  it 'correctly handles nested concatenatable parts and escaped single-quotes' do
    expect_offense(<<~'RUBY')
      "foo" + "\'#{bar}\'" + 'baz'
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
    RUBY

    expect_correction(<<~'RUBY')
      "foo'#{bar}'baz"
    RUBY
  end

  it 'does not register an offense when using `+` with all non string arguments' do
    expect_no_offenses(<<~RUBY)
      user.name + user.email
    RUBY
  end

  context 'implicit concatenation' do
    it 'registers an offense and corrects with implicit concatenation at the end' do
      expect_offense(<<~RUBY)
        "a" + "b" "c"
        ^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~RUBY)
        "abc"
      RUBY
    end

    it 'registers an offense and corrects with implicit concatenation at the start' do
      expect_offense(<<~RUBY)
        "a" "b" + "c"
        ^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~RUBY)
        "abc"
      RUBY
    end

    it 'registers an offense and corrects with implicit concatenation at the middle' do
      expect_offense(<<~RUBY)
        "a" + "b" "c" + "d"
        ^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~RUBY)
        "abcd"
      RUBY
    end

    it 'registers an offense and corrects with string interpolation' do
      expect_offense(<<~'RUBY')
        "string #{interpolation}" 'foo' + 'bar'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "string #{interpolation}foobar"
      RUBY
    end
  end

  context 'multiline' do
    context 'string continuation' do
      it 'does not register an offense' do
        # handled by `Style/LineEndConcatenation` instead.
        expect_no_offenses(<<~RUBY)
          "this is a long string " +
            "this is a continuation"
        RUBY
      end
    end

    context 'simple expressions' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          email_with_name = user.name +
                            ^^^^^^^^^^^ Prefer string interpolation to string concatenation.
            ' ' +
            user.email +
            '\\n'
        RUBY

        expect_correction(<<~RUBY)
          email_with_name = "\#{user.name} \#{user.email}\\\\n"
        RUBY
      end
    end

    context 'if condition' do
      it 'registers an offense but does not correct' do
        expect_offense(<<~RUBY)
          "result:" + if condition
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
            "true"
          else
            "false"
          end
        RUBY

        expect_no_corrections
      end
    end

    context 'multiline block' do
      it 'registers an offense but does not correct' do
        expect_offense(<<~RUBY)
          '(' + values.map do |v|
          ^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
              v.titleize
          end.join(', ') + ')'
        RUBY

        expect_no_corrections
      end
    end
  end

  context 'nested interpolation' do
    it 'registers an offense and corrects' do
      expect_offense(<<~'RUBY')
        "foo" + "bar: #{baz}"
        ^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "foobar: #{baz}"
      RUBY
    end
  end

  context 'inline block' do
    it 'registers an offense but does not correct' do
      expect_offense(<<~RUBY)
        '(' + values.map { |v| v.titleize }.join(', ') + ')'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_no_corrections
    end

    it 'registers an offense but does not correct for numblocks' do
      expect_offense(<<~RUBY)
        '(' + values.map { _1.titleize }.join(', ') + ')'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_no_corrections
    end
  end

  context 'heredoc' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        "foo" + <<~STR
          text
        STR
      RUBY
    end

    it 'does not register an offense when string concatenation with multiline heredoc text' do
      expect_no_offenses(<<~RUBY)
        "foo" + <<~TEXT
          bar
          baz
        TEXT
      RUBY
    end

    it 'does not register an offense when the heredoc is parenthesized' do
      expect_no_offenses(<<~RUBY)
        (<<~STR) + 'foo'
          text
        STR
      RUBY
    end

    it 'does not register an offense when a method is called on the heredoc' do
      expect_no_offenses(<<~RUBY)
        'foo' + <<~STR.strip + 'bar'
          text
        STR
      RUBY
    end
  end

  context 'with `__FILE__`' do
    it 'registers an offense and corrects by interpolating `__FILE__`' do
      expect_offense(<<~RUBY)
        __FILE__ + '/c'
        ^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "#{__FILE__}/c"
      RUBY
    end

    it 'registers an offense and corrects when an interpolated string spells out `__FILE__`' do
      expect_offense(<<~'RUBY')
        "__FILE__#{c}" + 'd'
        ^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "__FILE__#{c}d"
      RUBY
    end
  end

  context 'double quotes inside string' do
    it 'registers an offense and corrects with double quotes' do
      expect_offense(<<~'RUBY')
        email_with_name = "He said " + "\"Arrest that man!\"."
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        email_with_name = "He said \"Arrest that man!\"."
      RUBY
    end

    it 'registers an offense and corrects with percentage quotes' do
      expect_offense(<<~RUBY)
        email_with_name = %(He said ) + %("Arrest that man!".)
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        email_with_name = "He said \"Arrest that man!\"."
      RUBY
    end

    it 'registers an offense and corrects with interpolated percentage quotes containing quotes' do
      expect_offense(<<~'RUBY')
        command = %(clone "#{ref}" "#{url}" && ) + %(echo "done")
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        command = "clone \"#{ref}\" \"#{url}\" && echo \"done\""
      RUBY
    end
  end

  context 'empty quotes' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        '"' + "foo" + '"'
        ^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
        '"' + "foo" + "'"
        ^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
        "'" + "foo" + '"'
        ^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
        "'" + "foo" + '"' + "bar"
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "\"foo\""
        "\"foo'"
        "'foo\""
        "'foo\"bar"
      RUBY
    end
  end

  context 'double quotes inside string surrounded single quotes' do
    it 'registers an offense and corrects with double quotes' do
      expect_offense(<<~RUBY)
        '"bar"' + foo
        ^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "\"bar\"#{foo}"
      RUBY
    end
  end

  context 'characters for interpolation inside single quotes' do
    it 'registers an offense for `#{}`' do
      expect_offense(<<~'RUBY')
        "foo" + '#{bar}'
        ^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "foo\#{bar}"
      RUBY
    end

    it 'registers an offense for `#@`' do
      expect_offense(<<~'RUBY')
        "foo" + '#@bar'
        ^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "foo\#@bar"
      RUBY
    end

    it 'registers an offense for `#@@`' do
      expect_offense(<<~'RUBY')
        "foo" + '#@@bar'
        ^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "foo\#@@bar"
      RUBY
    end

    it 'registers an offense for `#$`' do
      expect_offense(<<~'RUBY')
        "foo" + '#$bar'
        ^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
      RUBY

      expect_correction(<<~'RUBY')
        "foo\#$bar"
      RUBY
    end
  end

  context 'Mode = conservative' do
    let(:cop_config) { { 'Mode' => 'conservative' } }

    context 'when first operand is not string literal' do
      it 'does not register offense' do
        expect_no_offenses(<<~RUBY)
          user.name + "!!"
          user.name + "<"
          user.name + "<" + "user.email" + ">"
        RUBY
      end
    end

    context 'when first operand is string literal' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          "Hello " + user.name
          ^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
          "Hello " + user.name + "!!"
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer string interpolation to string concatenation.
        RUBY

        expect_correction(<<~RUBY)
          "Hello \#{user.name}"
          "Hello \#{user.name}!!"
        RUBY
      end
    end
  end
end
