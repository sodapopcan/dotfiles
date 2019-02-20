if !exists('g:loaded_fugitive') || b:fugitive_type != 'index'
  finish
endif

" I'm very used to `o` from NERDTree and the like.
nmap <buffer> <silent> o <CR>
