" This is based on Nick Moffitt's version of Josh O'Rourke's version of
" railscasts.vim.  I've tweaked it and removed all the GUI noise.

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "sodapopcan"

hi Normal                            ctermbg=254    ctermfg=240    cterm=none
hi String                            ctermbg=none   ctermfg=233 cterm=none
hi link Delimiter String
hi! link Todo Normal

hi Cursor                            ctermbg=15     ctermfg=0      cterm=none
hi CursorLine                        ctermbg=255    ctermfg=none   cterm=none
hi CursorColumn                      ctermbg=254    ctermfg=none   cterm=none
hi ColorColumn                       ctermbg=234    ctermfg=none   cterm=none

" hi PopUpWin                          ctermbg=234    ctermfg=248    cterm=none
hi link PopUpWin CursorLine
hi PopUpScrollBar                    ctermbg=233    ctermfg=bg    cterm=none
hi PopUpThumb                        ctermbg=242    ctermfg=242    cterm=none

hi TabLine                           ctermbg=bg    ctermfg=242   cterm=none
hi TabLineFill                       ctermbg=250    ctermfg=254   cterm=none
hi TabLineSel                        ctermbg=137    ctermfg=0     cterm=bold

hi StatusLine                        ctermbg=252    ctermfg=fg   cterm=none
hi StatusLineNC                      ctermbg=bg    ctermfg=fg   cterm=none
hi StatusLineTerm                    ctermbg=bg    ctermfg=fg   cterm=none
hi StatusLineTermNC                  ctermbg=bg    ctermfg=fg   cterm=none

hi VertSplit                         ctermbg=bg     ctermfg=235    cterm=none

hi VimVar                            ctermfg=208

hi! link Conceal Normal
hi Comment                           ctermfg=242
hi! link Constant                     Normal
hi! link Identifier Constant
hi! link Label Constant
hi! link TypeDef Constant
hi! link StorageClass Constant
hi link Define String
" hi Define                            cterm=none   ctermfg=173
hi Statement                         cterm=none   ctermfg=fg
hi Error                             ctermbg=167   ctermfg=16
hi ErrorMsg                          ctermbg=none   ctermfg=167
hi WarningMsg                        ctermbg=none ctermfg=220 cterm=bold
hi Function                          cterm=none   ctermfg=fg
hi link Keyword                      Normal
hi link Include                      Statement
hi link PreProc                      Statement
hi link PreCondit                    Statement

hi LineNr                            ctermbg=bg   ctermfg=242 cterm=none
hi CursorLineNr                      ctermbg=252  ctermfg=0 cterm=bold
hi link Number String
hi PreProc                           ctermfg=103
hi Search                            ctermbg=none  ctermfg=9 cterm=none
" hi link Search Normal
hi IncSearch                         ctermbg=186    ctermfg=16
hi Title                             ctermfg=250
hi Type                              cterm=bold   ctermfg=fg
hi Visual                            ctermbg=3     ctermfg=16

hi link DiffAdd String
hi link DiffDelete Type
hi DiffRemoved ctermfg=240
hi DiffChange                        ctermbg=143    ctermfg=16  cterm=none
hi DiffText                          ctermbg=bg   ctermfg=114 cterm=bold
hi HelpExample                       ctermbg=none ctermfg=137

" Diff
" hi diffFile                          ctermbg=bg    ctermfg=214
hi! link diffFile diffIndexLine
hi! link diffSubname diffIndexLine
hi diffAdded                         ctermbg=bg    ctermfg=108
" hi diffRemoved                       ctermbg=bg     ctermfg=196
hi diffLine                          ctermbg=bg    ctermfg=242
" hi diffSubname                       ctermbg=bg    ctermfg=114
hi gitDiff                           ctermbg=bg    ctermfg=247

hi Special                           ctermbg=bg   ctermfg=167  cterm=none

hi qfLineNr ctermfg=214
" hi qfSeparator ctermfg=238
hi! link qfError Error
hi! link qfFileName String

