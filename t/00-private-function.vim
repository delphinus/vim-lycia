call vspec#hint({'sid': 'open_github_link#_sid()'})

describe 'private functions'

  describe 's:path_from_args()'

    context 'when no args are given'

      it 'returns current filename'
        Expect Call('s:path_from_args', []) ==# expand('%')
      end
    end
  end
end
