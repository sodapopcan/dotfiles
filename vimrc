if !&compatible | set nocompatible | endif
filetype off
" set rtp+=~/.vim/bundle/Vundle.vim

" Plugins {{{
" call vundle#begin()

" 'file:///' . expand('~') . '/.vim/bundle/Vundle.vim'

" plugin sjl/vitality.vim
" plugin christoomey/vim-tmux-navigator
" 'file:///' . expand('~') .'/src/vim/vim-tmux-navigator'
" plugin tpope/vim-tbone'

" plugin tpope/vim-dispatch'

" 'file:///' . expand('~') . '/src/vim/obsession'

" plugin ctrlpvim/ctrlp.vim'
" plugin scrooloose/nerdtree'
" plugin scrooloose/syntastic'

" plugin tpope/vim-eunuch'
" plugin tpope/vim-repeat'
" plugin tpope/vim-surround'
" plugin tpope/vim-unimpaired'
" plugin tpope/vim-endwise'
" plugin tommcdo/vim-exchange'

" plugin tpope/vim-commentary'

" plugin tpope/vim-fugitive'
" plugin gregsexton/gitv'
" plugin int3/vim-extradite'
" plugin mhinz/vim-signify'
" 'file:///' . expand('~') . '/src/vim/twiggy'

" plugin plasticboy/vim-markdown'
" plugin junegunn/vim-xmark'

" plugin tpope/vim-bundler'

" plugin vim-ruby/vim-ruby'
" plugin tpope/vim-rake'
" plugin tpope/vim-rails'

" plugin junegunn/limelight.vim'
" plugin junegunn/goyo.vim'

" call vundle#end()
" }}}

execute pathogen#infect('bundle/{}', '~/src/vim/{}')
filetype plugin indent on
runtime! macros/matchit.vim
let g:netrw_dirhistmax = 0

" Syntax {{{1

syntax on
colorscheme sodapopcan

hi User1 ctermfg=124 ctermbg=186   " git branch
hi User2 ctermfg=16  ctermbg=167   " warn
hi User3 ctermfg=16  ctermbg=237   " filename
hi User4 ctermfg=bg ctermbg=bg     " Obsession - tracking
hi User5 ctermfg=bg ctermbg=227    " Obsession - paused
hi User6 ctermfg=bg ctermbg=236    " Obsession - not tracking
hi User7 ctermfg=16  ctermbg=bg    " line

" Settings {{{1

" The following defaults are requires to maintain my sanity
" More, and file-type overrides, can be found in vim/ftplugins

set hidden				  " navigate away from  a buffer without saving it first
set shell=/bin/bash " Necessary to run the correct versions of unix programs
" when using zsh

set notimeout nottimeout
set ttyfast
set lazyredraw

set mouse=a

set encoding=utf-8

set backspace=2     " Backspace over everything
set laststatus=2    " Always show the status line
set showtabline=2   " I don't really use tabs, but the tabline works decently
                    " as a global status line

set autoindent
set tabstop=2 softtabstop=2 expandtab
set shiftwidth=2 shiftround
set incsearch hlsearch
set ignorecase smartcase

" I just like this stuff
set ruler
set textwidth=80
set nowrap
set scroll=5
set scrolloff=2
set sidescrolloff=0
set shortmess=atWI
set pumheight=5
set linebreak
set updatetime=100
set completeopt-=preview
set diffopt=filler,foldcolumn:0,context:4

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

