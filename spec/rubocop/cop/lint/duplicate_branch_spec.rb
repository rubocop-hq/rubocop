# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::DuplicateBranch, :config do
  shared_examples_for 'literal if allowed' do |type, value|
    context "when returning a #{type} in multiple branches" do
      it 'allows branches to be duplicated' do
        expect_no_offenses(<<~RUBY)
          if x
            #{value}
          elsif y
            #{value}
          else
            #{value}
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal if disallowed' do |type, value|
    context "when returning a #{type} in multiple branches" do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          if x
            #{value}
          elsif y
          ^^^^^^^ Duplicate branch body detected.
            #{value}
          else
          ^^^^ Duplicate branch body detected.
            #{value}
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal case allowed' do |type, value|
    context "when returning a #{type} in multiple branches" do
      it 'allows branches to be duplicated' do
        expect_no_offenses(<<~RUBY)
          case foo
          when x then #{value}
          when y then #{value}
          else #{value}
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal case disallowed' do |type, value|
    context "when returning a #{type} in multiple branches" do
      it 'registers an offense' do
        expect_offense(<<~RUBY, value: value)
          case foo
          when x then #{value}
          when y then #{value}
          ^^^^^^^^^^^^^{value} Duplicate branch body detected.
          else #{value}
          ^^^^ Duplicate branch body detected.
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal case-match allowed' do |type, value|
    context "when returning a #{type} in multiple branches", :ruby27 do
      it 'allows branches to be duplicated' do
        expect_no_offenses(<<~RUBY)
          case foo
          in x then #{value}
          in y then #{value}
          else #{value}
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal case-match disallowed' do |type, value|
    context "when returning a #{type} in multiple branches", :ruby27 do
      it 'registers an offense' do
        expect_offense(<<~RUBY, value: value)
          case foo
          in x then #{value}
          in y then #{value}
          ^^^^^^^^^^^{value} Duplicate branch body detected.
          else #{value}
          ^^^^ Duplicate branch body detected.
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal rescue allowed' do |type, value|
    context "when returning a #{type} in multiple branches" do
      it 'allows branches to be duplicated' do
        expect_no_offenses(<<~RUBY)
          begin
            foo
          rescue FooError
            #{value}
          rescue BarError
            #{value}
          else
            #{value}
          end
        RUBY
      end
    end
  end

  shared_examples_for 'literal rescue disallowed' do |type, value|
    context "when returning a #{type} in multiple branches" do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          begin
            foo
          rescue FooError
            #{value}
          rescue BarError
          ^^^^^^^^^^^^^^^ Duplicate branch body detected.
            #{value}
          else
          ^^^^ Duplicate branch body detected.
            #{value}
          end
        RUBY
      end
    end
  end

  it 'registers an offense when `if` has duplicate `else` branch' do
    expect_offense(<<~RUBY)
      if foo
        do_foo
      else
      ^^^^ Duplicate branch body detected.
        do_foo
      end

      if foo
        do_foo
        do_something_else
      else
      ^^^^ Duplicate branch body detected.
        do_foo
        do_something_else
      end
    RUBY
  end

  it 'registers an offense when `unless` has duplicate `else` branch' do
    expect_offense(<<~RUBY)
      unless foo
        do_bar
      else
      ^^^^ Duplicate branch body detected.
        do_bar
      end
    RUBY
  end

  it 'registers an offense when `if` has duplicate `elsif` branch' do
    expect_offense(<<~RUBY)
      if foo
        do_foo
      elsif bar
      ^^^^^^^^^ Duplicate branch body detected.
        do_foo
      end
    RUBY
  end

  it 'registers an offense when `if` has multiple duplicate branches' do
    expect_offense(<<~RUBY)
      if foo
        do_foo
      elsif bar
        do_bar
      elsif baz
      ^^^^^^^^^ Duplicate branch body detected.
        do_foo
      elsif quux
      ^^^^^^^^^^ Duplicate branch body detected.
        do_bar
      end
    RUBY
  end

  it 'does not register an offense when `if` has no duplicate branches' do
    expect_no_offenses(<<~RUBY)
      if foo
        do_foo
      elsif bar
        do_bar
      end
    RUBY
  end

  it 'does not register an offense when `unless` has no duplicate branches' do
    expect_no_offenses(<<~RUBY)
      unless foo
        do_bar
      else
        do_foo
      end
    RUBY
  end

  it 'does not register an offense for simple `if` without other branches' do
    expect_no_offenses(<<~RUBY)
      if foo
        do_foo
      end
    RUBY
  end

  it 'does not register an offense for simple `unless` without other branches' do
    expect_no_offenses(<<~RUBY)
      unless foo
        do_bar
      end
    RUBY
  end

  it 'does not register an offense for empty `if`' do
    expect_no_offenses(<<~RUBY)
      if foo
        # Comment.
      end
    RUBY
  end

  it 'does not register an offense for empty `unless`' do
    expect_no_offenses(<<~RUBY)
      unless foo
        # Comment.
      end
    RUBY
  end

  it 'does not register an offense for modifier `if`' do
    expect_no_offenses(<<~RUBY)
      do_foo if foo
    RUBY
  end

  it 'does not register an offense for modifier `unless`' do
    expect_no_offenses(<<~RUBY)
      do_bar unless foo
    RUBY
  end

  it 'registers an offense when ternary has duplicate branches' do
    expect_offense(<<~RUBY)
      res = foo ? do_foo : do_foo
                           ^^^^^^ Duplicate branch body detected.
    RUBY
  end

  it 'does not register an offense when ternary has no duplicate branches' do
    expect_no_offenses(<<~RUBY)
      res = foo ? do_foo : do_bar
    RUBY
  end

  it 'registers an offense when `case` has duplicate `when` branch' do
    expect_offense(<<~RUBY)
      case x
      when foo
        do_foo
      when bar
      ^^^^^^^^ Duplicate branch body detected.
        do_foo
      end
    RUBY
  end

  it 'registers an offense when `case` has duplicate `else` branch' do
    expect_offense(<<~RUBY)
      case x
      when foo
        do_foo
      else
      ^^^^ Duplicate branch body detected.
        do_foo
      end
    RUBY
  end

  it 'registers an offense when `case` has multiple duplicate branches' do
    expect_offense(<<~RUBY)
      case x
      when foo
        do_foo
      when bar
        do_bar
      when baz
      ^^^^^^^^ Duplicate branch body detected.
        do_foo
      when quux
      ^^^^^^^^^ Duplicate branch body detected.
        do_bar
      end
    RUBY
  end

  it 'does not register an offense when `case` has no duplicate branches' do
    expect_no_offenses(<<~RUBY)
      case x
      when foo
        do_foo
      when bar
        do_bar
      end
    RUBY
  end

  it 'registers an offense when `rescue` has duplicate `resbody` branch' do
    expect_offense(<<~RUBY)
      begin
        do_something
      rescue FooError
        handle_error(x)
      rescue BarError
      ^^^^^^^^^^^^^^^ Duplicate branch body detected.
        handle_error(x)
      end
    RUBY
  end

  it 'registers an offense when `rescue` has duplicate `else` branch' do
    expect_offense(<<~RUBY)
      begin
        do_something
      rescue FooError
        handle_error(x)
      else
      ^^^^ Duplicate branch body detected.
        handle_error(x)
      end
    RUBY
  end

  it 'registers an offense when `rescue` has multiple duplicate `resbody` branches' do
    expect_offense(<<~RUBY)
      begin
        do_something
      rescue FooError
        handle_foo_error(x)
      rescue BarError
        handle_bar_error(x)
      rescue BazError
      ^^^^^^^^^^^^^^^ Duplicate branch body detected.
        handle_foo_error(x)
      rescue QuuxError
      ^^^^^^^^^^^^^^^^ Duplicate branch body detected.
        handle_bar_error(x)
      end
    RUBY
  end

  it 'does not register an offense when `rescue` has no duplicate branches' do
    expect_no_offenses(<<~RUBY)
      begin
        do_something
      rescue FooError
        handle_foo_error(x)
      rescue BarError
        handle_bar_error(x)
      end
    RUBY
  end

  context 'with IgnoreLiteralBranches: true' do
    let(:cop_config) { { 'IgnoreLiteralBranches' => true } }

    %w[if case rescue].each do |keyword|
      context "with `#{keyword}`" do
        it_behaves_like "literal #{keyword} allowed", 'integer', '5'
        it_behaves_like "literal #{keyword} allowed", 'float', '5.0'
        it_behaves_like "literal #{keyword} allowed", 'rational', '5r'
        it_behaves_like "literal #{keyword} allowed", 'complex', '5i'
        it_behaves_like "literal #{keyword} allowed", 'string', '"string"'
        it_behaves_like "literal #{keyword} allowed", 'symbol', ':symbol'
        it_behaves_like "literal #{keyword} allowed", 'true', 'true'
        it_behaves_like "literal #{keyword} allowed", 'false', 'false'
        it_behaves_like "literal #{keyword} allowed", 'nil', 'nil'
        it_behaves_like "literal #{keyword} allowed", 'regexp', '/foo/'
        it_behaves_like "literal #{keyword} allowed", 'regexp with modifier', '/foo/i'
        it_behaves_like "literal #{keyword} allowed", 'simple irange', '1..5'
        it_behaves_like "literal #{keyword} allowed", 'simple erange', '1...5'
        it_behaves_like "literal #{keyword} allowed", 'empty array', '[]'
        it_behaves_like "literal #{keyword} allowed", 'array of literals', '[1, 2, 3]'
        it_behaves_like "literal #{keyword} allowed", 'empty hash', '{}'
        it_behaves_like "literal #{keyword} allowed", 'hash of literals', '{ foo: 1, bar: 2 }'

        it_behaves_like "literal #{keyword} disallowed", 'dstr', '"#{foo}"'
        it_behaves_like "literal #{keyword} disallowed", 'dsym', ':"#{foo}"'
        it_behaves_like "literal #{keyword} disallowed", 'xstr', '`foo bar`'
        it_behaves_like "literal #{keyword} disallowed", 'complex array', '[foo, bar, baz]'
        it_behaves_like "literal #{keyword} disallowed", 'complex hash', '{ foo: foo, bar: bar }'
        it_behaves_like "literal #{keyword} disallowed", 'complex irange', '1..foo'
        it_behaves_like "literal #{keyword} disallowed", 'complex erange', '1...foo'
        it_behaves_like "literal #{keyword} disallowed", 'complex regexp', '/#{foo}/i'
        it_behaves_like "literal #{keyword} disallowed", 'variable', 'foo'
        it_behaves_like "literal #{keyword} disallowed", 'method call', 'foo(bar)'

        context 'and IgnoreConstBranches: true' do
          let(:cop_config) { super().merge('IgnoreConstantBranches' => true) }

          it_behaves_like "literal #{keyword} allowed", 'array of constants', '[CONST1, CONST2]'
          it_behaves_like "literal #{keyword} allowed", 'hash of constants', '{ foo: CONST1, bar: CONST2 }'
        end

        context 'and IgnoreConstBranches: false' do
          let(:cop_config) { super().merge('IgnoreConstantBranches' => false) }

          it_behaves_like "literal #{keyword} disallowed", 'array of constants', '[CONST1, CONST2]'
          it_behaves_like "literal #{keyword} disallowed", 'hash of constants', '{ foo: CONST1, bar: CONST2 }'
        end
      end
    end
  end

  context 'with IgnoreConstantBranches: true' do
    let(:cop_config) { { 'IgnoreConstantBranches' => true } }

    %w[if case case-match rescue].each do |keyword|
      context "with `#{keyword}`" do
        it_behaves_like "literal #{keyword} allowed", 'constant', 'MY_CONST'

        it_behaves_like "literal #{keyword} disallowed", 'object', 'Object.new'
      end
    end
  end
end
