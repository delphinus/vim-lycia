load 'bin/open-github-link'
require_relative './helpers/kernel_helper.rb'

RSpec.describe FSSH, 'module functions' do

  before do
    allow(described_class).to receive(:fssh?).and_return fssh_enabled?
  end

  let(:port)      { '12345' }
  let(:user)      { 'some_user' }
  let(:copy_args) { 'some_args' }
  let(:path)      { 'some_path' }
  let(:cmd)       { 'some command' }

  shared_examples_for fssh?: :on do
    let(:fssh_enabled?) { true }
  end

  shared_examples_for fssh?: :off do
    let(:fssh_enabled?) { false }
  end

  describe 'system' do

    before do
      ENV['LC_FSSH_PORT']      = port
      ENV['LC_FSSH_USER']      = user
      ENV['LC_FSSH_COPY_ARGS'] = copy_args
      ENV['LC_FSSH_PATH']      = path
      allow(Kernel).to receive :system
      FSSH::system cmd
    end

    context 'when on fssh', fssh?: :on do

      let(:valid_command) {
        <<-CMD.undent.split("\n").join
          ssh -p #{port}  -l #{user}  #{copy_args}  localhost  PATH=#{path} "#{cmd}"
        CMD
      }

      it 'execute a valid command' do
        expect(Kernel).to have_received(:system).with valid_command
      end
    end

    context 'when not on fssh', fssh?: :off do
      it 'execute a valid command' do
        expect(Kernel).to have_received(:system).with cmd
      end
    end
  end

  describe 'copy' do

    before do
      ENV['LC_FSSH_COPY'] = copy
      allow(described_class).to receive :system
      allow(described_class).to receive_message_chain(:`, :chomp).and_return rtun_path
      allow_message_expectations_on_nil
      allow(nil).to receive(:success?).and_return :exit_status
      FSSH::copy txt
    end

    let(:txt)           { 'some_txt' }
    let(:copy)          { 'some_copy' }
    let(:valid_command) { "echo '#{txt}' | #{copy_cmd}" }

    shared_context :executing_a_valid_command do
      it 'execute a valid command' do
        expect(described_class).to have_received(:system).with valid_command
      end
    end

    context 'when on fssh', fssh?: :on do
      let(:copy_cmd) { copy }
    end

    context 'when not on fssh', fssh?: :off do

      before do
        with_warnings(nil) do
          FSSH::RUBY_PLATFORM = platform
        end
      end

      context 'when on darwin' do

        let(:platform) { 'darwin' }
        let(:copy_cmd) { "#{rtun_path} pbcopy" }

        context 'when reattach-to-user-namespace is installed' do
          let(:rtun_path)   { '/usr/bin/reattach-to-user-namespace' }
          let(:exit_status) { true }

          it_behaves_like :executing_a_valid_command
        end
      end
    end
  end
end
