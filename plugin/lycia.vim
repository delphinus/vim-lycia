" vim:foldmethod=marker:foldenable:
scriptencoding utf-8

" Load once {{{
if get(g:, 'loaded_lycia', 0) || &cp
  finish
endif
let g:loaded_lycia = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

if !exists('g:lycia_command')
  let g:lycia_command = 'lycia'
endif

if !exists('g:lycia_map')
  let g:lycia_map = 1
endif

if !exists('g:lycia_git')
  let g:lycia_git = 'git'
endif

function! s:error(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction

if !executable(g:lycia_git)
  call s:error('Please install git in you PATH.')
  finish
endif

nnoremap <silent> <Plug>(lycia)                         :<C-u>call lycia#open('')<CR>
vnoremap <silent> <Plug>(lycia)                         :<C-u>call lycia#open('', 1)<CR>
nnoremap <silent> <Plug>(lycia-current-branch)          :<C-u>call lycia#open('', 0, 1)<CR>
vnoremap <silent> <Plug>(lycia-current-branch)          :<C-u>call lycia#open('', 1, 1)<CR>
nnoremap <silent> <Plug>(lycia-current-commit)          :<C-u>call lycia#open('', 0, 2)<CR>
vnoremap <silent> <Plug>(lycia-current-commit)          :<C-u>call lycia#open('', 1, 2)<CR>
nnoremap <silent> <Plug>(lycia-top-page)                :<C-u>call lycia#open_top()<CR>
nnoremap <silent> <Plug>(lycia-top-page-current-branch) :<C-u>call lycia#open_top(1)<CR>
nnoremap <silent> <Plug>(lycia-top-page-current-commit) :<C-u>call lycia#open_top(2)<CR>

command! -range=0 -bar -nargs=* -complete=file
      \ Lycia
      \ call lycia#open(<f-args>, <count>)
command! -range=0 -bar -nargs=* -complete=file
      \ LyciaCurrentBranch
      \ call lycia#open(<f-args>, <count>, 1)
command! -range=0 -bar -nargs=* -complete=file
      \ LyciaCurrentCommit
      \ call lycia#open(<f-args>, <count>, 2)
command! LyciaTop              call lycia#open_top()
command! LyciaTopCurrentBranch call lycia#open_top(1)
command! LyciaTopCurrentCommit call lycia#open_top(2)

if g:lycia_map
  nmap go <Plug>(lycia)
  vmap go <Plug>(lycia)
  nmap gb <Plug>(lycia-current-branch)
  vmap gb <Plug>(lycia-current-branch)
  nmap gc <Plug>(lycia-current-commit)
  vmap gc <Plug>(lycia-current-commit)
  nmap g<C-t> <Plug>(lycia-top-page)
  nmap g<C-y> <Plug>(lycia-top-page-current-branch)
endif

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
