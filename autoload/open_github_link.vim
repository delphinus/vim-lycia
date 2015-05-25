function! open_github_link#open(path, ...)
  let rangegiven = get(a:, 1, 0)
  let is_current = get(a:, 2, 0)
  let branch = is_current ? s:current_branch() : ''
  if rangegiven
    return open_github_link#invoke_command(s:path_from_arg(a:path), branch, line("'<"), line("'>"))
  else
    return open_github_link#invoke_command(s:path_from_arg(a:path), branch, 0, 0)
  endif
endfunction

function! open_github_link#open_top(...)
  let is_current = get(a:, 1, 0)
  let branch = is_current ? s:current_branch() : ''
  return open_github_link#invoke_command('', branch, 0, 0)
endfunction

function! open_github_link#invoke_command(path, branch, from, to)
  let path_opt   = len(a:path) > 0 ? expand(a:path) : '-r ' . expand('%:p')
  let branch_opt = len(a:branch) > 0 ? '-b ' . a:branch : ''
  let from_opt   = a:from > 0 ? '-f ' . a:from : ''
  let to_opt     = a:to > 0 ? '-t ' . a:to : ''
  let result = system(join([g:open_github_link_command, branch_opt, from_opt, to_opt, path_opt], ' '))
  echomsg result
  return result
endfunction

function! s:path_from_arg(path)
  return s:resolve(expand(len(a:path) > 0 ? a:path : '%'))
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
