" All things git

nmap     <silent> gs :vert Git<CR><C-N>
nnoremap <silent> gw :silent Gwrite<CR>
nnoremap <silent> gb :Twiggy<CR>
nnoremap          g? :G blame -w<CR>
nnoremap <silent> gl :GV<CR>
nnoremap <silent> gL :GV!<CR>

command! -nargs=0 -bang Wip call s:wip(<bang>0)
function! s:wip(bang) abort
  if a:bang
    call system("git log --oneline | head -1 | awk '{print \$2}' | grep '^\-\-wip\-\-' > /dev/null && git reset head^")
  else
    call system("git log --oneline | head -1 | awk '{print \$2}' | grep '^\-\-wip\-\-'")

    if v:shell_error == 0
      call system("git add . && git commit --amend --no-edit")
    else
      call system("git add . && git commit -m '--wip--'")
    endif
  endif

  edit!
endfunction

" GV

function! s:scroll_commits(down) abort
  wincmd p
  execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
  wincmd p
endfunction

function! s:init_gv_scroll_mappings() abort
  nnoremap <silent> <buffer> J :call s:scroll_commits(1)<CR>
  nnoremap <silent> <buffer> K :call s:scroll_commits(0)<CR>
endfunction

augroup ScrollGV
  autocmd!
  autocmd FileType GV call s:init_gv_scroll_mappings()
  autocmd FileType GV set buftype=nowrite
augroup END
