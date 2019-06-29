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


" Programs {{{1
"
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
      \     "template": "%s --no-pager grep --no-color --line-number -I %s %s",
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
      \     "template": "%s --type-add 'mustache:*.mustache' --vimgrep --no-text %s %s",
      \     "a": "-uu",
      \     "i": "--ignore-case",
      \     "w": "--word-regexp"
      \   }
      \ }

" File Types {{{1
"
" These are copied from rg.
"
" This is copied here so that the same functionality can be provided for
" git-grep.
"

let s:filetypes = {
      \   "agda": ["*.agda", "*.lagda"],
      \   "asciidoc": ["*.adoc", "*.asc", "*.asciidoc"],
      \   "asm": ["*.S", "*.asm", "*.s"],
      \   "avro": ["*.avdl", "*.avpr", "*.avsc"],
      \   "awk": ["*.awk"],
      \   "bitbake": ["*.bb", "*.bbappend", "*.bbclass", "*.conf", "*.inc"],
      \   "bzip2": ["*.bz2"],
      \   "c": ["*.H", "*.c", "*.h"],
      \   "cabal": ["*.cabal"],
      \   "cbor": ["*.cbor"],
      \   "ceylon": ["*.ceylon"],
      \   "clojure": ["*.clj", "*.cljc", "*.cljs", "*.cljx"],
      \   "cmake": ["*.cmake", "CMakeLists.txt"],
      \   "coffeescript": ["*.coffee"],
      \   "config": ["*.cfg", "*.conf", "*.config", "*.ini"],
      \   "cpp": ["*.C", "*.H", "*.cc", "*.cpp", "*.cxx", "*.h", "*.hh", "*.hpp", "*.hxx", "*.inl"],
      \   "creole": ["*.creole"],
      \   "crystal": ["*.cr", "Projectfile"],
      \   "cs": ["*.cs"],
      \   "csharp": ["*.cs"],
      \   "cshtml": ["*.cshtml"],
      \   "css": ["*.css", "*.scss"],
      \   "csv": ["*.csv"],
      \   "cython": ["*.pyx"],
      \   "d": ["*.d"],
      \   "dart": ["*.dart"],
      \   "docker": ["*Dockerfile*"],
      \   "elisp": ["*.el"],
      \   "elixir": ["*.eex", "*.ex", "*.exs"],
      \   "elm": ["*.elm"],
      \   "erlang": ["*.erl", "*.hrl"],
      \   "fish": ["*.fish"],
      \   "fortran": ["*.F", "*.F77", "*.F90", "*.F95", "*.f", "*.f77", "*.f90", "*.f95", "*.pfo"],
      \   "fsharp": ["*.fs", "*.fsi", "*.fsx"],
      \   "gn": ["*.gn", "*.gni"],
      \   "go": ["*.go"],
      \   "groovy": ["*.gradle", "*.groovy"],
      \   "gzip": ["*.gz"],
      \   "h": ["*.h", "*.hpp"],
      \   "haskell": ["*.hs", "*.lhs"],
      \   "hbs": ["*.hbs"],
      \   "html": ["*.ejs", "*.htm", "*.html"],
      \   "java": ["*.java"],
      \   "jinja": ["*.j2", "*.jinja", "*.jinja2"],
      \   "jl": ["*.jl"],
      \   "js": ["*.js", "*.jsx", "*.vue"],
      \   "json": ["*.json", "composer.lock"],
      \   "jsonl": ["*.jsonl"],
      \   "julia": ["*.jl"],
      \   "jupyter": ["*.ipynb", "*.jpynb"],
      \   "kotlin": ["*.kt", "*.kts"],
      \   "less": ["*.less"],
      \   "license": ["*[.-]LICEN[CS]E*", "AGPL-*[0-9]*", "APACHE-*[0-9]*", "BSD-*[0-9]*", "CC-BY-*", "COPYING", "COPYING[.-]*", "COPYRIGHT", "COPYRIGHT[.-]*", "EULA", "EULA[.-]*", "GFDL-*[0-9]*", "GNU-*[0-9]*", "GPL-*[0-9]*", "LGPL-*[0-9]*", "LICEN[CS]E", "LICEN[CS]E[.-]*", "MIT-*[0-9]*", "MPL-*[0-9]*", "NOTICE", "NOTICE[.-]*", "OFL-*[0-9]*", "PATENTS", "PATENTS[.-]*", "UNLICEN[CS]E", "UNLICEN[CS]E[.-]*", "agpl[.-]*", "gpl[.-]*", "lgpl[.-]*", "licen[cs]e", "licen[cs]e.*"],
      \   "lisp": ["*.el", "*.jl", "*.lisp", "*.lsp", "*.sc", "*.scm"],
      \   "log": ["*.log"],
      \   "lua": ["*.lua"],
      \   "lzma": ["*.lzma"],
      \   "m4": ["*.ac", "*.m4"],
      \   "make": ["*.mak", "*.mk", "GNUmakefile", "Gnumakefile", "Makefile", "gnumakefile", "makefile"],
      \   "man": ["*.[0-9][cEFMmpSx]", "*.[0-9lnpx]"],
      \   "markdown": ["*.markdown", "*.md", "*.mdown", "*.mkdn"],
      \   "matlab": ["*.m"],
      \   "md": ["*.markdown", "*.md", "*.mdown", "*.mkdn"],
      \   "mk": ["mkfile"],
      \   "ml": ["*.ml"],
      \   "msbuild": ["*.csproj", "*.fsproj", "*.proj", "*.props", "*.targets", "*.vcxproj"],
      \   "mustache": ["*.mustache"],
      \   "nim": ["*.nim"],
      \   "nix": ["*.nix"],
      \   "objc": ["*.h", "*.m"],
      \   "objcpp": ["*.h", "*.mm"],
      \   "ocaml": ["*.ml", "*.mli", "*.mll", "*.mly"],
      \   "org": ["*.org"],
      \   "pdf": ["*.pdf"],
      \   "perl": ["*.PL", "*.perl", "*.pl", "*.plh", "*.plx", "*.pm", "*.t"],
      \   "php": ["*.php", "*.php3", "*.php4", "*.php5", "*.phtml"],
      \   "pod": ["*.pod"],
      \   "protobuf": ["*.proto"],
      \   "ps": ["*.cdxml", "*.ps1", "*.ps1xml", "*.psd1", "*.psm1"],
      \   "purs": ["*.purs"],
      \   "python": ["*.py"],
      \   "qmake": ["*.prf", "*.pri", "*.pro"],
      \   "r": ["*.R", "*.Rmd", "*.Rnw", "*.r"],
      \   "rdoc": ["*.rdoc"],
      \   "readme": ["*README", "README*"],
      \   "rst": ["*.rst"],
      \   "ruby": ["*.gemspec", "*.rb", ".irbrc", "Gemfile", "Rakefile"],
      \   "rust": ["*.rs"],
      \   "sass": ["*.sass", "*.scss"],
      \   "scala": ["*.scala"],
      \   "sh": ["*.bash", "*.bashrc", "*.csh", "*.cshrc", "*.ksh", "*.kshrc", "*.sh", "*.tcsh", "*.zsh", ".bash_login", ".bash_logout", ".bash_profile", ".bashrc", ".cshrc", ".kshrc", ".login", ".logout", ".profile", ".tcshrc", ".zlogin", ".zlogout", ".zprofile", ".zshenv", ".zshrc", "bash_login", "bash_logout", "bash_profile", "bashrc", "profile", "zlogin", "zlogout", "zprofile", "zshenv", "zshrc"],
      \   "smarty": ["*.tpl"],
      \   "sml": ["*.sig", "*.sml"],
      \   "soy": ["*.soy"],
      \   "spark": ["*.spark"],
      \   "sql": ["*.psql", "*.sql"],
      \   "stylus": ["*.styl"],
      \   "sv": ["*.h", "*.sv", "*.svh", "*.v", "*.vg"],
      \   "svg": ["*.svg"],
      \   "swift": ["*.swift"],
      \   "swig": ["*.def", "*.i"],
      \   "systemd": ["*.automount", "*.conf", "*.device", "*.link", "*.mount", "*.path", "*.scope", "*.service", "*.slice", "*.socket", "*.swap", "*.target", "*.timer"],
      \   "taskpaper": ["*.taskpaper"],
      \   "tcl": ["*.tcl"],
      \   "tex": ["*.bib", "*.cls", "*.ltx", "*.sty", "*.tex"],
      \   "textile": ["*.textile"],
      \   "tf": ["*.tf"],
      \   "toml": ["*.toml", "Cargo.lock"],
      \   "ts": ["*.ts", "*.tsx"],
      \   "twig": ["*.twig"],
      \   "txt": ["*.txt"],
      \   "vala": ["*.vala"],
      \   "vb": ["*.vb"],
      \   "vhdl": ["*.vhd", "*.vhdl"],
      \   "vim": ["*.vim"],
      \   "viml": ["*.vim"],
      \   "vimscript": ["*.vim"],
      \   "webidl": ["*.idl", "*.webidl", "*.widl"],
      \   "wiki": ["*.mediawiki", "*.wiki"],
      \   "xml": ["*.xml", "*.xml.dist"],
      \   "xz": ["*.xz"],
      \   "yacc": ["*.y"],
      \   "yaml": ["*.yaml", "*.yml"],
      \   "zsh": ["*.zsh", ".zlogin", ".zlogout", ".zprofile", ".zshenv", ".zshrc", "zlogin", "zlogout", "zprofile", "zshenv", "zshrc"]
      \ }

