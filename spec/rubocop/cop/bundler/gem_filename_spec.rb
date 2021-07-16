# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bundler::GemFilename, :config do
  shared_examples_for 'invalid gem file' do |message|
    it 'registers an offense' do
      offenses = _investigate(cop, processed_source)

      expect(offenses.size).to eq(1)
      expect(offenses.first.message).to eq(message)
    end
  end

  shared_examples_for 'valid gem file' do
    it 'does not register an offense' do
      offenses = _investigate(cop, processed_source)

      expect(offenses.size).to eq(0)
    end
  end

  context 'with default configuration' do
    let(:source) { 'print 1' }
    let(:processed_source) { parse_source(source) }

    before { allow(processed_source.buffer).to receive(:name).and_return(filename) }

    context 'with gems.rb file path' do
      let(:filename) { 'gems.rb' }

      include_examples 'invalid gem file', 'gems.rb file was found but Gemfile is required.'
    end

    context 'with gems.locked file path' do
      let(:filename) { 'gems.locked' }

      include_examples 'invalid gem file',
                       'Expected a Gemfile.lock with Gemfile but found gems.locked file.'
    end

    context 'with Gemfile file path' do
      let(:filename) { 'Gemfile' }

      include_examples 'valid gem file'
    end

    context 'with Gemfile.lock file path' do
      let(:filename) { 'Gemfile.lock' }

      include_examples 'valid gem file'
    end
  end

  context 'with RequiresGemfile set to false' do
    let(:source) { 'print 1' }
    let(:processed_source) { parse_source(source) }
    let(:cop_config) { { 'RequiresGemfile' => false } }

    before { allow(processed_source.buffer).to receive(:name).and_return(filename) }

    context 'with Gemfile file path' do
      let(:filename) { 'Gemfile' }

      include_examples 'invalid gem file', 'Gemfile was found but gems.rb file is required.'
    end

    context 'with Gemfile.lock file path' do
      let(:filename) { 'Gemfile.lock' }

      include_examples 'invalid gem file',
                       'Expected a gems.locked file with gems.rb but found Gemfile.lock.'
    end

    context 'with gems.rb file path' do
      let(:filename) { 'gems.rb' }

      include_examples 'valid gem file'
    end

    context 'with gems.locked file path' do
      let(:filename) { 'gems.locked' }

      include_examples 'valid gem file'
    end
  end
end
