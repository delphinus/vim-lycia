source t/helpers/setup.vim

describe '`open` commands'

  before
    let g:open_github_link_command = 'echo'
    let g:open_github_link_git = 'echo some_branch || echo'
  end

  describe 'open_github_link#open()'

    context 'when range is given'
      it 'invokes a valid command'
        Expect Call('open_github_link#open', ['/path/to/file'], 50, 30, 50) ==# "-f 30 -t 50 /path/to/file\n"
      end
    end

    context 'when range is not given'
      it 'invokes a valid command'
        Expect Call('open_github_link#open', ['/path/to/file'], 0, 30, 50) ==# "/path/to/file\n"
      end
    end
  end

  describe 'open_github_link#open_current_branch()'

    context 'when range is given'
      it 'invokes a valid command'
        Expect Call('open_github_link#open_current_branch', ['/path/to/file'], 50, 30, 50) ==# "-b some_branch -f 30 -t 50 /path/to/file\n"
      end
    end

    context 'when range is not given'
      it 'invokes a valid command'
        Expect Call('open_github_link#open_current_branch', ['/path/to/file'], 0, 30, 50) ==# "-b some_branch /path/to/file\n"
      end
    end
  end

  describe 'open_github_link#open_top()'

    context 'when valid args'
      it 'invokes a valid command'
        Expect Call('open_github_link#open_top') ==# "\n"
      end
    end
  end
end