autocmd Syntax ruby syn match rubyDefine "&"
autocmd Syntax ruby syn match rubyDefine "|"

" Ruby
hi link rubyBlockParameter           Normal
hi link rubyBlockParameterList       Normal
hi link rubyCapitalizedMethod        Function
hi link rubyConstant                 Type
hi link rubyPredefinedConstant       Type
hi rubyInstanceVariable              ctermfg=110
hi rubyInterpolation                 ctermfg=fg
hi rubyInterpolationDelimiter        ctermfg=28
hi rubyLocalVariableOrMethod         ctermfg=189
" hi rubyBlockParameterList            ctermfg=167
hi rubyPseudoVariable                ctermfg=74
hi link rubyStringDelimiter          String
hi rubyAccess                        ctermbg=none  ctermfg=167  cterm=none
hi link rubyClass Type
hi link rubyModule Type
hi link rubyRailsMethod rubyDefine
hi link rubyCallback rubyDefine
hi link rubyMacro rubyDefine
hi link rubyMagicComment rubySymbol
" hi shTodo ctermbg=bg ctermfg=11
" hi rubyTodo ctermbg=bg ctermfg=11
" hi VimTodo ctermbg=bg ctermfg=11
hi helpNote ctermbg=bg ctermfg=11

" hi! clear rubyIdentifier
" hi! clear rubyInstanceVariable
hi erubyBlock                           ctermfg=248 cterm=none
hi link erubyExpression erubyBlock
hi link erubyOneLiner erubyBlock
hi erubyDelimiter ctermfg=131

hi! VimWikiItalic ctermfg=fg ctermbg=none cterm=italic

" Python
hi pythonBuiltin                     cterm=none ctermfg=73

" CSS
" hi! cssBackgroundProp                cterm=none ctermfg=111
" hi! cssDimenionProp                  cterm=none ctermfg=111
" hi! cssPositioningProp               cterm=none ctermfg=111
" hi! cssListProp                      cterm=none ctermfg=111
hi! link sassClass cssTagName
hi! link sassChar sassClass
hi! link sassMixing cssSelectorOp
hi! link sassMixinName sassProperty

hi NonText                              ctermfg=8
hi SpecialKey                           ctermfg=8

" hi xmlTag                               ctermfg=214 "143
" hi xmlTag                               ctermfg=137
" hi xmlTag                               ctermfg=209 "247
hi xmlTag ctermfg=103
hi link xmlTagName xmlTag
hi link xmlEndTag xmlTag

hi link htmlTag                         xmlTag
hi link htmlTagName                     xmlTagName
hi link htmlTagN                        xmlTagName
hi link htmlEndTag                      xmlEndTag
hi htmlItalic                           ctermfg=fg ctermbg=none cterm=italic
hi htmlArg                              ctermfg=242 "243 "137 "143
" hi link htmlArg Keyword
" hi htmlString ctermfg=144
hi htmlString ctermfg=102
hi link heexComponentName xmlTag
hi heexDelimiter ctermfg=243
hi htmlEquals ctermfg=240
hi link heexSpecialAttribute Keyword

" hi link heexDelimiter Normal
hi htmlH1 ctermfg=245
hi htmlH2 ctermfg=245
hi htmlH3 ctermfg=245
hi htmlH4 ctermfg=245
hi htmlH5 ctermfg=245
hi htmlH6 ctermfg=245

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

hi Folded                               ctermfg=144 ctermbg=NONE    cterm=NONE
hi link FoldColumn Normal

hi Pmenu                                ctermfg=248 ctermbg=238 cterm=NONE
hi PmenuSel                             ctermfg=232 ctermbg=137
hi PMenuSbar                            ctermfg=137 ctermbg=137
hi PMenuThumb                           cterm=NONE

hi SignColumn ctermbg=bg

hi link NERDTreeClosable String
hi link NERDTreeOpenable String

