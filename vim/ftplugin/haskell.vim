function! s:do_haskell()
  let line = getline('.')
  if match(line, "^[a-z][a-zA-Z']* ::") >= 0
    exec "normal! ^yiW"
    exec "normal o\<esc>pA =\<esc>i "
  endif
endfunction

autocmd! InsertLeave * if (&ft ==# 'haskell') | call s:do_haskell() | end
