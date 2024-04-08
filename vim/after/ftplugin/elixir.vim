let b:ale_linters = ['lexical', 'mix']
let b:ale_elixir_lexical_release = '/Users/andrewhaust/elixir/lexical/_build/dev/package/lexical/bin'

imap <C-Space> <Plug>(ale_complete)
nnoremap <C-\]> <Plug>(ale_go_to_definition)
