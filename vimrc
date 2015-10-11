if !&compatible | set nocompatible | endif

" Plugins {{{
let g:plug_threads = 1
call plug#begin('~/.vim/plugins')

Plug 'sjl/vitality.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-tbone'

Plug 'tpope/vim-dispatch'

Plug 'tpope/vim-obsession'

Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-ruby'

Plug 'scrooloose/nerdtree',            { 'on':  'NERDTreeToggle' }
Plug 'kien/ctrlp.vim'
Plug 'vim-scripts/BufOnly.vim'

Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'
Plug 'sjl/gundo.vim'
Plug 'vim-scripts/TailMinusF'

Plug 'scrooloose/syntastic'

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/splitjoin.vim'
Plug '~/src/vim/ifionly'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'

Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'
Plug 'airblade/vim-gitgutter'
Plug '~/src/vim/twiggy'

Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-scriptease',           { 'for': 'vim' }

Plug 'plasticboy/vim-markdown',        { 'for': 'markdown' }
Plug 'junegunn/vim-xmark',             { 'for': 'markdown' }

Plug 'alvan/vim-closetag'
Plug 'othree/html5.vim'

Plug 'pangloss/vim-javascript'

Plug 'tpope/vim-bundler'

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'

Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'

call plug#end()
" }}}
" Common {{{1
"

runtime! macros/matchit.vim
let g:netrw_dirhistmax = 0

syntax on
colorscheme sodapopcan

hi User1 ctermfg=124 ctermbg=186   " git branch
hi User2 ctermfg=16  ctermbg=167   " warn
hi User3 ctermfg=16  ctermbg=237   " filename
hi User4 ctermfg=bg  ctermbg=bg    " Obsession - tracking
hi User5 ctermfg=bg  ctermbg=227   " Obsession - paused
hi User6 ctermfg=bg  ctermbg=167   " Obsession - not tracking
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
set cursorline
set ruler
set textwidth=80
set nowrap
set scroll=5
set scrolloff=2
set sidescrolloff=0
set shortmess=atWI
set pumheight=5
set linebreak
set updatetime=2000
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

" Mappings {{{1
"

" I'm trying to grow out of jk for escaping insert mode, but I'm failing pretty
" hard
inoremap <silent> jk <ESC>
inoremap <silent> <C-C> <ESC>

" Since C-L is in use, C-C will just do everything
nnoremap <C-C> <Esc>:w<CR><C-C>:syntax sync fromstart<CR>:redraw!<CR>

" One keystroke--instead of 4--to save
nnoremap <CR> :write<CR>
" Apparently I have to do this because of my iTerm key-remaps
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-H> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
nnoremap <silent> <C-K> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateRight<cr>
" Control when you want to see more
nnoremap <silent> H :vertical resize 102<CR>
" nnoremap <silent> <M-H>:TmuxNavigatePrevious<cr>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>

" Run tests
" I'm going to need to flesh this out a bunch but, for now, assume rspec
nnoremap f<CR> :call RunTests(1)<CR>
nnoremap t<CR> :call RunTests(2)<CR>
nnoremap c<CR> :call RunTests(3)<CR>
function! RunTests(type)
  let jumpback = 0

  if expand('%') !~ '\v_spec.rb$'
    try
      silent A
    catch
      echo "No test file"
      return
    endtry
    let jumpback = 1
  endif

  if expand('%') =~ '\v_spec.rb$'
    normal! m'gg
    let bundle = ''
    if search("spec_helper") || search("rails_helper")
      let bundle = 'bundle exec '
    endif
    normal! `'
    let test_cmd = ":!clear && ".bundle."rspec --fail-fast --no-profile %"
    if a:type == 1
      exe test_cmd
    elseif a:type == 2
      exe test_cmd.':'.line('.')
    elseif a:type == 3
      normal! m'
      if getline('.') =~ '\vcontext(.*)do$' || search('context', 'bW') || search('context')
        exe test_cmd.':'.line('.')
        normal! `'
      else
        exe test_cmd
      endif
    endif
  else
    echo "No test file"
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
" Fuzzy finding
nnoremap <Space> :FZF!<CR>
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
    nnoremap <buffer> <silent> <Leader>s :Eini<CR>
    nnoremap <buffer> <silent> <Leader>S :Eini<Space>
    nnoremap <buffer>          <Leader>C :Econtroller<Space>
    nnoremap <buffer> <silent> <Leader>c :Econtroller<CR>
    nnoremap <buffer>          <Leader>V :Eview<Space>
    nnoremap <buffer> <silent> <Leader>v :Eview<CR>
    nnoremap <buffer>          <Leader>M :Emodel<Space>
    nnoremap <buffer>          <Leader>m :Emodel<CR>
    nnoremap <buffer> <silent> d<CR>     :Dispatch bundle exec rspec<CR>
  endif

  if s:isdir('db/migrate')
    nnoremap <buffer> <silent> <Leader>d :e db/migrate<CR>:keepjumps normal! G<CR>
    nnoremap <buffer> <silent> <Leader>D :e db/migrate<CR>:keepjumps normal! G<CR>:keepjumps exec "normal <C-V><CR>"<CR>
  endif
endfunction

function! InsertGlyphicon(name)
  exec 'normal! i<span class="glyphicon glyphicon-' . a:name . '"></span>'
endfunction
command! -nargs=1 Glyph call InsertGlyphicon(<f-args>)


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


" Closetag
"

let g:closetag_filenames = "*.html,*.erb,*.xml"

" Git {{{1
"
nnoremap <silent> gs :Gstatus<CR>
nnoremap <silent> gi :call GitDiffPlus()<CR>
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

" CtrlP
"
let g:ctrlp_map = '<Space>'
let g:ctrlp_prompt_mappings = {
      \ 'PrtExit()': ['<esc>', '<c-c>', '<c-g>', '<space>']
      \ }

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
nmap g- <Plug>GitGutterRevertHunk
nmap g_ <Plug>GitGutterPreviewHunk
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk

hi GitGutterAdd    ctermfg=28  ctermbg=bg cterm=NONE
hi GitGutterChange ctermfg=24  ctermbg=bg cterm=NONE
hi GitGutterDelete ctermfg=167 ctermbg=bg cterm=NONE


" Goyo {{{1
"
function! s:goyo_leave()
  source ~/.vimrc
endfunction
autocmd User GoyoLeave nested call <SID>goyo_leave()

" IfIOnly {{{1
"
let g:ifionly_filetypes = ['vim-plug']

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
      \   "command": "service"
      \ },
      \ "spec/factories/*_factory.rb": {
      \   "command": "factory",
      \   "template":
      \     ["FactoryGirl.define do",
      \      "  factory :{} do",
      \      "  end", "end"],
      \   "affinity": "model"
      \ }}

" RSI  {{{1
"
let g:rsi_no_meta = 1

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
"
let g:tmux_navigator_no_mappings = 1
