" rummage.vim -- A grep interface
" 
" Maintainer: Andrew Haust <andrewwhhaust@gmail.com>
" Website:    https://github.com/sodapopcan/vim-rummage
" License:    Same terms as Vim itself (see :help license)
" Version:    0.1

" if exists('g:loaded_rummage') || &cp
"   finish
" endif
" let g:loaded_rummage = 1


" Plugin {{{1

let s:return_file = ''
let s:last_output = ''
let s:last_linenr = 1

function! s:rummage(bang, ...) abort
  if !len(a:1) " No arguments supplied
    if a:bang
      if len(s:return_file)
        exec "edit" s:return_file
      endif
    else
      call s:populate_qf(s:last_output, "No recent searches")
    endif

    return
  endif

  let command = s:parse_command(join(a:000, ' '))

  if len(command.error)
    return s:warn(command.error)
  endif

  let cmd = shellescape(command.search_pattern)

  if len(command.file_pattern)
    let parts = split(command.file_pattern)
    let filetypes = split(parts[0], ',')
    let dirs = map(command.directory_pattern, 'substitute(v:val, ''\v[/]+$'', '''', '''')')
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

  if command.options['ignore_case']
    let flags.= ' --ignore-case'  " ignore case
  endif

  let output = system(git_cmd . " --no-pager grep" . flags . " --no-color --line-number --full-name -I " . cmd)

  if len(output)
    let s:last_output = output
  endif

  return s:populate_qf(output, "¯\\_(ツ)_/¯  No results for '" . command.search_pattern . "'")
endfunction

function! s:parse_command(cmd) abort
  let command = {
        \   "type": '',
        \   "search_pattern": '',
        \   "file_pattern": '',
        \   "directory_pattern": '',
        \   "options": {
        \     "ignore_case": 0
        \   },
        \   "error": ''
        \ }

  " This is a hack to compensate for not being able to perform back reference
  " negation.  The regex can very likely be tweeked--I'm working on it but this
  " is where I've landed for now.
  let char = ''
  if index(['"', "'", "/"], a:cmd[0]) >= 0
    let char = a:cmd[0]
  endif

  let matches = []

  if len(char)
    let regex = '\v(''|"|/)\zs%([^'.char.'\\]|\\.)*\ze%(\1)(i)?%(%(%(\s+)?)@<=%(%(%(\s+)(\S+)?)%(%(\s+)(\S+))?)?)?'
    let matches = matchlist(a:cmd, regex)
  endif

  if !len(char) || !len(matches)
    " Regex did not match meaning quotes or slashes were not used for the search pattern
    let matches = split(a:cmd)
    if !len(matches) " || len(matches) > 3
      let command.error = "No pattern given"
    endif
  endif

  if !len(matches[0])
    let command.error = "No pattern given"
  endif

  let command.search_pattern = matches[0]

  if len(matches) ==# 1
    let type = "fixed"

    return command
  endif

  if index(['"', "'"], matches[1]) >=0
    let command.type = "fixed"
  elseif matches[1] ==# '/'
    let command.type = "regex"
  else
    let command.type = "fixed"
  endif
  let command.options['ignore_case'] = matches[2] ==# 'i'
  let command.file_pattern = matches[3]
  let command.directory_pattern = matches[4]

  return command
endfunction

function! s:populate_qf(output, errmsg) abort
  if len(a:output)
    cgetexpr a:output
    silent botright copen
    call setqflist([], 'a', {"title":"Rummage"})
    exec s:last_linenr
  else
    return s:warn(a:errmsg)
  endif
endfunction

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


" Command {{{1

function! s:custom_dirs(A,L,P) abort
  let args = substitute(a:L, '\v\C^%(\s+)?Rum%(mage)? %(\s+)?%(%(%("|''|/)%(.*)%("|''|/)%(i)?|\w)\s+)?', '', '')
  let file_types = matchstr(args, '\v%(\*(\s+)?|[a-zA-Z,]+(\s+)?)')
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

au! FileType qf au! CursorMoved <buffer> 
      \ | if getqflist({"title":0}).title ==# "Rummage"
        \ |   let s:last_linenr = line('.')
        \ | endif
