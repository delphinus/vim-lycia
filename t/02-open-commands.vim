source t/helpers/setup.vim

describe '`open` commands'

  before
    let g:open_github_link_command = 'echo'
    let g:open_github_link_git = 'echo some_branch || echo'
    let result = system('rm /tmp/vim-verbose.log')
    new
    put =['1', '2', '3', '4', '5', '6']
    call Select(3, 5)
  end

  after
    close!
  end

  describe 'open_github_link#open()'

    context 'when range is not given'

      context 'when is_current flag is off'
        it 'invokes a valid command'
          Expect Call('open_github_link#open', '/path/to/file') ==# "/path/to/file\n"
        end
      end

      context 'when is_current is on'
        it 'invokes a valid command'
          Expect Call('open_github_link#open', '/path/to/file', 0, 1) ==# "-b some_branch /path/to/file\n"
        end
      end
    end

    context 'when range is given'

      context 'when is_current flag is off'
        it 'invokes a valid command'
          Expect Call('open_github_link#open', '/path/to/file', 1) ==# "-f 3 -t 5 /path/to/file\n"
        end
      end

      context 'when is_current flag is on'
        it 'invokes a valid command'
          Expect Call('open_github_link#open', '/path/to/file', 1, 1) ==# "-b some_branch -f 3 -t 5 /path/to/file\n"
        end
      end
    end
  end

  describe 'open_github_link#open_top()'

    context 'when valid args'
      it 'invokes a valid command'
        Expect Call('open_github_link#open_top') ==# "-r\n"
      end
    end
  end
end
