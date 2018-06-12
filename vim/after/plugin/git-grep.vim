" git-grep.vim -- A git grep interface
" 
" Maintainer: Andrew Haust <andrewwhhaust@gmail.com>
" Website:    https://github.com/sodapopcan/dotfiles/vim/after/plugin/git-grep.vim
" License:    Same terms as Vim itself (see :help license)
" Version:    0.1
 
" Plugin {{{1
let s:return_file = ''
let s:edit_winnr = 1

function! s:grep(arg) abort
  let search_pattern = matchstr(a:arg, '\v("|'')\zs(.*)+\ze("|'')')

  if search_pattern ==# ''
    let search_pattern = matchstr(a:arg, '\v[^ ]+')

    if search_pattern ==# ''
      return s:warn("No pattern given")
    endif
  endif

  let filter_pattern = substitute(a:arg, '\v("|'')?'.escape(search_pattern, '(){}<>$?@~|\').'("|'')?(\s+)?', '', '')

  let cmd = shellescape(search_pattern)

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
  let s:edit_winnr = winnr()

  if exists('g:loaded_fugitive')
    let git_cmd = fugitive#buffer().repo().git_command()
  else
    let git_cmd = "git"
  endif

  let output = system(git_cmd . " --no-pager grep --no-color -n " . cmd)

  if len(output)
    cgetexpr output
    silent botright copen
    nnoremap          <buffer> o :call <SID>open_file()<CR>
    nnoremap          <buffer> go :call <SID>preview_file()<CR>
    nnoremap <silent> <buffer> O :call <SID>open_file_and_close_qf()<CR>
    nnoremap <silent> <buffer> q :cclose<CR>
    nnoremap <silent> <buffer> <c-c> <c-c>:cclose<CR>:call <SID>edit_return_file()<CR>
  else
    call s:warn(' ¯\_(ツ)_/¯  No results for "' . search_pattern . '"')
  endif
endfunction

function! s:get_filename_and_linenr() abort
  return split(getline('.'), '|')[0:1]
endfunction

function! s:open_file()
  let [filename, linenr] = s:get_filename_and_linenr()
  let qfheight = winheight(winnr())
  pclose
  exec "resize" qfheight
  exec "keepjumps" s:edit_winnr."wincmd w"
  exec "edit +".linenr filename
endfunction

function! s:open_file_and_close_qf() abort
  call s:open_file()
  cclose
endfunction

function! s:preview_file() abort
  let [filename, linenr] = s:get_filename_and_linenr()
  exec "pedit +".linenr filename
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
