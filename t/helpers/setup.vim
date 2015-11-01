call vspec#hint({'sid': 'lycia#_sid()'})
runtime! plugin/lycia.vim

function! Select(from, to)
  call cursor(a:from, 1)
  execute 'normal' 'V' . (a:to - a:from) . 'jy'
endfunction