" Status/Tab Lines {{{1
"
" 'Tab Line' is used as a 'global status' bar.
"   * File name (basename of currently focused buffer)
"     is always at the top of the screen
function! s:git_branch_status_line()
  let status = substitute(substitute(copy(fugitive#statusline()), '^[Git(', '', ''), ')]$', '', '')
  if status != ''
    return ' ' . status . ' '
  else
    return ' [No Branch] '
  endif
endfunction
function! StatusLine()
  let s = ''
  let s.= "%2*"
  let s.= "%{&paste?'\ \ paste\ ':''}"
  let s.= "%{match(expand('%:p'), '^fugitive') >= 0?'\ \ fugitive \ ':''}"
  let s.= "%*"
  " let s.= "\ %(%f%)"
  let s.= "%="
  let s.= "%3*"
  let s.= "\ %(%p%%\ \ %l/%L,%v\ \ %)"
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
  endfor
  let s.= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s.= '%=%#TabLine#'
  endif
  let s.= '%='
  let s.= "%1*"
  let s.= s:git_branch_status_line()

  return s
endfunction
function! TabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufname = bufname(buflist[winnr - 1])
  let filename = matchstr(
        \ substitute(bufname, '\/$', '', ''),
        \ '\v\/([^/]*)$')
  if filename ==# ''
    return bufname[:36]
  endif
  let filename = substitute(filename, '/', '', '')
  if filename ==# ''
    return '=^..^='
  endif
  return filename[:36]
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

" Mappings {{{1
"

" I'm trying to grow out of jk for escaping insert mode, but I'm failing pretty
" hard
inoremap jk <ESC>:call AfterEsc()<CR>
inoremap <C-C> <ESC>:call AfterEsc()<CR>

nnoremap o :let b:last_curpos = getcurpos()<CR>o
nnoremap O :let b:last_curpos = getcurpos()<CR>O
function! AfterEsc()
  if getline('.') =~ '\v^\s*$'
    if exists('b:last_curpos')
      normal! dd
      call setpos('.', b:last_curpos)
      unlet b:last_curpos
    endif
  else
    write
  endif
endfunction

" Since C-L is in use, C-C will just do everything
nnoremap <C-C> <Esc>:w<CR><C-C>:syntax sync fromstart<CR>:redraw!<CR>

" Some Insert mode readline bindings
inoremap <C-A> <C-O>^
inoremap <C-E> <C-O>$
" Meta-key for me is actually Apple's left Command key
nnoremap <M-H> <C-W>h
nnoremap <M-J> <C-W>j
nnoremap <M-K> <C-W>k
nnoremap <M-L> <C-W>l
" Run tests
" I'm going to need to flesh this out a bunch but, for now, assume rspec
nnoremap <CR> :call RunTests(0)<CR>
nnoremap d<CR> :call RunTests(1)<CR>
function! RunTests(type)
  write
  let jumpback = 0
  if expand('%') =~ '\v_spec.rb$'
  else
    try
      silent A
    catch
      echo "Not a test file"
      return
    endtry
    let jumpback = 1
  endif

  if expand('%') =~ '\v_spec.rb$'
    if a:type == 0
      exe ":!clear && bundle exec rspec --fail-fast %"
    else
      exe ":!clear && bundle exec rspec --fail-fast %:".line('.')
    endif
  else
    echo "Not a test file"
  endif
  if jumpback
    silent A
  endif
endfunction
" Write everything and quit
nnoremap zZ :wall \| qall!<CR>
" I've never used more than one macro register before (though maybe I should?)
" In any event, qq for recording, Q to playback (stolen from junegunn)
nnoremap Q @q
" Only show this window
nnoremap <silent> L :IfIOnly<CR>
" Make Y do what you think it would
nnoremap Y y$
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
nnoremap + mzgg=G`z
" Help on word under cursor
" nnoremap <silent> <C-H> yiw :only \| vertical botright help <C-R><C-"><CR>
" Paste into command line
" Increase scroll speed a little
nnoremap <C-E> 2<C-E>
nnoremap <C-Y> 2<C-Y>
" Strip whitespace
nnoremap <silent> da<Space> :%s/\s\+$//<CR>
" Allow recovery from accidental c-w or c-u while in insert mode
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" Just take me quick to github
vnoremap <CR> :Gbrowse<CR>
" I've held off on this for a long time.  I dont' know why
nnoremap <F5> :so ~/.vimrc<CR>

" Navigation
" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <Space> :call SelectaCommand("find * -type f", "", ":e")<CR>
" Position func/meth definition at top of screen after jump
nnoremap <C-]> <C-]>zt
" This relies on having unimpaired installed
nmap <C-N> ]c
nmap <C-P> [c
" Sync zz with my eyes
nnoremap zz zz2<C-E>

" Leader Mappings
"

" Wipe buffer while maintaining its split
nnoremap <silent> <leader>q :bp\|bwipeout #<CR>
" Edit a new file in the same directory
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
" Location mappings for rails
autocmd BufEnter * call <SID>define_rails_mappings()

" Mappings Functions {{{2

" Paste at end of the line
function! PasteAtEOL()
  " strip trailing space on current line
  s/\s\+$//e
  " add trailing space then paste
  exec "normal! A\<space>\<esc>mzp`z"
endfunction

" Make (custom) L mapping smarter
"
" If there are only modifiable splits present, make the current split the only
" split (ie, run :only). If any unmodifable splits are open (:Gstatus, quickfix
" window, NERDTree, etc...) close all of those.  If the cursor is in an
" unmodifiable split, jump to the first modifiable one.

function! s:isdir(dir)
  return glob(a:dir) !=# ''
endfunction

" Define location mappings for rails projects
function! s:define_rails_mappings()
  if exists('*RailsDetect')
    nnoremap <buffer> <silent> <Leader>m :e db/schema.rb<CR>
  endif

  if s:isdir('db/migrate')
    nnoremap <buffer> <silent> <Leader>d :e db/migrate<CR>:keepjumps normal! G<CR>
    nnoremap <buffer> <silent> <Leader>D :e db/migrate<CR>:keepjumps normal! G<CR>:keepjumps exec "normal <C-V><CR>"<CR>
  endif
endfunction



" Autocommands {{{1
augroup FileTypeOptions
  autocmd!
  autocmd BufReadPost fugitive://*
        \ setlocal bufhidden=wipe |
        \ nnoremap <buffer> q :q<CR>
  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit setlocal list listchars=tab:\ \ 
  autocmd FileType help,qf nnoremap <silent> <buffer> q :q<CR>
  autocmd FileType vim nnoremap <silent> <buffer> <CR> :w \|
        \ so % \| noh<CR>


  autocmd BufReadPost * if !&modifiable |
        \ nnoremap <buffer> q :q<CR> |
        \ endif
augroup END

" Don't show cursorline and an empty statusline on inactive buffers
augroup CursorStatusLines
  autocmd!
  autocmd VimEnter,WinEnter,BufReadPost * if &ft !=# 'gitcommit'
        \ | setlocal statusline=%!StatusLine()
        \ | endif
  " Just put an ASCII cat on inactive status bars why not
  autocmd WinLeave * setlocal statusline=\ \ \=^..^\=
augroup END

augroup AlwaysDoThisStuff
  autocmd!
  " Always show the sign column
  autocmd BufEnter * sign define dummy
  autocmd BufEnter * exec 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
  " I dunno anymore
  autocmd ShellCmdPost * redraw!
augroup END


" CTRLP {{{1
"
" Use space to invoke and quit
" let g:ctrlp_map = '<Space>'
let g:ctrlp_prompt_mappings = {
      \ 'PrtExit()': ['<esc>', '<c-c>', '<c-g>', '<space>']
      \ }
let g:ctrlp_custom_ignore = {
      \ 'dir': '\v(doc|db|tmp|log|bin|vendor|vim\/bundle|node_modules|instructions)\/(.*)',
      \ 'file': '\vSession.vim'
      \ }

" Git {{{1
"
nnoremap <silent> gs :Gstatus<CR>
nnoremap <silent> gd :call GitDiffPlus()<CR>
nnoremap <silent> g? :Gblame -w<CR>
nnoremap <silent> gw :Gwrite<CR>:w<CR>
nnoremap <silent> gR :call system(fugitive#buffer().repo().git_command() . ' checkout ' . expand('%'))<CR>:e!<CR>:normal! zo<CR>
nnoremap          g<Space>  :Ggrep ""<Left>
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Ggrep \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Ggrep \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Ggrep \"\"<Left><C-R><C-\">"
endfor
" nnoremap          gh :Glog<CR>
nnoremap <silent> gH :Extradite<CR>
nnoremap <silent> gh :Gitv<CR>
nnoremap <silent> gb :Twiggy<CR>
nnoremap          gB :Twiggy<Space>

" +++ Git Functions {{{2
if !exists('*GitDiffPlus')
  function! GitDiffPlus()
    let linenr = line('.')
    SignifyToggle
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
    SignifyToggle
    nnoremap <buffer> q q
    source $MYVIMRC
  endfunction
endif

" Gitv {{{1
"

let g:Gitv_OpenHorizontal  = 1
let g:Gitv_DoNotMapCtrlKey = 1
highlight diffAdded   ctermbg=121
highlight diffRemoved ctermbg=224


" Goyo {{{1
"
function! s:goyo_leave()
  source ~/.vimrc
endfunction
autocmd User GoyoLeave nested call <SID>goyo_leave()

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
let NERDTreeHijackNetrw         = 0
let NERDTreeHighlightCursorline = 0
let NERDTreeMinimalUI           = 1

" RSI  {{{1
"
let g:rsi_no_meta = 1

" Selecta  {{{1
"

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command) abort
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Syntastic {{{1
"
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting = 0

let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_javascript_checkers = ['jshint']

let g:syntastic_mode_map = {
      \ 'mode': 'active',
      \ 'passive_filetypes': ['erb']
      \ }

" Signify {{{1
"
let g:signify_sign_add                 = "\u258F"
let g:signify_sign_delete              = "\u2581"
let g:signify_sign_delete_first_line   = "\u2594"
let g:signify_sign_change              = g:signify_sign_add
let g:signify_sign_changedelete        = g:signify_sign_add
let g:signify_vcs_list                 = ['git']
let g:signify_cursorhold_normal        = 1

highlight SignifySignAdd    ctermfg=28  ctermbg=bg cterm=NONE
highlight SignifySignChange ctermfg=24  ctermbg=bg cterm=NONE
highlight SignifySignDelete ctermfg=167 ctermbg=bg cterm=NONE


" Twiggy {{{1
"
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_group_locals_by_slash = 0
let g:twiggy_use_dispatch = 0
let g:twiggy_enable_remote_delete = 1

hi! TwiggyIconTracking      ctermfg=2   ctermbg=NONE
hi! TwiggyIconAhead         ctermfg=9   ctermbg=NONE
hi! TwiggyIconAheadBehind   ctermfg=9   ctermbg=NONE
hi! TwiggyIconDetached      ctermfg=5   ctermbg=NONE
hi! TwiggyIconUnmerged      ctermfg=11  ctermbg=NONE

" highlight TwiggyHeader ctermfg=195
" highlight TwiggySort ctermfg=213

" Vim-Tmux Navigator {{{1
" let g:tmux_navigator_no_mappings = 1

" nnoremap <silent>     :TmuxNavigateLeft<cr>
" nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
" nnoremap <silent>     :TmuxNavigateUp<cr>
" nnoremap <silent>     :TmuxNavigateRight<cr>
" nnoremap <silent> <F1>  :TmuxNavigatePrevious<cr>
