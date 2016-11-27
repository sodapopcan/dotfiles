" This is based on Nick Moffitt's version of Josh O'Rourke's version of
" railscasts.vim.  I've tweaked it and removed all the GUI noise.

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "sodapopcan"

hi Normal                            ctermbg=236    ctermfg=248    cterm=none

hi Cursor                            ctermbg=15     ctermfg=0      cterm=none
hi CursorLine                        ctermbg=235    ctermfg=none   cterm=none
hi CursorCol                         ctermbg=none   ctermfg=none   cterm=none

hi TabLine                           ctermbg=237    ctermfg=242   cterm=none
hi TabLineFill                       ctermbg=237    ctermfg=254   cterm=none
hi TabLineSel                        ctermbg=244    ctermfg=bg    cterm=bold

hi StatusLine                        ctermbg=237    ctermfg=248   cterm=none
hi StatusLineNC                      ctermbg=237    ctermfg=237   cterm=none
hi VertSplit                         ctermbg=bg     ctermfg=235    cterm=none

hi VimVar                            ctermfg=208

hi Comment                           ctermfg=240
hi Constant                          ctermfg=74
hi! link Identifier Constant
hi! link Label Constant
hi! link TypeDef Constant
hi! link StorageClass Constant
hi! link Define Constant
hi Define                            cterm=none   ctermfg=173
hi Statement                         cterm=none   ctermfg=137
hi Error                             ctermbg=167   ctermfg=16
hi ErrorMsg                          ctermbg=none   ctermfg=167
hi Function                          cterm=none   ctermfg=215
hi Keyword                           cterm=none   ctermfg=173
hi link Include                      Statement
hi link PreProc                      Statement
hi link PreCondit                    Statement

hi LineNr                            ctermbg=bg   ctermfg=235
hi CursorLineNr                      ctermbg=bg   ctermfg=234 cterm=NONE
hi String                            ctermfg=107
hi link Number String
hi PreProc                           ctermfg=103
hi Search                            ctermbg=186    ctermfg=16
" hi link Search Normal
hi IncSearch                         ctermbg=186    ctermfg=16
hi Title                             ctermfg=250
hi Type                              cterm=none   ctermfg=167
hi Visual                            ctermbg=11    ctermfg=16

hi DiffAdd                           ctermbg=bg   ctermfg=108 cterm=bold
hi DiffDelete                        ctermbg=bg    ctermfg=95 cterm=bold
hi DiffChange                        ctermbg=143    ctermfg=16  cterm=none
hi DiffText                          ctermbg=bg   ctermfg=114 cterm=bold

" Gitv
hi diffAdded                         ctermbg=bg    ctermfg=108
hi diffRemoved                       ctermbg=bg     ctermfg=95
hi diffLine                          ctermbg=bg    ctermfg=190
hi diffSubname                       ctermbg=bg    ctermfg=114

hi Special                           ctermbg=bg   ctermfg=167  cterm=none

hi pythonBuiltin                     cterm=none ctermfg=73
hi link rubyBlockParameter           Function
hi link rubyConstant                 Type
hi link rubyPredefinedConstant       Type
hi rubyInstanceVariable              ctermfg=110
hi rubyInterpolation                 ctermfg=107
hi rubyLocalVariableOrMethod         ctermfg=189
hi rubyPseudoVariable                ctermfg=74
hi link rubyStringDelimiter          String
hi rubyAccess                        ctermbg=none  ctermfg=167  cterm=none
hi link rubyRailsMethod rubyDefine

" hi! clear rubyIdentifier
" hi! clear rubyInstanceVaria           ble

hi erubyBlock                           ctermfg=167 cterm=none

hi link erubyExpression erubyBlock
hi link erubyOneLiner erubyBlock

hi erubyDelimiter ctermfg=131

hi NonText                              ctermfg=8
hi SpecialKey                           ctermfg=8

hi xmlTag                               ctermfg=179
hi xmlTagName                           ctermfg=179
hi xmlEndTag                            ctermfg=179

hi link htmlTag                         xmlTag
hi link htmlTagName                     xmlTagName
hi link htmlEndTag                      xmlEndTag
hi htmlItalic                           ctermfg=bg    ctermbg=137   cterm=italic

hi mailSubject                          ctermfg=107
hi mailHeaderKey                        ctermfg=221
hi mailEmail                            ctermfg=107 cterm=underline

hi SpellBad                             ctermbg=NONE ctermfg=160 cterm=underline
hi SpellRare                            ctermbg=NONE ctermfg=168 cterm=underline
hi SpellCap                             ctermbg=NONE ctermfg=189 cterm=underline
hi MatchParen                           ctermbg=23 ctermfg=15

hi Ignore                               ctermfg=Black
hi WildMenu                             ctermbg=179  ctermfg=016 cterm=none
hi! link Directory String

hi Folded                               ctermfg=0 ctermbg=144    cterm=NONE
hi link FoldColumn Normal

hi Pmenu                                ctermfg=White ctermbg=238 cterm=NONE
hi PmenuSel                             ctermfg=Black ctermbg=150
hi PMenuSbar                            cterm=NONE
hi PMenuThumb                           cterm=NONE

hi SignColumn ctermbg=bg

hi link NERDTreeClosable String
hi link NERDTreeOpenable String

" Vim
hi link VimIsCommand function
hi link VimFuncKey function
hi! link vimVar Normal
hi vimLet                               ctermbg=none  ctermfg=180 cterm=none
hi! link vimFuncBody vimLet
hi! link vimNotFunc vimLet
hi! link vimCommand vimLet

" CSS
hi link scssSelectorName Function
" hi cssCommonAttr ctermbg=none ctermfg=229 cterm=none
" hi scssAttribute ctermbg=none ctermfg=229 cterm=none
hi scssVariable     ctermbg=none ctermfg=208 cterm=none

" Javascript
hi jsParens                             ctermbg=none ctermfg=067 cterm=none
hi jsParen                              ctermbg=none ctermfg=111 cterm=none

hi jsFunction                           ctermbg=none ctermfg=098 cterm=none
hi jsFuncName                           ctermbg=none ctermfg=104 cterm=none
hi jsFuncCall                           ctermbg=none ctermfg=062 cterm=none
hi jsBlock                              ctermbg=none ctermfg=167 cterm=none
hi jsFuncBlock                          ctermbg=none ctermfg=167 cterm=none
hi jsFuncBraces                         ctermbg=none ctermfg=062 cterm=none
" 62 deepish lightish blue
hi jsStorageClass                       ctermbg=none ctermfg=067 cterm=none
hi link jsOperator jsStorageClass

