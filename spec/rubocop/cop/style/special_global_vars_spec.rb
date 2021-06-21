# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::SpecialGlobalVars, :config do
  context 'when style is use_english_names' do
    context 'when add require English is disabled' do
      let(:cop_config) do
        {
          'EnforcedStyle' => 'use_english_names',
          'CorrecAddRequireEnglish' => false
        }
      end

      it 'registers an offense for $:' do
        expect_offense(<<~RUBY)
          puts $:
               ^^ Prefer `$LOAD_PATH` over `$:`.
        RUBY

        expect_correction(<<~RUBY)
          puts $LOAD_PATH
        RUBY
      end

      it 'registers an offense for $"' do
        expect_offense(<<~RUBY)
          puts $"
               ^^ Prefer `$LOADED_FEATURES` over `$"`.
        RUBY

        expect_correction(<<~RUBY)
          puts $LOADED_FEATURES
        RUBY
      end

      it 'registers an offense for $0' do
        expect_offense(<<~RUBY)
          puts $0
               ^^ Prefer `$PROGRAM_NAME` over `$0`.
        RUBY

        expect_correction(<<~RUBY)
          puts $PROGRAM_NAME
        RUBY
      end

      it 'registers an offense for $$' do
        expect_offense(<<~RUBY)
          puts $$
               ^^ Prefer `$PROCESS_ID` or `$PID` from the stdlib 'English' module (don't forget to require it) over `$$`.
        RUBY

        expect_correction(<<~RUBY)
          puts $PROCESS_ID
        RUBY
      end

      it 'is clear about variables from the English library vs those not' do
        expect_offense(<<~RUBY)
          puts $*
               ^^ Prefer `$ARGV` from the stdlib 'English' module (don't forget to require it) or `ARGV` over `$*`.
        RUBY

        expect_correction(<<~RUBY)
          puts $ARGV
        RUBY
      end

      it 'does not register an offense for backrefs like $1' do
        expect_no_offenses('puts $1')
      end

      it 'auto-corrects $/ to $INPUT_RECORD_SEPARATOR' do
        expect_offense(<<~RUBY)
          $/
          ^^ Prefer `$INPUT_RECORD_SEPARATOR` or `$RS` from the stdlib 'English' module (don't forget to require it) over `$/`.
        RUBY

        expect_correction(<<~RUBY)
          $INPUT_RECORD_SEPARATOR
        RUBY
      end

      it 'auto-corrects #$: to #{$LOAD_PATH}' do
        expect_offense(<<~'RUBY')
          "#$:"
            ^^ Prefer `$LOAD_PATH` over `$:`.
        RUBY

        expect_correction(<<~'RUBY')
          "#{$LOAD_PATH}"
        RUBY
      end

      it 'auto-corrects #{$!} to #{$ERROR_INFO}' do
        expect_offense(<<~'RUBY')
          "#{$!}"
             ^^ Prefer `$ERROR_INFO` from the stdlib 'English' module (don't forget to require it) over `$!`.
        RUBY

        expect_correction(<<~'RUBY')
          "#{$ERROR_INFO}"
        RUBY
      end

      it 'generates correct auto-config when Perl variable names are used' do
        expect_offense(<<~RUBY)
          $0
          ^^ Prefer `$PROGRAM_NAME` over `$0`.
        RUBY
        expect(cop.config_to_allow_offenses).to eq('EnforcedStyle' => 'use_perl_names')

        expect_correction(<<~RUBY)
          $PROGRAM_NAME
        RUBY
      end

      it 'generates correct auto-config when mixed styles are used' do
        expect_offense(<<~RUBY)
          $!; $ERROR_INFO
          ^^ Prefer `$ERROR_INFO` from the stdlib 'English' module (don't forget to require it) over `$!`.
        RUBY
        expect(cop.config_to_allow_offenses).to eq('Enabled' => false)

        expect_correction(<<~RUBY)
          $ERROR_INFO; $ERROR_INFO
        RUBY
      end
    end

    context 'when add require English is enabled' do
      let(:cop_config) do
        {
          'EnforcedStyle' => 'use_english_names',
          'CorrecAddRequireEnglish' => true
        }
      end

      context 'when English has not been required at top-level' do
        it 'adds require English for $$' do
          expect_offense(<<~RUBY)
            puts $$
                 ^^ Prefer `$PROCESS_ID` or `$PID` from the stdlib 'English' module (don't forget to require it) over `$$`.
          RUBY

          expect_correction(<<~RUBY)
            require 'English'
            puts $PROCESS_ID
          RUBY
        end

        it 'adds require English for $$ in nested code' do
          expect_offense(<<~RUBY)
            # frozen_string_literal: true

            x = true
            if x
              puts $$
                   ^^ Prefer `$PROCESS_ID` or `$PID` from the stdlib 'English' module (don't forget to require it) over `$$`.
            end
          RUBY

          expect_correction(<<~RUBY)
            # frozen_string_literal: true

            require 'English'
            x = true
            if x
              puts $PROCESS_ID
            end
          RUBY
        end

        it 'does not add for replacement outside of English lib' do
          expect_offense(<<~RUBY)
            puts $0
                 ^^ Prefer `$PROGRAM_NAME` over `$0`.
          RUBY

          expect_correction(<<~RUBY)
            puts $PROGRAM_NAME
          RUBY
        end
      end

      context 'when English is already required at top-level' do
        it 'leaves require English alone for $$' do
          expect_offense(<<~RUBY)
            require 'English'
            puts $$
                 ^^ Prefer `$PROCESS_ID` or `$PID` from the stdlib 'English' module (don't forget to require it) over `$$`.
          RUBY

          expect_correction(<<~RUBY)
            require 'English'
            puts $PROCESS_ID
          RUBY
        end

        it 'moves require English above replacement' do
          expect_offense(<<~RUBY)
            puts $$
                 ^^ Prefer `$PROCESS_ID` or `$PID` from the stdlib 'English' module (don't forget to require it) over `$$`.
            require 'English'
          RUBY

          expect_correction(<<~RUBY)
            require 'English'
            puts $PROCESS_ID
          RUBY
        end
      end
    end
  end

  context 'when style is use_perl_names' do
    let(:cop_config) { { 'EnforcedStyle' => 'use_perl_names' } }

    it 'registers an offense for $LOAD_PATH' do
      expect_offense(<<~RUBY)
        puts $LOAD_PATH
             ^^^^^^^^^^ Prefer `$:` over `$LOAD_PATH`.
      RUBY

      expect_correction(<<~RUBY)
        puts $:
      RUBY
    end

    it 'registers an offense for $LOADED_FEATURES' do
      expect_offense(<<~RUBY)
        puts $LOADED_FEATURES
             ^^^^^^^^^^^^^^^^ Prefer `$"` over `$LOADED_FEATURES`.
      RUBY

      expect_correction(<<~RUBY)
        puts $"
      RUBY
    end

    it 'registers an offense for $PROGRAM_NAME' do
      expect_offense(<<~RUBY)
        puts $PROGRAM_NAME
             ^^^^^^^^^^^^^ Prefer `$0` over `$PROGRAM_NAME`.
      RUBY

      expect_correction(<<~RUBY)
        puts $0
      RUBY
    end

    it 'registers an offense for $PID' do
      expect_offense(<<~RUBY)
        puts $PID
             ^^^^ Prefer `$$` over `$PID`.
      RUBY

      expect_correction(<<~RUBY)
        puts $$
      RUBY
    end

    it 'registers an offense for $PROCESS_ID' do
      expect_offense(<<~RUBY)
        puts $PROCESS_ID
             ^^^^^^^^^^^ Prefer `$$` over `$PROCESS_ID`.
      RUBY

      expect_correction(<<~RUBY)
        puts $$
      RUBY
    end

    it 'does not register an offense for backrefs like $1' do
      expect_no_offenses('puts $1')
    end

    it 'auto-corrects $INPUT_RECORD_SEPARATOR to $/' do
      expect_offense(<<~RUBY)
        $INPUT_RECORD_SEPARATOR
        ^^^^^^^^^^^^^^^^^^^^^^^ Prefer `$/` over `$INPUT_RECORD_SEPARATOR`.
      RUBY

      expect_correction(<<~RUBY)
        $/
      RUBY
    end

    it 'auto-corrects #{$LOAD_PATH} to #$:' do
      expect_offense(<<~'RUBY')
        "#{$LOAD_PATH}"
           ^^^^^^^^^^ Prefer `$:` over `$LOAD_PATH`.
      RUBY

      expect_correction(<<~'RUBY')
        "#$:"
      RUBY
    end
  end
end
