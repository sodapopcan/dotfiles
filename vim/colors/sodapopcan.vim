" This is based on Nick Moffitt's version of Josh O'Rourke's version of
" railscasts.vim.  I've tweaked it and removed all the GUI noise.

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "sodapopcan"

hi Normal                    ctermfg=248   ctermbg=236
hi Cursor                    ctermfg=0     ctermbg=15
hi CursorLine                ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi CursorCol                 ctermfg=NONE
hi TabLine                   ctermfg=242   ctermbg=237   cterm=NONE
hi TabLineFill               ctermfg=254   ctermbg=237   cterm=NONE
hi TabLineSel                ctermfg=bg   ctermbg=244    cterm=bold

hi StatusLine                ctermfg=248   ctermbg=237   cterm=NONE
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
hi Function                   ctermfg=215   cterm=NONE
hi Keyword                    ctermfg=173   cterm=NONE
hi link Include               Statement
hi! link PreProc              Statement
hi! link PreCondit            Statement

hi LineNr                     ctermfg=243   ctermbg=bg
hi CursorLineNr               ctermfg=208   ctermbg=bg cterm=NONE
hi String                     ctermfg=107
hi link Number String
hi PreProc                    ctermfg=103
hi Search                     ctermfg=16    ctermbg=186
hi IncSearch                  ctermfg=16    ctermbg=186
hi Title                      ctermfg=250
hi Type                       ctermfg=167   cterm=NONE
hi Visual                     ctermfg=16    ctermbg=11

hi! DiffAdd                   ctermfg=108   ctermbg=bg cterm=bold
hi! DiffDelete                ctermfg=95    ctermbg=bg cterm=bold
hi! DiffChange                ctermfg=16    ctermbg=143  cterm=none
hi! DiffText                  ctermfg=114   ctermbg=bg cterm=BOLD

" Gitv
hi! diffAdded                 ctermfg=108    ctermbg=bg
hi! diffRemoved               ctermfg=95     ctermbg=bg
hi! diffLine                  ctermfg=190    ctermbg=bg
hi! diffSubname               ctermfg=114    ctermbg=bg

hi Special                    ctermfg=167   ctermbg=bg  cterm=NONE

hi pythonBuiltin              ctermfg=73 cterm=NONE
hi link rubyBlockParameter    Function
hi link rubyConstant           Type
hi link rubyPredefinedConstant Type
hi! rubyInstanceVariable      ctermfg=110
hi rubyInterpolation          ctermfg=107
hi rubyLocalVariableOrMethod  ctermfg=189
hi rubyPseudoVariable         ctermfg=74
hi link rubyStringDelimiter   String

" hi! clear rubyIdentifier
" hi! clear rubyInstanceVariable

hi! erubyBlock ctermfg=167 cterm=NONE
hi! link erubyExpression erubyBlock
hi! link erubyOneLiner erubyBlock
hi! erubyDelimiter ctermfg=131

hi NonText                   ctermfg=8
hi SpecialKey                ctermfg=8

hi xmlTag                    ctermfg=179
hi xmlTagName                ctermfg=179
hi xmlEndTag                 ctermfg=179

hi link htmlTag              xmlTag
hi link htmlTagName          xmlTagName
hi link htmlEndTag           xmlEndTag
hi htmlItalic                ctermfg=bg    ctermbg=137   cterm=italic

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

"{{{1
"Fold
"}}}
hi Folded                    ctermbg=235 ctermfg=241  cterm=NONE
hi! link FoldColumn          Normal

hi Pmenu                     ctermbg=238 ctermfg=White cterm=NONE
hi PmenuSel                  ctermbg=150 ctermfg=Black
hi PMenuSbar                 cterm=NONE
hi PMenuThumb                cterm=NONE

hi SignColumn ctermbg=bg

hi link NERDTreeClosable String
hi link NERDTreeOpenable String
