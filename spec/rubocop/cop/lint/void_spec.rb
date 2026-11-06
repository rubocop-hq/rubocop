# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::Void, :config do
  described_class::BINARY_OPERATORS.each do |op|
    it "registers an offense for void op #{op} if not on last line" do
      expect_offense(<<~RUBY, op: op)
        a %{op} b
          ^{op} Operator `#{op}` used in void context.
        a %{op} b
          ^{op} Operator `#{op}` used in void context.
        a %{op} b
      RUBY

      expect_correction(<<~RUBY)
        a
        b
        a
        b
        a #{op} b
      RUBY
    end

    it "accepts void op #{op} if on last line" do
      expect_no_offenses(<<~RUBY)
        something
        a #{op} b
      RUBY
    end

    it "accepts void op #{op} by itself without a begin block" do
      expect_no_offenses("a #{op} b")
    end

    it "accepts void op #{op} method call without arguments unless it is on the last line" do
      expect_no_offenses(<<~RUBY)
        a.#{op}
        something
      RUBY
    end

    it "accepts void op #{op} safe navigation method call without arguments unless it is on the last line" do
      expect_no_offenses(<<~RUBY)
        a&.#{op}
        something
      RUBY
    end

    it "registers an offense for parenthesized void op #{op} if not on last line" do
      expect_offense(<<~RUBY, op: op)
        (a %{op} b)
           ^{op} Operator `#{op}` used in void context.
        ((a %{op} b))
            ^{op} Operator `#{op}` used in void context.
        (((a %{op} b)))
      RUBY

      # NOTE: Redundant parentheses in `(var)` are left to `Style/RedundantParentheses` to fix.
      expect_correction(<<~RUBY)
        (a
        b)
        ((a
        b))
        (((a #{op} b)))
      RUBY
    end

    it "accepts parenthesized void op #{op} if on last line" do
      expect_no_offenses(<<~RUBY)
        something
        (a #{op} b)
      RUBY
    end

    it "accepts parenthesized void op #{op} by itself without a begin block" do
      expect_no_offenses("(a #{op} b)")
    end

    it 'handles methods called by dot' do
      expect_offense(<<~RUBY, op: op)
        a.%{op}(b)
          ^{op} Operator `#{op}` used in void context.
        nil
      RUBY

      expect_correction(<<~RUBY)
        a
        (b)
        nil
      RUBY
    end

    it "accepts void op #{op} method call with multiple arguments" do
      expect_no_offenses(<<~RUBY)
        a.#{op}(b, c)
        nil
      RUBY
    end

    it "accepts void op #{op} method call with keyword arguments" do
      expect_no_offenses(<<~RUBY)
        a.#{op}(key: value)
        a.#{op}(**options)
        nil
      RUBY
    end

    it "accepts void op #{op} method call with a trailing comma" do
      expect_no_offenses(<<~RUBY)
        a.#{op}(b,)
        nil
      RUBY
    end

    it "accepts void op #{op} method call with a splat argument" do
      expect_no_offenses(<<~RUBY)
        a.#{op}(*args)
        nil
      RUBY
    end

    it "accepts void op #{op} method call with a block argument" do
      expect_no_offenses(<<~RUBY)
        a.#{op}(&block)
        nil
      RUBY
    end

    it 'handles methods called by dot with a hash argument' do
      expect_offense(<<~RUBY, op: op)
        a.%{op}({key: value})
          ^{op} Operator `#{op}` used in void context.
        nil
      RUBY

      expect_correction(<<~RUBY)
        a
        ({key: value})
        nil
      RUBY
    end

    it 'handles methods called by dot with safe navigation' do
      expect_offense(<<~RUBY, op: op)
        a&.%{op}(b)
           ^{op} Operator `#{op}` used in void context.
        nil
      RUBY

      expect_correction(<<~RUBY)
        a
        (b)
        nil
      RUBY
    end
  end

  sign_unary_operators = %i[+ -]
  other_unary_operators = %i[~ !]
  unary_operators = sign_unary_operators + other_unary_operators

  sign_unary_operators.each do |op|
    it "registers an offense for void sign op #{op} if not on last line" do
      expect_offense(<<~RUBY, op: op)
        %{op}b
        ^{op} Operator `#{op}@` used in void context.
        %{op}b
        ^{op} Operator `#{op}@` used in void context.
        %{op}b
      RUBY

      expect_correction(<<~RUBY)
        b
        b
        #{op}b
      RUBY
    end
  end

  other_unary_operators.each do |op|
    it "registers an offense for void unary op #{op} if not on last line" do
      expect_offense(<<~RUBY, op: op)
        %{op}b
        ^{op} Operator `#{op}` used in void context.
        %{op}b
        ^{op} Operator `#{op}` used in void context.
        %{op}b
      RUBY

      expect_correction(<<~RUBY)
        b
        b
        #{op}b
      RUBY
    end

    it "registers an offense for void unary op #{op} with dot" do
      expect_offense(<<~RUBY, op: op)
        b.%{op}
          ^{op} Operator `#{op}` used in void context.
        b.%{op}
      RUBY

      expect_correction(<<~RUBY)
        b
        b.#{op}
      RUBY
    end

    it "registers an offense for void unary op #{op} with dot with safe navigation" do
      expect_offense(<<~RUBY, op: op)
        b&.%{op}
           ^{op} Operator `#{op}` used in void context.
        b&.%{op}
      RUBY

      expect_correction(<<~RUBY)
        b
        b&.#{op}
      RUBY
    end
  end

  unary_operators.each do |op|
    it "accepts void unary op #{op} if on last line" do
      expect_no_offenses(<<~RUBY)
        something
        #{op}b
      RUBY
    end

    it "accepts void unary op #{op} by itself without a begin block" do
      expect_no_offenses("#{op}b")
    end
  end

  %w[var @var @@var $var].each do |var|
    it "registers an offense for void var #{var} if not on last line" do
      expect_offense(<<~RUBY, var: var)
        %{var} = 5
        %{var}
        ^{var} Variable `#{var}` used in void context.
        top
      RUBY

      expect_correction(<<~RUBY)
        #{var} = 5
        top
      RUBY
    end

    it "registers an offense for void var #{var} with guard clause if not on last line" do
      expect_offense(<<~RUBY, var: var)
        %{var} = 5
        %{var} unless condition
        ^{var} Variable `#{var}` used in void context.
        top
      RUBY

      # `var unless condition` might indicate missing `return` in `return var unless condition`,
      # so for convenience, the code will not be autocorrected by deletion.
      expect_no_corrections
    end

    it "registers an offense for void var #{var} inside unless block if not on last line" do
      expect_offense(<<~RUBY, var: var)
        %{var} = 5
        unless condition
          %{var}
          ^{var} Variable `#{var}` used in void context.
        end
        top
      RUBY

      # `unless condition; var end` might indicate missing `return` or assignment,
      # so for convenience, the code will not be autocorrected by deletion.
      expect_no_corrections
    end

    it "registers an offense for void var #{var} in ternary if not on last line" do
      expect_offense(<<~RUBY, var: var)
        %{var} = 5
        condition ? %{var} : nil
                    ^{var} Variable `#{var}` used in void context.
        top
      RUBY

      # `condition ? var : nil` might indicate missing `return` or assignment,
      # so for convenience, the code will not be autocorrected by deletion.
      expect_no_corrections
    end
  end

  it 'registers an offense for void constant `CONST` if not on last line' do
    expect_offense(<<~RUBY)
      CONST = 5
      CONST
      ^^^^^ Constant `CONST` used in void context.
      top
    RUBY

    # Referencing a constant can trigger autoloading side effects, so removing it may
    # change behavior; the offense is reported but not autocorrected.
    expect_no_corrections
  end

  it 'registers an offense but does not autocorrect a qualified constant in void context' do
    expect_offense(<<~RUBY)
      Foo::Bar
      ^^^^^^^^ Constant `Foo::Bar` used in void context.

      class Foo::Bar
      end
    RUBY

    expect_no_corrections
  end

  it 'registers an offense for void constant `CONST` with guard condition if not on last line' do
    expect_offense(<<~RUBY)
      CONST = 5
      CONST unless condition
      ^^^^^ Constant `CONST` used in void context.
      top
    RUBY

    # `CONST unless condition` might indicate missing `return` in `return CONST unless condition`,
    # so for convenience, the code will not be autocorrected by deletion.
    expect_no_corrections
  end

  it 'registers an offense for void constant `CONST` within conditional if not on last line' do
    expect_offense(<<~RUBY)
      CONST = 5
      unless condition
        CONST
        ^^^^^ Constant `CONST` used in void context.
      end
      top
    RUBY

    # `unless condition; CONST end` might indicate missing `return` or assignment,
    # so for convenience, the code will not be autocorrected by deletion.
    expect_no_corrections
  end

  it 'registers an offense for void constant `CONST` within ternary if not on last line' do
    expect_offense(<<~RUBY)
      CONST = 5
      condition ? CONST : nil
                  ^^^^^ Constant `CONST` used in void context.
      top
    RUBY

    # `condition ? CONST : ...` might indicate missing `return` or assignment,
    # so for convenience, the code will not be autocorrected by deletion.
    expect_no_corrections
  end

  %w(1 2.0 :test /test/ [1] {}).each do |lit|
    it "registers an offense for void lit #{lit} if not on last line" do
      expect_offense(<<~RUBY, lit: lit)
        %{lit}
        ^{lit} Literal `#{lit}` used in void context.
        top
      RUBY

      expect_correction(<<~RUBY)

        top
      RUBY
    end

    it "registers an offense for void lit #{lit} with guard condition if not on last line" do
      expect_offense(<<~RUBY, lit: lit)
        %{lit} unless condition
        ^{lit} Literal `#{lit}` used in void context.
        top
      RUBY

      # `42 unless condition` might indicate missing `return` in `return 42 unless condition`,
      # so for convenience, the code will not be autocorrected by deletion.
      expect_no_corrections
    end

    it "registers an offense for void lit #{lit} within conditional if not on last line" do
      expect_offense(<<~RUBY, lit: lit)
        unless condition
          %{lit}
          ^{lit} Literal `#{lit}` used in void context.
        end
        top
      RUBY

      # `unless condition; 42 end` might indicate missing `return` or assignment,
      # so for convenience, the code will not be autocorrected by deletion.
      expect_no_corrections
    end

    it "registers an offense for void lit #{lit} within ternary if not on last line" do
      expect_offense(<<~RUBY, lit: lit)
        condition ? %{lit} : nil
                    ^{lit} Literal `#{lit}` used in void context.
        top
      RUBY

      # `condition ? 42 : ...` might indicate missing `return` or assignment,
      # so for convenience, the code will not be autocorrected by deletion.
      expect_no_corrections
    end
  end

  it 'registers an offense for a void heredoc and removes its body along with it' do
    expect_offense(<<~RUBY)
      <<~CSS
      ^^^^^^ Literal `<<~CSS` used in void context.
        /* comment */
      CSS
      top
    RUBY

    expect_correction(<<~RUBY)

      top
    RUBY
  end

  it 'registers an offense for a void heredoc assigned nowhere in a method body and removes it' do
    expect_offense(<<~RUBY)
      def foo
        <<-CSS
        ^^^^^^ Literal `<<-CSS` used in void context.
        /* comment */
        CSS
        1
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        1
      end
    RUBY
  end

  it 'registers an offense for void `self` if not on last line' do
    expect_offense(<<~RUBY)
      self; top
      ^^^^ `self` used in void context.
    RUBY

    expect_correction(<<~RUBY)
      ; top
    RUBY
  end

  it 'registers an offense for void `defined?` if not on last line' do
    expect_offense(<<~RUBY)
      defined?(x)
      ^^^^^^^^^^^ `defined?(x)` used in void context.
      top
    RUBY

    expect_correction(<<~RUBY)

      top
    RUBY
  end

  it 'registers an offense for void `-> { bar }` if not on last line' do
    expect_offense(<<~RUBY)
      def foo
        -> { bar }
        ^^^^^^^^^^ `-> { bar }` used in void context.
        top
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        top
      end
    RUBY
  end

  it 'does not register an offense for void `-> { bar }` if on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        top
        -> { bar }
      end
    RUBY
  end

  it 'does not register an offense for void `-> { bar }.call` if not on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        -> { bar }.call
        top
      end
    RUBY
  end

  it 'registers an offense for void `lambda { bar }` if not on last line' do
    expect_offense(<<~RUBY)
      def foo
        lambda { bar }
        ^^^^^^^^^^^^^^ `lambda { bar }` used in void context.
        top
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        top
      end
    RUBY
  end

  it 'does not register an offense for void `lambda { bar }` if on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        top
        lambda { bar }
      end
    RUBY
  end

  it 'does not register an offense for void `lambda { bar }.call` if not on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        lambda { bar }.call
        top
      end
    RUBY
  end

  it 'registers an offense for void `proc { bar }` if not on last line' do
    expect_offense(<<~RUBY)
      def foo
        proc { bar }
        ^^^^^^^^^^^^ `proc { bar }` used in void context.
        top
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        top
      end
    RUBY
  end

  it 'does not register an offense for void `proc { bar }` if on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        top
        proc { bar }
      end
    RUBY
  end

  it 'does not register an offense for void `proc { bar }.call` if not on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        proc { bar }.call
        top
      end
    RUBY
  end

  it 'registers an offense for void `Proc.new { bar }` if not on last line' do
    expect_offense(<<~RUBY)
      def foo
        Proc.new { bar }
        ^^^^^^^^^^^^^^^^ `Proc.new { bar }` used in void context.
        top
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        top
      end
    RUBY
  end

  it 'does not register an offense for void `Proc.new { bar }` if on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        top
        Proc.new { bar }
      end
    RUBY
  end

  it 'does not register an offense for void `Proc.new { bar }.call` if not on last line' do
    expect_no_offenses(<<~RUBY)
      def foo
        Proc.new { bar }.call
        top
      end
    RUBY
  end

  context 'when checking for methods with no side effects' do
    let(:config) do
      RuboCop::Config.new('Lint/Void' => { 'CheckForMethodsWithNoSideEffects' => true })
    end

    it 'registers an offense for nonmutating method that takes a block' do
      expect_offense(<<~RUBY)
        [1,2,3].collect do |n|
        ^^^^^^^^^^^^^^^^^^^^^^ Method `#collect` used in void context. Did you mean `#each`?
          n.to_s
        end
        "done"
      RUBY

      expect_correction(<<~RUBY)
        [1,2,3].each do |n|
          n.to_s
        end
        "done"
      RUBY
    end

    context 'Ruby 2.7', :ruby27 do
      it 'registers an offense for nonmutating method that takes a numbered parameter block' do
        expect_offense(<<~RUBY)
          [1,2,3].map do
          ^^^^^^^^^^^^^^ Method `#map` used in void context. Did you mean `#each`?
            _1.to_s
          end
          "done"
        RUBY

        expect_correction(<<~RUBY)
          [1,2,3].each do
            _1.to_s
          end
          "done"
        RUBY
      end
    end

    context 'Ruby 3.4', :ruby34 do
      it 'registers an offense for nonmutating method that takes an `it` parameter block' do
        expect_offense(<<~RUBY)
          [1,2,3].map do
          ^^^^^^^^^^^^^^ Method `#map` used in void context. Did you mean `#each`?
            it.to_s
          end
          "done"
        RUBY

        expect_correction(<<~RUBY)
          [1,2,3].each do
            it.to_s
          end
          "done"
        RUBY
      end
    end

    it 'registers an offense if not on last line' do
      expect_offense(<<~RUBY)
        x.sort
        ^^^^^^ Method `#sort` used in void context. Did you mean `#sort!`?
        top(x)
      RUBY

      expect_correction(<<~RUBY)
        x.sort!
        top(x)
      RUBY
    end

    it 'registers an offense for chained methods' do
      expect_offense(<<~RUBY)
        x.sort.flatten
        ^^^^^^^^^^^^^^ Method `#flatten` used in void context. Did you mean `#flatten!`?
        top(x)
      RUBY

      expect_correction(<<~RUBY)
        x.sort.flatten!
        top(x)
      RUBY
    end

    it 'registers an offense for a safe navigation call' do
      expect_offense(<<~RUBY)
        x&.sort
        ^^^^^^^ Method `#sort` used in void context. Did you mean `#sort!`?
        top(x)
      RUBY

      expect_correction(<<~RUBY)
        x&.sort!
        top(x)
      RUBY
    end

    it 'does not register an offense assigning variable' do
      expect_no_offenses(<<~RUBY)
        foo = bar
        baz
      RUBY
    end

    it 'does not register an offense when using a method definition' do
      expect_no_offenses(<<~RUBY)
        def merge
        end

        42
      RUBY
    end
  end

  context 'when not checking for methods with no side effects' do
    let(:config) do
      RuboCop::Config.new('Lint/Void' => { 'CheckForMethodsWithNoSideEffects' => false })
    end

    it 'does not register an offense for void nonmutating methods' do
      expect_no_offenses(<<~RUBY)
        x.sort
        top(x)
      RUBY
    end
  end

  it 'does not register an offense for an array literal that includes non-literal elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        [foo, bar]
        baz
      end
    RUBY
  end

  it 'does not register an offense for a nested array literal that includes non-literal elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        [1, 2, [foo, bar]]
        baz
      end
    RUBY
  end

  it 'registers an offense for an array literal composed entirely of literals in a method definition' do
    expect_offense(<<~RUBY)
      def something
        [1, 2]
        ^^^^^^ Literal `[1, 2]` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'registers an offense for a nested array literal composed entirely of literals in a method definition' do
    expect_offense(<<~RUBY)
      def something
        [1, 2, [3]]
        ^^^^^^^^^^^ Literal `[1, 2, [3]]` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'registers an offense for a frozen literal in a method definition' do
    expect_offense(<<~RUBY)
      def something
        'foo'.freeze
        ^^^^^^^^^^^^ Literal `'foo'.freeze` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'registers an offense for a literal frozen via safe navigation in a method definition' do
    expect_offense(<<~RUBY)
      def something
        'foo'&.freeze
        ^^^^^^^^^^^^^ Literal `'foo'&.freeze` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'does not register an offense for frozen non-literal in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        foo.freeze
        baz
      end
    RUBY
  end

  it 'registers an offense for a nested array literal composed of frozen and unfrozen literals in a method definition' do
    expect_offense(<<~RUBY)
      def something
        [1, ['foo'.freeze]]
        ^^^^^^^^^^^^^^^^^^^ Literal `[1, ['foo'.freeze]]` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'does not register an offense for a nested array literal that includes frozen non-literal value elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        [1, [foo.freeze]]
        baz
      end
    RUBY
  end

  it 'does not register an offense for a hash literal that includes non-literal value elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        {k1: foo, k2: bar}
        baz
      end
    RUBY
  end

  it 'does not register an offense for a nested hash literal that includes non-literal value elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        {k0: {k1: foo, k2: bar}}
        baz
      end
    RUBY
  end

  it 'does not register an offense for a hash literal that includes non-literal key elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        {foo => 1, bar => 2}
        baz
      end
    RUBY
  end

  it 'does not register an offense for a nested hash literal that includes non-literal key elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        {foo: 1, bar: {baz => 2}}
        baz
      end
    RUBY
  end

  it 'registers an offense for a hash literal composed entirely of literals in a method definition' do
    expect_offense(<<~RUBY)
      def something
        {k1: 1, k2: 2}
        ^^^^^^^^^^^^^^ Literal `{k1: 1, k2: 2}` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'registers an offense for a nested hash literal composed entirely of literals in a method definition' do
    expect_offense(<<~RUBY)
      def something
        {x: {k1: 1, k2: 2}}
        ^^^^^^^^^^^^^^^^^^^ Literal `{x: {k1: 1, k2: 2}}` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'does not register an offense for a hash literal that includes array literal key within non-literal elements in a method definition' do
    expect_no_offenses(<<~RUBY)
      def something
        {[foo, bar] => :foo}
        baz
      end
    RUBY
  end

  it 'registers an offense for a hash literal that includes array literal key within literal elements in a method definition' do
    expect_offense(<<~RUBY)
      def something
        {[1, 2] => :foo}
        ^^^^^^^^^^^^^^^^ Literal `{[1, 2] => :foo}` used in void context.
        baz
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        baz
      end
    RUBY
  end

  it 'registers an offense for void literal in a method definition' do
    expect_offense(<<~RUBY)
      def something
        42
        ^^ Literal `42` used in void context.
        42
      end
    RUBY

    expect_correction(<<~RUBY)
      def something
        42
      end
    RUBY
  end

  it 'registers an offense but does not correct a void interpolated string' do
    expect_offense(<<~'RUBY')
      def something
        "#{foo}"
        ^^^^^^^^ Literal `"#{foo}"` used in void context.
        42
      end
    RUBY

    expect_no_corrections
  end

  it 'registers an offense but does not correct a void array with an interpolated symbol' do
    expect_offense(<<~'RUBY')
      def something
        [:"#{foo}"]
        ^^^^^^^^^^^ Literal `[:"#{foo}"]` used in void context.
        42
      end
    RUBY

    expect_no_corrections
  end

  it 'corrects a void operator inside a void interpolated string' do
    expect_offense(<<~'RUBY')
      def something
        "#{1 + 1; 2}"
        ^^^^^^^^^^^^^ Literal `"#{1 + 1; 2}"` used in void context.
             ^ Operator `+` used in void context.
        42
      end
    RUBY

    expect_correction(<<~'RUBY')
      def something
        "#{; 2}"
        42
      end
    RUBY
  end

  it 'registers two offenses for void literals in an initialize method' do
    expect_offense(<<~RUBY)
      def initialize
        42
        ^^ Literal `42` used in void context.
        42
        ^^ Literal `42` used in void context.
      end
    RUBY

    expect_correction(<<~RUBY)
      def initialize
      end
    RUBY
  end

  it 'registers an offense only for the non-last void literal in a setter method' do
    expect_offense(<<~RUBY)
      def foo=(rhs)
        42
        ^^ Literal `42` used in void context.
        42
      end
    RUBY

    expect_no_corrections
  end

  it 'registers an offense only for the non-last void literal in a class setter method' do
    expect_offense(<<~RUBY)
      def self.foo=(rhs)
        42
        ^^ Literal `42` used in void context.
        42
      end
    RUBY

    expect_no_corrections
  end

  it 'does not register an offense for the return value of a setter method' do
    expect_no_offenses(<<~RUBY)
      def name=(name)
        @name = name
        reset
        name
      end
    RUBY
  end

  it 'registers an offense only for non-last void literal in a `#each` method' do
    expect_offense(<<~RUBY)
      array.each do |_item|
        42
        ^^ Literal `42` used in void context.
        42
      end
    RUBY

    expect_correction(<<~RUBY)
      array.each do |_item|
        42
      end
    RUBY
  end

  it 'does not register an offense for a constant as last expression in a `#each` method' do
    expect_no_offenses(<<~RUBY)
      array.each do |_item|
        CONST
      end
    RUBY
  end

  it 'does not register an offense for a literal as single expression in `#each` block' do
    expect_no_offenses(<<~RUBY)
      array.each do |_item|
        42
      end
    RUBY
  end

  it 'does not register `#each` block with conditional expression' do
    expect_no_offenses(<<~RUBY)
      enumerator_as_filter.each do |item|
        # The `filter` method is used to filter for matches with `42`.
        # In this case, it's not void.
        item == 42
      end
    RUBY
  end

  it 'does not register `#each` block with conditional expressions that has multiple statements' do
    expect_no_offenses(<<~RUBY)
      enumerator_as_filter.each do |item|
        puts item

        # The `filter` method is used to filter for matches with `42`.
        # In this case, it's not void.
        item == 42
      end
    RUBY
  end

  it 'does not register `#each` numblock with conditional expressions that has multiple statements' do
    expect_no_offenses(<<~RUBY)
      enumerator_as_filter.each do
        puts _1

        # The `filter` method is used to filter for matches with `42`.
        # In this case, it's not void.
        _1 == 42
      end
    RUBY
  end

  context 'Ruby 2.7', :ruby27 do
    it 'registers two offenses for void literals in `#tap` method' do
      expect_offense(<<~RUBY)
        foo.tap do
          _1
          ^^ Variable `_1` used in void context.
          42
          ^^ Literal `42` used in void context.
        end
      RUBY

      expect_correction(<<~RUBY)
        foo.tap do
        end
      RUBY
    end
  end

  it 'registers two offenses for void literals in `#tap` method with a numbered block' do
    expect_offense(<<~RUBY)
      foo.tap do
        _1
        ^^ Variable `_1` used in void context.
        42
        ^^ Literal `42` used in void context.
      end
    RUBY

    expect_correction(<<~RUBY)
      foo.tap do
      end
    RUBY
  end

  it 'accepts empty block' do
    expect_no_offenses(<<~RUBY)
      array.each { |_item| }
    RUBY
  end

  it 'registers two offenses for void literals in `#tap` method' do
    expect_offense(<<~RUBY)
      foo.tap do |x|
        42
        ^^ Literal `42` used in void context.
        42
        ^^ Literal `42` used in void context.
      end
    RUBY

    expect_correction(<<~RUBY)
      foo.tap do |x|
      end
    RUBY
  end

  it 'registers two offenses for void literals in a `for`' do
    expect_offense(<<~RUBY)
      for _item in array do
        42
        ^^ Literal `42` used in void context.
        42
        ^^ Literal `42` used in void context.
      end
    RUBY

    expect_correction(<<~RUBY)
      for _item in array do
      end
    RUBY
  end

  it 'registers two offenses for void literals in an `ensure`' do
    expect_offense(<<~RUBY)
      def foo
      ensure
        bar
        42
        ^^ Literal `42` used in void context.
        42
        ^^ Literal `42` used in void context.
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
      ensure
        bar
      end
    RUBY
  end

  it 'registers an offense when the body of `ensure` is a literal' do
    expect_offense(<<~RUBY)
      def foo
        bar
      ensure
        [1, 2, [3]]
        ^^^^^^^^^^^ Literal `[1, 2, [3]]` used in void context.
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        bar
      ensure
      end
    RUBY
  end

  it 'handles explicit begin blocks' do
    expect_offense(<<~RUBY)
      begin
       1
       ^ Literal `1` used in void context.
       2
      end
    RUBY

    expect_correction(<<~RUBY)
      begin
       2
      end
    RUBY
  end

  it 'accepts short call syntax' do
    expect_no_offenses(<<~RUBY)
      lambda.(a)
      top
    RUBY
  end

  it 'accepts backtick commands' do
    expect_no_offenses(<<~RUBY)
      `touch x`
      nil
    RUBY
  end

  it 'accepts assigned if statements' do
    expect_no_offenses(<<~RUBY)
      x = if condition
            42
          end
      nil
    RUBY
  end

  it 'accepts assigned if statements in modifier form' do
    expect_no_offenses(<<~RUBY)
      x = (42 if condition)
      nil
    RUBY
  end

  it 'accepts assigned ternary statements' do
    expect_no_offenses(<<~RUBY)
      x = condition ? 42 : nil
      nil
    RUBY
  end

  it 'accepts percent-x commands' do
    expect_no_offenses(<<~RUBY)
      %x(touch x)
      nil
    RUBY
  end

  it 'accepts method with irange block' do
    expect_no_offenses(<<~RUBY)
      def foo
        1..100.times.each { puts 1 }
        do_something
      end
    RUBY
  end

  it 'accepts method with erange block' do
    expect_no_offenses(<<~RUBY)
      def foo
        1...100.times.each { puts 1 }
        do_something
      end
    RUBY
  end

  it 'registers an offense when using special __ENCODING__' do
    expect_offense(<<~RUBY)
      def foo
        __ENCODING__
        ^^^^^^^^^^^^ Variable `__ENCODING__` used in void context.
        42
      end
    RUBY

    expect_correction(<<~RUBY)
      def foo
        42
      end
    RUBY
  end

  it 'registers an offense for void literal in `case` branch' do
    expect_offense(<<~RUBY)
      case foo
      when 1 then 2
                  ^ Literal `2` used in void context.
      end
      puts 3
    RUBY

    expect_no_corrections
  end

  it 'registers offenses for void literals in multiple `case` branches' do
    expect_offense(<<~RUBY)
      case foo
      when 1 then 2
                  ^ Literal `2` used in void context.
      when 3 then 4
                  ^ Literal `4` used in void context.
      else 5
           ^ Literal `5` used in void context.
      end
      puts 6
    RUBY

    expect_no_corrections
  end

  it 'registers an offense for void variable in `case` branch' do
    expect_offense(<<~RUBY)
      x = 1
      case foo
      when 1 then x
                  ^ Variable `x` used in void context.
      end
      puts 3
    RUBY

    expect_no_corrections
  end

  it 'does not register an offense for non-void expression in `case` branch' do
    expect_no_offenses(<<~RUBY)
      case foo
      when 1 then do_something
      end
      puts 3
    RUBY
  end

  it 'does not register an offense for `nil` in `case` branch' do
    expect_no_offenses(<<~RUBY)
      case foo
      when 1
        nil
      end
      puts 3
    RUBY
  end

  it 'does not register an offense for `case` on last line' do
    expect_no_offenses(<<~RUBY)
      case foo
      when 1 then 2
      end
    RUBY
  end

  it 'does not register an offense for `case` without when body' do
    expect_no_offenses(<<~RUBY)
      case foo
      when 1
      end
      puts :ok
    RUBY
  end

  it 'registers an offense for void literal in `case...in` branch' do
    expect_offense(<<~RUBY)
      case foo
      in 1 then 2
                ^ Literal `2` used in void context.
      in 2 then 3
                ^ Literal `3` used in void context.
      else 4
           ^ Literal `4` used in void context.
      end
      puts 5
    RUBY

    expect_no_corrections
  end

  it 'registers an offense for void variable in `case...in` branch' do
    expect_offense(<<~RUBY)
      x = 1
      case foo
      in 1 then x
                ^ Variable `x` used in void context.
      end
      puts 3
    RUBY

    expect_no_corrections
  end

  it 'does not register an offense for non-void expression in `case...in` branch' do
    expect_no_offenses(<<~RUBY)
      case foo
      in 1 then do_something
      end
      puts 3
    RUBY
  end

  it 'does not register an offense for `case...in` on last line' do
    expect_no_offenses(<<~RUBY)
      case foo
      in 1 then 2
      end
    RUBY
  end

  it 'does not register an offense for `case...in` without in_pattern body' do
    expect_no_offenses(<<~RUBY)
      case foo
      in 1
      end
      puts :ok
    RUBY
  end

  it 'does not register an offense for `if` without body' do
    expect_no_offenses(<<~RUBY)
      if some_condition
      end

      puts :ok
    RUBY
  end

  it 'does not register an offense for nested empty `begin`' do
    expect_no_offenses(<<~RUBY)
      ((); 1)
    RUBY
  end
end
