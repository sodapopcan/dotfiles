if exists("g:loaded_fireplace")
  nnoremap <buffer> <silent> <cr> :write<cr>:Require<cr>
  nnoremap <buffer> g<cr> :Eval<cr>
endif

let g:projectionist_heuristics['project.clj'] = {
      \   'src/*.clj': {
      \     'type': 'src',
      \     'alternate': 'test/{}_test.clj',
      \   },
      \   'test/*_test.clj': {
      \     'type': 'test',
      \     'alternate': 'src/{}.clj',
      \   },
      \   'project.clj': { 'type': 'project' },
      \ }
