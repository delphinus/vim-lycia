source t/helpers/setup.vim

describe '`open` commands'

  before
    let g:lycia_command = 'echo'
    let g:lycia_git = 'echo some_branch || echo'
    let result = system('rm /tmp/vim-verbose.log')
    new
    put =['1', '2', '3', '4', '5', '6']
    call Select(3, 5)
  end

  after
    close!
  end

  describe 'lycia#open()'

    context 'when range is not given'

      context 'when is_current flag is off'
        it 'invokes a valid command'
          Expect Call('lycia#open', '/path/to/file') ==# "open /path/to/file\n"
        end
      end

      context 'when is_current is on'
        it 'invokes a valid command'
          Expect Call('lycia#open', '/path/to/file', 0, 1) ==# "open -r some_branch /path/to/file\n"
        end
      end
    end

    context 'when range is given'

      context 'when is_current flag is off'
        it 'invokes a valid command'
          Expect Call('lycia#open', '/path/to/file', 1) ==# "open -f 3 -t 5 /path/to/file\n"
        end
      end

      context 'when is_current flag is on'
        it 'invokes a valid command'
          Expect Call('lycia#open', '/path/to/file', 1, 1) ==# "open -r some_branch -f 3 -t 5 /path/to/file\n"
        end
      end
    end
  end

  describe 'lycia#open_top()'

    context 'when is_current flag is off'
      it 'invokes a valid command'
        Expect Call('lycia#open_top') ==# "open\n"
      end
    end

    context 'when is_current flag is on'
      it 'invokes a valid command'
        Expect Call('lycia#open_top', 1) ==# "open -r some_branch\n"
      end
    end
  end
end
