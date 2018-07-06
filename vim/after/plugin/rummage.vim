" rummage.vim -- A grep interface
" 
" Maintainer: Andrew Haust <andrewwhhaust@gmail.com>
" Website:    https://github.com/sodapopcan/vim-rummage
" License:    Same terms as Vim itself (see :help license)
" Version:    0.1

if exists('g:loaded_rummage') || &cp
  finish
endif
let g:loaded_rummage = 1


" Helpers {{{1

function! s:warn(str) abort
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endfunction

function! s:in_git_repo() abort
  if exists('g:loaded_fugitive') && exists('b:git_dir')
    return 1
  else
    call system('git rev-parse --is-inside-work-tree 2> /dev/null')
    return !v:shell_error
  endif
endfunction


" Plugin {{{1

let s:return_file = ''
let s:last_output = ''
let s:last_linenr = 1

function! s:populate_qf(output, errmsg) abort
  if len(a:output)
    cgetexpr a:output
    silent botright copen
    call setqflist([], 'r', {"title":"Rummage"})
    exec s:last_linenr
  else
    return s:warn(a:errmsg)
  endif
endfunction

function! s:rummage(bang, ...) abort
  if a:bang && !len(a:1)
    if len(s:return_file)
      exec "edit" s:return_file
    endif
    return
  elseif !len(a:1)
    return s:populate_qf(s:last_output, "No recent searches")
  endif

  let arg = join(a:000, ' ')

  let matches = matchlist(arg, '\v("|''|/)\zs(.*)+\ze("|''|/)(i)?')
  let search_pattern = matches[0]

  if search_pattern ==# ''
    let search_pattern = matchstr(arg, '\v[^ ]+')

    if search_pattern ==# '' || search_pattern ==# '""' || search_pattern ==# "''" || search_pattern ==# '//'
      return s:warn("No pattern given")
    endif
  endif

  let filter_pattern = substitute(arg, '\v%("|''|/)?'.escape(search_pattern, '(){}<>$?@~|\').'%("|''|/)?%(i)?%(\s+)?', '', '')

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

  if exists('g:loaded_fugitive') && exists('b:git_dir')
    let git_cmd = fugitive#buffer().repo().git_command()
  else
    let git_cmd = "git"
  endif

  let flags = ''
  if !s:in_git_repo()
    let flags.= ' --no-index'
  endif

  if matches[1] ==# '/' && matches[4] ==# 'i'
    let flags.= ' --ignore-case'  " ignore case
  endif

  let output = system(git_cmd . " --no-pager grep" . flags . " --no-color --line-number -I " . cmd)

  if len(output)
    let s:last_output = output
  endif

  return s:populate_qf(output, "¯\\_(ツ)_/¯  No results for '" . search_pattern . "'")
endfunction


" Command {{{1

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

command! -nargs=* -bang -complete=custom,s:custom_dirs Rummage call s:rummage(<bang>0, <q-args>)

au! FileType qf au! CursorMoved <buffer> if getqflist({"title":0}).title ==# "Rummage" | let s:last_linenr = line('.') | endif
