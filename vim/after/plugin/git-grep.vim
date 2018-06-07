" git-grep.vim -- A git grep interface
" 
" Maintainer: Andrew Haust <andrewwhhaust@gmail.com>
" Website:    https://github.com/sodapopcan/dotfiles/vim/after/plugin/git-grep.vim
" License:    Same terms as Vim itself (see :help license)
" Version:    0.1
 
" Plugin {{{1
let s:return_file = ''

function! s:grep(arg) abort
  let search_pattern = matchstr(a:arg, '\v"(.*)"\Z')

  if search_pattern ==# '""'
    return s:warn("No pattern given")
  elseif search_pattern ==# ''
    let search_pattern = matchstr(a:arg, '\v[a-zA-Z0-9]+')
    if search_pattern ==# '' || search_pattern ==# '""'
      return s:warn("No pattern given")
    endif
  endif

  let cmd = search_pattern

  let filter_pattern = substitute(a:arg, '\v'.escape(search_pattern, '<>$!?@{}()').'(\s+)?', '', '')

  if len(filter_pattern)
    let parts = split(filter_pattern, '\v\s+')
    let filetypes = split(parts[0], ',')
    let dirs = map(parts[1:], 'substitute(v:val, ''\v[/]+$'', '''', '''')')
    let cmd.= " --"
    for filetype in filetypes
      let pattern = filetype ==# '*' ? '*' : '*.'.filetype
      if len(dirs)
        for dir in dirs
          let cmd.= " '".dir."/".pattern."'"
        endfor
      else
        let cmd.= " '".pattern."'"
      endif
    endfor
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
    call s:warn("No results for " . search_pattern)
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
command! -nargs=+ -complete=dir Grep call s:grep(<q-args>)
command! -nargs=0 GrepClear call s:edit_return_file()

" Mappings {{{1
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Grep \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Grep \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Grep \"\"<Left><C-R><C-\">"
endfor

let s:cmd = 'Grep "" '
exec "nnoremap g<Space> :".s:cmd.repeat("<Left>", len(s:cmd) - 6)
