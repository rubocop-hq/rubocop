# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::RedundantCopEnableDirective, :config do
  it 'registers offense and corrects unnecessary enable' do
    expect_offense(<<~RUBY)
      foo
      # rubocop:enable Layout/LineLength
                       ^^^^^^^^^^^^^^^^^ Unnecessary enabling of Layout/LineLength.
    RUBY

    expect_correction(<<~RUBY)
      foo
    RUBY
  end

  it 'registers an offense and corrects when the first cop is unnecessarily enabled' do
    expect_offense(<<~RUBY)
      # rubocop:disable Layout/LineLength
      foo
      # rubocop:enable Metrics/AbcSize, Layout/LineLength
                       ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
    RUBY

    expect_correction(<<~RUBY)
      # rubocop:disable Layout/LineLength
      foo
      # rubocop:enable Layout/LineLength
    RUBY
  end

  it 'registers multiple offenses and corrects the same comment' do
    expect_offense(<<~RUBY)
      foo
      # rubocop:enable Metrics/ModuleLength, Metrics/AbcSize
                                             ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
                       ^^^^^^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/ModuleLength.
      bar
    RUBY

    expect_correction(<<~RUBY)
      foo
      bar
    RUBY
  end

  it 'registers correct offense when combined with necessary enable' do
    expect_offense(<<~RUBY)
      # rubocop:disable Layout/LineLength
      fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo = barrrrrrrrrrrrrrrrrrrrrrrrrr
      # rubocop:enable Metrics/AbcSize, Layout/LineLength
                       ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
      bar
    RUBY

    expect_correction(<<~RUBY)
      # rubocop:disable Layout/LineLength
      fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo = barrrrrrrrrrrrrrrrrrrrrrrrrr
      # rubocop:enable Layout/LineLength
      bar
    RUBY
  end

  it 'registers correct offense when combined with necessary enable, no white-space after comma' do
    expect_offense(<<~RUBY)
      # rubocop:disable Layout/LineLength
      fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo = barrrrrrrrrrrrrrrrrrrrrrrrrr
      # rubocop:enable Metrics/AbcSize,Layout/LineLength
                       ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
      bar
    RUBY

    expect_correction(<<~RUBY)
      # rubocop:disable Layout/LineLength
      fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo = barrrrrrrrrrrrrrrrrrrrrrrrrr
      # rubocop:enable Layout/LineLength
      bar
    RUBY
  end

  it 'registers offense and corrects redundant enabling of same cop' do
    expect_offense(<<~RUBY)
      # rubocop:disable Layout/LineLength
      fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo = barrrrrrrrrrrrrrrrrrrrrrrrrr
      # rubocop:enable Layout/LineLength

      bar

      # rubocop:enable Layout/LineLength
                       ^^^^^^^^^^^^^^^^^ Unnecessary enabling of Layout/LineLength.
      bar
    RUBY

    expect_correction(<<~RUBY)
      # rubocop:disable Layout/LineLength
      fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo = barrrrrrrrrrrrrrrrrrrrrrrrrr
      # rubocop:enable Layout/LineLength

      bar

      bar
    RUBY
  end

  context 'all switch' do
    it 'registers offense and corrects unnecessary enable all' do
      expect_offense(<<~RUBY)
        foo
        # rubocop:enable all
                         ^^^ Unnecessary enabling of all cops.
      RUBY

      expect_correction(<<~RUBY)
        foo
      RUBY
    end

    context 'when at least one cop was disabled' do
      it 'does not register offense' do
        expect_no_offenses(<<~RUBY)
          # rubocop:disable Layout/LineLength
          foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
          # rubocop:enable all
        RUBY
      end
    end
  end

  context 'when last cop is unnecessarily enabled' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        # rubocop:disable Layout/LineLength
        foo
        # rubocop:enable Layout/LineLength, Metrics/AbcSize
                                            ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
      RUBY

      expect_correction(<<~RUBY)
        # rubocop:disable Layout/LineLength
        foo
        # rubocop:enable Layout/LineLength
      RUBY
    end

    it 'registers an offense and corrects when there is no space between the cops and the comma' do
      expect_offense(<<~RUBY)
        # rubocop:disable Layout/LineLength
        foo
        # rubocop:enable Layout/LineLength,Metrics/AbcSize
                                           ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
      RUBY

      expect_correction(<<~RUBY)
        # rubocop:disable Layout/LineLength
        foo
        # rubocop:enable Layout/LineLength
      RUBY
    end
  end

  context 'when middle cop is unnecessarily enabled' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        # rubocop:disable Layout/LineLength, Lint/Debugger
        foo
        # rubocop:enable Layout/LineLength, Metrics/AbcSize, Lint/Debugger
                                            ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
      RUBY

      expect_correction(<<~RUBY)
        # rubocop:disable Layout/LineLength, Lint/Debugger
        foo
        # rubocop:enable Layout/LineLength, Lint/Debugger
      RUBY
    end

    it 'registers an offense and corrects when there is extra white space' do
      expect_offense(<<~RUBY)
        # rubocop:disable Layout/LineLength,  Lint/Debugger
        foo
        # rubocop:enable Layout/LineLength,  Metrics/AbcSize,  Lint/Debugger
                                             ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
      RUBY

      expect_correction(<<~RUBY)
        # rubocop:disable Layout/LineLength,  Lint/Debugger
        foo
        # rubocop:enable Layout/LineLength,  Lint/Debugger
      RUBY
    end
  end

  context 'when all cops are unnecessarily enabled' do
    context 'on the same line' do
      it 'registers an offense and corrects' do
        expect_offense(<<~RUBY)
          foo
          # rubocop:enable Layout/LineLength, Metrics/AbcSize, Lint/Debugger
                                                               ^^^^^^^^^^^^^ Unnecessary enabling of Lint/Debugger.
                                              ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
                           ^^^^^^^^^^^^^^^^^ Unnecessary enabling of Layout/LineLength.
        RUBY

        expect_correction(<<~RUBY)
          foo
        RUBY
      end
    end

    context 'on separate lines' do
      it 'registers an offense and corrects when there is extra white space' do
        expect_offense(<<~RUBY)
          foo
          # rubocop:enable Metrics/ModuleSize
                           ^^^^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/ModuleSize.
          # rubocop:enable Layout/LineLength, Metrics/ClassSize
                           ^^^^^^^^^^^^^^^^^ Unnecessary enabling of Layout/LineLength.
                                              ^^^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/ClassSize.
          # rubocop:enable Metrics/AbcSize, Lint/Debugger
                                            ^^^^^^^^^^^^^ Unnecessary enabling of Lint/Debugger.
                           ^^^^^^^^^^^^^^^ Unnecessary enabling of Metrics/AbcSize.
        RUBY

        expect_correction(<<~RUBY)
          foo
        RUBY
      end
    end
  end

  context 'when cop disabled with `disable-next-line` and enabled again' do
    it 'registers an offense and corrects' do
      expect_offense(<<~RUBY)
        # rubocop:disable-next-line Layout/LineLength
        foo
        # rubocop:enable Layout/LineLength
                         ^^^^^^^^^^^^^^^^^ Unnecessary enabling of Layout/LineLength.
      RUBY

      expect_correction(<<~RUBY)
        # rubocop:disable-next-line Layout/LineLength
        foo
      RUBY
    end
  end
end
