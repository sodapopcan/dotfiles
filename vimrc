if !&compatible | set nocompatible | endif

" Plugins {{{1
"
call plug#begin('~/.vim/plugins')

function! s:PlugLocal(local, remote)
  Plug !empty(glob(a:local)) ? a:local : a:remote
endfunction

" Usability
Plug 'sjl/vitality.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-tbone'
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction
" Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'dzeban/vim-log-syntax'

" Utility
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-obsession'
Plug 'mbbill/undotree'
Plug 'junegunn/vim-pseudocl'
Plug 'janko-m/vim-test'
Plug 'heavenshell/vim-slack'
Plug 'majutsushi/tagbar'
" Plug '~/src/vim/rummage'
Plug 'RRethy/vim-illuminate'
" Plug 'svermeulen/vim-yoink'
Plug 'markonm/traces.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'

Plug '~/src/vim/refactor'

" Text Objects
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'rhysd/vim-textobj-ruby'
Plug 'andyl/vim-textobj-elixir'

Plug 'kana/vim-smartinput'

" Navigation
Plug 'scrooloose/nerdtree',            { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf',                   { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-scriptease'

" Lint
Plug '~/src/vim/rubocop',              { 'branch': 'dev' }
Plug 'w0rp/ale'

" Extend
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/splitjoin.vim'
call s:PlugLocal('~/src/vim/ifionly', 'sodapopcan/vim-ifionly')
Plug 'tpope/vim-ragtag'
Plug 'vim-scripts/a.vim'
Plug 'justinmk/vim-syntax-extra'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
call s:PlugLocal('~/src/vim/twiggy', 'sodapopcan/vim-twiggy')
Plug 'junegunn/gv.vim'

" Markdown
Plug 'plasticboy/vim-markdown',        { 'for': 'markdown' }
Plug 'junegunn/vim-xmark',             { 'for': 'markdown' }

" Html
Plug 'alvan/vim-closetag'
Plug 'othree/html5.vim'
Plug 'slim-template/vim-slim'

" CSS
Plug 'cakebaker/scss-syntax.vim'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'jparise/vim-graphql'
Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn install',
      \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'kristijanhusak/vim-js-file-import'

" CoffeeScript
Plug 'kchmck/vim-coffee-script'

" Ruby
Plug 'tpope/vim-bundler'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'

" Elixir
Plug 'elixir-lang/vim-elixir'

" Haskell
Plug 'itchyny/vim-haskell-indent'

" Pony
Plug 'jakwings/vim-pony'

" Other
Plug 'junegunn/goyo.vim'
Plug 'chr4/nginx.vim'
Plug 'hashivim/vim-terraform'

" Work
if $WORK_COMPUTER
  Plug '~/src/vim/packman'
endif
call plug#end()
" }}}

" Common {{{1
"
runtime! macros/matchit.vim
let g:netrw_dirhistmax = 0

if !exists('g:syntax_on')
  syntax on
endif
colorscheme sodapopcan

hi User1 ctermbg=179  ctermfg=16   cterm=none   " git branch
hi User2 ctermbg=237  ctermfg=16   cterm=none   " warn
hi User3 ctermbg=237  ctermfg=179  cterm=none   " filename
hi User4 ctermbg=bg   ctermfg=bg   cterm=none   " Obsession - tracking
hi User5 ctermbg=227  ctermfg=bg   cterm=none   " Obsession - paused
hi User6 ctermbg=167  ctermfg=bg   cterm=none   " Obsession - not tracking
hi User7 ctermbg=130  ctermfg=0    cterm=none   " line

" Settings {{{1

" The following defaults are required to maintain my sanity
" More, and file-type overrides, can be found in vim/ftplugins

set hidden " navigate away from  a buffer without saving it first
" if !has('nvim')
" Necessary to run the correct versions of unix programs when using zsh
set shell=/bin/bash
" endif
set clipboard=unnamed

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
else
  set ttyfast
  if &encoding !=# 'utf-8'
    set encoding=utf-8
  endif
endif
set lazyredraw

set mouse=a

set backspace=2     " Backspace over everything
set laststatus=2    " Always show the status line
set showtabline=2   " I don't really use tabs, but the tabline works decently
                    " as a global status line
set expandtab
set shiftround
set tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType c setlocal tabstop=8 softtabstop=8 shiftwidth=8
autocmd FileType cpp setlocal tabstop=8 softtabstop=8 shiftwidth=8

set autoindent
set incsearch hlsearch
set ignorecase smartcase

" Stop highlighting past the 120th column.
" Really, I hate having lines even that long.  Ah well.
set synmaxcol=120

" I just like this stuff
set number
set cmdheight=2
set cursorline
set nostartofline
set breakindent
set breakindentopt=shift:2
set ruler
set textwidth=80
set wrap
set scrolloff=2
set sidescrolloff=0
set shortmess=atWI
set pumheight=5
set linebreak
set updatetime=100  " Update gitgutter and ale quickly
set completeopt-=preview
set diffopt=filler,foldcolumn:0,context:4
set autoread

set fillchars=fold:\ ,vert:▕

set nobackup noswapfile

set list listchars=tab:>\ ,eol:\ ,trail:·
hi SpecialKey ctermfg=238

set formatoptions=
set formatoptions+=t     " Respect the wrap
set formatoptions+=c     " Format comments
set formatoptions+=r     " Continue comments by default
set formatoptions+=q     " Format comments with gq
set formatoptions+=2     " Use indent from 2nd line of a paragraph
set formatoptions+=l     " Don't break lines that are already long
set formatoptions+=1     " Break before 1-letter words

set wildmenu
set wildmode=list:longest,full
set wildignore+=*DS_Store*
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" Mappings {{{1
"

" I'm trying to grow out of jk for escaping insert mode, but I'm failing pretty
" hard.  j/k!  jk4lyfe!
inoremap <silent> jk <ESC>
if has('nvim')
  tnoremap <silent> jk <C-\><C-N>
endif

" I accidentally hit this more than you'd think
inoremap <C-@> <Nop>
" Since C-L is in use, C-C will just do everything
inoremap <silent> <C-C> <Esc>:redraw!<CR>
nnoremap <silent> <C-C> :redraw!<CR>

" Thanks a lot, macOS touchbar you worthless... ugh.  Ok, I'll stop...
" Disable Fn keys in command and insert modes.
for i in range(1, 12)
  for mode in ['c', 'i']
    exec mode."map <F".i."> <Nop>"
  endfor
endfor

" One keystroke--instead of 4--to save
nnoremap <CR> :write<CR>
" Don't jump on search (and always highlight)
nnoremap <silent> * :let winstate = winsaveview()<bar>
      \ exec "normal! *"<bar>
      \ setlocal hlsearch<bar>
      \ call winrestview(winstate)<bar>
      \ unlet winstate<cr>
nnoremap <silent> # #<C-O>:set hlsearch<CR>
" Apparently I have to do this because of my iTerm key-remaps
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-H> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
nnoremap <silent> <C-K> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateRight<cr>
" Control when you want to see more
exec "nnoremap \<silent> H :vertical resize " . string(&columns * 0.6) "\<CR>"
" nnoremap <silent> <M-H>:TmuxNavigatePrevious<cr>
" Up/Down in command line
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
" Set paste, paste from clipboard, unset paste
nnoremap <silent> gp :set paste<bar>put<bar>set nopaste<CR>==
" Thanks a lot, touchbar
nnoremap <F1> <nop>

" Dispatch
nnoremap <silent> d<CR> :Dispatch<CR>
" Tests (Vim-Test)
nnoremap <silent> f<CR> :TestFile<CR>
nnoremap <silent> t<CR> :TestNearest<CR>
nnoremap <silent> F<CR> :TestVisit<CR>
" Write everything and quit
nnoremap z; :wall \| qall!<CR>
" I've never used more than one macro register before (though maybe I should?)
" In any event, qq for recording, Q to playback (stolen from junegunn)
nnoremap Q @q
" Only show this window
nnoremap <silent> L :IfIOnly<CR>
" Make Y do what you think it would
nnoremap Y y$
" Yank full path (yank full path)
nnoremap ypp :let @+ = expand('%:p')<CR>:echo "Yanked: ".expand('%:p')<CR>
nnoremap ypP :let @+ = expand('%:p').":".line(".")<CR>:echo "Yanked: ".expand('%:p').":".line(".")<CR>
" Yank relative path ([y]ank [p]ath [r]elative)
nnoremap ypr :let @+ = expand('%')<CR>:echo "Yanked: ".expand('%')<CR>
nnoremap ypR :let @+ = expand('%').":".line(".")<CR>:echo "Yanked: ".expand('%').":".line(".")<CR>
" Yank relative path ([y]ank [p]ath [b]asename)
nnoremap yfb :let @+ = expand('%:t')<CR>:echo "Yanked: ".expand('%:t')<CR>
nnoremap yfB :let @+ = expand('%:t').":".line(".")<CR>:echo "Yanked: ".expand('%:t').":".line(".")<CR>
" I'm a S over cc kinda guy so may as well use cc for a corner case
nnoremap cc S<esc>
" I never use & but it drives me nuts when I hit due to the error it throws
nnoremap <silent> & :try <Bar> exec "normal! &" <Bar> catch <Bar> endtry<CR>
" Keep your lines short, children
nnoremap j gj
nnoremap k gk
" Who doesn't prefer `'s functionality?  Well, I do
nnoremap ` '
nnoremap ' `
" I always have to think for a second if I want :vsp or :sp
nnoremap <silent>  _ :sp<CR>
nnoremap <silent> \| :vsp<CR>
" Paste at EOL
nnoremap <silent> K :call PasteAtEOL()<CR>
" Reformat entire file
nnoremap <silent> + :let winstate = winsaveview()<bar>
      \ exec "normal! mzgg=G`z"<bar>
      \ call winrestview(winstate)<bar>
      \ unlet winstate<cr>
" Increase scroll speed a little
nnoremap <C-E> 2<C-E>
nnoremap <C-Y> 2<C-Y>
" Strip whitespace
nnoremap <silent> da<Space> :call StripWhitespace()<bar>echo "All clean"<CR>
" Allow recovery from accidental c-w or c-u while in insert mode
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" Just take me quick to github
vnoremap <CR> :Gbrowse<CR>
" Position func/meth definition at top of screen after jump
nnoremap <C-]> <C-]>zt
" Sync zz with my eyes
nnoremap zz zz2<C-E>
" Open quickfix list across bottom
cnoreabbrev copen botright copen
" Even up the current vertical split
nnoremap <silent> g\| :wincmd =<CR>
" Running
nnoremap g<cr> :exec "Dispatch " . &ft . " %"<cr>
" Tagbar
nnoremap zt :Tagbar<cr>
" Folding
nnoremap c-m :set fdm=marker<CR>
nnoremap c-{ :set fdm=manual<CR>
nnoremap c-i :set fdm=indent<CR>
nnoremap c-s :set fdm=syntax<CR>
nnoremap c-e :set fdm=expr<CR>
nnoremap c-d :set fdm=diff<CR>
" a.vim-like
nnoremap ga :A<CR>
nnoremap gr :R<CR>
nnoremap <leader>ga ga
nnoremap <leader>gl gr
" Grepping
nnoremap g<Space> :Rummage "" <Left><Left>
let chars = ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
for c in chars
  " Grep
  exec "nnoremap gy".c."<Space> y".c.":Rummage \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".c."<Space> yi".c.":Rummage \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".c."<Space> ya".c.":Rummage \"\"<Left><C-R><C-\">"
  " Substitute
  exec "nnoremap gy".c."s y".c.":%s/<C-R><C-\">//g<Left><Left>"
  exec "nnoremap gyi".c."s yi".c.":%s/<C-R><C-\">//g<Left><Left>"
  exec "nnoremap gya".c."s ya".c.":%s/<C-R><C-\">//g<Left><Left>"
endfor

" Leader Mappings

" Location
"
" Wipe buffer while maintaining its split
nnoremap <silent> <leader>q :bp\|bwipeout #<CR>
" Edit a new file in the same directory
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
" Read a file in the same directory
nnoremap <Leader>r :r <C-R>=expand('%:p:h') . '/'<CR>
" Add bash shebang
nnoremap <Leader># :normal! ggi#!/usr/bin/env bash<CR>

" Status/Tab Lines {{{1
"
" 'Tab Line' is used as a 'global status' bar.
"   * File name (basename of currently focused buffer)
"     is always at the top of the screen
function! s:git_branch_status_line()
  let status = ''

  if exists('*FugitiveHead')
    let status = FugitiveHead()
  endif

  if len(status)
    let jira_ticket = matchstr(status, '\v^[A-Z]+\-[0-9]+')
    if jira_ticket !=# ''
      return jira_ticket
    else
      return status
    endif
  endif

  return 'No Branch'
endfunction

function! StatusLine()
  let is_fugitive_buffer = match(expand('%:p'), '^fugitive') >= 0
  let s = ''
  let s.= "%2*"
  let s.= "%{&paste?'\ \ paste\ ':''}"
  if is_fugitive_buffer
    let s.= "%6*\ \ git \ %*"
  endif
  let s.= "%*"
  if !is_fugitive_buffer
    let s.= "%1*"
    let s.= "\ " . s:git_branch_status_line() . "\ "
    let s.= "%*"
  endif
  let s.= "\ %3*%(%t%)%*"
  let s.= "%="
  let s.= "%3*"
  let s.= "\ %(%p%%\ %l:%v/%L\ \ %)"
  let s.= "%*"
  return s
endfunction
set statusline=%!StatusLine()

" Largely ripped from :h setting-tabline
function! TabLine()
  let s = ''
  let ochar = " "
  let s.= '%*'.ObsessionStatus("%4*".ochar, "%5*".ochar, "%6*".ochar)
  if exists('*FugitiveWorkTree') && FugitiveWorkTree() !=# ""
    let s.= "%7* " . substitute(split(FugitiveWorkTree(), '/')[-1], '\v[_-]', ' ', 'g') . " %* "
  endif
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s.= '%#TabLineSel#'
    else
      let s.= '%#TabLine#'
    endif
    let s.= '%' . (i + 1) . 'T'
    let s.= ' %{TabLabel(' . (i + 1) . ')} '
  endfor
  let s.= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s.= '%=%#TabLine#'
  endif
  let s.= '%='

  return s
endfunction
function! TabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let filename = bufname(buflist[winnr - 1])
  let directory = split(getcwd(1, a:n), "/")[-1]
  if filename ==# ''
    return '[No Name]'
  endif
  return directory
endfunction
set tabline=%!TabLine()

" Misc Auto {{{1
augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir)
          \   && (a:force
          \       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END

autocmd! BufRead,BufNewFile *.tfvars setlocal filetype=tf

" Commands {{{1
"

" General
command! -nargs=1 H exec ":vert h " . <f-args> . "\<cr>"
" Shruggie
command! -nargs=0 Shrug exec "normal! a¯\\_(ツ)_/¯\<Esc>"
" Source
command! -nargs=0 So so %
" Add a debug statement
" Takes a variable name as an arg and will output a debug log
" statement dependent on the language
" With no argument will use the word under the cursor
nnoremap <silent> gI :call <SID>console_log()<CR>
function! s:console_log()
  let token = expand('<cword>')
  let output = []
  if &ft ==# 'vim'
    let output = 'echo '.token
  elseif &ft ==# 'elixir'
    let output = ['IO.puts "\n#################"', 'IO.inspect('.token.', label: "'.token.'")']
  elseif &ft ==# 'ruby'
    let output = ['p "#" * 80', 'p '.token, 'p "#" * 80']
  elseif &ft ==# 'elixir'
    let output = ['IO.inspect '.token]
  elseif &ft =~# '^javascript'
    let output = 'console.log("'.token.'", '.token.')'
  else
    return
  endif
  call append(line('.'), output)
  let z = @z
  normal! mz
  exec "silent normal! j".len(output)."=j`z"
  let @z = z
endfunction

" Mappings Functions {{{2

" Paste at end of the line
function! PasteAtEOL()
  " strip trailing space on current line
  s/\s\+$//e
  " add trailing space then paste
  exec "normal! A\<space>\<esc>mzp`z"
endfunction

function! StripWhitespace()
  let winstate = winsaveview()
  %s/\s\+$//e
  %s#\($\n\s*\)\+\%$##e
  call winrestview(winstate)
  unlet winstate
endfunction

" Autocommands {{{1
"
augroup FileTypeOptions
  autocmd!
  autocmd BufReadPost fugitive://*
        \ setlocal bufhidden=wipe |
        \ nnoremap <buffer> q :q<CR>
  autocmd FileType ruby,javascript,coffee autocmd BufWritePre <buffer> call StripWhitespace()
  autocmd FileType help nnoremap <silent> <buffer> q :q<CR>
  autocmd FileType git setlocal foldlevel=1
augroup END

" Don't show cursorline and an empty statusline on inactive buffers
augroup CursorStatusLines
  autocmd!
  autocmd VimEnter,WinEnter,BufReadPost * if &ft !=# 'gitcommit'
        \ | setlocal statusline=%!StatusLine()
        \ | endif
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter * setlocal cursorline
augroup END

augroup SignColumn
  autocmd!
  " Always show the sign column
  autocmd BufEnter * sign define dummy
  autocmd BufEnter * exec 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

au FileType GV nnoremap go :normal o<cr><bar>:wincmd w<cr><bar>:normal! zR<cr>
au FileType GV nnoremap <buffer> Q :tabclose<CR>


" Closetag {{{1
"
let g:closetag_filenames = "*.html,*.erb,*.eex,*.leex,*.xml,*.js,*.jsx,*.mustache"

" Edtiorconfig {{{1
"

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Git {{{1
"

" Mappings (maybe I should move this to mappings section)

nnoremap <silent> gs :keepalt G<CR>
nnoremap <silent> gC :G commit -v<CR>
nnoremap <silent> gd :! clear && git diff<CR>
nnoremap <silent> gD :! clear && git diff --cached<CR>
nnoremap <silent> g? :G blame -w<CR>
nnoremap <silent> gw :silent Gwrite<CR>
nnoremap          g^ :G push<CR>
nnoremap          gV :G pull<CR>
nnoremap <silent> gb :Twiggy<CR>
nnoremap          gB :Twiggy<Space>
nnoremap <silent> gl :GV<CR>
nnoremap <silent> gL :GV!<CR>
nnoremap          gM :GV master<CR>

" Commands
command! -nargs=0 -bang Push call <SID>git_push(<bang>0)

function! s:git_push(bang) abort
  if a:bang
    Gpush -f
  else
    Gpush -u
  endif
endfunction

" GV specific

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


" Rails
command! -nargs=? Migrate call <SID>migrate_rails(<f-args>)
command! -nargs=0 Rollback Dispatch rake db:rollback
command! -nargs=0 Eform Eview _form

function! s:migrate_rails(...)
  if a:0 > 0
    exec ":Dispatch rails g migration " . a:1
  else
    Dispatch rake db:migrate && RAILS_ENV=test rake db:migrate
  endif
endfunction

" ALE {{{1
"

let g:ale_linters = {
      \   'ruby': ['mri', 'rubocop'],
      \   'javascript': ['eslint'],
      \   'javascript.jsx': ['eslint'],
      \   'haskell': ['ghc']
      \ }

" if !empty(glob("Gemfile")) && system('grep "rubocop" < Gemfile')
let g:ale_ruby_rubocop_executable = 'bundle'
" endif
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'

highlight ALEErrorSign term=bold ctermfg=160
highlight ALEWarningSign term=bold ctermfg=178

" Dispatch
"
let g:nremap = {"m":"","`":"","'":"","g":""}

" FZF {{{1
"
nnoremap <silent> <Space> :FZF<CR>
let g:fzf_layout = { 'down': '~20%' }
let g:fzf_commits_log_options = "--pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

" GitGutter {{{1
"
let g:gitgutter_sign_added = "\u258F"
let g:gitgutter_sign_modified = g:gitgutter_sign_added
let g:gitgutter_sign_removed = "\u2581"
let g:gitgutter_sign_removed_first_line = "\u2594"
let g:gitgutter_sign_modified_removed = g:gitgutter_sign_added

" Pre-defined leader mappings in plugins fill me with rage.  Well, not that much
" rage.  I love Git Gutter.
let g:gitgutter_map_keys = 0
nmap g+ <Plug>(GitGutterStageHunk)
nmap g- <Plug>(GitGutterUndoHunk)
nmap g_ <Plug>(GitGutterPreviewHunk)
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)

hi GitGutterAdd    ctermfg=28  ctermbg=bg cterm=NONE
hi GitGutterChange ctermfg=24  ctermbg=bg cterm=NONE
hi GitGutterDelete ctermfg=167 ctermbg=bg cterm=NONE

" Goyo {{{1
"

function! s:goyo_enter()
  set statusline=0
endfunction
function! s:goyo_leave()
  source ~/.vimrc
endfunction
autocmd User GoyoEnter nested call <SID>goyo_enter()
autocmd User GoyoLeave nested call <SID>goyo_leave()

" Gutentags {{{1
"
let g:gutentags_exclude_filetypes = ['javascript', 'javascript.jsx', 'markdown']
let g:gutentags_ctags_exclude = ['js', 'jsx', 'md', 'markdown', 'json', 'sh']

" IfIOnly {{{1
"
let g:ifionly_filetypes = ['vim-plug']
let g:ifionly_destructive_jump = 0

" Illuminate {{{1
"
let illuminateJS = [
      \ 'jsFuncCall',
      \ 'jsFuncBlock',
      \ 'jsVariableDef',
      \ 'jsDestructuringPropertyValue',
      \ 'jsObjectValue'
      \ ]
let g:Illuminate_ftHighlightGroups = {
      \ 'ruby': ['rubyBlock'],
      \ 'javascript': illuminateJS,
      \ 'javascript.jsx': illuminateJS,
      \ }

" JavaScript
"
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Markdown {{{1
"
let g:vim_markdown_folding_disabled=1

func! MarkdownFold(lnum)
  if (a:lnum == 1)
    let l0 = ''
  else
    let l0 = getline(a:lnum-1)
  endif

  let l1 = getline(a:lnum)

  let l2 = getline(a:lnum+1)

  if  l2 =~ '^==\+\s*'
    " next line is underlined (level 1)
    return '>1'
  elseif l2 =~ '^--\+\s*'
    " next line is underlined (level 2)
    return '>2'
  elseif l1 =~ '^#'
    " current line starts with hashes
    " return '>'.matchend(l0, '^#\+')
    return '>1'
  else
    " keep previous foldlevel
    return '='
  endif
endfunc

autocmd FileType mkd setlocal foldexpr=MarkdownFold(v:lnum) | setlocal foldmethod=expr


" NERDTree {{{1
"
nnoremap <silent> M :NERDTreeToggle<CR>:wincmd =<CR>

let NERDTreeQuitOnOpen          = 1
let NERDTreeHijackNetrw         = 1
let NERDTreeHighlightCursorline = 0
let NERDTreeMinimalUI           = 1
let NERDTreeWinSize             = 45
let NERDTreeIgnore=['node_modules']

" Rails
"
let g:rails_projections = {
      \ "app/workers/*_worker.rb": {
      \   "command": "worker",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Worker",
      \      "  include Sidekiq::Worker", "", "  def perform(id)",
      \      "  end", "end"]
      \ },
      \ "app/services/*.rb": {
      \   "command": "service",
      \   "template":
      \     [
      \       "class {camelcase|capitalize|colons}",
      \       "  def self.call()",
      \       "  end",
      \       "",
      \       "  def call",
      \       "  end",
      \       "",
      \       "  private",
      \       "",
      \       "  def initialize()",
      \       "  end",
      \       "end"
      \   ],
      \   "affinity": "model"
      \ },
      \ "app/managers/*_manager.rb": {
      \   "command": "manager",
      \   "template":
      \     ["module {camelcase|capitalize|colons}Manager",
      \      "  extend self", "", "end"],
      \   "affinity": "model"
      \ },
      \ "app/serializers/*_serializer.rb": {
      \   "command": "serializer",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Serializer < ActiveModel::Serializer",
      \       "end"]
      \ },
      \ "app/queries/*_query.rb": {
      \   "command": "query",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Query",
      \       "end"],
      \   "affinity": "model"
      \ },
      \ "test/unit/*_test.rb": {
      \   "command": "unittest",
      \   "alternate": "app/models/{}.rb",
      \   "related": "test/fixtures/{pluarlize}.yml"
      \ },
      \ "app/api/*.rb": {
      \   "command": "api",
      \   "template":
      \     ["class {camelcase|capitalize|colons} < Grape::API", "end"],
      \ },
      \ "Gemfile": {
      \   "dispatch": "bundle"
      \ },
      \ "app/decorators/*_decorator.rb": {
      \   "command": "decorator",
      \   "related": "app/models/{}.rb",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Decorator < Draper::Decorator",
      \       "  delegate_all", "end"],
      \  "affinity": "model"
      \ },
      \ "app/factories/*_factory.rb": {
      \   "command": "factory",
      \   "template":
      \     ["module {camelcase|capitalize|colons}Factory", "end"],
      \   "affinity": "model"
      \ },
      \ "lib/utils/*.rb": {
      \   "command": "util",
      \   "template":
      \     ["module Utils", "  module {camelcase|capitalize|colons}", "    module_function", "  end", "end"]
      \ }}


command! -nargs=? Gemfile call <SID>gemfile(<f-args>)

function! s:gemfile(...) abort
  edit Gemfile
  if a:0
    call search('\v^group')
    keepjumps normal! {k
    call append(line('.'), 'gem "'.a:1.'"')
    normal! j
  endif
endfunction

nnoremap <leader>y /up<cr>cechange<esc>/down<cr>djkddkO

" Prettier {{{1
"
" when running at every change you may want to disable quickfix
let g:prettier#config#arrow_parens = 'always'
let g:prettier#config#trailing_comma ='es5'
let g:prettier#autoformat = 1
try
  autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
catch
  echom "Prettier done goofed"
endtry

function! s:map_prettier()
  if exists(":Prettier") && system('which prettier') != ""
    nnoremap <buffer> <silent> + :Prettier<CR>
  endif
endfunction
autocmd BufEnter *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html call <sid>map_prettier()

" RuboCop {{{1
"
let g:vimrubocop_keymap = 0
" if !empty(glob("Gemfile")) && system('grep "rubocop" < Gemfile')
let g:vimrubocop_rubocop_cmd = 'bundle exec rubocop '
" endif


" Rummage {{{1
"
let g:rummage_program = 'git'


" RSI  {{{1
"
let g:rsi_no_meta = 1


" SplitJoin  {{{1
"
let g:splitjoin_ruby_curly_braces = 0
let g:splitjoin_ruby_hanging_args = 0


" Test {{{1
"

let test#ruby#minitest#executable = 'ruby'
" let g:test#runner_commands = ['Minitest']

" Twiggy {{{1
"
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_group_locals_by_slash = 0
let g:twiggy_use_dispatch = 0
let g:twiggy_enable_remote_delete = 1
let g:twiggy_show_full_ui = 1
if $WORK_COMPUTER
  let g:twiggy_adapt_columns = 1
  let g:twiggy_group_locals_by_slash = 1
endif


" Vim-Test {{{1
"
let g:test#strategy = 'dispatch'

" Vim-Tmux Navigator {{{1
"
let g:tmux_navigator_no_mappings = 1

" Unimpaired {{{1
"
nmap co yo

nmap c<CR> mm'o:TestNearest<CR>'m

" YouCompleteMe {{{1
"
let g:ycm_key_list_select_completion = ['<c-e>']


" Work {{{1
"

if $WORK_COMPUTER
  autocmd BufEnter * call s:lcd()

  function! s:lcd() abort
    try
      let path = expand('%:p')

      if match(path, '\v\/production_scheduling\/') < 0
        return
      endif

      let cd_base_path = matchstr(path, '\v.+production_scheduling\/')

      if match(path, '\v\/backend\/') >= 0
        exec "lcd ".cd_base_path."backend"
      endif

      if match(path, '\v\/frontend\/') >= 0
        exec "lcd ".cd_base_path."frontend"
      endif
    catch
      echo "Failed to lcd"
    endtry
  endfunction
endif



function! s:git_cmd(cmd) abort
  return systemlist(fugitive#repo().git_command() . ' ' . a:cmd)
endfunction

function! s:get_current_branch_name() abort
  return s:git_cmd('rev-parse --abbrev-ref HEAD')[0]
endfunction

let s:ticket_regex = '\v^PS-[0-9]+'

function! s:add_ticket_number() abort
  let branch = s:get_current_branch_name()
  let ticket_number = matchstr(branch, s:ticket_regex)
  if ticket_number !=# ''
    if match(getline(1), s:ticket_regex) == -1
      exec "normal! i" . ticket_number . ":  \<esc>$"
      let v:char = "¯\_(ツ)_/¯" " See :help InsertEnter--Vim's weird, man
    endif
  endif
endfunction

function! s:remove_ticket_number() abort
  let branch = s:get_current_branch_name()
  let ticket_number = matchstr(branch, s:ticket_regex)
  if ticket_number !=# ''
    if match(getline(1), s:ticket_regex . ':\s+$') >= 0
      " If the ticket number is the only thing in the commit message, remove it
      " when exiting insert mode.
      call setline(1, '')
      for i in range(2, line('$'))
        if getline(i) !=# ''
          break
        endif
        delete_
      endfor
    else
      " Strip trailing whitespace.  This isn't really necessary but I'm pretty
      " OCD about this stuff.
      let pos = getpos('.')
      s/\s\+$//e
      call cursor(pos[1:])
    endif
  endif
endfunction

augroup Jira
  autocmd!
  autocmd FileType gitcommit :autocmd! InsertEnter <buffer=abuf> call <SID>add_ticket_number()
  autocmd FileType gitcommit :autocmd! InsertLeave <buffer=abuf> call <SID>remove_ticket_number()
augroup END
