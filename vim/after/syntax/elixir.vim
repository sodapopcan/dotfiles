syn match elixirSpec "^\s\+@spec\_.*\ze\%(@\|def\)$" 
hi elixirSpec ctermfg=238

if exists(':MixFormat') == 2
  nnoremap <buffer> + :write<cr>:MixFormat<cr>
endif
