" git-grep.vim -- A git grep interface
" 
" Maintainer: Andrew Haust <andrewwhhaust@gmail.com>
" Website:    https://github.com/sodapopcan/dotfiles/vim/after/plugin/git-grep.vim
" License:    Same terms as Vim itself (see :help license)
" Version:    0.1
 
" Plugin {{{1
let s:return_file = ''

function! s:grep(arg) abort
  let pattern = matchstr(a:arg, '\v"(.*)"\Z')

  if pattern ==# ''
    call s:warn("No pattern given")
    return
  endif

  let cmd = pattern
  let args = substitute(a:arg, pattern.' ', '', '')
  if len(args)
    let filetypes = "'*.".join(split(args, ','), "' '*.")."'"
    let cmd = cmd.' '.filetypes
  endif

  let s:return_file = expand('%')

  if exists('g:loaded_fugitive')
    let git_cmd = fugitive#buffer().repo().git_command()
  else
    let git_cmd = "git"
  endif

  let output = system(git_cmd . " --no-pager grep --no-color -n " . cmd)

  if len(output)
    cgetexpr output
    silent botright copen
    nnoremap          <buffer> o :call <SID>edit_file()<CR>
    nnoremap          <buffer> go :call <SID>preview_file()<CR>
    nnoremap <silent> <buffer> q :cclose<CR>
    nnoremap <silent> <buffer> <c-c> <c-c>:cclose<CR>:call <SID>edit_return_file()<CR>
  else
    call s:warn("No results for " . pattern)
  endif
endfunction

function! s:edit_file()
  let [filename, linenr] = split(getline('.'), '|')[0:1]
  keepjumps wincmd p
  exec "edit " . filename
  exec "keepjumps " . linenr
endfunction

function! s:preview_file() abort
  call s:edit_file()
  keepjumps wincmd p
endfunction

function! s:edit_return_file()
  if s:return_file ==# ''
    return
  endif
  exec "keepjumps edit" s:return_file
endfunction

function! s:warn(str) abort
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endfunction

" Commands {{{1
command! -nargs=? -complete=file Grep call s:grep(<q-args>)
command! -nargs=0 GrepClear call s:edit_return_file()

" Mappings {{{1
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Grep \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Grep \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Grep \"\"<Left><C-R><C-\">"
endfor

let s:cmd = 'Grep "" rb,rake -- '
exec "nnoremap g<Space> :".s:cmd.repeat("<Left>", len(s:cmd) - 6)