" Globals {{{1
"
if !exists('g:rummage_program')
  for p in s:program_names
    if executable(p)
      let g:rummage_program = p
      break
    endif
  endfor
endif

let s:smart_case = get(g:, 'rummage_use_smartcase', &smartcase)

" Helpers {{{1
"
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


" Main {{{1
"
let s:return_file = ''
let s:last_output = ''
let s:last_linenr = 1

function! s:rummage(cnt, bang, ...) abort
  let has_args = len(a:1)
  if !a:cnt
    if has_args
      let command = s:parse_command(substitute(a:1, '\v\s\s', '', 'g'))
    else
      if a:bang
        if len(s:return_file)
          exec "edit" s:return_file
        endif
      else
        call s:populate(s:last_output, "No recent searches")
      endif

      return
    end
  elseif a:cnt && a:cnt ==# line('.')
    let str = expand("<cword>")
    if has_args
      let args = split(substitute(a:1, '\v\s\s', '', 'g'), " ")
      let command = {
            \   "type": 'fixed',
            \   "search_pattern": expand("<cword>"),
            \   "file_pattern": args[0],
            \   "directory_pattern": len(args) > 1 ? args[1] : '',
            \   "options": [],
            \   "error": ''
            \ }
    endif
  elseif a:cnt
    return s:warn("Cursor not on specified line")
  else
    let str = a:1
  endif

  if len(command.error)
    return s:warn(command.error)
  endif

  let cmd = shellescape(command.search_pattern)

  let program_name = g:rummage_program


  if len(command.file_pattern)
    let filetypes = split(command.file_pattern, ',')
    let dirs = map(split(command.directory_pattern, ','), 'substitute(v:val, ''\v[/]+$'', '''', '''')')

    if program_name ==# 'git'
      let cmd.= " --"
    endif

    for filetype in filetypes
      let pattern = filetype ==# '*' ? '*' : '*.'.filetype
      if len(dirs)
        for dir in dirs
          if program_name ==# 'git'
            let cmd.= " '".dir."/".pattern."'"
          else
            let cmd.= " ".dir."/".pattern
          endif
        endfor
      else
        let cmd.= " '".pattern."'"
      endif
    endfor
  endif

  let s:return_file = expand('%')

  let program = s:programs[program_name]

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


