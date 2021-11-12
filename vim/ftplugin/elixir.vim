nnoremap <buffer> <silent> + :silent w<cr>:echo "Formating..."<cr>:call system("mix format ".expand("%"))<Bar>e!<cr>
