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
      allow(FSSH).to receive :system
      FSSH::copy txt
    end

    let(:txt)           { 'some_txt' }
    let(:copy)          { 'some_copy' }
    let(:valid_command) { "echo '#{txt}' | #{copy_cmd}" }

    context 'when on fssh', fssh?: :on do

      let(:copy_cmd) { copy }

      it 'execute a valid command' do
        expect(FSSH).to have_received(:system).with valid_command
      end
    end

    context 'when not on fssh', fssh?: :off do

      context 'when on darwin' do

        before do
          with_warnings(nil) do
            FSSH::RUBY_PLATFORM = 'darwin'
          end
        end
      end
    end
  end
end
