nnoremap <buffer> <silent> + :silent w<cr>:echo "Formating..."<cr>:call system("mix format ".expand("%"))<Bar>e!<cr>

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
  \   'mix.exs': { 'type': 'mix', 'dispatch': 'mix deps.get' },
  \   'config/*.exs': { 'type': 'config' }
  \ }
