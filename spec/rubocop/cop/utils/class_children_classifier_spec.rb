# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Utils::ClassChildrenClassifier do
  subject(:values) { values_at(*fields).flatten(1) }

  let(:source) { "class Foo\n#{body}\nend" }
  let(:fields) { %i[visibility group] }
  let(:visibilities) { values.map { |c| c[:visibility] } }
  let(:ast) { parse_source(source).ast }
  let(:class_node) { ast }
  let(:categories) do
    {
      module_inclusion: %i[include prepend extend],
      attributes: %i[attr_reader attr_writer attr_accessor],
      associations: %i[has_one has_many belongs_to]
    }
  end
  let(:instance) { described_class.new(categories) }
  let(:classification_map) { instance.classify_children(class_node) }
  let(:classification) { classification_map.values }

  def values_at(*which)
    classification.map { |h| h.values_at(*which) }
  end

  context 'given def(s) with inline visibility' do
    let(:body) { <<~RUBY }
      def foo; end
      protected def bar; end
      private def baz; end
      public def qux; end
      private_class_method def self.foo; end
      public_class_method def self.bar; end
    RUBY

    it {
      expect(values).to match %i[
        public methods
        protected methods
        private methods
        public methods
        private class_methods
        public class_methods
      ]
    }
  end

  context 'given def(s) with specific visibility' do
    let(:body) { <<~RUBY }
      private
      def foo; end
      def bar; end
      def baz; end
      def qux; end
      def self.foo; end
      def self.bar; end
      def self.qux; end
      protected :bar
      private :baz
      public :qux
      private_class_method :foo
      public_class_method :bar
    RUBY

    it {
      expect(values).to match %i[
        private methods
        private methods
        protected methods
        private methods
        public methods
        private class_methods
        public class_methods
        public class_methods
        protected methods
        private methods
        public methods
        private class_methods
        public class_methods
      ]
    }
  end

  context 'given visibility for multiple def / constants' do
    let(:body) { <<~RUBY }
      attr_reader :at
      def foo; end
      def bar; end
      def qux; end
      private :foo, :bar
      private :at
      X = 42
      Y = 42
      Z = 42
      private_constant :X, :Y
    RUBY

    it {
      expect(values).to match %i[
        private methods
        private methods
        private methods
        public methods
        private methods
        private methods
        private constants
        private constants
        public constants
        private constants
      ]
    }
  end

  context 'given macros' do
    let(:fields) { %i[macro category affects_categories] }
    let(:body) { <<~RUBY }
      some_macro
      belongs_to :foo, bar: :baz
      has_many :qux
      attr_accessor :a, :b, :c
    RUBY

    it {
      expect(values).to eq [
        :generic, nil, nil,
        :generic, :associations, nil,
        :generic, :associations, nil,
        :generic, :attributes, nil
      ]
    }

    context 'with mixed categories for post-macros' do
      let(:body) { <<~RUBY }
        attr_reader :foo
        belongs_to :bar, foreign_key: true
        private :foo, :bar
      RUBY

      it {
        expect(values).to eq [
          :generic, :attributes, nil,
          :generic, :associations, nil,
          :post, nil, %i[attributes associations]
        ]
      }
    end

    context 'with mixed categories for pre-macros' do
      let(:body) { <<~RUBY }
        private
        attr_reader :foo
        belongs_to :bar, foreign_key: true
      RUBY

      it {
        expect(values).to eq [
          :pre, nil, %i[attributes associations],
          :generic, :attributes, nil,
          :generic, :associations, nil
        ]
      }
    end

    context 'with unknown categories for post-macros' do
      let(:body) { <<~RUBY }
        FOO = 42
        BAR = 42
        private_constant :FOO
        private_constant :BAR, :BAZ
        private_constant :QUX
      RUBY

      it {
        expect(values).to eq [
          nil, nil, nil, # no worries, group == :constants
          nil, nil, nil,
          :post, nil, [:constants],
          :post, nil, [:constants],
          :post, nil, []
        ]
      }
    end
  end
end
