# frozen_string_literal: true

RSpec.describe RuboCop::CommentConfig do
  subject(:comment_config) { described_class.new(parse_source(source)) }

  describe '#cop_enabled_at_line?' do
    let(:source) do
      # rubocop:disable Lint/EmptyExpression, Lint/EmptyInterpolation
      <<~RUBY
        # rubocop:disable Metrics/MethodLength with a comment why
        def some_method
          puts 'foo'                                                        # 03
        end
        # rubocop:enable Metrics/MethodLength

        # rubocop:disable all
        some_method                                                         # 08
        # rubocop:enable all

        code = 'This is evil.'
        eval(code) # rubocop:disable Security/Eval
        puts 'This is not evil.'                                            # 12

        def some_method
          puts 'Disabling indented single line' # rubocop:disable Layout/LineLength
        end
                                                                            # 18
        string = <<~END
        This is a string not a real comment # rubocop:disable Style/Loop
        END

        foo # rubocop:disable Style/MethodCallWithoutArgsParentheses        # 23

        # rubocop:enable Lint/Void

        # rubocop:disable Style/For, Style/Not,Layout/IndentationStyle
        foo                                                                 # 28

        class One
          # rubocop:disable Style/ClassVars
          @@class_var = 1
        end                                                                 # 33

        class Two
          # rubocop:disable Style/ClassVars
          @@class_var = 2
        end                                                                 # 38
        # rubocop:enable Style/Not,Layout/IndentationStyle
        # rubocop:disable Style/Send, Lint/RandOne some comment why
        # rubocop:disable Layout/BlockAlignment some comment why
        # rubocop:enable Style/Send, Layout/BlockAlignment but why?
        # rubocop:enable Lint/RandOne foo bar!                              # 43
        # rubocop:disable Lint/EmptyInterpolation
        "result is #{}"
        # rubocop:enable Lint/EmptyInterpolation
        # rubocop:disable RSpec/Example
        # rubocop:disable Custom2/Number9                                   # 48

        #=SomeDslDirective # rubocop:disable Layout/LeadingCommentSpace
        # rubocop:disable RSpec/Rails/HttpStatus
        it { is_expected.to have_http_status 200 }                          # 52
        # rubocop:enable RSpec/Rails/HttpStatus

        # rubocop:disable-next-line Style/EmptyMethod
        def foo                                                             # 56
        end
      RUBY
      # rubocop:enable Lint/EmptyExpression, Lint/EmptyInterpolation
    end

    def disabled_lines_of_cop(cop)
      (1..source.size).each_with_object([]) do |line_number, disabled_lines|
        enabled = comment_config.cop_enabled_at_line?(cop, line_number)
        disabled_lines << line_number unless enabled
      end
    end

    it 'supports disabling multiple lines with a pair of directive' do
      method_length_disabled_lines = disabled_lines_of_cop('Metrics/MethodLength')
      expected_part = (1..4).to_a
      expect(method_length_disabled_lines & expected_part).to eq(expected_part)
    end

    it 'supports enabling/disabling multiple cops in a single directive' do
      not_disabled_lines = disabled_lines_of_cop('Style/Not')
      tab_disabled_lines = disabled_lines_of_cop('Layout/IndentationStyle')

      expect(not_disabled_lines).to eq(tab_disabled_lines)
      expected_part = (27..39).to_a
      expect(not_disabled_lines & expected_part).to eq(expected_part)
    end

    it 'supports enabling/disabling multiple cops along with a comment' do
      {
        'Style/Send' => 40..42,
        'Lint/RandOne' => 40..43,
        'Layout/BlockAlignment' => 41..42
      }.each do |cop_name, expected|
        actual = disabled_lines_of_cop(cop_name)
        expect(actual & expected.to_a).to eq(expected.to_a)
      end
    end

    it 'supports disabling cops with multiple levels in department name' do
      disabled_lines = disabled_lines_of_cop('RSpec/Rails/HttpStatus')
      expected_part = (51..53).to_a
      expect(disabled_lines & expected_part).to eq(expected_part)
    end

    it 'supports enabling/disabling cops without a prefix' do
      empty_interpolation_disabled_lines = disabled_lines_of_cop('Lint/EmptyInterpolation')

      expected = (44..46).to_a

      expect(empty_interpolation_disabled_lines & expected).to eq(expected)
    end

    it 'supports disabling all lines after a directive' do
      for_disabled_lines = disabled_lines_of_cop('Style/For')
      expected_part = (27..source.size).to_a
      expect(for_disabled_lines & expected_part).to eq(expected_part)
    end

    it 'just ignores unpaired enabling directives' do
      void_disabled_lines = disabled_lines_of_cop('Lint/Void')
      expected_part = (25..source.size).to_a
      expect((void_disabled_lines & expected_part).empty?).to be(true)
    end

    it 'supports disabling single line with a directive at end of line' do
      eval_disabled_lines = disabled_lines_of_cop('Security/Eval')
      expect(eval_disabled_lines).to include(12)
      expect(eval_disabled_lines).not_to include(13)
    end

    it 'handles indented single line' do
      line_length_disabled_lines = disabled_lines_of_cop('Layout/LineLength')
      expect(line_length_disabled_lines).to include(16)
      expect(line_length_disabled_lines).not_to include(18)
    end

    it 'does not confuse a comment directive embedded in a string literal with a real comment' do
      loop_disabled_lines = disabled_lines_of_cop('Loop')
      expect(loop_disabled_lines).not_to include(20)
    end

    it 'supports disabling all cops except Lint/RedundantCopDisableDirective with keyword all' do
      expected_part = (7..8).to_a

      cops = RuboCop::Cop::Registry.all.reject do |klass|
        klass == RuboCop::Cop::Lint::RedundantCopDisableDirective
      end

      cops.each do |cop|
        disabled_lines = disabled_lines_of_cop(cop)
        expect(disabled_lines & expected_part).to eq(expected_part)
      end
    end

    it 'does not confuse a cop name including "all" with all cops' do
      alias_disabled_lines = disabled_lines_of_cop('Alias')
      expect(alias_disabled_lines).not_to include(23)
    end

    it 'can handle double disable of one cop' do
      expect(disabled_lines_of_cop('Style/ClassVars')).to eq([7, 8, 9] + (31..source.size).to_a)
    end

    it 'supports disabling cops with multiple uppercase letters' do
      expect(disabled_lines_of_cop('RSpec/Example')).to include(47)
    end

    it 'supports disabling cops with numbers in their name' do
      expect(disabled_lines_of_cop('Custom2/Number9')).to include(48)
    end

    it 'supports disabling cops on a comment line with an EOL comment' do
      expect(disabled_lines_of_cop('Layout/LeadingCommentSpace')).to eq([7, 8, 9, 50])
    end

    it 'supports disabling cops on next line' do
      expect(disabled_lines_of_cop('Style/EmptyMethod')).to eq([7, 8, 9, 56])
    end
  end

  describe '#cop_disabled_line_ranges' do
    subject(:range) { comment_config.cop_disabled_line_ranges }

    let(:source) do
      <<~RUBY
        # rubocop:disable Metrics/MethodLength with a comment why
        def some_method
          puts 'foo'
        end
        # rubocop:enable Metrics/MethodLength

        code = 'This is evil.'
        eval(code) # rubocop:disable Security/Eval
        puts 'This is not evil.'
      RUBY
    end

    it 'collects line ranges by disabled cops' do
      expect(range).to eq({ 'Metrics/MethodLength' => [1..5], 'Security/Eval' => [8..8] })
    end
  end

  describe '#extra_enabled_comments' do
    subject(:extra) { comment_config.extra_enabled_comments }

    let(:source) do
      <<~RUBY
        # rubocop:enable Metrics/MethodLength, Security/Eval
        def some_method; end
      RUBY
    end

    it 'has keys as instances of Parser::Source::Comment for extra enabled comments' do
      key = extra.keys.first

      expect(key.is_a?(Parser::Source::Comment)).to be true
      expect(key.text).to eq '# rubocop:enable Metrics/MethodLength, Security/Eval'
    end

    shared_examples 'has extra_enabled_comments' do |ctx, src|
      context ctx do
        let(:source) { src }

        it 'has extra_enabled_comments' do
          expect(extra.values.first).to eq ['Metrics/MethodLength']
        end
      end
    end

    include_examples 'has extra_enabled_comments',
                     'with `rubocop:enable`',
                     <<~RUBY
                       # rubocop:enable Metrics/MethodLength
                       def some_method; end
                     RUBY

    include_examples 'has extra_enabled_comments',
                     'with `rubocop:disable-next-line` and `rubocop:enable`',
                     <<~RUBY
                       # rubocop:disable-next-line Metrics/MethodLength
                       def some_method; end
                       # rubocop:enable Metrics/MethodLength
                     RUBY

    include_examples 'has extra_enabled_comments',
                     'with `rubocop:disable` for line and `rubocop:enable`',
                     <<~RUBY
                       def some_method; end # rubocop:disable Metrics/MethodLength
                       # rubocop:enable Metrics/MethodLength
                     RUBY

    shared_examples 'has no extra_enabled_comments' do |ctx, src|
      context ctx do
        let(:source) { src }

        it 'has no extra_enabled_comments' do
          expect(extra).to eq({})
        end
      end
    end

    include_examples 'has no extra_enabled_comments',
                     'with `rubocop:disable-next-line`',
                     <<~RUBY
                       # rubocop:disable-next-line Metrics/MethodLength
                       def some_method; end
                     RUBY

    include_examples 'has no extra_enabled_comments',
                     'with `rubocop:disable`',
                     <<~RUBY
                       # rubocop:disable Metrics/MethodLength
                       def some_method; end
                     RUBY

    include_examples 'has no extra_enabled_comments',
                     'with `rubocop:disable` for line',
                     <<~RUBY
                       def some_method; end # rubocop:disable Metrics/MethodLength
                     RUBY
  end

  describe 'comment_only_line?' do
    let(:source) do
      <<~RUBY
        # rubocop:disable Metrics/MethodLength                                01
        def some_method
          puts 'foo'
        end
        # rubocop:enable Metrics/MethodLength                                 05

        code = 'This is evil.'
        eval(code) # rubocop:disable Security/Eval
      RUBY
    end

    context 'when line contains only comment' do
      [1, 5].each do |line_number|
        it 'returns true' do
          expect(comment_config.comment_only_line?(line_number)).to be true
        end
      end
    end

    context 'when line is empty' do
      [6].each do |line_number|
        it 'returns true' do
          expect(comment_config.comment_only_line?(line_number)).to be true
        end
      end
    end

    context 'when line contains only code' do
      [2, 3, 4, 7].each do |line_number|
        it 'returns false' do
          expect(comment_config.comment_only_line?(line_number)).to be false
        end
      end
    end

    context 'when line contains code and comment' do
      [8].each do |line_number|
        it 'returns false' do
          expect(comment_config.comment_only_line?(line_number)).to be false
        end
      end
    end
  end
end
