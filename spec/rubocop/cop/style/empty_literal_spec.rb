# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::EmptyLiteral, :config do
  describe 'Empty Array' do
    shared_examples 'registers_and_corrects' do |initializer:|
      it "registers an offense for #{initializer}" do
        expect_offense(<<~RUBY)
          test = #{initializer}
                 #{'^' * initializer.length} Use array literal `[]` instead of `#{initializer}`.
        RUBY

        expect_correction(<<~RUBY)
          test = []
        RUBY
      end
    end

    context 'initializer resulting in an empty array literal' do
      it_behaves_like 'registers_and_corrects', initializer: 'Array.new()'
      it_behaves_like 'registers_and_corrects', initializer: 'Array.new'
      it_behaves_like 'registers_and_corrects', initializer: '::Array.new()'
      it_behaves_like 'registers_and_corrects', initializer: 'Array.new([])'
      it_behaves_like 'registers_and_corrects', initializer: 'Array[]'
      it_behaves_like 'registers_and_corrects', initializer: 'Array([])'
    end

    it 'does not register an offense for Array.new(3)' do
      expect_no_offenses('test = Array.new(3)')
    end

    it 'autocorrects Array.new in block in block' do
      expect_offense(<<~RUBY)
        puts { Array.new }
               ^^^^^^^^^ Use array literal `[]` instead of `Array.new`.
      RUBY

      expect_correction(<<~RUBY)
        puts { [] }
      RUBY
    end

    it 'does not register an offense Array.new with block' do
      expect_no_offenses('test = Array.new { 1 }')
    end

    it 'does not register an offense for ::Array.new with block' do
      expect_no_offenses('test = ::Array.new { 1 }')
    end

    it 'does not register Array.new with block in other block' do
      expect_no_offenses('puts { Array.new { 1 } }')
    end

    it 'does not register an offense for Array[3]' do
      expect_no_offenses('Array[3]')
    end

    it 'does not register an offense for Array [3]' do
      expect_no_offenses('Array [3]')
    end
  end

  describe 'Empty Hash' do
    shared_examples 'registers_and_corrects' do |initializer:|
      it "registers an offense for #{initializer}" do
        expect_offense(<<~RUBY)
          test = #{initializer}
                 #{'^' * initializer.length} Use hash literal `{}` instead of `#{initializer}`.
        RUBY

        expect_correction(<<~RUBY)
          test = {}
        RUBY
      end
    end

    context 'initializer resulting in an empty hash literal' do
      it_behaves_like 'registers_and_corrects', initializer: 'Hash.new()'
      it_behaves_like 'registers_and_corrects', initializer: 'Hash.new'
      it_behaves_like 'registers_and_corrects', initializer: '::Hash.new()'
      it_behaves_like 'registers_and_corrects', initializer: 'Hash[]'
      it_behaves_like 'registers_and_corrects', initializer: 'Hash([])'
    end

    it 'does not register an offense for Hash[3,4]' do
      expect_no_offenses('Hash[3,4]')
    end

    it 'does not register an offense for Hash [3,4]' do
      expect_no_offenses('Hash [3,4]')
    end

    it 'does not register an offense for Hash.new(3)' do
      expect_no_offenses('test = Hash.new(3)')
    end

    it 'does not register an offense for ::Hash.new(3)' do
      expect_no_offenses('test = ::Hash.new(3)')
    end

    it 'does not register an offense for Hash.new { block }' do
      expect_no_offenses('test = Hash.new { block }')
    end

    it 'does not register an offense for ::Hash.new { block }' do
      expect_no_offenses('test = ::Hash.new { block }')
    end

    it 'does not register an offense for Hash.new([])' do
      expect_no_offenses('Hash.new([])')
    end

    context 'Ruby 2.7', :ruby27 do
      it 'does not register an offense for Hash.new { _1[_2] = [] }' do
        expect_no_offenses('test = Hash.new { _1[_2] = [] }')
      end

      it 'does not register an offense for ::Hash.new { _1[_2] = [] }' do
        expect_no_offenses('test = ::Hash.new { _1[_2] = [] }')
      end

      it 'does not register an offense for Array.new with a numbered-parameter block' do
        expect_no_offenses('test = Array.new { _1 }')
      end
    end

    context 'Ruby 3.4', :ruby34 do
      it 'does not register an offense for Array.new with an `it`-block' do
        expect_no_offenses('test = Array.new { it }')
      end

      it 'does not register an offense for Hash.new with an `it`-block' do
        expect_no_offenses('test = Hash.new { it }')
      end
    end

    it 'autocorrects Hash.new in block' do
      expect_offense(<<~RUBY)
        puts { Hash.new }
               ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        puts { {} }
      RUBY
    end

    it 'autocorrects Hash.new to {} in various contexts' do
      expect_offense(<<~RUBY)
        test = Hash.new
               ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
        Hash.new.merge("a" => 3)
        ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
        yadayada.map { a }.reduce(Hash.new, :merge)
                                  ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        test = {}
        {}.merge("a" => 3)
        yadayada.map { a }.reduce({}, :merge)
      RUBY
    end

    it 'autocorrects Hash.new to {} as the only parameter to a method' do
      expect_offense(<<~RUBY)
        yadayada.map { a }.reduce Hash.new
                                  ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        yadayada.map { a }.reduce({})
      RUBY
    end

    it 'autocorrects Hash.new to {} as the first parameter to a method' do
      expect_offense(<<~RUBY)
        yadayada.map { a }.reduce Hash.new, :merge
                                  ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        yadayada.map { a }.reduce({}, :merge)
      RUBY
    end

    it 'autocorrects Hash.new to {} and wraps it in parentheses ' \
       'when it is the only argument to super' do
      expect_offense(<<~RUBY)
        def foo
          super Hash.new
                ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo
          super({})
        end
      RUBY
    end

    it 'autocorrects Hash[] to {} and wraps all arguments in ' \
       'parentheses when it is the first argument to a method call' do
      expect_offense(<<~RUBY)
        assert_equal Hash[], foo
                     ^^^^^^ Use hash literal `{}` instead of `Hash[]`.
      RUBY

      expect_correction(<<~RUBY)
        assert_equal({}, foo)
      RUBY
    end

    it 'autocorrects Hash([]) to {} and wraps it in parentheses ' \
       'when it is the only argument to a method call' do
      expect_offense(<<~RUBY)
        puts Hash([])
             ^^^^^^^^ Use hash literal `{}` instead of `Hash([])`.
      RUBY

      expect_correction(<<~RUBY)
        puts({})
      RUBY
    end

    it 'autocorrects Hash.new to {} and wraps all arguments in ' \
       'parentheses when it is the first argument to super' do
      expect_offense(<<~RUBY)
        def foo
          super Hash.new, something
                ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo
          super({}, something)
        end
      RUBY
    end

    it 'autocorrects Hash[] to {} without parentheses when it is the argument of an element reference' do
      expect_offense(<<~RUBY)
        foo[Hash[]]
            ^^^^^^ Use hash literal `{}` instead of `Hash[]`.
      RUBY

      expect_correction(<<~RUBY)
        foo[{}]
      RUBY
    end

    it 'autocorrects Hash.new to {} without parentheses when it is the first argument of an element assignment' do
      expect_offense(<<~RUBY)
        foo[Hash.new] = bar
            ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        foo[{}] = bar
      RUBY
    end

    it 'autocorrects Hash.new to {} without parentheses when it is the operand of a binary operator' do
      expect_offense(<<~RUBY)
        foo == Hash.new
               ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        foo == {}
      RUBY
    end

    it 'autocorrects Hash.new to {} with parentheses when it is the argument of an operator method called with a dot' do
      expect_offense(<<~RUBY)
        foo.== Hash.new
               ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        foo.==({})
      RUBY
    end

    it 'autocorrects Hash.new to {} with parentheses when it is the first argument of an operator method called with a dot' do
      expect_offense(<<~RUBY)
        foo.[] Hash.new, bar
               ^^^^^^^^ Use hash literal `{}` instead of `Hash.new`.
      RUBY

      expect_correction(<<~RUBY)
        foo.[]({}, bar)
      RUBY
    end
  end

  describe 'Empty String', :config do
    let(:other_cops) { { 'Style/FrozenStringLiteralComment' => { 'Enabled' => false } } }

    it 'registers an offense for String.new()' do
      expect_offense(<<~RUBY)
        test = String.new()
               ^^^^^^^^^^^^ Use string literal `''` instead of `String.new`.
      RUBY

      expect_correction(<<~RUBY)
        test = ''
      RUBY
    end

    it 'registers an offense for String.new' do
      expect_offense(<<~RUBY)
        test = String.new
               ^^^^^^^^^^ Use string literal `''` instead of `String.new`.
      RUBY

      expect_correction(<<~RUBY)
        test = ''
      RUBY
    end

    it 'registers an offense for ::String.new' do
      expect_offense(<<~RUBY)
        test = ::String.new
               ^^^^^^^^^^^^ Use string literal `''` instead of `String.new`.
      RUBY

      expect_correction(<<~RUBY)
        test = ''
      RUBY
    end

    it 'does not register an offense for String.new("top")' do
      expect_no_offenses('test = String.new("top")')
    end

    it 'does not register an offense for ::String.new("top")' do
      expect_no_offenses('test = ::String.new("top")')
    end

    context 'when double-quoted string literals are preferred' do
      let(:other_cops) do
        super().merge('Style/StringLiterals' => { 'EnforcedStyle' => 'double_quotes' })
      end

      it 'registers an offense for String.new' do
        expect_offense(<<~RUBY)
          test = String.new
                 ^^^^^^^^^^ Use string literal `""` instead of `String.new`.
        RUBY

        expect_correction(<<~RUBY)
          test = ""
        RUBY
      end

      it 'registers an offense for ::String.new' do
        expect_offense(<<~RUBY)
          test = ::String.new
                 ^^^^^^^^^^^^ Use string literal `""` instead of `String.new`.
        RUBY

        expect_correction(<<~RUBY)
          test = ""
        RUBY
      end
    end

    context 'when frozen string literals is enabled', :ruby23 do
      it 'does not register an offense for String.new' do
        expect_no_offenses(<<~RUBY)
          # frozen_string_literal: true
          test = String.new
        RUBY
      end
    end

    context 'when Style/FrozenStringLiteralComment is enabled' do
      let(:other_cops) { { 'Style/FrozenStringLiteralComment' => { 'Enabled' => true } } }

      context 'and there is no magic comment' do
        it 'does not register an offense' do
          expect_no_offenses(<<~RUBY)
            test = String.new
          RUBY
        end
      end

      context 'and there is a frozen_string_literal: false comment' do
        it 'registers an offense and corrects' do
          expect_offense(<<~RUBY)
            # frozen_string_literal: false
            test = String.new
                   ^^^^^^^^^^ Use string literal `''` instead of `String.new`.
          RUBY

          expect_correction(<<~RUBY)
            # frozen_string_literal: false
            test = ''
          RUBY
        end
      end
    end

    context 'when `AllCops/StringLiteralsFrozenByDefault: true`' do
      let(:config) do
        RuboCop::Config.new('AllCops' => { 'StringLiteralsFrozenByDefault' => true })
      end

      context 'when the frozen string literal comment is missing' do
        it 'registers no offense' do
          expect_no_offenses(<<~RUBY)
            test = String.new
          RUBY
        end
      end

      context 'when the frozen string literal comment is true' do
        it 'registers no offense' do
          expect_no_offenses(<<~RUBY)
            # frozen_string_literal: true
              test = String.new
          RUBY
        end
      end

      context 'when the frozen string literal comment is false' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            # frozen_string_literal: false
            test = String.new
                   ^^^^^^^^^^ Use string literal `''` instead of `String.new`.
          RUBY

          expect_correction(<<~RUBY)
            # frozen_string_literal: false
            test = ''
          RUBY
        end
      end
    end

    context 'when `AllCops/StringLiteralsFrozenByDefault: false`' do
      let(:config) do
        RuboCop::Config.new('AllCops' => { 'StringLiteralsFrozenByDefault' => false })
      end

      context 'when the frozen string literal comment is missing' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            test = String.new
                   ^^^^^^^^^^ Use string literal `''` instead of `String.new`.
          RUBY

          expect_correction(<<~RUBY)
            test = ''
          RUBY
        end
      end

      context 'when the frozen string literal comment is true' do
        it 'registers no offense' do
          expect_no_offenses(<<~RUBY)
            # frozen_string_literal: true
              test = String.new
          RUBY
        end
      end

      context 'when the frozen string literal comment is false' do
        it 'registers an offense' do
          expect_offense(<<~RUBY)
            # frozen_string_literal: false
            test = String.new
                   ^^^^^^^^^^ Use string literal `''` instead of `String.new`.
          RUBY

          expect_correction(<<~RUBY)
            # frozen_string_literal: false
            test = ''
          RUBY
        end
      end
    end
  end
end
