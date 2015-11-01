function! lycia#open(path, ...)
  let rangegiven = get(a:, 1, 0)
  let tag_flag = get(a:, 2, 0)
  if tag_flag == 1
    let tag = s:current_branch()
  elseif tag_flag == 2
    let tag = s:current_commit()
  else
    let tag = ''
  endif
  if rangegiven
    return lycia#invoke_command(s:path_from_arg(a:path), tag, line("'<"), line("'>"))
  else
    return lycia#invoke_command(s:path_from_arg(a:path), tag, 0, 0)
  endif
endfunction

function! lycia#open_top(...)
  let is_current = get(a:, 1, 0)
  let branch = is_current ? s:current_branch() : ''
  return lycia#invoke_command('', branch, 0, 0)
endfunction

function! lycia#invoke_command(path, branch, from, to)
  let path_opt   = len(a:path) > 0 ? expand(a:path) : ''
  let branch_opt = len(a:branch) > 0 ? '-r ' . a:branch : ''
  let from_opt   = a:from > 0 ? '-f ' . a:from : ''
  let to_opt     = a:to > 0 ? '-t ' . a:to : ''
  let result = system(join([g:lycia_command, 'open', branch_opt, from_opt, to_opt, path_opt], ' '))
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
  let result = substitute(system(g:lycia_git . ' rev-parse --abbrev-ref @'), '\n$', '', '')
  return result
endfunction

function! s:current_commit()
  let result = substitute(system(g:lycia_git . ' rev-parse HEAD'), '\n$', '', '')
  return result
endfunction

" For testing {{{
function! lycia#_sid()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>
" }}}
