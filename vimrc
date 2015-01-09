if !&compatible | set nocompatible | endif
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugins {{{

call vundle#begin()

Plugin 'file:///' . expand('~') . '/.vim/bundle/Vundle.vim'

Plugin 'sjl/vitality.vim'

Plugin 'tpope/vim-dispatch'

Plugin 'tpope/vim-obsession'

Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'

Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-endwise'
Plugin 'tommcdo/vim-exchange'

Plugin 'tpope/vim-commentary'

Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'
Plugin 'mhinz/vim-signify'
Plugin 'file:///' . expand('~') . '/src/vim/twiggy'

Plugin 'plasticboy/vim-markdown'

Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'

Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/goyo.vim'

call vundle#end()
" }}}

filetype plugin indent on
runtime! macros/matchit.vim
let g:netrw_dirhistmax = 0

" Syntax {{{1

syntax on
colorscheme sodapopcan

hi User1 ctermfg=16  ctermbg=173   " git branch
hi User2 ctermfg=255 ctermbg=88    " warn
hi User3 ctermfg=16  ctermbg=238   " filename

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
set cursorline
set textwidth=80
set nowrap
set scroll=5
set scrolloff=7
set sidescrolloff=0
set shortmess=atTsWc
set pumheight=5
set autoread
set autowrite
set linebreak
set updatetime=1
set completeopt-=preview

" There is a space at the end of the next line:
set fillchars=fold:\ 
"  Now folds won't have those distracting dashes in 'em

set nobackup noswapfile

set notimeout ttimeout ttimeoutlen=10

set list listchars=tab:\ \ ,eol:\ ,trail:\.
hi SpecialKey ctermfg=9

set formatoptions=
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
    return ''
  endif
endfunction
function! StatusLine()
  let s =     ''
  let s.= "%2*"
  let s.= "%{&paste?'\ \ paste\ ':''}"
  let s.= "%{match(expand('%:p'), 'fugitive') >= 0?'\ \ fugitive \ ':''}"
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
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s.= '%#TabLineSel#'
    else
      let s.= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by TabLabel()
    let s .= ' %{TabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#'
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
" I already know how to quit; no need to remind me
nnoremap <C-C> <C-C>:echo ''<CR>
" One keypress -- instead of 4 -- to save
nnoremap <CR> :w<CR>
" Write everything and quit
nnoremap Q :wall \| qall!<CR>
" I don't like this, but it's somewhat life-changing
map <C-W> <Nop>
nnoremap <C-J> <C-W>
" Undo an 'o'
inoremap <C-O> <Esc>ddk
" Only show this window
nnoremap <silent> L :only<CR>
" I get it, Braam, but c'mon
nnoremap Y y$
" Keep your lines short, children
nnoremap j gj
nnoremap k gk
" Who doesn't prefer `'s functionailty?  Well, I do
nnoremap ` '
" I always have to think for a second if I want :vsp or :sp
nnoremap <silent>  - :sp<CR>
nnoremap <silent> \| :vsp<CR>
" Paste at EOL
nnoremap <silent> K :call PasteAtEOL()<CR>
" Help on word under cursor
nnoremap <silent> <C-H> yiw :only \| vertical botright help <C-R><C-"><CR>
" Paste into command line
cnoremap <C-P> <C-R><C-">
" Increase scroll speed a little
nnoremap <C-E> 2<C-E>
nnoremap <C-Y> 2<C-Y>
" Wipe buffer while maintaining its split
nnoremap <silent> <leader>q :bp\|bwipeout #<CR>
" Strip whitespace
nnoremap <silent> da<Space> :%s/\s\+$//<CR>
" Allow recovery from accidental c-w or c-u while in insert mode
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
" Just take me quick to github
vnoremap <CR> :Gbrowse<CR>

" Autocommands {{{1
augroup FileTypeOptions
  autocmd!
  autocmd BufReadPost fugitive://*
        \ setlocal bufhidden=wipe |
        \ nnoremap <buffer> q :q<CR>:set cursorline<CR>
  autocmd FileType gitcommit setlocal spell
  autocmd FileType help nnoremap <silent> <buffer> q :q<CR>
  autocmd FileType vim nnoremap <silent> <buffer> <CR> :w \|
        \ so % \| noh<CR>
  autocmd BufReadPost * if !&modifiable |
        \ nnoremap <buffer> q :q<CR> |
        \ endif
augroup END

" Don't show cursorline and an empty statusline on inactive buffers
augroup CursorStatusLines
  autocmd!
  " autocmd VimEnter,WinEnter,BufReadPost * if &ft !=# 'gitcommit'
  "       \ | setlocal cursorline statusline=%!StatusLine()
  "       \ | call sy#start()
  "       \ | endif
  " Just put an ASCII cat on inactive status bars why not
  autocmd WinLeave * setlocal nocursorline statusline=\ \ \=^..^\=
augroup END

augroup AlwaysShowSignColumn
  autocmd!
  autocmd BufEnter * sign define dummy
  autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

au! BufEnter * redraw!

" Cut and Paste Functions {{{1

" Paste at end of the line
function! PasteAtEOL()
  " strip trailing space on current line
  s/\s\+$//e
  " add trailing space then paste
  exec "normal! A\<space>\<esc>mzp`z"
endfunction

" CTRLP {{{1
"
" Use space to invoke and quit
let g:ctrlp_map = '<Space>'
let g:ctrlp_prompt_mappings = {
      \ 'PrtExit()': ['<esc>', '<c-c>', '<c-g>', '<space>']
      \ }
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v(doc|db|tmp|log|bin|vendor|vim\/bundle)\/(.*)'
  \ }

" Git {{{1
"
nnoremap <silent> gs :Gstatus<CR>
nnoremap <silent> gd :Gdiff<CR>
nnoremap <silent> g? :Gblame<CR>
nnoremap <silent> gw :Gwrite<CR>:w<CR>
nnoremap          g<Space>  :Ggrep ""<Left>
for t in ['w', 'W', 'b', 'B', '"', "'", '`', '<', '>', '[', ']', '(', ')', '{', '}']
  exec "nnoremap gy".t."<Space> y".t.":Ggrep \"\"<Left><C-R><C-\">"
  exec "nnoremap gyi".t."<Space> yi".t.":Ggrep \"\"<Left><C-R><C-\">"
  exec "nnoremap gya".t."<Space> ya".t.":Ggrep \"\"<Left><C-R><C-\">"
endfor
nnoremap          gh :Glog<CR>
nnoremap <silent> gl :Gitv!<CR>
nnoremap <silent> gL :Gitv<CR>
nnoremap <silent> gb :Twiggy<CR>
nnoremap          gB :Twiggy<Space>

" Gitv {{{1
"

let g:Gitv_OpenHorizontal  = 1
let g:Gitv_DoNotMapCtrlKey = 1
highlight diffAdded   ctermbg=121
highlight diffRemoved ctermbg=224


" Goyo {{{1
"
nnoremap <C-K> :Goyo<CR>

function! s:goyo_leave()
  source ~/.vimrc
endfunction
autocmd User GoyoLeave nested call <SID>goyo_leave()

" Markdown
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
let NERDTreeHighlightCursorline = 1
let NERDTreeMinimalUI           = 1

" Syntastic {{{1
"
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting = 0

let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_javascript_checkers = ['jshint']

" Signify {{{1
"
let g:signify_sign_add                 = "\u258E"
let g:signify_sign_delete              = "\u2581"
let g:signify_sign_delete_first_line   = "\u2594"
let g:signify_sign_change              = g:signify_sign_add
let g:signify_sign_changedelete        = g:signify_sign_add
let g:signify_vcs_list                 = ['git']
let g:signify_cursorhold_normal        = 1

highlight SignifySignAdd    ctermfg=28  ctermbg=bg cterm=NONE
highlight SignifySignChange ctermfg=24  ctermbg=bg cterm=NONE
highlight SignifySignDelete ctermfg=124 ctermbg=bg cterm=NONE


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
