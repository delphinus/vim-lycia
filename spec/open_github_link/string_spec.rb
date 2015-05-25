load 'bin/open-github-link'

RSpec.describe String, 'helper methods' do

  subject { String.new }

  it { is_expected.to respond_to :undent }
  it { is_expected.to respond_to :red }
  it { is_expected.to respond_to :cyan }
end
