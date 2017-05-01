# frozen_string_literal: true

describe RuboCop::Cop::Style::MultilineIfThen do
  subject(:cop) { described_class.new }

  # if

  it 'does not get confused by empty elsif branch' do
    expect_no_offenses(<<-END.strip_indent)
      if cond
      elsif cond
      end
    END
  end

  it 'registers an offense for then in multiline if' do
    inspect_source(cop, ['if cond then',
                         'end',
                         "if cond then\t",
                         'end',
                         'if cond then  ',
                         'end',
                         'if cond',
                         'then',
                         'end',
                         'if cond then # bad',
                         'end'])
    expect(cop.offenses.map(&:line)).to eq([1, 3, 5, 8, 10])
    expect(cop.highlights).to eq(['then'] * 5)
    expect(cop.messages).to eq(['Do not use `then` for multi-line `if`.'] * 5)
  end

  it 'registers an offense for then in multiline elsif' do
    inspect_source(cop, <<-END.strip_indent)
      if cond1
        a
      elsif cond2 then
        b
      end
    END
    expect(cop.offenses.map(&:line)).to eq([3])
    expect(cop.highlights).to eq(['then'])
    expect(cop.messages).to eq(['Do not use `then` for multi-line `elsif`.'])
  end

  it 'accepts multiline if without then' do
    expect_no_offenses(<<-END.strip_indent)
      if cond
      end
    END
  end

  it 'accepts table style if/then/elsif/ends' do
    expect_no_offenses(<<-END.strip_indent)
      if    @io == $stdout then str << "$stdout"
      elsif @io == $stdin  then str << "$stdin"
      elsif @io == $stderr then str << "$stderr"
      else                      str << @io.class.to_s
      end
    END
  end

  it 'does not get confused by a then in a when' do
    expect_no_offenses(<<-END.strip_indent)
      if a
        case b
        when c then
        end
      end
    END
  end

  it 'does not get confused by a commented-out then' do
    expect_no_offenses(<<-END.strip_indent)
      if a # then
        b
      end
      if c # then
      end
    END
  end

  it 'does not raise an error for an implicit match if' do
    expect do
      inspect_source(cop, <<-END.strip_indent)
        if //
        end
      END
    end.not_to raise_error
  end

  # unless

  it 'registers an offense for then in multiline unless' do
    expect_offense(<<-END.strip_indent)
      unless cond then
                  ^^^^ Do not use `then` for multi-line `unless`.
      end
    END
  end

  it 'accepts multiline unless without then' do
    expect_no_offenses(<<-END.strip_indent)
      unless cond
      end
    END
  end

  it 'does not get confused by a postfix unless' do
    expect_no_offenses('two unless one')
  end

  it 'does not get confused by a nested postfix unless' do
    expect_no_offenses(<<-END.strip_indent)
      if two
        puts 1
      end unless two
    END
  end

  it 'does not raise an error for an implicit match unless' do
    expect do
      inspect_source(cop, <<-END.strip_indent)
        unless //
        end
      END
    end.not_to raise_error
  end

  it 'auto-corrects the usage of "then" in multiline if' do
    new_source = autocorrect_source(cop, <<-END.strip_indent)
      if cond then
        something
      end
    END
    expect(new_source).to eq(<<-END.strip_indent)
      if cond
        something
      end
    END
  end
end
