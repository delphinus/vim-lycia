load 'bin/open-github-link'

RSpec.describe String, 'helper methods' do

  subject { String.new }

  it { is_expected.to respond_to :undent }
  it { is_expected.to respond_to :red }
  it { is_expected.to respond_to :cyan }

  describe '#undent' do

    context 'when some indented text' do

      let(:input) { <<-EOT }
        some
          indented
            text

          foo
            bar
      EOT
      let(:expected) { <<-EOT }
some
  indented
    text

  foo
    bar
      EOT

      it 'returns a valid undented text' do
        expect(input.undent).to eq expected
      end
    end
  end

  describe 'colorish methods' do

    let(:txt) { 'hoge' }
    let(:colored_text) { "\033[#{color_code}m#{txt}\033[0m" }

    before do
      allow(STDOUT).to receive(:isatty).and_return isatty
    end

    shared_examples_for STDOUT: :isatty do

      let(:isatty) { true }

      it { is_expected.to eq colored_text }
    end

    shared_examples_for STDOUT: :not_isatty do

      let(:isatty) { false }

      it { is_expected.to eq txt }
    end

    describe '#red' do

      let(:color_code) { 31 }
      subject { txt.red }

      context 'when isatty',     STDOUT: :isatty
      context 'when not isatty', STDOUT: :not_isatty
    end

    describe '#cyan' do

      let(:color_code) { 36 }
      subject { txt.cyan }

      context 'when isatty',     STDOUT: :isatty
      context 'when not isatty', STDOUT: :not_isatty
    end
  end
end
