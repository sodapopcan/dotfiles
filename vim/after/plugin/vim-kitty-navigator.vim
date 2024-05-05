if !exists('g:loaded_kitty_navigator') | finish | endif

nnoremap <silent> <c-`>h :KittyNavigateLeft<cr>
nnoremap <silent> <c-`>j :KittyNavigateDown<cr>
nnoremap <silent> <c-`>k :KittyNavigateUp<cr>
nnoremap <silent> <c-`>l :KittyNavigateRight<cr>

tnoremap <silent> <c-`>h <c-g>:KittyNavigateLeft<cr>
tnoremap <silent> <c-`>j <c-g>:KittyNavigateDown<cr>
tnoremap <silent> <c-`>k <c-g>:KittyNavigateUp<cr>
tnoremap <silent> <c-`>l <c-g>:KittyNavigateRight<cr>
