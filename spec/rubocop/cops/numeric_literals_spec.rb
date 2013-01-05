# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    describe NumericLiterals do
      let (:num) { NumericLiterals.new }

      it 'registers an offence for a long integer without underscores' do
        inspect_source(num, 'file.rb', ['a = 123456'])
        num.offences.map(&:message).should ==
          ['Add underscores to large numeric literals to improve their ' +
           'readability.']
      end

      it 'registers an offence for an integer with not enough underscores' do
        inspect_source(num, 'file.rb', ['a = 123456_789000'])
        num.offences.map(&:message).should ==
          ['Add underscores to large numeric literals to improve their ' +
           'readability.']
      end

      it 'registers an offence for a long float without underscores' do
        inspect_source(num, 'file.rb', ['a = 1.234567'])
        num.offences.map(&:message).should ==
          ['Add underscores to large numeric literals to improve their ' +
           'readability.']
      end

      it 'accepts long numbers with underscore' do
        inspect_source(num, 'file.rb', ['a = 123_456',
                                       'b = 1.234_56'])
        num.offences.map(&:message).should == []
      end

      it 'accepts a short integer without underscore' do
        inspect_source(num, 'file.rb', ['a = 123'])
        num.offences.map(&:message).should == []
      end

      it 'accepts short numbers without underscore' do
        inspect_source(num, 'file.rb', ['a = 123',
                                       'b = 123.456'])
        num.offences.map(&:message).should == []
      end
    end
  end
end
