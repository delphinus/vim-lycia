" vim:foldmethod=marker:foldenable:
scriptencoding utf-8

" Load once {{{
if get(g:, 'loaded_open_github_link', 0) || &cp
  finish
endif
let g:loaded_open_github_link = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

if !exists('g:open_github_link_command')
  let g:open_github_link_command = 'ruby ' . substitute(expand('<sfile>:p:h:h'), '\\', '/', 'g') . '/bin/open-github-link'
endif

if !exists('g:open_github_link_map')
  let g:open_github_link_map = 1
endif

if !exists('g:open_github_link_git')
  let g:open_github_link_git = 'git'
endif

function! s:error(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction

if !executable(g:open_github_link_git)
  call s:error('Please install git in you PATH.')
  finish
endif

nnoremap <silent> <Plug>(open-github-link)                         :<C-u>call open_github_link#open('')<CR>
vnoremap <silent> <Plug>(open-github-link)                         :<C-u>call open_github_link#open('', 1)<CR>
nnoremap <silent> <Plug>(open-github-link-current-branch)          :<C-u>call open_github_link#open('', 0, 1)<CR>
vnoremap <silent> <Plug>(open-github-link-current-branch)          :<C-u>call open_github_link#open('', 1, 1)<CR>
nnoremap <silent> <Plug>(open-github-link-current-commit)          :<C-u>call open_github_link#open('', 0, 2)<CR>
vnoremap <silent> <Plug>(open-github-link-current-commit)          :<C-u>call open_github_link#open('', 1, 2)<CR>
nnoremap <silent> <Plug>(open-github-link-top-page)                :<C-u>call open_github_link#open_top()<CR>
nnoremap <silent> <Plug>(open-github-link-top-page-current-branch) :<C-u>call open_github_link#open_top(1)<CR>
nnoremap <silent> <Plug>(open-github-link-top-page-current-commit) :<C-u>call open_github_link#open_top(2)<CR>

command! -range=0 -bar -nargs=* -complete=file
      \ OpenGithubLink
      \ call open_github_link#open(<f-args>, <count>)
command! -range=0 -bar -nargs=* -complete=file
      \ OpenGithubLinkCurrentBranch
      \ call open_github_link#open(<f-args>, <count>, 1)
command! -range=0 -bar -nargs=* -complete=file
      \ OpenGithubLinkCurrentCommit
      \ call open_github_link#open(<f-args>, <count>, 2)
command! OpenGithubLinkTop              call open_github_link#open_top()
command! OpenGithubLinkTopCurrentBranch call open_github_link#open_top(1)
command! OpenGithubLinkTopCurrentCommit call open_github_link#open_top(2)

if g:open_github_link_map
  nmap go <Plug>(open-github-link)
  vmap go <Plug>(open-github-link)
  nmap gb <Plug>(open-github-link-current-branch)
  vmap gb <Plug>(open-github-link-current-branch)
  nmap gc <Plug>(open-github-link-current-commit)
  vmap gc <Plug>(open-github-link-current-commit)
  nmap g<C-t> <Plug>(open-github-link-top-page)
  nmap g<C-y> <Plug>(open-github-link-top-page-current-branch)
endif

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