" Command Parser {{{1
"
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
    let search_regex = '\v(''|"|/)\zs%([^'.char.'\\]|\\.)*\ze%(\1)'
    let modifier_regex = '(i)?'
    let ft_regex = '%(%(\s+)(\S+)?)'
    let dir_regex = '%(%(\s+)(\S+))?'
    let regex = search_regex.modifier_regex.'%(%(%(\s+)?)@<=%('.ft_regex.dir_regex.')?)?'
    let matches = matchlist(a:cmd, regex)
  endif

  if !len(char) || !len(matches)
    " Regex did not match meaning quotes or slashes were not used for the search pattern
    let matches = split(a:cmd)
    if !len(matches)
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

  " Make array match `match()` output
  if len(matches) <= 3
    call insert(matches, '', 1)
    call insert(matches, '', 1)
    call add(matches, '')
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


" Command {{{1
"
function! s:complete(A,L,P) abort
  let command_regex = '\v\C^%(\s+)?Rum%(mage)?' 
  let search_string_regex = '\v\C%(\s+)?%(%(%("|''|/)%(.*)%("|''|/)%(i)?|\w+)\s+)?'
  let all_args = substitute(a:L, command_regex, '', '')
  let search_string = matchstr(all_args, search_string_regex)
  let args = substitute(all_args, search_string_regex, '', '')
  let filetypes = matchstr(args, '\v%(\*(\s+)?|[a-zA-Z,]+(\s+)?)')
  if len(filetypes) && filetypes[-1:] ==# ' '
    let dirstr = substitute(args, filetypes, '', '')
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
  elseif match(search_string, '\S') >= 0
    if match(filetypes, '\v,') >= 0
      if filetypes[-1:] !=# ','
        let filetypes = matchstr(filetypes, '\v%(.*),')
      endif
      let currfts = split(filetypes, ',')
      let res = keys(s:filetypes)
      let res = filter(res, "index(currfts, v:val) < 0")
      let res = map(res, 'filetypes.v:val')
    else
      let res = keys(s:filetypes)
    end

    return join(res, "\n")
  endif

  return ''
endfunction

command! -nargs=* -count=0 -bang -complete=custom,s:complete Rummage call s:rummage(<count>, <bang>0, <q-args>)

au! FileType qf au! CursorMoved <buffer> 
      \   if getqflist({"title":0}).title ==# "Rummage"
      \ |   let s:last_linenr = line('.')
      \ | endif
