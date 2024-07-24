" Toggles the foldmethod
" If the filetype vim, it will toggle between 'marker' and 'manual'.
" Any other filetype will toggle between 'syntax' and 'manual'.

function! s:toggle_fdm()
  if &fdm ==# 'manual'
    if &ft == 'vim'
      setlocal fdm=marker
      echom 'set fdm=marker'
    else
      setlocal fdm=syntax
      echom 'set fdm=syntax'
    endif
  else
    setlocal fdm=manual
    normal! zE
    echom 'set fdm=manual'
  endif
endfunction

nnoremap <silent> zT :call <sid>toggle_fdm()<cr>
