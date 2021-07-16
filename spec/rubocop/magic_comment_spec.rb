# frozen_string_literal: true

RSpec.describe RuboCop::MagicComment do
  shared_examples 'magic comment' do |comment, expectations = {}|
    encoding = expectations[:encoding]
    frozen_string = expectations[:frozen_string_literal]
    shareable_constant_value = expectations[:shareable_constant_value]

    it "returns #{encoding.inspect} for encoding when comment is #{comment}" do
      expect(described_class.parse(comment).encoding).to eql(encoding)
    end

    it "returns #{frozen_string.inspect} for frozen_string_literal when comment is #{comment}" do
      expect(described_class.parse(comment).frozen_string_literal).to eql(frozen_string)
    end

    it "returns #{shareable_constant_value.inspect} for shareable_constant_value " \
       "when comment is #{comment}" do
      expect(described_class.parse(comment)
                            .shareable_constant_value).to eql(shareable_constant_value)
    end
  end

  include_examples 'magic comment', '#'

  include_examples 'magic comment', '# encoding: utf-8', encoding: 'utf-8'

  include_examples 'magic comment', '# ENCODING: utf-8', encoding: 'utf-8'

  include_examples 'magic comment', '# eNcOdInG: utf-8', encoding: 'utf-8'

  include_examples 'magic comment', '# coding: utf-8', encoding: 'utf-8'

  include_examples 'magic comment', '    # coding: utf-8', encoding: 'utf-8'

  include_examples 'magic comment', '# incoding: utf-8'

  include_examples 'magic comment',
                   '# encoding: stateless-iso-2022-jp-kddi',
                   encoding: 'stateless-iso-2022-jp-kddi'

  include_examples 'magic comment', '# frozen_string_literal: true', frozen_string_literal: true

  include_examples 'magic comment', '    # frozen_string_literal: true', frozen_string_literal: true

  include_examples 'magic comment', '# frozen_string_literal:true', frozen_string_literal: true

  include_examples 'magic comment', '# frozen_string_literal: false', frozen_string_literal: false

  include_examples 'magic comment', '# frozen-string-literal: true', frozen_string_literal: true

  include_examples 'magic comment', '# FROZEN-STRING-LITERAL: true', frozen_string_literal: true

  include_examples 'magic comment', '# fRoZeN-sTrInG_lItErAl: true', frozen_string_literal: true

  include_examples 'magic comment', '# shareable_constant_value: literal', shareable_constant_value: 'literal'

  include_examples 'magic comment', '# shareable_constant_value:literal', shareable_constant_value: 'literal'

  include_examples 'magic comment', '# shareable-constant-value: literal', shareable_constant_value: 'literal'

  include_examples 'magic comment', '# SHAREABLE-CONSTANT-VALUE: literal', shareable_constant_value: 'literal'

  include_examples 'magic comment', '# sHaReaBLE-CoNstANT-ValUE: literal', shareable_constant_value: 'literal'

  include_examples 'magic comment', '# shareable_constant_value: none', shareable_constant_value: 'none'

  include_examples 'magic comment', '# xyz shareable_constant_value: literal'

  include_examples 'magic comment', '# xyz shareable_constant_value: literal xyz'

  include_examples(
    'magic comment',
    '# shareable_constant_value: experimental_everything',
    shareable_constant_value: 'experimental_everything'
  )

  include_examples(
    'magic comment',
    '# shareable_constant_value: experimental_copy',
    shareable_constant_value: 'experimental_copy'
  )

  include_examples 'magic comment',
                   '# -*- frozen-string-literal: true -*-',
                   frozen_string_literal: true

  include_examples 'magic comment',
                   '# frozen_string_literal: invalid',
                   frozen_string_literal: 'invalid'

  include_examples 'magic comment',
                   '# -*- encoding : ascii-8bit -*-',
                   encoding: 'ascii-8bit',
                   frozen_string_literal: nil

  include_examples 'magic comment',
                   '# encoding: ascii-8bit frozen_string_literal: true',
                   encoding: 'ascii-8bit',
                   frozen_string_literal: nil

  include_examples 'magic comment',
                   '# frozen_string_literal: true encoding: ascii-8bit',
                   encoding: 'ascii-8bit',
                   frozen_string_literal: nil

  include_examples 'magic comment',
                   ' CSV.generate(encoding: Encoding::UTF_8) do |csv|',
                   encoding: nil,
                   frozen_string_literal: nil

  include_examples(
    'magic comment',
    '# -*- encoding: ASCII-8BIT; frozen_string_literal: true -*-',
    encoding: 'ascii-8bit',
    frozen_string_literal: true
  )

  include_examples(
    'magic comment',
    '# coding: utf-8 -*- encoding: ASCII-8BIT; frozen_string_literal: true -*-',
    encoding: 'ascii-8bit',
    frozen_string_literal: true
  )

  include_examples(
    'magic comment',
    '# -*- coding: ASCII-8BIT; frozen_string_literal: true -*-',
    encoding: 'ascii-8bit',
    frozen_string_literal: true
  )

  include_examples 'magic comment',
                   '# vim: filetype=ruby, fileencoding=ascii-8bit',
                   encoding: 'ascii-8bit'

  include_examples 'magic comment', '# vim: filetype=ruby,fileencoding=ascii-8bit', encoding: nil

  include_examples 'magic comment',
                   '# vim: filetype=ruby,  fileencoding=ascii-8bit',
                   encoding: 'ascii-8bit'

  include_examples 'magic comment',
                   '#vim: filetype=ruby, fileencoding=ascii-8bit',
                   encoding: 'ascii-8bit'

  include_examples(
    'magic comment',
    '# coding: utf-8 vim: filetype=ruby, fileencoding=ascii-8bit',
    encoding: 'utf-8'
  )

  include_examples 'magic comment',
                   '# vim: filetype=python, fileencoding=ascii-8bit',
                   encoding: 'ascii-8bit'

  include_examples 'magic comment', '# vim:fileencoding=utf-8', encoding: nil

  describe '#valid_shareable_constant_value?' do
    subject { described_class.parse(comment).valid_shareable_constant_value? }

    context 'when given comment specified as `none`' do
      let(:comment) { '# shareable_constant_value: none' }

      it { is_expected.to eq(true) }
    end

    context 'when given comment specified as `literal`' do
      let(:comment) { '# shareable_constant_value: literal' }

      it { is_expected.to eq(true) }
    end

    context 'when given comment specified as `experimental_everything`' do
      let(:comment) { '# shareable_constant_value: experimental_everything' }

      it { is_expected.to eq(true) }
    end

    context 'when given comment specified as `experimental_copy`' do
      let(:comment) { '# shareable_constant_value: experimental_copy' }

      it { is_expected.to eq(true) }
    end

    context 'when given comment specified as unknown value' do
      let(:comment) { '# shareable_constant_value: unknown' }

      it { is_expected.to eq(false) }
    end

    context 'when given comment is not specified' do
      let(:comment) { '' }

      it { is_expected.to eq(false) }
    end
  end
end
