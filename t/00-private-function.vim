call vspec#hint({'sid': 'open_github_link#_sid()'})

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
end
