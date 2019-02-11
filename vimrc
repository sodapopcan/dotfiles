if !&compatible | set nocompatible | endif

" Plugins {{{1
"
call plug#begin('~/.vim/plugins')

" Usability
Plug 'sjl/vitality.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-tbone'
Plug 'ludovicchabant/vim-gutentags'
Plug 'editorconfig/editorconfig-vim'

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

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'

Plug '~/src/vim/refactor'

" Text Objects
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-ruby'
Plug 'andyl/vim-textobj-elixir'

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
Plug '~/src/vim/ifionly'
Plug 'tpope/vim-ragtag'
Plug 'vim-scripts/a.vim'
Plug 'justinmk/vim-syntax-extra'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug '~/src/vim/twiggy'
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

" Other
Plug 'junegunn/goyo.vim'
Plug 'chr4/nginx.vim'

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
hi User7 ctermbg=bg   ctermfg=16   cterm=none   " line

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

if $WORK_COMPUTER
  " I don't need numbers when I work alone but they are useful when pairing
  set number
endif
" I just like this stuff
set cmdheight=2
set showcmd
set cursorline
set nostartofline
set breakindent
set breakindentopt=shift:2
set ruler
set textwidth=80
set wrap
" set scroll=5
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

" Since C-L is in use, C-C will just do everything
inoremap <silent> <C-C> <Esc>:redraw!<CR>
nnoremap <silent> <C-C> :redraw!<CR>

" One keystroke--instead of 4--to save
au! BufReadPost * if &buftype ==# '' && &modifiable | exec "nnoremap \<buffer> \<CR> :write\<CR>" | endif
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

nnoremap <silent> gp :set paste<bar>put<bar>set nopaste<CR>
" Thanks a lot, touchbar
nnoremap <F1> <nop>

