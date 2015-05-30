load 'bin/open-github-link' unless 'constant' == defined? OpenGithubLink

RSpec.describe OpenGithubLink do

  subject { described_class.new }

  describe 'constructor' do

    before do
      allow(ARGV).to       receive(:getopts).and_return params
      allow(OpenTarget).to receive(:new).and_return     target
      allow(GithubUrl).to  receive(:new).and_return     github_url
      allow_any_instance_of(described_class).to receive_messages(
        help_and_exit: nil,
        default_branch: default_branch,
      )
    end

    let(:default_branch) { 'default_branch' }
    let(:from) { 3 }
    let(:to)   { 5 }

    let(:params) { {
      'root'   => root,
      'from'   => from,
      'to'     => to,
      'branch' => branch,
      'help'   => help?,
    } }

    let(:target) {
      mocked = instance_double OpenTarget
      allow(mocked).to receive(:nil?).and_return target_nil?
      mocked
    }

    let(:github_url) {
      mocked = instance_double GithubUrl
      allow(mocked).to receive_messages(
        open:      mocked,
        line_hash: mocked,
        :+ =>      mocked,
      )
      mocked
    }

    shared_examples_for help: :no do
      it { expect(subject).not_to receive :help_and_exit }
    end

    shared_examples_for help: :yes do
      it { expect(subject).to have_received(:help_and_exit).with(no_args).once }
    end

    shared_examples_for github_url_plus: :no do
      it { subject; expect(github_url).not_to receive :+ }
    end

    shared_examples_for github_url_plus: :once do
      it { subject; expect(github_url).to have_received(:+).with(kind_of String).once }
    end

    shared_examples_for github_url_plus_string: :yes do
      it { subject; expect(github_url).to have_received(:+).with(kind_of String).once }
    end

    shared_examples_for github_url_plus_target: :yes do
      it { subject; expect(github_url).to have_received(:+).with(target).once }
    end

    shared_examples_for github_url_open: :yes do
      it { subject; expect(github_url).to have_received(:open).with(no_args).once }
    end

    shared_examples_for github_url_line_hash: :no do
      it { subject; expect(github_url).not_to receive :line_hash }
    end

    shared_examples_for github_url_line_hash: :yes do
      it { subject; expect(github_url).to have_received(:line_hash).with(from, to).once }
    end

    shared_examples_for target_nil?: :no do
      it { subject; expect(target).not_to receive :nil? }
    end

    shared_examples_for target_nil?: :yes do
      it { subject; expect(target).to have_received(:nil?).with(no_args).once }
    end

    context 'when with help', help: :yes do
      let(:help?)          { true }
      let(:root)           { true }
      let(:branch)         { '' }
      let(:target_nil?)    { false }
    end

    context 'when with no help' do

      let(:help?) { false }

      context 'when with root' do

        let(:root) { true }

        context 'when branch == BRANCH_NOT_SPECIFIED', {
          help:                 :no,
          github_url_plus:      :no,
          github_url_line_hash: :no,
          github_url_open:      :yes,
          target_nil?:          :no,
        } do
          let(:branch) { described_class.const_get :BRANCH_NOT_SPECIFIED }
          let(:target_nil?) { false }
        end

        context 'when branch != BRANCH_NOT_SPECIFIED', {
          help:                   :no,
          github_url_plus_string: :yes,
          github_url_line_hash:   :no,
          github_url_open:        :yes,
          target_nil?:            :no,
        } do
          let(:branch) { '' }
          let(:target_nil?) { false }
        end
      end

      context 'when with no root' do

        let(:root) { false }
        let(:branch) { 'branch' }

        context 'when target is nil', {
          help:                 :no,
          github_url_plus:      :no,
          github_url_line_hash: :no,
          github_url_open:      :yes,
          target_nil?:          :yes,
        } do
          let(:target_nil?) { true }
        end

        context 'when target is not nil', {
          help:                   :no,
          github_url_plus_string: :yes,
          github_url_plus_target: :yes,
          github_url_line_hash:   :yes,
          github_url_open:        :yes,
          target_nil?:            :yes,
        } do
          let(:target_nil?) { false }
        end
      end
    end
  end
end
