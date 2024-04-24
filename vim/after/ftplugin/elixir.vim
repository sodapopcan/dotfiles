function! IsMixProject() abort
  return findfile("mix.exs", ".;") !=# ""
endfunction

if IsMixProject()
  nnoremap <buffer> <silent> + :silent w<cr>:echo "Formating..."<cr>:call system("mix format ".expand("%"))<Bar>e!<cr>
  nnoremap <buffer> dM :Dispatch mix ecto.gen.migration<space>
  command! -buffer -nargs=1 Dep call s:add_hex_dep(<f-args>)

  function s:add_hex_dep(dep) abort
    let result = system('mix hex.info '.a:dep)
    let dep = matchstr(result, "{:".a:dep.",.*}")
    call append(line("."), dep)
    normal! j==
    echom match(getline(line(".") + 1), "\]$")
    if match(getline(line(".") + 1), "\]$") == -1
      exec "normal! A,\<esc>^"
    else
      exec "normal! kA,\<esc>j^"
    endif
  endfunction
endif

let g:projectionist_heuristics['mix.exs'] = {
      \   'apps/*/mix.exs': { 'type': 'app' },
      \   'lib/*.ex': {
      \     'type': 'lib',
      \     'alternate': 'test/{}_test.exs',
      \     'template': ['defmodule {camelcase|capitalize|dot} do', 'end'],
      \   },
      \   'test/*_test.exs': {
      \     'type': 'test',
      \     'alternate': 'lib/{}.ex',
      \     'template': ['defmodule {camelcase|capitalize|dot}Test do', '  use ExUnit.Case', '', '  @subject {camelcase|capitalize|dot}', 'end'],
      \   },
      \   'mix.exs': {
      \     'type': 'mix',
      \     'alternate': 'mix.lock',
      \     'dispatch': 'mix deps.get'
      \   },
      \   'mix.lock': {
      \     'type': 'lock',
      \     'alternate': 'mix.exs',
      \     'dispatch': 'mix deps.get'
      \   },
      \   'config/*.exs': { 'type': 'config' },
      \   'priv/repo/migrations/*.exs': { 'type': 'migration', 'dispatch': 'mix ecto.migrate' }
      \ }

let b:ale_linters = ['lexical', 'mix']
let b:ale_elixir_lexical_release = '/Users/andrewhaust/elixir/lexical/_build/dev/package/lexical/bin'

imap <C-Space> <Plug>(ale_complete)
nnoremap gd :ALEGoToDefinition<cr>