" Vim
autocmd Syntax vim syn match vimUserCommand '^[A-Z][A-Za-z0-9]\+'
hi! link vimUserCommand function
hi link VimIsCommand function
hi link VimFuncKey function
hi! link vimVar Normal
hi vimLet                               ctermbg=none  ctermfg=180 cterm=none
hi! link vimFuncBody vimLet
hi! link vimNotFunc vimLet
hi! link vimCommand vimLet
hi link vim9OperAssign Normal
hi link vim9Declare vim9DefKey
hi link vim9Export Type
hi link vim9AutocmdPat Normal
hi link vim9FuncHeader Normal
hi link vim9FuncArgs Normal
hi link vim9RepeatForDeclareName Normal
hi link vim9AugroupNameEnd vimLet
hi link vim9DataType Comment
hi link vim9FuncCallUser vimNotFunc
hi link vim9Oper Normal
hi link vim9ParenSep vim9DefKey
hi link vim9Sep Normal
hi vim9Norm ctermfg=130
hi link vim9NormCmds Type

" CSS
hi link scssSelectorName Function
" hi cssCommonAttr ctermbg=none ctermfg=229 cterm=none
" hi scssAttribute ctermbg=none ctermfg=229 cterm=none
hi scssVariable     ctermbg=none ctermfg=208 cterm=none

" Javascript
" hi jsParens                             ctermbg=none ctermfg=067 cterm=none
" hi jsParen                              ctermbg=none ctermfg=111 cterm=none

hi jsFunction                           ctermbg=none ctermfg=097 cterm=none
" hi jsFuncCall                           ctermbg=none ctermfg=062 cterm=none
hi link jsFuncCall Normal
hi jsBlock                              ctermbg=none ctermfg=167 cterm=none
" hi jsFuncBlock                          ctermbg=none ctermfg=104 cterm=none
" hi jsFuncBraces                         ctermbg=none ctermfg=062 cterm=none
hi link jsFuncBraces Normal
hi link jsArrowFunction Normal
" 62 deepish lightish blue
hi jsStorageClass                       ctermbg=none ctermfg=067 cterm=none
hi link jsConditional jsStorageClass
hi jsReturn ctermbg=none ctermfg=96
hi link jsOf jsStorageClass
hi link jsFuncName jsStorageClass
hi link jsFuncBlock jsExportDefault
hi link jsModuleAs jsReturn
hi link jsSpreadOperator jsStorageClass
hi link jsImport jsReturn
hi link jsExport jsReturn
hi link jsFrom jsReturn
hi link jsExtendsKeyword jsReturn
hi link jsClassKeyword jsReturn
hi jsClassKeyword ctermfg=061
hi jsClassDefinition ctermfg=068
hi link jsThis jsObjectKey
hi link jsObjectFuncName jsStorageClass
hi link jsRepeat jsStorageClass
hi jsGlobalObjects ctermbg=none ctermfg=060 cterm=none
hi link jsGlobalNodeObjects jsGlobalObjects
hi link jsOperator Normal
hi! link jsObjectKey jsExportDefault
hi link jsTemplateBraces String



hi link graphqlVariable String
hi link graphqlName Function
hi link graphqlFold graphqlName
hi graphqlTemplateString ctermfg=137
hi graphqlTaggedTemplate ctermfg=137
hi graphqlBraces ctermfg=137
hi link graphqlStructure graphqlKeyword


hi link coffeeInterpDelim rubyInterpolationDelimiter

" ALE
hi! ALEError ctermfg=160 cterm=undercurl ctermul=160
hi! ALEWarning cterm=undercurl ctermul=11


" hi ALEWarning ctermfg=137
" JSON
hi JsonKeyword                          ctermbg=none  ctermfg=214
hi JsonNoise                            ctermbg=none  ctermfg=243
hi link JsonKeywordMatch JsonNoise
hi link JsonQuote JsonNoise
hi link JsonBraces JsonNoise
hi link JsonBraces JsonNoise

" Plug
hi link PlugDeleted String

" Illuminate
hi illuminatedWord cterm=underline gui=underline
