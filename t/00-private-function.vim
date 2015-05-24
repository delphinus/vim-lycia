source t/helpers/setup.vim

describe 'private functions'

  describe 's:path_from_args()'

    context 'when no args is given'
      it 'returns current filename'
        Expect Call('s:path_from_args', []) ==# expand('%')
      end
    end

    context 'when some path is given'
      it 'returns a valid path'
        let path = system('mktemp')
        Expect Call('s:path_from_args', [path]) ==# path
      end
    end
  end

  describe 's:current_branch()'

    context 'when called'
      it 'invokes true git command'
        let g:open_github_link_git = 'echo'
        Expect Call('s:current_branch') ==# 'rev-parse --abbrev-ref @'
      end
    end
  end
end
