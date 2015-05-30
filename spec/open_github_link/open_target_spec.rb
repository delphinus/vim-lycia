load 'bin/open-github-link' unless 'constant' == defined? OpenGithubLink

RSpec.describe OpenTarget do

  describe 'confiming methods' do

    subject { described_class.new }

    let(:git_top_dir) { nil }

    it { is_expected.to respond_to :to_s }
    it { is_expected.to respond_to :nil? }
  end

  describe 'constructor' do

    before do
      allow_any_instance_of(described_class).to receive_message_chain(:`, :chomp).and_return git_top_dir
    end

    shared_examples_for it_is: :a_OpenTarget do
      it { is_expected.to be_a_instance_of described_class }
    end

    context 'when with no args', it_is: :a_OpenTarget do
      subject { described_class.new }
      let(:git_top_dir) { nil }
    end

    context 'when with path_str' do

      subject { described_class.new path_str }

      before do
        allow_any_instance_of(Pathname).to receive_messages(
          directory?:  directory?,
          relative?:   relative?,
          expand_path: expand_path,
        )
        allow(Dir).to receive :chdir
      end

      shared_examples_for it_has: :a_valid_path do
        it 'chdir to a valid dir' do
          subject
          expect(Dir).to have_received(:chdir).with pwd
        end

        it 'has a valid path' do
          expect(subject.instance_variable_get :@path).to eq path
        end
      end

      context 'when with relative path' do

        let(:relative?) { true }
        let(:expand_path) { Pathname("/path/to/expanded/#{path_str}") }

        context 'when with directory' do

          let(:directory?) { true }
          let(:path_str)   { 'some/dir' }
          let(:pwd)        { expand_path }

          context 'when path == git_top_dir', it_is: :a_OpenTarget, it_has: :a_valid_path do
            let(:git_top_dir) { expand_path }
            let(:path)        { nil }
          end

          context 'when path != git_top_dir', it_is: :a_OpenTarget, it_has: :a_valid_path do
            let(:git_top_dir) { Pathname('/path/to/expanded') }
            let(:path)        { Pathname('some/dir') }
          end
        end

        context 'when with file', it_is: :a_OpenTarget, it_has: :a_valid_path do
          let(:directory?)  { false }
          let(:path_str)    { 'some/dir/file.rb' }
          let(:pwd)         { expand_path.dirname }
          let(:git_top_dir) { expand_path.dirname }
          let(:path)        { Pathname('file.rb') }
        end
      end

      context 'when with absolute path' do

        let(:relative?)   { false }
        let(:expand_path) { nil }

        context 'when with directory' do

          let(:directory?) { true }
          let(:path_str)   { '/path/to/expanded/some/dir' }
          let(:pwd)        { Pathname(path_str) }

          context 'when path == git_top_dir', it_is: :a_OpenTarget, it_has: :a_valid_path do
            let(:git_top_dir) { Pathname(path_str) }
            let(:path)        { nil }
          end

          context 'when path != git_top_dir', it_is: :a_OpenTarget, it_has: :a_valid_path do
            let(:git_top_dir) { Pathname('/path/to/expanded') }
            let(:path)        { Pathname('some/dir') }
          end
        end
      end
    end
  end

  describe 'instance methods' do

    subject { described_class.new }

    before do
      subject.instance_variable_set :@path, Pathname('/some/path')
      allow(path).to receive :to_s
      allow(path).to receive :nil?
      subject.to_s
      subject.nil?
    end

    let(:path) { subject.instance_variable_get :@path }

    describe 'to_s' do
      it 'has a stringified path' do
        expect(path).to have_received(:to_s).once
      end
    end

    describe 'nil?' do
      it 'has been confirmed with :nil?' do
        expect(path).to have_received(:nil?).once
      end
    end
  end
end
