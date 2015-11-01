source t/helpers/setup.vim

describe 'lycia#invoke_command()'

  before
    let g:lycia_command = 'echo'
    let g:_test_func_name = 'lycia#invoke_command'
  end

  context 'when no path, branch, from, to are given'
    it 'returns a valid command'
      Expect Call(g:_test_func_name, '', '', 0, 0) ==# "open\n"
    end
  end

  context 'when a path, no branch, from, to are given'
    it 'returns a valid command'
      Expect Call(g:_test_func_name, '/path/to/file', '', 0, 0) ==# "open /path/to/file\n"
    end
  end

  context 'when a path, a branch, no from, to are given'
    it 'returns a valid command'
      Expect Call(g:_test_func_name, '/path/to/file', 'hoge', 0, 0) ==# "open -r hoge /path/to/file\n"
    end
  end

  context 'when a path, a branch, a from, no to are given'
    it 'returns a valid command'
      Expect Call(g:_test_func_name, '/path/to/file', 'hoge', 30, 0) ==# "open -r hoge -f 30 /path/to/file\n"
    end
  end

  context 'when a path, a branch, a from, a to are given'
    it 'returns a valid command'
      Expect Call(g:_test_func_name, '/path/to/file', 'hoge', 30, 35) ==# "open -r hoge -f 30 -t 35 /path/to/file\n"
    end
  end
end
