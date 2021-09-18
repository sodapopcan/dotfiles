nnoremap <buffer> <silent> + :w<cr>:call system("mix format ".expand("%"))<Bar>e!<cr>
