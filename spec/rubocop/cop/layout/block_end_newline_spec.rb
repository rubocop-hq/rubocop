# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::BlockEndNewline, :config do
  it 'accepts a one-liner' do
    expect_no_offenses('test do foo end')
  end

  it 'accepts multiline blocks with newlines before the end' do
    expect_no_offenses(<<~RUBY)
      test do
        foo
      end
    RUBY
  end

  it 'does not register an offense when multiline blocks with newlines before the `; end`' do
    expect_no_offenses(<<~RUBY)
      test do
        foo
      ; end
    RUBY
  end

  it 'registers an offense and corrects when multiline block end is not on its own line' do
    expect_offense(<<~RUBY)
      test do
        foo end
            ^^^ Expression at 2, 7 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      test do
        foo
      end
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line' do
    expect_offense(<<~RUBY)
      test {
        foo }
            ^ Expression at 2, 7 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo
      }
    RUBY
  end

  it 'registers an offense and corrects when `}` of multiline block ' \
     'without processing is not on its own line' do
    expect_offense(<<~RUBY)
      test {
        |foo| }
              ^ Expression at 2, 9 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      test {
        |foo|
      }
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
     'and using method chain' do
    expect_offense(<<~RUBY)
      test {
        foo }.bar.baz
            ^ Expression at 2, 7 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo
      }.bar.baz
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
     'and it is used as multiple arguments' do
    expect_offense(<<~RUBY)
      foo(one {
        x }, two {
          ^ Expression at 2, 5 should be on its own line.
        y })
          ^ Expression at 3, 5 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      foo(one {
        x
      }, two {
        y
      })
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
     'and using heredoc argument' do
    expect_offense(<<~RUBY)
      test {
        foo(<<~EOS) }
                    ^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo(<<~EOS)
          Heredoc text.
        EOS
      }
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
     'and using multiple heredoc arguments' do
    expect_offense(<<~RUBY)
      test {
        foo(<<~FIRST, <<~SECOND) }
                                 ^ Expression at 2, 28 should be on its own line.
          Heredoc text.
        FIRST
          Heredoc text.
        SECOND
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo(<<~FIRST, <<~SECOND)
          Heredoc text.
        FIRST
          Heredoc text.
        SECOND
      }
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
     'and using heredoc argument with method chain' do
    expect_offense(<<~RUBY)
      test {
        foo(<<~EOS).bar }
                        ^ Expression at 2, 19 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo(<<~EOS).bar
          Heredoc text.
        EOS
      }
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
     'and using multiple heredoc argument method chain' do
    expect_offense(<<~RUBY)
      test {
        foo(<<~FIRST).bar(<<~SECOND) }
                                     ^ Expression at 2, 32 should be on its own line.
          Heredoc text.
        FIRST
          Heredoc text.
        SECOND
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo(<<~FIRST).bar(<<~SECOND)
          Heredoc text.
        FIRST
          Heredoc text.
        SECOND
      }
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is followed by an expression and using heredoc argument' do
    expect_offense(<<~RUBY)
      x = test {
        foo(<<~EOS) } + bar
                    ^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      x = test {
        foo(<<~EOS)
          Heredoc text.
        EOS
      } + bar
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is followed by a method call and using heredoc argument' do
    expect_offense(<<~RUBY)
      test {
        foo(<<~EOS) }.bar
                    ^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo(<<~EOS)
          Heredoc text.
        EOS
      }.bar
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is followed by the rest of the arguments and using heredoc argument' do
    expect_offense(<<~RUBY)
      do_something(test {
        foo(<<~EOS) }, bar)
                    ^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      do_something(test {
        foo(<<~EOS)
          Heredoc text.
        EOS
      }, bar)
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is followed by a comment and using heredoc argument' do
    expect_offense(<<~RUBY)
      test {
        foo(<<~EOS) } # comment
                    ^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      test {
        foo(<<~EOS) # comment
          Heredoc text.
        EOS
      }
    RUBY
  end

  it 'registers an offense and corrects when multiline block `}` is followed by an expression and a comment and using heredoc argument' do
    expect_offense(<<~RUBY)
      x = test {
        foo(<<~EOS) } + bar # comment
                    ^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      x = test {
        foo(<<~EOS) # comment
          Heredoc text.
        EOS
      } + bar
    RUBY
  end

  it 'registers an offense and corrects when multiline block `end` is followed by a method call and using heredoc argument' do
    expect_offense(<<~RUBY)
      test do
        foo(<<~EOS) end.bar
                    ^^^ Expression at 2, 15 should be on its own line.
          Heredoc text.
        EOS
    RUBY

    expect_correction(<<~RUBY)
      test do
        foo(<<~EOS)
          Heredoc text.
        EOS
      end.bar
    RUBY
  end

  it 'registers an offense and corrects when nested multiline blocks `} }` close on the line of a heredoc argument' do
    expect_offense(<<~RUBY)
      test {
        do_something {
          foo(<<~EOS) } }
                      ^ Expression at 3, 17 should be on its own line.
                        ^ Expression at 3, 19 should be on its own line.
            Heredoc text.
          EOS
    RUBY

    expect_correction(<<~RUBY)
      test {
        do_something {
          foo(<<~EOS)
            Heredoc text.
          EOS
      }
      }
    RUBY
  end

  it 'registers an offense and corrects when nested multiline blocks `end end` close on the line of a heredoc argument' do
    expect_offense(<<~RUBY)
      test do
        do_something do
          foo(<<~EOS) end end
                      ^^^ Expression at 3, 17 should be on its own line.
                          ^^^ Expression at 3, 21 should be on its own line.
            Heredoc text.
          EOS
    RUBY

    expect_correction(<<~RUBY)
      test do
        do_something do
          foo(<<~EOS)
            Heredoc text.
          EOS
      end
      end
    RUBY
  end

  it 'registers an offense and corrects when a multiline block ends with a hash' do
    expect_offense(<<~RUBY)
      foo {
        { bar: :baz } }
                      ^ Expression at 2, 17 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      foo {
        { bar: :baz }
      }
    RUBY
  end

  it 'registers an offense and corrects when a multiline block ends with a method call with hash arguments' do
    expect_offense(<<~RUBY)
      foo {
        bar(baz: :quux) }
                        ^ Expression at 2, 19 should be on its own line.
    RUBY

    expect_correction(<<~RUBY)
      foo {
        bar(baz: :quux)
      }
    RUBY
  end

  context 'Ruby 2.7', :ruby27 do
    it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
       'and using method chain' do
      expect_offense(<<~RUBY)
        test {
          _1 }.bar.baz
             ^ Expression at 2, 6 should be on its own line.
      RUBY

      expect_correction(<<~RUBY)
        test {
          _1
        }.bar.baz
      RUBY
    end

    it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
       'and using heredoc argument' do
      expect_offense(<<~RUBY)
        test {
          _1.push(<<~EOS) }
                          ^ Expression at 2, 19 should be on its own line.
            Heredoc text.
          EOS
      RUBY

      expect_correction(<<~RUBY)
        test {
          _1.push(<<~EOS)
            Heredoc text.
          EOS
        }
      RUBY
    end
  end

  context 'Ruby 3.4', :ruby34 do
    it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
       'and using method chain' do
      expect_offense(<<~RUBY)
        test {
          it }.bar.baz
             ^ Expression at 2, 6 should be on its own line.
      RUBY

      expect_correction(<<~RUBY)
        test {
          it
        }.bar.baz
      RUBY
    end

    it 'registers an offense and corrects when multiline block `}` is not on its own line ' \
       'and using heredoc argument' do
      expect_offense(<<~RUBY)
        test {
          it.push(<<~EOS) }
                          ^ Expression at 2, 19 should be on its own line.
            Heredoc text.
          EOS
      RUBY

      expect_correction(<<~RUBY)
        test {
          it.push(<<~EOS)
            Heredoc text.
          EOS
        }
      RUBY
    end
  end
end
