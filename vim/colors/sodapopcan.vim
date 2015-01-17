" This is based on Nick Moffitt's version of Josh O'Rourke's version of
" railscasts.vim.  I've tweaked it and removed all the GUI noise.

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "sodapopcan"

hi link htmlTag              xmlTag
hi link htmlTagName          xmlTagName
hi link htmlEndTag           xmlEndTag

hi Normal                    ctermfg=248   ctermbg=236
hi Cursor                    ctermfg=0     ctermbg=15
hi CursorLine                ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi CursorCol                 ctermfg=NONE
hi TabLine                   ctermfg=242   ctermbg=237   cterm=NONE
hi TabLineFill               ctermfg=254   ctermbg=237   cterm=NONE
hi TabLineSel                ctermfg=244   ctermbg=bg    cterm=NONE

hi StatusLine                ctermfg=248    ctermbg=237   cterm=NONE
hi StatusLineNC              ctermfg=237   ctermbg=237   cterm=NONE
hi VertSplit                 ctermfg=235   ctermbg=bg    cterm=none

hi! Comment                   ctermfg=240
hi! Constant                  ctermfg=74
hi! link Identifier Constant
hi! Label                     ctermfg=74
hi! TypeDef                   ctermfg=74
hi! StorageClass              ctermfg=74
hi! Structure                 ctermfg=74
hi! Define                    ctermfg=173   cterm=NONE
hi! Statement                 ctermfg=137   cterm=NONE
hi! Error                     ctermfg=16    ctermbg=167
hi! link ErrorMsg Error
hi Function                  ctermfg=215   cterm=NONE
hi Keyword                   ctermfg=173   cterm=NONE
hi link Include              Statement
hi! link PreCondit            Statement

hi LineNr                    ctermfg=243   ctermbg=235
hi CursorLineNr              ctermfg=250   ctermbg=234 cterm=NONE
hi String                    ctermfg=107
hi link Number String
hi PreProc                   ctermfg=103
hi Search                    ctermfg=16    ctermbg=186
hi IncSearch                 ctermfg=16    ctermbg=186
hi Title                     ctermfg=15
hi Type                      ctermfg=167   cterm=NONE
hi visual                    ctermfg=16    ctermbg=11

hi! DiffAdd                   ctermfg=108   ctermbg=NONE cterm=bold
hi! DiffDelete                ctermfg=95    ctermbg=NONE cterm=bold
hi! DiffChange                ctermfg=190   ctermbg=NONE cterm=BOLD
hi! DiffText                  ctermfg=114   ctermbg=NONE cterm=BOLD

" Gitv
hi! diffAdded                 ctermfg=108    ctermbg=bg
hi! diffRemoved               ctermfg=95     ctermbg=bg
hi! diffLine                  ctermfg=190    ctermbg=bg
hi! diffSubname               ctermfg=114    ctermbg=bg

hi Special                   ctermfg=167   ctermbg=bg  cterm=NONE

hi pythonBuiltin             ctermfg=73 cterm=NONE
hi rubyBlockParameter        ctermfg=132
hi link rubyConstant           Type
hi link rubyPredefinedConstant Type
hi rubyInstanceVariable      ctermfg=110
hi rubyInterpolation         ctermfg=107
hi rubyLocalVariableOrMethod ctermfg=189
hi rubyPseudoVariable        ctermfg=221
hi link rubyStringDelimiter  String

hi NonText                   ctermfg=8
hi SpecialKey                ctermfg=8

hi xmlTag                    ctermfg=179
hi xmlTagName                ctermfg=179
hi xmlEndTag                 ctermfg=179

hi mailSubject               ctermfg=107
hi mailHeaderKey             ctermfg=221
hi mailEmail                 ctermfg=107 cterm=underline

hi SpellBad                  ctermfg=160 ctermbg=NONE cterm=underline
hi SpellRare                 ctermfg=168 ctermbg=NONE cterm=underline
hi SpellCap                  ctermfg=189 ctermbg=NONE cterm=underline
hi MatchParen                ctermfg=15 ctermbg=23

hi Ignore                    ctermfg=Black
hi WildMenu                  cterm=bold
hi Directory                 none
hi link Directory            String

hi Folded                    ctermbg=236 ctermfg=244  cterm=NONE
hi FoldColumn                none
hi link FoldColumn           Normal

hi Pmenu                     ctermbg=238 ctermfg=White cterm=NONE
hi PmenuSel                  ctermbg=150 ctermfg=Black
hi PMenuSbar                 cterm=NONE
hi PMenuThumb                cterm=NONE

hi SignColumn ctermbg=bg

hi link NERDTreeClosable String
hi link NERDTreeOpenable String
