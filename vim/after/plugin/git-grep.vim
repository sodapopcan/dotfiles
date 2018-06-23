" git-grep.vim -- A git gep interface
" 
" Maintainer: Andrew Haust <andrewwhhaust@gmail.com>
" Website:    https://github.com/sodapopcan/dotfiles/vim/after/plugin/git-grep.vim
" License:    Same terms as Vim itself (see :help license)
" Version:    0.1

" Plugin {{{1
let s:return_file = ''
let s:edit_winnr = 1

function! s:rummage(bang, ...) abort
  if a:bang && !len(a:1)
    call s:edit_return_file()
    return
  endif

  let arg = join(a:000, ' ')

  let search_pattern = matchstr(arg, '\v("|'')\zs(.*)+\ze("|'')')

  if search_pattern ==# ''
    let search_pattern = matchstr(arg, '\v[^ ]+')

    if search_pattern ==# ''
      return s:warn("No pattern given")
    endif
  endif

  let filter_pattern = substitute(arg, '\v("|'')?'.escape(search_pattern, '(){}<>$?@~|\').'("|'')?(\s+)?', '', '')

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

function! s:custom_dirs(A,L,P) abort
  let args = substitute(a:L, '\v\C^%(\s+)?R%(ummage)?%(\s+)%(%(("|'')%(.*)%("|'')|\w)\s+)?', '', '')
  let file_types = matchstr(args, '\v%(\*(\s)?|[a-zA-Z,]+(\s+)?)')
  if len(file_types) && file_types[-1:] ==# ' '
    let dirstr = split(args, '\v\s+')[-1]
    if match(dirstr, '\v,') >= 0
      if dirstr[-1:] !=# ','
        let dirstr = matchstr(dirstr, '\v%(.*),')
      endif
      let currdirs = map(split(dirstr, ','), "v:val[-1:] !=# '/' ? v:val.'/' : v:val")
      let dirs = systemlist('ls -1 -d */')
      let dirs = filter(dirs, "index(currdirs, v:val) < 0")
      let dirs = map(dirs, 'dirstr.v:val')
    elseif match(dirstr, '\v/$') >= 0
      let dirs = systemlist('ls -1 -d '.dirstr.'*')
    else
      let dirs = systemlist('ls -1 -d */')
    endif

    return join(dirs, "\n")
  endif

  return ''
endfunction

" Commands {{{1
command! -nargs=* -bang -complete=custom,s:custom_dirs Rummage call s:rummage(<bang>0, <q-args>)

" Mappings (to be removed)

nnoremap g<Space> :Rummage "" <Left><Left>
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Rummage \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Rummage \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Rummage \"\"<Left><C-R><C-\">"
endfor
