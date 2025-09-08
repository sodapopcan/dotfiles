" Hop between functions with <c-n> and <c-p>.
"
" This behaviour is available natively (or by language plugin) via ]] and [[,
" but this is super annoying to type quickly.  It also doesn't take a count.

if exists('g:loaded_function')
  finish
endif
let g:loaded_function = 1

function! s:map(pat)
  exec "nnoremap <silent> <buffer> <c-n> :<c-u>call search('" .. a:pat .. "', 'W')<cr>"
  exec "nnoremap <silent> <buffer> <c-p> :<c-u>call search('" .. a:pat .. "', 'Wb')<cr>"
  exec "nnoremap <silent> <buffer> g<c-n> :<c-u>$<cr>:call search('" .. a:pat .. "', 'Wb')<cr>"
  exec "nnoremap <silent> <buffer> g<c-p> :<c-u>0<cr>:call search('" .. a:pat .. "', 'W')<cr>"
endfunction

augroup Functions
  autocmd!
  autocmd FileType elixir call s:map('^\s*\zs\<defp\=\>')
  autocmd FileType vim,lua,javascript call s:map('^\s*\zs\<function\>')
  autocmd FileType rust call s:map('^\s*\zs\<fn\>')
  autocmd FileType go call s:map('^\s*\zs\<func\>')
augroup END