" Dispatch
nnoremap <silent> d<CR> :Dispatch<CR>
" Tests (Vim-Test)
nnoremap <silent> f<CR> :TestFile<CR>
nnoremap <silent> t<CR> :TestNearest<CR>
nnoremap <silent> F<CR> :TestVisit<CR>
" Write everything and quit
nnoremap ZX :wall \| qall!<CR>
nnoremap zx :wall \| qall!<CR>
" I've never used more than one macro register before (though maybe I should?)
" In any event, qq for recording, Q to playback (stolen from junegunn)
nnoremap Q @q
" Only show this window
nnoremap <silent> L :IfIOnly<CR>
" Make Y do what you think it would
nnoremap Y y$
" Yank full path (yank full)
nnoremap yff :let @+ = expand('%:p')<CR>:echo "Yanked: ".expand('%:p')<CR>
" Yank relative path ([y]ank [f]ile [p]ath)
nnoremap yfp :let @+ = expand('%')<CR>:echo "Yanked: ".expand('%')<CR>
" Yank relative path ([y]ank [f]ile [n]ame)
nnoremap yfn :let @+ = expand('%:t')<CR>:echo "Yanked: ".expand('%:t')<CR>
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
" I've held off on this for a long time.  I dont' know why
nnoremap <F5> :so ~/.vimrc<CR>
" Position func/meth definition at top of screen after jump
nnoremap <C-]> <C-]>zt
" This relies on having unimpaired installed
nmap <C-N> ]m
nmap <C-P> [m
" Sync zz with my eyes
nnoremap zz zz2<C-E>
" Open quickfix list across bottom
cnoreabbrev copen botright copen
" Maximize current vertical split
nnoremap <silent> gZ :wincmd \|<CR>
" Even up the current vertical split
nnoremap <silent> g\| :wincmd =<CR>
" Running
nnoremap g<cr> :exec "Dispatch " . &ft . " %"<cr>
" Tagbar
nnoremap zt :Tagbar<cr>
" Folding
nnoremap cfm :set fdm=marker<CR>
nnoremap cfc :set fdm=manual<CR>
nnoremap cfi :set fdm=indent<CR>
nnoremap cfs :set fdm=syntax<CR>
nnoremap cfe :set fdm=expr<CR>
nnoremap cfd :set fdm=diff<CR>
" a.vim-like
nnoremap ga :A<CR>
nnoremap gr :R<CR>
nnoremap gA :only<Bar>AV<CR>
nnoremap gR :only<Bar>RV<CR>
nnoremap <leader>ga ga
nnoremap <leader>gl gr
" Grepping
nnoremap g<Space> :Rummage "" <Left><Left>
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Rummage \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Rummage \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Rummage \"\"<Left><C-R><C-\">"
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
" Rails specific
nnoremap <Leader>c :e config/settings.local.yml<CR>
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
  let s = ''
  let s.= "%2*"
  let s.= "%{&paste?'\ \ paste\ ':''}"
  let s.= "%{match(expand('%:p'), '^fugitive') >= 0?'\ \ fugitive \ ':''}"
  let s.= "%*"
  let s.= "%1*"
  let s.= "\ " . s:git_branch_status_line() . "\ "
  let s.= "%*"
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
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s.= '%#TabLineSel#'
    else
      let s.= '%#TabLine#'
    endif
    let s.= '%' . (i + 1) . 'T'
    let s.= ' %{TabLabel(' . (i + 1) . ')} '
    " let s.= ' %{split(getcwd(), "/")[-1]} '
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
  if filename ==# ''
    return '[No Name]'
  endif
  " return join(split(filename, '/'), ' ▶ ')
  return fnamemodify(filename, ':t')
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

" Commands {{{1
"

" General
command! -nargs=1 H exec ":vert h " . <f-args> . "\<cr>"
" Vim
command! -nargs=* E silent edit <f-args>
" Dispatch
command! -nargs=* D Dispatch <f-args>
" HTML
command! -nargs=1 Note exec ":e ~/notes/" . <f-args> . ".txt"
" Shruggie
command! -nargs=0 Shrug exec "normal! a ¯\\_(ツ)_/¯\<Esc>"
" Source
command! -nargs=0 So so %
" :redraw!
command! -nargs=0 Redraw redraw!
" Branj
command! -nargs=+ Branj exec ":Start branj " . <f-args>

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
  " Just put an ASCII cat on inactive status bars why not
  autocmd WinLeave * setlocal statusline=\ \ \=^..^\=
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

augroup Debugging
  au!
  au FileType eruby nnoremap <buffer><silent><leader>f :exec "call append(line('.'), '<% byebug %>')\<bar>normal j==\<bar>"<cr>:write<cr>
  au FileType ruby  nnoremap <buffer><silent><leader>f :exec "call append(line('.'), 'byebug')\<bar>normal j=="<cr>:write<cr>
augroup END

au FileType GV nnoremap go :normal o<cr><bar>:wincmd w<cr><bar>:normal! zR<cr>
au FileType GV nnoremap <buffer> Q :tabclose<CR>


" Closetag {{{1
"
let g:closetag_filenames = "*.html,*.erb,*.xml,*.mustache"

" Edtiorconfig {{{1
"

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Git {{{1
"
nnoremap <silent> gs :keepalt leftabove Gstatus<CR>
nnoremap <silent> gC :Gcommit -v<CR>
nnoremap <silent> gd :! clear && git diff<CR>
nnoremap <silent> gD :! clear && git diff --cached<CR>
nnoremap <silent> g? :Gblame -w<CR>
nnoremap <silent> gw :Gwrite<CR>:write<CR>
nnoremap <silent> gR :call system(fugitive#buffer().repo().git_command() . ' checkout ' . expand('%'))<CR>:e!<CR>:normal! zo<CR>
nnoremap <silent> gb :Twiggy<CR>
nnoremap          gB :Twiggy<Space>
nnoremap <silent> gl :GV<CR>
nnoremap <silent> gL :GV!<CR>
nnoremap          g^ :Gpush<CR>
nnoremap          gV :Gpull<CR>

command! -nargs=? Migrate call <SID>migrate_rails(<f-args>)
command! -nargs=0 Rollback Dispatch rake db:rollback && RAILS_ENV=test rake db:rollback
command! -nargs=0 Eform Eview _form
command! -nargs=0 -bang Push call <SID>git_push(<bang>0)

function! s:migrate_rails(...)
  if a:0 > 0
    exec ":Dispatch rails g migration " . a:1
  else
    Dispatch rake db:migrate && RAILS_ENV=test rake db:migrate
  endif
endfunction

function! s:git_push(bang) abort
  if a:bang
    Gpush -f
  else
    Gpush -u
  endif
endfunction

" +++ Git Functions {{{2
if !exists('*GitDiffPlus')
  function! GitDiffPlus()
    let linenr = line('.')
    GitGutterDisable
    tabnew %
    Gvdiff
    colorscheme diff
    exec "normal! " . linenr . 'G'
    windo nnoremap <buffer> q :call GitDiffPlusCleanUp()<CR>
  endfunction

  function! GitDiffPlusCleanUp()
    windo write
    tabclose
    colorscheme sodapopcan
    GitGutterEnable
    nnoremap <buffer> q q
    source $MYVIMRC
  endfunction
endif


" ALE {{{1
"

let g:ale_linters = {
\   'ruby': ['mri', 'rubocop'],
\   'javascript': ['eslint'],
\   'haskell': ['ghc']
\ }

if !empty(glob("Gemfile")) && system('grep "rubocop" < Gemfile')
  let g:ale_ruby_rubocop_executable = 'bundle'
endif
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'

highlight ALEErrorSign term=bold ctermfg=160
highlight ALEWarningSign term=bold ctermfg=178
" ^ I can't decide v ¯\_(ツ)_/¯
" highlight ALEErrorSign ctermfg=167
" highlight ALEWarningSign ctermfg=187

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
nmap g+ <Plug>GitGutterStageHunk
nmap g- <Plug>GitGutterUndoHunk
nmap g_ <Plug>GitGutterPreviewHunk
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk

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

" GV {{{1
"

function! s:scroll_commits(down) abort
  wincmd p
  execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
  wincmd p
endfunction

function! s:init_gv_scroll() abort
  nnoremap <silent> <buffer> J :call <sid>scroll_commits(1)<cr>
  nnoremap <silent> <buffer> K :call <sid>scroll_commits(0)<cr>
endfunction

augroup GV
  autocmd!
  autocmd FileType GV :call s:init_gv_scroll()
augroup END
" IfIOnly {{{1
"
let g:ifionly_filetypes = ['vim-plug']
let g:ifionly_destructive_jump = 0


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
      \ "app/services/*_service.rb": {
      \   "command": "service",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Service", "end"],
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
      \ }}


nnoremap <leader>y /up<cr>cechange<esc>/down<cr>djkddkO

" RuboCop {{{1
"
let g:vimrubocop_keymap = 0


" Rummage {{{1
"
let g:rummage_default_program = 'git'


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
