source t/helpers/setup.vim

describe 'open_github_link#invoke_command()'

  before
    let g:open_github_link_command = 'echo'
  end

  context 'when no path, branch, from, to are given'
    it 'returns a valid command'
      Expect Call('open_github_link#invoke_command', '', '', 0, 0) ==# "\n"
    end
  end
end
