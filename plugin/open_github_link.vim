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

nnoremap <silent> <Plug>(open-github-link-default-branch)
      \ :<C-u>call opengithublink#open([''], <line1>, <line2>)
nnoremap <silent> <Plug>(open-github-link-current-branch)
      \ :<C-u>call opengithublink#open_current_branch([''], <line1>, <line2>)
vnoremap <silent> <Plug>(open-github-link-default-branch-with-line)
      \ :<C-u>call opengithublink#open([''], <line1>, <line2>)
vnoremap <silent> <Plug>(open-github-link-current-branch-with-line)
      \ :<C-u>call opengithublink#open_current_branch([''], <line1>, <line2>)
nnoremap <silent> <Plug>(open-github-link-top-page)
      \ :<C-u>call opengithublink#open_top()<CR>

command! -range=0 -bar -nargs=* -complete=file
      \ OpenGithubLink
      \ call open_github_link#open([<f-args>], <line1>, <line2>)
command! -range=0 -bar -nargs=* -complete=file
      \ OpenGithubLinkTest
      \ call open_github_link#open_test([<f-args>], <count>, <line1>, <line2>)
command! OpenGithubLinkTop call open_github_link#open_top()

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
