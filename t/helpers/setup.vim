call vspec#hint({'sid': 'open_github_link#_sid()'})
runtime! plugin/open_github_link.vim

function! Select(from, to)
  call cursor(a:from, 1)
  execute 'normal' 'V' . (a:to - a:from) . 'jy'
endfunction
