load 'bin/open-github-link' unless 'constant' == defined? OpenGithubLink
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

    shared_examples_for system: :receive_a_valid_command do
      it 'system receive a valid command' do
        expect(Kernel).to have_received(:system).with valid_command
      end
    end

    context 'when on fssh', fssh?: :on, system: :receive_a_valid_command do
      let(:valid_command) {
        <<-CMD.undent.split("\n").join
          ssh -p #{port}  -l #{user}  #{copy_args}  localhost  PATH=#{path} "#{cmd}"
        CMD
      }
    end

    context 'when not on fssh', fssh?: :off, system: :receive_a_valid_command do
      let(:valid_command) { cmd }
    end
  end

  describe 'copy' do

    before do
      ENV['LC_FSSH_COPY'] = copy
      allow(described_class).to receive :system
      allow(described_class).to receive_message_chain(:`, :chomp).and_return rtun_path
      allow_message_expectations_on_nil
      allow(nil).to receive(:success?).and_return :exit_status
      with_warnings(nil) do
        FSSH::RUBY_PLATFORM = platform
      end
      FSSH::copy txt
    end

    let(:txt)           { 'some_txt' }
    let(:copy)          { 'some_copy' }
    let(:valid_command) { "echo '#{txt}' | #{copy_cmd}" }

    shared_examples_for execute: :a_valid_command do
      it 'execute a valid command' do
        expect(described_class).to have_received(:system).with valid_command
      end
    end

    context 'when on fssh', fssh?: :on, execute: :a_valid_command do
      let(:copy_cmd)  { copy }
      let(:rtun_path) { '' }
      let(:platform)  { 'darwin' }
    end

    context 'when not on fssh', fssh?: :off do

      context 'when on darwin' do

        let(:platform) { 'darwin' }
        let(:copy_cmd) { "#{rtun_path} pbcopy" }

        context 'when reattach-to-user-namespace is installed', execute: :a_valid_command do
          let(:rtun_path)   { '/usr/bin/reattach-to-user-namespace' }
          let(:exit_status) { true }
        end

        context 'when reattach-to-user-namespace is not installed', execute: :a_valid_command do
          let(:rtun_path)   { '' }
          let(:exit_status) { false }
        end
      end

      context 'when not on darwin', execute: :a_valid_command do
        let(:platform)  { 'some neat platform' }
        let(:copy_cmd)  { 'xclip -i' }
        let(:rtun_path) { '' }
      end
    end
  end
end
