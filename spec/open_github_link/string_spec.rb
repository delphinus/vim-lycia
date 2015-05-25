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
end
