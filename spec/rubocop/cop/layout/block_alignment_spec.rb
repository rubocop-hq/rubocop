# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Layout::BlockAlignment, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    { 'EnforcedStyleAlignWith' => 'either' }
  end

  context 'with begin-end block' do
    it 'registers an offense for mismatched block end' do
      expect_offense(<<~RUBY)
        begin
          end
          ^^^ `end` at 2, 2 is not aligned with `begin` at 1, 0.
      RUBY

      expect_correction(<<~RUBY)
        begin
        end
      RUBY
    end
  end

  context 'when the block has no arguments' do
    it 'registers an offense for mismatched block end' do
      expect_offense(<<~RUBY)
        test do
          end
          ^^^ `end` at 2, 2 is not aligned with `test do` at 1, 0.
      RUBY

      expect_correction(<<~RUBY)
        test do
        end
      RUBY
    end
  end

  context 'when the block has arguments' do
    it 'registers an offense for mismatched block end' do
      expect_offense(<<~RUBY)
        test do |ala|
          end
          ^^^ `end` at 2, 2 is not aligned with `test do |ala|` at 1, 0.
      RUBY

      expect_correction(<<~RUBY)
        test do |ala|
        end
      RUBY
    end
  end

  it 'accepts a block end that does not begin its line' do
    expect_no_offenses(<<~RUBY)
      scope :bar, lambda { joins(:baz)
                           .distinct }
    RUBY
  end

  context 'when the block is a logical operand' do
    it 'accepts a correctly aligned block end' do
      expect_no_offenses(<<~RUBY)
        (value.is_a? Array) && value.all? do |subvalue|
          type_check_value(subvalue, array_type)
        end
        a || b do
        end
      RUBY
    end
  end

  it 'accepts end aligned with a variable' do
    expect_no_offenses(<<~RUBY)
      variable = test do |ala|
      end
    RUBY
  end

  context 'when there is an assignment chain' do
    it 'registers an offense for an end aligned with the 2nd variable' do
      expect_offense(<<~RUBY)
        a = b = c = test do |ala|
            end
            ^^^ `end` at 2, 4 is not aligned with `a = b = c = test do |ala|` at 1, 0.
      RUBY

      expect_correction(<<~RUBY)
        a = b = c = test do |ala|
        end
      RUBY
    end

    it 'accepts end aligned with the first variable' do
      expect_no_offenses(<<~RUBY)
        a = b = c = test do |ala|
        end
      RUBY
    end
  end

  context 'and the block is an operand' do
    it 'accepts end aligned with a variable' do
      expect_no_offenses(<<~RUBY)
        b = 1 + preceding_line.reduce(0) do |a, e|
          a + e.length + newline_length
        end + 1
      RUBY
    end
  end

  it 'registers an offense for mismatched block end with a variable' do
    expect_offense(<<~RUBY)
      variable = test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `variable = test do |ala|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      variable = test do |ala|
      end
    RUBY
  end

  context 'when the block is defined on the next line' do
    it 'accepts end aligned with the block expression' do
      expect_no_offenses(<<~RUBY)
        variable =
          a_long_method_that_dont_fit_on_the_line do |v|
            v.foo
          end
      RUBY
    end

    it 'registers an offenses for mismatched end alignment' do
      expect_offense(<<~RUBY)
        variable =
          a_long_method_that_dont_fit_on_the_line do |v|
            v.foo
        end
        ^^^ `end` at 4, 0 is not aligned with `a_long_method_that_dont_fit_on_the_line do |v|` at 2, 2.
      RUBY

      expect_correction(<<~RUBY)
        variable =
          a_long_method_that_dont_fit_on_the_line do |v|
            v.foo
          end
      RUBY
    end
  end

  context 'when the method part is a call chain that spans several lines' do
    # Example from issue 346 of rubocop-hq/rubocop on github:
    it 'accepts pretty alignment style' do
      expect_no_offenses(<<~RUBY)
        def foo(bar)
          bar.get_stuffs
              .reject do |stuff|
                stuff.with_a_very_long_expression_that_doesnt_fit_the_line
              end.select do |stuff|
                stuff.another_very_long_expression_that_doesnt_fit_the_line
              end
              .select do |stuff|
                stuff.another_very_long_expression_that_doesnt_fit_the_line
              end
        end
      RUBY
    end

    it 'registers offenses for misaligned ends' do
      expect_offense(<<~RUBY)
        def foo(bar)
          bar.get_stuffs
              .reject do |stuff|
                stuff.with_a_very_long_expression_that_doesnt_fit_the_line
                end.select do |stuff|
                ^^^ `end` at 5, 8 is not aligned with `bar.get_stuffs` at 2, 2 or `.reject do |stuff|` at 3, 6.
                stuff.another_very_long_expression_that_doesnt_fit_the_line
            end
            ^^^ `end` at 7, 4 is not aligned with `bar.get_stuffs` at 2, 2 or `end.select do |stuff|` at 5, 8.
              .select do |stuff|
                stuff.another_very_long_expression_that_doesnt_fit_the_line
                end
                ^^^ `end` at 10, 8 is not aligned with `bar.get_stuffs` at 2, 2 or `.select do |stuff|` at 8, 6.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo(bar)
          bar.get_stuffs
              .reject do |stuff|
                stuff.with_a_very_long_expression_that_doesnt_fit_the_line
          end.select do |stuff|
                stuff.another_very_long_expression_that_doesnt_fit_the_line
          end
              .select do |stuff|
                stuff.another_very_long_expression_that_doesnt_fit_the_line
          end
        end
      RUBY
    end

    # Example from issue 393 of rubocop-hq/rubocop on github:
    it 'accepts end indented as the start of the block' do
      expect_no_offenses(<<~RUBY)
               my_object.chaining_this_very_long_method(with_a_parameter)
                   .and_one_with_a_block do
                 do_something
               end
        # Other variant:
               my_object.chaining_this_very_long_method(
                   with_a_parameter).and_one_with_a_block do
                 do_something
               end
      RUBY
    end

    # Example from issue 447 of rubocop-hq/rubocop on github:
    it 'accepts two kinds of end alignment' do
      expect_no_offenses(<<~RUBY)
        # Aligned with start of line where do is:
        params = default_options.merge(options)
                  .delete_if { |k, v| v.nil? }
                  .each_with_object({}) do |(k, v), new_hash|
                    new_hash[k.to_s] = v.to_s
                  end
        # Aligned with start of the whole expression:
        params = default_options.merge(options)
                  .delete_if { |k, v| v.nil? }
                  .each_with_object({}) do |(k, v), new_hash|
                    new_hash[k.to_s] = v.to_s
        end
      RUBY
    end
  end

  context 'when variables of a mass assignment spans several lines' do
    it 'accepts end aligned with the variables' do
      expect_no_offenses(<<~RUBY)
        e,
        f = [5, 6].map do |i|
          i - 5
        end
      RUBY
    end

    it 'registers an offense for end aligned with the block' do
      expect_offense(<<~RUBY)
        e,
        f = [5, 6].map do |i|
          i - 5
            end
            ^^^ `end` at 4, 4 is not aligned with `e,` at 1, 0 or `f = [5, 6].map do |i|` at 2, 0.
      RUBY

      expect_correction(<<~RUBY)
        e,
        f = [5, 6].map do |i|
          i - 5
        end
      RUBY
    end
  end

  it 'accepts end aligned with an instance variable' do
    expect_no_offenses(<<~RUBY)
      @variable = test do |ala|
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with' \
     ' an instance variable' do
    expect_offense(<<~RUBY)
      @variable = test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `@variable = test do |ala|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      @variable = test do |ala|
      end
    RUBY
  end

  it 'accepts end aligned with a class variable' do
    expect_no_offenses(<<~RUBY)
      @@variable = test do |ala|
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with a class variable' do
    expect_offense(<<~RUBY)
      @@variable = test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `@@variable = test do |ala|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      @@variable = test do |ala|
      end
    RUBY
  end

  it 'accepts end aligned with a global variable' do
    expect_no_offenses(<<~RUBY)
      $variable = test do |ala|
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with a global variable' do
    expect_offense(<<~RUBY)
      $variable = test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `$variable = test do |ala|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      $variable = test do |ala|
      end
    RUBY
  end

  it 'accepts end aligned with a constant' do
    expect_no_offenses(<<~RUBY)
      CONSTANT = test do |ala|
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with a constant' do
    expect_offense(<<~RUBY)
      Module::CONSTANT = test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `Module::CONSTANT = test do |ala|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      Module::CONSTANT = test do |ala|
      end
    RUBY
  end

  it 'accepts end aligned with a method call' do
    expect_no_offenses(<<~RUBY)
      parser.children << lambda do |token|
        token << 1
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with a method call' do
    expect_offense(<<~RUBY)
      parser.children << lambda do |token|
        token << 1
        end
        ^^^ `end` at 3, 2 is not aligned with `parser.children << lambda do |token|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      parser.children << lambda do |token|
        token << 1
      end
    RUBY
  end

  it 'accepts end aligned with a method call with arguments' do
    expect_no_offenses(<<~RUBY)
      @h[:f] = f.each_pair.map do |f, v|
        v = 1
      end
    RUBY
  end

  it 'registers an offense for mismatched end with a method call' \
     ' with arguments' do
    expect_offense(<<~RUBY)
      @h[:f] = f.each_pair.map do |f, v|
        v = 1
        end
        ^^^ `end` at 3, 2 is not aligned with `@h[:f] = f.each_pair.map do |f, v|` at 1, 0.
    RUBY

    expect_correction(<<~RUBY)
      @h[:f] = f.each_pair.map do |f, v|
        v = 1
      end
    RUBY
  end

  it 'does not raise an error for nested block in a method call' do
    expect_no_offenses('expect(arr.all? { |o| o.valid? })')
  end

  it 'accepts end aligned with the block when the block is a method argument' do
    expect_no_offenses(<<~RUBY)
      expect(arr.all? do |o|
               o.valid?
             end)
    RUBY
  end

  it 'registers an offense for mismatched end not aligned with the block' \
     ' that is an argument' do
    expect_offense(<<~RUBY)
      expect(arr.all? do |o|
        o.valid?
        end)
        ^^^ `end` at 3, 2 is not aligned with `arr.all? do |o|` at 1, 7 or `expect(arr.all? do |o|` at 1, 0.
    RUBY
  end

  it 'accepts end aligned with an op-asgn (+=, -=)' do
    expect_no_offenses(<<~RUBY)
      rb += files.select do |file|
        file << something
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with an op-asgn (+=, -=)' do
    expect_offense(<<~RUBY)
      rb += files.select do |file|
        file << something
        end
        ^^^ `end` at 3, 2 is not aligned with `rb` at 1, 0.
    RUBY
  end

  it 'accepts end aligned with an and-asgn (&&=)' do
    expect_no_offenses(<<~RUBY)
      variable &&= test do |ala|
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with an and-asgn (&&=)' do
    expect_offense(<<~RUBY)
      variable &&= test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `variable &&= test do |ala|` at 1, 0.
    RUBY
  end

  it 'accepts end aligned with an or-asgn (||=)' do
    expect_no_offenses(<<~RUBY)
      variable ||= test do |ala|
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with an or-asgn (||=)' do
    expect_offense(<<~RUBY)
      variable ||= test do |ala|
        end
        ^^^ `end` at 2, 2 is not aligned with `variable ||= test do |ala|` at 1, 0.
    RUBY
  end

  it 'accepts end aligned with a mass assignment' do
    expect_no_offenses(<<~RUBY)
      var1, var2 = lambda do |test|
        [1, 2]
      end
    RUBY
  end

  it 'accepts end aligned with a call chain left hand side' do
    expect_no_offenses(<<~RUBY)
      parser.diagnostics.consumer = lambda do |diagnostic|
        diagnostics << diagnostic
      end
    RUBY
  end

  it 'registers an offense for mismatched block end with a mass assignment' do
    expect_offense(<<~RUBY)
      var1, var2 = lambda do |test|
        [1, 2]
        end
        ^^^ `end` at 3, 2 is not aligned with `var1, var2` at 1, 0.
    RUBY
  end

  context 'when multiple similar-looking blocks have misaligned ends' do
    it 'registers an offense for each of them' do
      expect_offense(<<~RUBY)
        a = test do
         end
         ^^^ `end` at 2, 1 is not aligned with `a = test do` at 1, 0.
        b = test do
         end
         ^^^ `end` at 4, 1 is not aligned with `b = test do` at 3, 0.
      RUBY
    end
  end

  context 'on a splatted method call' do
    it 'aligns end with the splat operator' do
      expect_no_offenses(<<~RUBY)
        def get_gems_by_name
          @gems ||= Hash[*get_latest_gems.map { |gem|
                           [gem.name, gem, gem.full_name, gem]
                         }.flatten]
        end
      RUBY
    end

    it 'autocorrects' do
      source = <<~RUBY
        def get_gems_by_name
          @gems ||= Hash[*get_latest_gems.map { |gem|
                           [gem.name, gem, gem.full_name, gem]
                      }.flatten]
        end
      RUBY
      corrected = <<~RUBY
        def get_gems_by_name
          @gems ||= Hash[*get_latest_gems.map { |gem|
                           [gem.name, gem, gem.full_name, gem]
                         }.flatten]
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected)
    end
  end

  context 'on a bit-flipped method call' do
    it 'aligns end with the ~ operator' do
      expect_no_offenses(<<~RUBY)
        def abc
          @abc ||= A[~xyz { |x|
                       x
                     }.flatten]
        end
      RUBY
    end

    it 'autocorrects' do
      source = <<~RUBY
        def abc
          @abc ||= A[~xyz { |x|
                       x
                                }.flatten]
        end
      RUBY
      corrected = <<~RUBY
        def abc
          @abc ||= A[~xyz { |x|
                       x
                     }.flatten]
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected)
    end
  end

  context 'on a logically negated method call' do
    it 'aligns end with the ! operator' do
      expect_no_offenses(<<~RUBY)
        def abc
          @abc ||= A[!xyz { |x|
                       x
                     }.flatten]
        end
      RUBY
    end

    it 'autocorrects' do
      source = <<~RUBY
        def abc
          @abc ||= A[!xyz { |x|
                       x
        }.flatten]
        end
      RUBY
      corrected = <<~RUBY
        def abc
          @abc ||= A[!xyz { |x|
                       x
                     }.flatten]
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected)
    end
  end

  context 'on an arithmetically negated method call' do
    it 'aligns end with the - operator' do
      expect_no_offenses(<<~RUBY)
        def abc
          @abc ||= A[-xyz { |x|
                       x
                     }.flatten]
        end
      RUBY
    end

    it 'autocorrects' do
      source = <<~RUBY
        def abc
          @abc ||= A[-xyz { |x|
                       x
                          }.flatten]
        end
      RUBY
      corrected = <<~RUBY
        def abc
          @abc ||= A[-xyz { |x|
                       x
                     }.flatten]
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected)
    end
  end

  context 'when the block is terminated by }' do
    it 'mentions } (not end) in the message' do
      expect_offense(<<~RUBY)
        test {
          }
          ^ `}` at 2, 2 is not aligned with `test {` at 1, 0.
      RUBY
    end
  end

  context 'when configured to align with start_of_line' do
    let(:cop_config) do
      { 'EnforcedStyleAlignWith' => 'start_of_line' }
    end

    it 'allows when start_of_line aligned' do
      expect_no_offenses(<<~RUBY)
        foo.bar
          .each do
            baz
        end
      RUBY
    end

    it 'allows when start_of_line aligned for begin-end block' do
      expect_no_offenses(<<~RUBY)
        x = begin
          baz
        end
      RUBY
    end

    it 'errors when do aligned' do
      expect_offense(<<~RUBY)
        foo.bar
          .each do
            baz
          end
          ^^^ `end` at 4, 2 is not aligned with `foo.bar` at 1, 0.
      RUBY

      expect_correction(<<~RUBY)
        foo.bar
          .each do
            baz
        end
      RUBY
    end

    it 'errors when begin aligned for begin-end block' do
      expect_offense(<<~RUBY)
        x = begin
              baz
            end
            ^^^ `end` at 3, 4 is not aligned with `x = begin` at 1, 0.
      RUBY

      expect_correction(<<~RUBY)
        x = begin
              baz
        end
      RUBY
    end
  end

  context 'when configured to align with do' do
    let(:cop_config) do
      { 'EnforcedStyleAlignWith' => 'start_of_block' }
    end

    it 'allows when do aligned' do
      expect_no_offenses(<<~RUBY)
        foo.bar
          .each do
            baz
          end
      RUBY
    end

    it 'allows when do aligned for begin-end block' do
      expect_no_offenses(<<~RUBY)
        begin
          baz
        end
      RUBY
    end

    it 'errors when start_of_line aligned' do
      expect_offense(<<~RUBY)
        foo.bar
          .each do
            baz
        end
        ^^^ `end` at 4, 0 is not aligned with `.each do` at 2, 2.
      RUBY

      expect_correction(<<~RUBY)
        foo.bar
          .each do
            baz
          end
      RUBY
    end

    it 'errors when start_of_line aligned for begin-end block' do
      expect_offense(<<~RUBY)
        x =
          begin
            baz
        end
        ^^^ `end` at 4, 0 is not aligned with `begin` at 2, 2.
      RUBY

      expect_correction(<<~RUBY)
        x =
          begin
            baz
          end
      RUBY
    end
  end
end
