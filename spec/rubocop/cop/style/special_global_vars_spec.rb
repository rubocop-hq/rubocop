# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::SpecialGlobalVars, :config do
  context 'when style is use_english_names' do
    let(:cop_config) { { 'EnforcedStyle' => 'use_english_names' } }

    it 'registers an offense for $@' do
      expect_offense(<<~RUBY)
        puts $@
             ^^ Prefer `$ERROR_POSITION` from the stdlib 'English' module (don't forget to require it) over `$@`.
      RUBY

      expect_correction(<<~RUBY)
        puts $ERROR_POSITION
      RUBY
    end

    it 'registers an offense for $;' do
      expect_offense(<<~RUBY)
        puts $;
             ^^ Prefer `$FIELD_SEPARATOR` or `$FS` from the stdlib 'English' module (don't forget to require it) over `$;`.
      RUBY

      expect_correction(<<~RUBY)
        puts $FIELD_SEPARATOR
      RUBY
    end

    it 'registers an offense for $,' do
      expect_offense(<<~RUBY)
        puts $,
             ^^ Prefer `$OUTPUT_FIELD_SEPARATOR` or `$OFS` from the stdlib 'English' module (don't forget to require it) over `$,`.
      RUBY

      expect_correction(<<~RUBY)
        puts $OUTPUT_FIELD_SEPARATOR
      RUBY
    end

    it 'registers an offense for $\\' do
      expect_offense(<<~RUBY)
        puts $\\
             ^^ Prefer `$OUTPUT_RECORD_SEPARATOR` or `$ORS` from the stdlib 'English' module (don't forget to require it) over `$\\`.
      RUBY

      expect_correction(<<~RUBY)
        puts $OUTPUT_RECORD_SEPARATOR
      RUBY
    end

    it 'registers an offense for $.' do
      expect_offense(<<~RUBY)
        puts $.
             ^^ Prefer `$INPUT_LINE_NUMBER` or `$NR` from the stdlib 'English' module (don't forget to require it) over `$.`.
      RUBY

      expect_correction(<<~RUBY)
        puts $INPUT_LINE_NUMBER
      RUBY
    end

    it 'registers an offense for $_' do
      expect_offense(<<~RUBY)
        puts $_
             ^^ Prefer `$LAST_READ_LINE` from the stdlib 'English' module (don't forget to require it) over `$_`.
      RUBY

      expect_correction(<<~RUBY)
        puts $LAST_READ_LINE
      RUBY
    end

    it 'registers an offense for $>' do
      expect_offense(<<~RUBY)
        puts $>
             ^^ Prefer `$DEFAULT_OUTPUT` from the stdlib 'English' module (don't forget to require it) over `$>`.
      RUBY

      expect_correction(<<~RUBY)
        puts $DEFAULT_OUTPUT
      RUBY
    end

    it 'registers an offense for $<' do
      expect_offense(<<~RUBY)
        puts $<
             ^^ Prefer `$DEFAULT_INPUT` from the stdlib 'English' module (don't forget to require it) over `$<`.
      RUBY

      expect_correction(<<~RUBY)
        puts $DEFAULT_INPUT
      RUBY
    end

    it 'registers an offense for $?' do
      expect_offense(<<~RUBY)
        puts $?
             ^^ Prefer `$CHILD_STATUS` from the stdlib 'English' module (don't forget to require it) over `$?`.
      RUBY

      expect_correction(<<~RUBY)
        puts $CHILD_STATUS
      RUBY
    end

    it 'registers an offense for $~' do
      expect_offense(<<~RUBY)
        puts $~
             ^^ Prefer `$LAST_MATCH_INFO` from the stdlib 'English' module (don't forget to require it) over `$~`.
      RUBY

      expect_correction(<<~RUBY)
        puts $LAST_MATCH_INFO
      RUBY
    end

    it 'registers an offense for $=' do
      expect_offense(<<~RUBY)
        puts $=
             ^^ Prefer `$IGNORECASE` from the stdlib 'English' module (don't forget to require it) over `$=`.
      RUBY

      expect_correction(<<~RUBY)
        puts $IGNORECASE
      RUBY
    end

    it 'registers an offense for $&' do
      expect_offense(<<~RUBY)
        puts $&
             ^^ Prefer `$MATCH` from the stdlib 'English' module (don't forget to require it) over `$&`.
      RUBY

      expect_correction(<<~RUBY)
        puts $MATCH
      RUBY
    end

    it 'registers an offense for $`' do
      expect_offense(<<~RUBY)
        puts $`
             ^^ Prefer `$PREMATCH` from the stdlib 'English' module (don't forget to require it) over `$``.
      RUBY

      expect_correction(<<~RUBY)
        puts $PREMATCH
      RUBY
    end

    it 'registers an offense for $\'' do
      expect_offense(<<~RUBY)
        puts $'
             ^^ Prefer `$POSTMATCH` from the stdlib 'English' module (don't forget to require it) over `$'`.
      RUBY

      expect_correction(<<~RUBY)
        puts $POSTMATCH
      RUBY
    end

    it 'registers an offense for $+' do
      expect_offense(<<~RUBY)
        puts $+
             ^^ Prefer `$LAST_PAREN_MATCH` from the stdlib 'English' module (don't forget to require it) over `$+`.
      RUBY

      expect_correction(<<~RUBY)
        puts $LAST_PAREN_MATCH
      RUBY
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
      expect(cop.config_to_allow_offenses).to eq(
        'EnforcedStyle' => 'use_perl_names'
      )

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
