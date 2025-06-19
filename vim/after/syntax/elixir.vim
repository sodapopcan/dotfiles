syn match elixirSpec "^\s*@spec\_.\{-}\ze\(@\|def\)" 
hi link elixirSpec Comment

if exists(':MixFormat') == 2
  nnoremap <buffer> + :write<cr>:MixFormat<cr>
endif
