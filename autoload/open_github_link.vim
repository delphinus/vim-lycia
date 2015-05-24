function! open_github_link#open(args, firstlnum, lastlnum)
  call open_github_link#invoke_command(s:path_from_args(args), '', firstlnum, lastlnum)
endfunction

function! open_github_link#open_current_branch(args, firstlnum, lastlnum)
  call open_github_link#invoke_command(s:path_from_args(args), s:current_branch(), 0, 0)
endfunction

function! open_github_link#open_top()
  call open_github_link#invoke_command('', '', 0, 0))
endfunction

function! open_github_link#invoke_command(path, branch, from, to)
  let path_opt   = len(path) > 0 ? expand(path) : expand('%:p')
  let branch_opt = len(branch) > 0 ? '-b ' . branch : ''
  let from_opt   = from > 0 ? '-f ' . from : ''
  let to_opt     = to > 0 ? '-t ' . to : ''
  let result = system(join([g:open_github_link_command, branch_opt, from_opt, to_opt, path_opt], ' ')))
  echomsg result
endfunction

function! s:path_from_args(args)
  return s:resolve(expand(empty(a:args) ? '%' : a:args[0]))
endfunction

function! s:resolve(path)
  return expand('*resolve') ? resolve(a:path) : a:path
endfunction

function! s:current_branch()
  let result = substitute(system(g:open_github_link_git . ' rev-parse --abbrev-ref @'), '\n$', '', '')
  return result
endfunction

" For testing {{{
function! open_github_link#_sid()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>
" }}}
