if !&compatible | set nocompatible | endif
filetype off
" set rtp+=~/.vim/bundle/Vundle.vim

" Plugins {{{
" call vundle#begin()

" Plugin 'file:///' . expand('~') . '/.vim/bundle/Vundle.vim'

" Plugin 'sjl/vitality.vim'
" Plugin 'christoomey/vim-tmux-navigator'
" Plugin 'file:///' . expand('~') .'/src/vim/vim-tmux-navigator'
" Plugin 'tpope/vim-tbone'

" Plugin 'tpope/vim-dispatch'

" Plugin 'file:///' . expand('~') . '/src/vim/obsession'

" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'scrooloose/nerdtree'
" Plugin 'scrooloose/syntastic'

" Plugin 'tpope/vim-eunuch'
" Plugin 'tpope/vim-repeat'
" Plugin 'tpope/vim-surround'
" Plugin 'tpope/vim-unimpaired'
" Plugin 'tpope/vim-endwise'
" Plugin 'tommcdo/vim-exchange'

" Plugin 'tpope/vim-commentary'

" Plugin 'tpope/vim-fugitive'
" Plugin 'gregsexton/gitv'
" Plugin 'int3/vim-extradite'
" Plugin 'mhinz/vim-signify'
" Plugin 'file:///' . expand('~') . '/src/vim/twiggy'

" Plugin 'plasticboy/vim-markdown'
" Plugin 'junegunn/vim-xmark'

" Plugin 'tpope/vim-bundler'

" Plugin 'vim-ruby/vim-ruby'
" Plugin 'tpope/vim-rake'
" Plugin 'tpope/vim-rails'

" Plugin 'junegunn/limelight.vim'
" Plugin 'junegunn/goyo.vim'

" call vundle#end()
" }}}

execute pathogen#infect('bundle/{}', '~/src/vim/{}')
filetype plugin indent on
runtime! macros/matchit.vim
let g:netrw_dirhistmax = 0

" Syntax {{{1

syntax on
colorscheme sodapopcan

hi User1 ctermfg=255 ctermbg=239   " git branch
hi User2 ctermfg=16  ctermbg=167   " warn
hi User3 ctermfg=16  ctermbg=237   " filename
hi User4 ctermfg=167 ctermbg=237   " Obsession - tracking
hi User5 ctermfg=227 ctermbg=237   " Obsession - paused
hi User6 ctermfg=238 ctermbg=237   " Obsession - not tracking
hi User7 ctermfg=16  ctermbg=bg    " line

" Settings {{{1

" The following defaults are requires to maintain my sanity
" More, and file-type overrides, can be found in vim/ftplugins

set hidden				  " navigate away from  a buffer without saving it first
set shell=/bin/bash " Necessary to run the correct versions of unix programs
									  " when using zsh

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
set shortmess=at
set pumheight=5
set linebreak
set updatetime=1
set completeopt-=preview
set diffopt=filler,foldcolumn:0,context:4

set fillchars=fold:\ ,vert:▕

set nobackup noswapfile

set notimeout ttimeout ttimeoutlen=10

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
  let s = "%1*"
  let s.= s:git_branch_status_line()
  let s.= '%*'.ObsessionStatus().' '
  for i in range(tabpagenr('$'))
    " select the highlighting
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
" I've never grown out of using jk to escape insert mode
inoremap jk <ESC>
" Since C-L is in use, C-C will just do everything
nnoremap <C-C> <silent> <C-C>:noh<CR>:syntax sync fromstart<CR>:redraw!<CR>
" I'll get rid of this once I hack vim-tmux-navigator a bit
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
" One keypress -- instead of 4 -- to save
nnoremap <CR> :w \| redraw!<CR>
" Write everything and quit
nnoremap Q :wall \| qall!<CR>
" Undo an 'o'
inoremap <C-O> <Esc>ddk
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
nnoremap <silent>  - :sp<CR>
nnoremap <silent> \| :vsp<CR>
" Paste at EOL
nnoremap <silent> K :call PasteAtEOL()<CR>
" Reformat entire file
nnoremap + mzgg=G`z
" Help on word under cursor
" nnoremap <silent> <C-H> yiw :only \| vertical botright help <C-R><C-"><CR>
" Paste into command line
cnoremap <C-P> <C-R><C-">
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
" Position func/meth definition at top of screen after jump
nnoremap <C-]> <C-]>z<CR>
" This relies on having unimpaired installed
nmap <C-N> ]c
nmap <C-P> [c
" Tabs
nnoremap H :tabnew %<CR>
nnoremap ]h :tabnext<CR>
nnoremap [h :tabprev<CR>
nnoremap gH :tabclose<CR>
" Obsession
" nnoremap go :Obsession<CR>:redraw!<CR>
" nnoremap gO :Obsession!<CR>:redraw!<CR>


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
  " Well, this is a bad hack to fix colours getting all messed up after
  " shelling-out.  There's gotta be a better way.
  " autocmd BufEnter * redraw!
augroup END


" CTRLP {{{1
"
" Use space to invoke and quit
let g:ctrlp_map = '<Space>'
let g:ctrlp_prompt_mappings = {
      \ 'PrtExit()': ['<esc>', '<c-c>', '<c-g>', '<space>']
      \ }
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v(doc|db|tmp|log|bin|vendor|vim\/bundle|node_modules)\/(.*)'
  \ }

" Git {{{1
"
nnoremap <silent> gs :Gstatus<CR>
nnoremap <silent> gd :call GitDiffPlus()<CR>
nnoremap <silent> g? :Gblame<CR>
nnoremap <silent> gw :Gwrite<CR>:w<CR>
nnoremap <silent> gR :call system(fugitive#buffer().repo().git_command() . ' checkout ' . expand('%'))<CR>:e!<CR>:normal! zo<CR>
nnoremap          g<Space>  :Ggrep ""<Left>
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Ggrep \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Ggrep \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Ggrep \"\"<Left><C-R><C-\">"
endfor
nnoremap          gh :Glog<CR>
nnoremap <silent> gl :Extradite<CR>
nnoremap <silent> gL :Gitv<CR>
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


" Obsession

function! ObsessionStatus()
  let session   = filereadable(v:this_session)
  if exists('g:this_obsession') && session  " tracking
    return "%4* \u25CF"
  elseif session  " paused
    return "%5* \u25CF"
  else  " not tracking
    return "%6* \u25CF"
  endif
endfunction


" NERDTree {{{1
"
nnoremap <silent> M :NERDTreeToggle<CR>:wincmd =<CR>

let NERDTreeQuitOnOpen          = 1
let NERDTreeHijackNetrw         = 0
let NERDTreeHighlightCursorline = 1
let NERDTreeMinimalUI           = 1

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
