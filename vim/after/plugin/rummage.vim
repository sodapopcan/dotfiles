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


" Setup {{{1

let s:program_names = ['rg', 'ag', 'ack', 'git', 'grep']
let s:programs = {
      \   "ack": {
      \     "template": "%s --nocolor --with-filename %s %s",
      \     "a": "",
      \     "i": "--ignore-case",
      \     "w": "--word-regexp"
      \   },
      \   "ag": {
      \     "template": "%s --vimgrep %s %s",
      \     "a": "--all-types",
      \     "i": "--ignore-case",
      \     "w": "--word-regexp"
      \   },
      \   "git": {
      \     "template": "%s --no-pager grep --no-color --line-number --full-name -I %s %s",
      \     "a": "--no-index",
      \     "i": "--ignore-case",
      \     "w": "--word-regexp"
      \   },
      \   "grep": {
      \     "template": "%s --color=never --line-number -I -r %s %s .",
      \     "a": "",
      \     "i": "--ignore-case",
      \     "w": "--word-regexp"
      \   },
      \   "rg": {
      \     "template": "%s --vimgrep --no-text %s %s",
      \     "a": "-uu",
      \     "i": "--ignore-case",
      \     "w": "--word-regexp"
      \   }
      \ }

if !exists('g:rummage_default_program')
  for p in s:program_names
    if executable(p)
      let g:rummage_default_program = p
      break
    endif
  endfor
endif

let s:smart_case = get(g:, 'rummage_use_smartcase', &smartcase)

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
      call s:populate(s:last_output, "No recent searches")
    endif

    return
  endif

  let command = s:parse_command(join(a:000, ' '))

  if len(command.error)
    return s:warn(command.error)
  endif

  let cmd = shellescape(command.search_pattern)

  if len(command.file_pattern)
    let filetypes = split(command.file_pattern, ',')
    let dirs = map(split(command.directory_pattern, ','), 'substitute(v:val, ''\v[/]+$'', '''', '''')')
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

  let program_name = g:rummage_default_program
  let program = s:programs[program_name]
  if program_name ==# 'git' && exists('g:loaded_fugitive') && exists('b:git_dir')
    let program_name = fugitive#buffer().repo().git_command()
  endif

  let flags = ''
  if program_name ==# 'git' && !s:in_git_repo()
    let flags.= ' --no-index'
  endif

  for option in command.options
    let flags.= ' '.program[option]
  endfor

  if command.type ==# 'fixed' && program_name !=# 'ack'
    let flags.= ' --fixed-strings'
  endif

  let cmd = printf(program.template, program_name, flags, cmd)
  let output = system(cmd)

  if len(output)
    let s:last_output = output
  endif

  return s:populate(output, "¯\\_(ツ)_/¯  No results for '" . command.search_pattern . "'")
endfunction

function! s:parse_command(cmd) abort
  let command = {
        \   "type": '',
        \   "search_pattern": '',
        \   "file_pattern": '',
        \   "directory_pattern": '',
        \   "options": [],
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
  if len(matches) > 2
    let command.options = split(matches[2], '\zs')
    let command.file_pattern = matches[3]
    let command.directory_pattern = matches[4]
  endif

  return command
endfunction

function! s:populate(output, errmsg) abort
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
      \   if getqflist({"title":0}).title ==# "Rummage"
      \ |   let s:last_linenr = line('.')
      \ | endif
