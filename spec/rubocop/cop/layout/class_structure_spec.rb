# frozen_string_literal: true

# rubocop:disable Lint/LiteralAsCondition
RSpec.describe RuboCop::Cop::Layout::ClassStructure, :config do
  let(:config) do
    RuboCop::Config.new(
      'Layout/ClassStructure' => {
        'ExpectedOrder' => %w[
          module_inclusion
          constants
          attribute_macros
          delegate
          macros
          public_class_methods
          initializer
          public_methods
          protected_attribute_macros
          protected_methods
          private_constants
          private_attribute_macros
          private_delegate
          private_class_methods
          private_methods
        ],
        'Categories' => {
          'attribute_macros' => %w[
            attr_accessor
            attr_reader
            attr_writer
          ],
          'macros' => %w[
            validates
            validate
          ],
          'module_inclusion' => %w[
            prepend
            extend
            include
          ]
        }
      }
    )
  end

  context 'with a complete ordered example' do
    it 'does not create offense' do
      expect_no_offenses <<-RUBY
        class Person
          # extend and include go first
          extend SomeModule
          include AnotherModule

          # inner classes
          CustomError = Class.new(StandardError)

          # constants are next
          SOME_CONSTANT = 20

          # afterwards we have attribute macros
          attr_reader :name

          # then we have public delegate macros
          delegate :to_s, to: :name

          # followed by other macros (if any)
          validates :name

          # public class methods are next in line
          def self.some_method
          end

          # initialization goes between class methods and other instance methods
          def initialize
          end

          # followed by other public instance methods
          def some_method
          end

          # protected attribute macros and methods go next
          protected

          attr_reader :protected_name

          def some_protected_method
          end

          # private attribute macros, delegate macros and methods are grouped near the end
          private

          attr_reader :private_name

          delegate :some_private_delegate, to: :name

          def some_private_method
          end
        end
      RUBY
    end
  end

  context 'simple example' do
    specify do
      expect_offense <<~RUBY
        class Person
          CONST = 'wrong place'
          CONST2 = 'wrong place2'
          CONST3 = 'wrong place3'
          include AnotherModule
          ^^^^^^^^^^^^^^^^^^^^^ `module_inclusion` is supposed to appear before `constants`.
          extend SomeModule
        end
      RUBY

      expect_correction(<<~RUBY)
        class Person
          include AnotherModule
          extend SomeModule
          CONST = 'wrong place'
          CONST2 = 'wrong place2'
          CONST3 = 'wrong place3'
        end
      RUBY
    end
  end

  context 'with a class with an inline comment' do
    it 'does not get confused' do
      expect_offense <<~'RUBY'
        class Foo # comment needed for this to fail!
          def bar
          end

          def baz
          end

          attr_reader :foo
          ^^^^^^^^^^^^^^^^ `attribute_macros` is supposed to appear before `public_methods`.
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo # comment needed for this to fail!
          attr_reader :foo

          def bar
          end

          def baz
          end
        end
      RUBY
    end
  end

  context 'with protected methods declared before private' do
    it 'corrects it' do
      expect_offense(<<~RUBY)
        class MyClass
          def public_method
          end

          private

          def first_private_method
          end

          def second_private_method
          end

          def third_private_method
          end

          protected
          ^^^^^^^^^ `protected_methods` is supposed to appear before `private_methods`.

          def first_protected_method
          end

          def second_protected_method
          end
        end
      RUBY

      expect_correction(<<~RUBY) unless :pending
        class MyClass
          def public_method
          end

          protected

          def first_protected_method
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ `protected_methods` is supposed to appear before `private_methods`.
          end

          def second_protected_method
          end

          private

          def first_private_method
          end

          def second_private_method
          end

          def third_private_method
          end
        end
      RUBY
    end
  end

  context 'with attribute macros before after validations' do
    it 'corrects it' do
      expect_offense(<<~RUBY)
        class Person
          include AnotherModule
          extend SomeModule

          CustomError = Class.new(StandardError)

          validates :name

          validates :address

          attr_reader :name
          ^^^^^^^^^^^^^^^^^ `attribute_macros` is supposed to appear before `macros`.
        end
      RUBY

      expect_correction(<<~RUBY) unless :pending
        class Person
          include AnotherModule
          extend SomeModule

          CustomError = Class.new(StandardError)

          attr_reader :name

          validates :name

          validates :address
        end
      RUBY
    end
  end

  context 'constant is not a literal' do
    it 'registers offense but does not autocorrect' do
      expect_offense <<~RUBY
        class Person
          def name; end
          def address; end

          foo = 5
          LIMIT = foo + 1
          ^^^^^^^^^^^^^^^ `constants` is supposed to appear before `public_methods`.
        end
      RUBY

      expect_no_corrections
    end
  end

  it 'registers an offense and corrects when there is a comment in the macro method' do
    expect_offense(<<~RUBY)
      class Foo
        # This is a comment for macro method.
        validates :attr
        validates :attr2
        attr_reader :foo
        ^^^^^^^^^^^^^^^^ `attribute_macros` is supposed to appear before `macros`.
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        attr_reader :foo
        # This is a comment for macro method.
        validates :attr
        validates :attr2
      end
    RUBY
  end

  it 'registers an offense and corrects when literal constant is after method definitions' do
    expect_offense(<<~RUBY)
      class Foo
        def name; end
        def address; end

        LIMIT = 10
        ^^^^^^^^^^ `constants` is supposed to appear before `public_methods`.
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        LIMIT = 10

        def name; end
        def address; end
      end
    RUBY
  end

  context 'with private constants' do
    context 'with unrecognized constants' do
      it 'does not register an offense for unrecognized constants' do
        expect_no_offenses(<<~RUBY)
          class Foo
            include Bar
            private_constant :LIMIT # e.g. part of Bar

            def name; end
          end
        RUBY
      end
    end

    it 'registers an offense and corrects for literal private constants' do
      expect_offense(<<~RUBY)
        class Foo
          LIMIT = 10
          private_constant :LIMIT

          def name; end
          ^^^^^^^^^^^^^ `public_methods` is supposed to appear before `private_constants`.
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          def name; end

          LIMIT = 10
          private_constant :LIMIT
        end
      RUBY
    end
  end

  it 'registers an offense and corrects when str heredoc constant is defined after public method' do
    expect_offense(<<~RUBY)
      class Foo
        def do_something
        end

        def do_something_else
        end

        CONSTANT = <<~EOS
        ^^^^^^^^^^^^^^^^^ `constants` is supposed to appear before `public_methods`.
          str
        EOS
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        CONSTANT = <<~EOS
          str
        EOS

        def do_something
        end

        def do_something_else
        end
      end
    RUBY
  end

  it 'registers an offense and corrects when dstr heredoc constant is defined after public method' do
    expect_offense(<<~'RUBY')
      class Foo
        def do_something
        end

        def do_something_else
        end

        CONSTANT = <<~EOS
        ^^^^^^^^^^^^^^^^^ `constants` is supposed to appear before `public_methods`.
          #{2 + 2}
        EOS
      end
    RUBY

    expect_correction(<<~'RUBY')
      class Foo
        CONSTANT = <<~EOS
          #{2 + 2}
        EOS

        def do_something
        end

        def do_something_else
        end
      end
    RUBY
  end

  it 'registers an offense and corrects when xstr heredoc constant is defined after public method' do
    expect_offense(<<~'RUBY')
      class Foo
        def do_something
        end

        def do_something_else
        end

        CONSTANT = <<~`EOS`
        ^^^^^^^^^^^^^^^^^^^ `constants` is supposed to appear before `public_methods`.
          str
        EOS
      end
    RUBY

    expect_correction(<<~'RUBY')
      class Foo
        CONSTANT = <<~`EOS`
          str
        EOS

        def do_something
        end

        def do_something_else
        end
      end
    RUBY
  end

  context 'when def modifier is used' do
    it 'registers an offense and corrects public method with modifier declared after private method with modifier' do
      expect_offense(<<~RUBY)
        class A
          private def foo
          end

          private def qux
          end

          public def bar
          ^^^^^^^^^^^^^^ `public_methods` is supposed to appear before `private_methods`.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        class A
          public def bar
          end

          private def foo
          end

          private def qux
          end
        end
      RUBY
    end

    it 'registers an offense and corrects public method without modifier declared after private method with modifier' do
      expect_offense(<<~RUBY)
        class A
          private def foo
          end

          private def qux
          end

          def bar
          ^^^^^^^ `public_methods` is supposed to appear before `private_methods`.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        class A
          def bar
          end

          private def foo
          end

          private def qux
          end
        end
      RUBY
    end
  end

  context 'when defs modifier is used' do
    it 'registers an offense for public class methods after private class methods' do
      expect_offense(<<~RUBY)
        class A
          private_class_method def self.foo
          end

          private_class_method def self.qux
          end

          public_class_method def self.bar
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `public_class_methods` is supposed to appear before `private_class_methods`.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        class A
          public_class_method def self.bar
          end

          private_class_method def self.foo
          end

          private_class_method def self.qux
          end
        end
      RUBY
    end
  end

  context 'initializer is private and comes after attribute macro' do
    it 'registers offense and auto-corrects' do
      expect_offense(<<~RUBY)
        class A
          private

          attr_accessor :foo

          attr_accessor :bar

          def initialize
          ^^^^^^^^^^^^^^ `initializer` is supposed to appear before `private_attribute_macros`.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        class A
          private

          def initialize
          end

          attr_accessor :foo

          attr_accessor :bar
        end
      RUBY
    end
  end

  it 'does not get confused by single node bodies' do
    expect_no_offenses(<<~RUBY)
      class A
        test&.private_methods(def foo; end)
      end
    RUBY
  end

  it 'does not get confused by kwbegin nodes' do
    expect_offense(<<~RUBY)
      class A
        begin
          begin
            private def foo; end
            private def qux; end
            public def bar; end
            ^^^^^^^^^^^^^^^^^^^ `public_methods` is supposed to appear before `private_methods`.
          end
        end
      end
    RUBY
  end

  it 'does not get confused by non-macro calls' do
    expect_no_offenses(<<~RUBY)
      class A
        def bar
        end

        singleton_class.attr_reader :foo
      end
    RUBY
  end

  it 'handles categories visibility with inline style too' do
    expect_offense(<<~RUBY)
      class A
        private attr_accessor :foo

        private attr_accessor :qux

        attr_accessor :bar
        ^^^^^^^^^^^^^^^^^^ `attribute_macros` is supposed to appear before `private_attribute_macros`.
      end
    RUBY
  end

  it 'treats inline unknown macros as not recognized' do
    expect_no_offenses(<<~RUBY)
      class A
        private something

        def bar
        end
      end
    RUBY
  end

  it 'considers singleton class too' do
    expect_offense(<<~RUBY)
      class << A
        private def foo; end
        private def qux; end
        public def bar; end
        ^^^^^^^^^^^^^^^^^^^ `public_methods` is supposed to appear before `private_methods`.
      end
    RUBY
  end
end
# rubocop:enable Lint/LiteralAsCondition
