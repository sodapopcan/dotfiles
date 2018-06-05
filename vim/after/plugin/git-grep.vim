" Plugin {{{1
let s:return_file = ''

function! s:grep(arg) abort
  if a:arg ==# ''
    call s:warn("No pattern given")
    return
  endif

  let s:return_file = expand('%')

  if exists('g:loaded_fugitive')
    let git_cmd = fugitive#buffer().repo().git_command()
  else
    let git_cmd = "git"
  endif

  let output = system(git_cmd . " --no-pager grep --no-color -n " . a:arg)
  if len(output)
    cgetexpr output
    silent botright copen
    nnoremap          <buffer> o :call <SID>edit_file()<CR>
    nnoremap          <buffer> go :call <SID>preview_file()<CR>
    nnoremap <silent> <buffer> q :cclose<CR>
    nnoremap <silent> <buffer> <c-c> <c-c>:cclose<CR>:call <SID>edit_return_file()<CR>
  else
    call s:warn("No results for " . a:arg)
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

nnoremap g<Space> :Grep "" '*.rb' '*.rake'<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap t<Space> :Grep "" '*.js' '*.jsx'<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap y<Space> :Grep "" '*.yml' '*.yaml'<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
