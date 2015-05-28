load 'bin/open-github-link' unless 'constant' == defined? OpenGithubLink

RSpec.describe GithubUrl do

  subject { described_class.new }

  shared_examples_for git_command: :valid do
    before do
      allow_any_instance_of(described_class).to receive_message_chain(*%i,` split [] split [] split [],).and_return git_remote
    end
  end

  shared_examples_for git_command: :invalid do
    before do
      allow_any_instance_of(described_class).to receive(:`).and_raise StandardError
    end
  end

  describe 'confirming methods', git_command: :valid do

    let(:git_remote) { 'git@github.com:git/git' }

    it { is_expected.to respond_to :to_s }
    it { is_expected.to respond_to :open }
    it { is_expected.to respond_to :+ }
    it { is_expected.to respond_to :line_hash }
  end

  describe 'constructor' do

    shared_examples_for it: :occur_non_repository_error do
      it 'occurs NonRepositoryError' do
        expect { described_class.new }.to raise_error NonRepositoryError
      end
    end

    context 'when failed `git remote`', git_command: :invalid, it: :occur_non_repository_error

    context 'when successed `git remote`', git_command: :valid do

      subject { described_class.new.instance_variable_get :@url }

      shared_examples_for it: :has_a_valid_url do
        it { is_expected.to eq valid_url }
      end

      context 'when git remote is git@...', it: :has_a_valid_url do
        let(:git_remote) { 'git@github.com:git/git' }
        let(:valid_url)  { 'https://github.com/git/git' }
      end

      context 'when git remote is ssh://...', it: :has_a_valid_url do
        let(:git_remote) { 'ssh://git@github.com/git/git' }
        let(:valid_url)  { 'https://github.com/git/git' }
      end

      context 'when git remote is git://...', it: :has_a_valid_url do
        let(:git_remote) { 'git://github.com/git/git' }
        let(:valid_url)  { 'https://github.com/git/git' }
      end

      context 'when git remote is https://...', it: :has_a_valid_url do
        let(:git_remote) { 'https://github.com/git/git' }
        let(:valid_url)  { git_remote }
      end

      context 'when git remote is an invalid string', it: :occur_non_repository_error do
        let(:git_remote) { '' }
      end
    end
  end

  describe 'instance methods', git_command: :valid do

    let(:git_remote) { 'git@github.com:git/git' }

    before do
      subject.instance_variable_set :@url, url
    end

    describe '#+' do

      subject { described_class.new }

      shared_examples_for url: :joined_with_slash do
        it 'has a joined url with slash' do
          expect(subject.instance_variable_get :@url).to eq joined_url
        end
      end

      let(:joined_url) { 'some_url/some_other' }

      before do
        subject + other
      end

      context 'when url does not end with `/`' do

        context 'when other does not start with `/`', url: :joined_with_slash do
          let(:url)   { 'some_url' }
          let(:other) { 'some_other' }
        end

        context 'when other does start with `/`', url: :joined_with_slash do
          let(:url)   { 'some_url' }
          let(:other) { '/some_other' }
        end
      end

      context 'when url does end with `/`' do

        context 'when other does not start with `/`', url: :joined_with_slash do
          let(:url)   { 'some_url/' }
          let(:other) { 'some_other' }
        end

        context 'when other does start with `/`', url: :joined_with_slash do
          let(:url)   { 'some_url/' }
          let(:other) { '/some_other' }
        end
      end
    end
  end
end
