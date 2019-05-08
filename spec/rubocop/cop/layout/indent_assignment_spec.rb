# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::IndentAssignment, :config do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new('Layout/IndentAssignment' => {
                          'IndentationWidth' => cop_indent
                        },
                        'Layout/IndentationWidth' => { 'Width' => 2 })
  end
  let(:cop_indent) { nil } # use indentation with from Layout/IndentationWidth

  it 'registers an offense for incorrectly indented rhs' do
    expect_offense(<<~RUBY)
      a =
      if b ; end
      ^^^^^^^^^^ Indent the first line of the right-hand-side of a multi-line assignment.
    RUBY

    expect_correction(<<~RUBY)
      a =
        if b ; end
    RUBY
  end

  it 'allows assignments that do not start on a newline' do
    expect_no_offenses(<<~RUBY)
      a = if b
            foo
          end
    RUBY
  end

  it 'allows a properly indented rhs' do
    expect_no_offenses(<<~RUBY)
      a =
        if b ; end
    RUBY
  end

  it 'allows a properly indented rhs with fullwidth characters' do
    expect_no_offenses(<<~RUBY)
      f 'Ｒｕｂｙ', a =
                      b
    RUBY
  end

  it 'registers an offense for multi-lhs' do
    expect_offense(<<~RUBY)
      a,
      b =
      if b ; end
      ^^^^^^^^^^ Indent the first line of the right-hand-side of a multi-line assignment.
    RUBY

    expect_correction(<<~RUBY)
      a,
      b =
        if b ; end
    RUBY
  end

  it 'ignores comparison operators' do
    expect_no_offenses(<<~RUBY)
      a ===
      if b ; end
    RUBY
  end

  context 'when indentation width is overridden for this cop only' do
    let(:cop_indent) { 7 }

    it 'allows a properly indented rhs' do
      expect_no_offenses(<<~RUBY)
        a =
               if b ; end
      RUBY
    end

    it 'auto-corrects indentation' do
      expect_offense(<<~RUBY)
        a =
          if b ; end
          ^^^^^^^^^^ Indent the first line of the right-hand-side of a multi-line assignment.
      RUBY

      expect_correction(<<~RUBY)
        a =
               if b ; end
      RUBY
    end
  end
end
