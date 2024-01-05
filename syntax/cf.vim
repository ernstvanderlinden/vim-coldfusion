" Vim syntax file
"
" Language:     CF (ColdFusion)
" Author:       Ernst M. van der Linden <ernst.vanderlinden@ernestoz.com>
" License:      The MIT License (MIT)
"
" Maintainer:   Ernst M. van der Linden <ernst.vanderlinden@ernestoz.com>
" URL:          https://github.com/ernstvanderlinden/vim-coldfusion
" Last Change:  2017 Nov 28
"
" Filenames:    *.cfc *.cfm

" Quit when a syntax file was already loaded.
	if exists("b:current_syntax")
	  finish
	endif

" Using line continuation here.
let s:cpo_save=&cpo
set cpo-=C

sy sync fromstart
" 20171126: disabled as we have fast computers now.
"sy sync maxlines=2000
sy case ignore

" INCLUDES {{{
sy include @sqlSyntax $VIMRUNTIME/syntax/sql.vim
" 20161010: Disabled include html highlighting as it contains huge keywords
" regex, so it will have impact on performance.  Use own simple SGML tag
" coloring instead.
"runtime! syntax/html.vim
" / INCLUDES }}}

" NUMBER {{{
sy match cfNumber
    \ "\v<\d+>"
" / NUMBER }}}

" EQUAL SIGN {{{
sy match cfEqualSign
    \ "\v\="
" / EQUAL SIGN }}}

" BOOLEAN {{{
sy match cfBoolean
    \ "\v<(true|false)>"
" / BOOLEAN }}}

" HASH SURROUNDED {{{
sy region cfHashSurround
  \ keepend
  \ oneline
  \ start="#"
  \ end="#"
  \ skip="##"
    \ contains=
      \@cfOperator,
      \@cfPunctuation,
      \cfBoolean,
      \cfCoreKeyword,
      \cfCoreScope,
      \cfCustomKeyword,
      \cfCustomScope,
      \cfEqualSign,
      \cfFunctionName,
      \cfNumber
" / HASH SURROUNDED }}}

" OPERATOR {{{

" OPERATOR - ARITHMETIC {{{
" +7 -7
" ++i --i
" i++ i--
" + - * / %
" += -= *= /= %=
" ^ mod
sy match cfArithmeticOperator
  \ /\v
  \(\+|-)\ze\d
  \|(\+\+|--)\ze\w
  \|\w\zs(\+\+|--)
  \|(\s(
  \(\+|-|\*|\/|\%){1}\={,1}
  \|\^
  \|mod
  \)\s)
  \/
" / OPERATOR - ARITHMETIC }}}

" OPERATOR - BOOLEAN {{{
" not and or xor eqv imp
" ! && ||
sy match cfBooleanOperator
  \ /\v\s
  \(not|and|or|xor|eqv|imp
  \|\!|\&\&|\|\|
  \)(\s|\))
  \|\s\!\ze\w
  \/
" / OPERATOR - BOOLEAN }}}

" OPERATOR - DECISION {{{
"is|equal|eq
"is not|not equal|neq
"contains|does not contain
"greater than|gt
"less than|lt
"greater than or equal to|gte|ge
"less than or equal to|lte|le
"==|!=|>|<|>=|<=
sy match cfDecisionOperator
  \ /\v\s
  \(is|equal|eq
  \|is not|not equal|neq
  \|contains|does not contain
  \|greater than|gt
  \|less than|lt
  \|greater than or equal to|gte|ge
  \|less than or equal to|lte|le
  \|(!|\<|\>|\=){1}\=
  \|\<
  \|\>
  \)\s/
" / OPERATOR - DECISION }}}

" OPERATOR - STRING {{{
" &
" &=
sy match cfStringOperator
    \ "\v\s\&\={,1}\s"
" / OPERATOR - STRING }}}

" OPERATOR - TERNARY {{{
" ? :
sy match cfTernaryOperator
  \ /\v\s
  \\?|\:
  \\s/
" / OPERATOR - TERNARY }}}

sy cluster cfOperator
  \ contains=
    \cfArithmeticOperator,
    \cfBooleanOperator,
    \cfDecisionOperator,
    \cfStringOperator,
    \cfTernaryOperator
" / OPERATOR }}}

" PARENTHESIS {{{
sy cluster cfParenthesisRegionContains
  \ contains=
    \@cfAttribute,
    \@cfComment,
    \@cfFlowStatement,
    \@cfOperator,
    \@cfPunctuation,
    \cfBoolean,
    \cfBrace,
    \cfCoreKeyword,
    \cfCoreScope,
    \cfCustomKeyword,
    \cfCustomScope,
    \cfEqualSign,
    \cfFunctionName,
    \cfNumber,
    \cfStorageKeyword,
    \cfStorageType

sy region cfParenthesisRegion1
  \ extend
  \ matchgroup=cfParenthesis1
  \ transparent
  \ start=/(/
  \ end=/)/
  \ contains=
    \cfParenthesisRegion2,
    \@cfParenthesisRegionContains
sy region cfParenthesisRegion2
  \ matchgroup=cfParenthesis2
  \ transparent
  \ start=/(/
  \ end=/)/
  \ contains=
    \cfParenthesisRegion3,
    \@cfParenthesisRegionContains
sy region cfParenthesisRegion3
  \ matchgroup=cfParenthesis3
  \ transparent
  \ start=/(/
  \ end=/)/
  \ contains=
    \cfParenthesisRegion1,
    \@cfParenthesisRegionContains
sy cluster cfParenthesisRegion
  \ contains=
    \cfParenthesisRegion1,
    \cfParenthesisRegion2,
    \cfParenthesisRegion3
" / PARENTHESIS }}}

" BRACE {{{
sy match cfBrace
    \ "{\|}"

sy region cfBraceRegion
  \ extend
  \ fold
  \ keepend
  \ transparent
  \ start="{"
  \ end="}"
" / BRACE }}}

" PUNCTUATION {{{

" PUNCTUATION - BRACKET {{{
sy match cfBracket
  \ "\(\[\|\]\)"
  \ contained
" / PUNCTUATION - BRACKET }}}

" PUNCTUATION - CHAR {{{
sy match cfComma ","
sy match cfDot "\."
sy match cfSemiColon ";"

" / PUNCTUATION - CHAR }}}

" PUNCTUATION - QUOTE {{{
sy region cfSingleQuotedValue
  \ matchgroup=cfSingleQuote
  \ start=/'/
  \ skip=/''/
  \ end=/'/
  \ contains=
    \cfHashSurround

sy region cfDoubleQuotedValue
  \ matchgroup=cfDoubleQuote
  \ start=/"/
  \ skip=/""/
  \ end=/"/
  \ contains=
    \cfHashSurround

sy cluster cfQuotedValue
  \ contains=
    \cfDoubleQuotedValue,
    \cfSingleQuotedValue

sy cluster cfQuote
  \ contains=
    \cfDoubleQuote,
    \cfSingleQuote
" / PUNCTUATION - QUOTE }}}

sy cluster cfPunctuation
  \ contains=
    \@cfQuote,
    \@cfQuotedValue,
    \cfBracket,
    \cfComma,
    \cfDot,
    \cfSemiColon

" / PUNCTUATION }}}

" TAG START AND END {{{
" tag start
" <cf...>
" s^^   e
sy region cfTagStart
  \ keepend
  \ transparent
  \ start="\c<cf_*"
  \ end=">"
\ contains=
  \@cfAttribute,
  \@cfComment,
  \@cfOperator,
  \@cfParenthesisRegion,
  \@cfPunctuation,
  \@cfQuote,
  \@cfQuotedValue,
  \cfAttrEqualSign,
  \cfBoolean,
  \cfBrace,
  \cfCoreKeyword,
  \cfCoreScope,
  \cfCustomKeyword,
  \cfCustomScope,
  \cfEqualSign,
  \cfFunctionName,
  \cfNumber,
  \cfStorageKeyword,
  \cfStorageType,
  \cfTagBracket,
  \cfTagName

" tag end
" </cf...>
" s^^^   e
sy match cfTagEnd
  \ transparent
  \ "\c</cf_*[^>]*>"
  \ contains=
    \cfTagBracket,
    \cfTagName

" tag bracket
" </...>
" ^^   ^
sy match cfTagBracket
  \ contained
  \ "\(<\|>\|\/\)"

" tag name
" <cf...>
"  s^^^e
sy match cfTagName
  \ contained
  \ "\v<\/*\zs\ccf\w*"
" / TAG START AND END }}}

" ATTRIBUTE NAME AND VALUE {{{
sy match cfAttrName
  \ contained
  \ "\v(var\s)@<!\w+\ze\s*\=([^\=])+"

sy match cfAttrValue
  \ contained
  \ "\v(\=\"*)\zs\s*\w*"

sy match cfAttrEqualSign
  \ contained
  \ "\v\="

sy cluster cfAttribute
\ contains=
  \@cfQuotedValue,
  \cfAttrEqualSign,
  \cfAttrName,
  \cfAttrValue,
  \cfCoreKeyword,
  \cfCoreScope
" / ATTRIBUTE NAME AND VALUE }}}

" TAG REGION AND FOLDING {{{

" CFCOMPONENT REGION AND FOLD {{{
" <cfcomponent
" s^^^^^^^^^^^
" </cfcomponent>
" ^^^^^^^^^^^^^e
sy region cfComponentTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfcomponent"
  \ end="\c</cfcomponent>"

" / CFCOMPONENT REGION AND FOLD }}}

" CFFUNCTION REGION AND FOLD {{{
" <cffunction
" s^^^^^^^^^^
" </cffunction>
" ^^^^^^^^^^^^e
sy region cfFunctionTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cffunction"
  \ end="\c</cffunction>"
" / CFFUNCTION REGION AND FOLD }}}

" CFIF REGION AND FOLD {{{
" <cfif
" s^^^^
" </cfif>
" ^^^^^^e
sy region cfIfTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfif"
  \ end="\c</cfif>"
" / CFIF REGION AND FOLD }}}

" CFLOOP REGION AND FOLD {{{
" <cfloop
" s^^^^^^
" </cfloop>
" ^^^^^^^^e
sy region cfLoopTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfloop"
  \ end="\c</cfloop>"
" / CFLOOP REGION AND FOLD }}}

" CFOUTPUT REGION AND FOLD {{{
" <cfoutput
" s^^^^^^^^
" </cfoutput>
" ^^^^^^^^^^e
sy region cfOutputTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfoutput"
  \ end="\c</cfoutput>"
" / CFOUTPUT REGION AND FOLD }}}

" CFQUERY REGION AND FOLD {{{
" <cfquery
" s^^^^^^^
" </cfquery>
" ^^^^^^^^^e
        "\@cfSqlStatement,
sy region cfQueryTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfquery"
  \ end="\c</cfquery>"
  \ contains=
    \@cfSqlStatement,
    \cfTagStart,
    \cfTagEnd,
    \cfTagComment
" / CFQUERY REGION AND FOLD }}}

" SAVECONTENT REGION AND FOLD {{{
" <savecontent
" s^^^^^^^^^^^
" </savecontent>
" ^^^^^^^^^^^^^e
sy region cfSavecontentTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfsavecontent"
  \ end="\c</cfsavecontent>"
" / SAVECONTENT REGION AND FOLD }}}

" CFSCRIPT REGION AND FOLD {{{
" <cfscript>
" s^^^^^^^^^
" </cfscript>
" ^^^^^^^^^^e
"\cfCustomScope,
sy region cfScriptTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfscript>"
  \ end="\c</cfscript>"
  \ contains=
    \@cfComment,
    \@cfFlowStatement,
    \cfHashSurround,
    \@cfOperator,
    \@cfParenthesisRegion,
    \@cfPunctuation,
    \cfBoolean,
    \cfBrace,
    \cfCoreKeyword,
    \cfCoreScope,
    \cfCustomKeyword,
    \cfCustomScope,
    \cfEqualSign,
    \cfFunctionDefinition,
    \cfFunctionName,
    \cfNumber,
    \cfOddFunction,
    \cfStorageKeyword,
    \cfTagEnd,
    \cfTagStart
" / CFSCRIPT REGION AND FOLD }}}

" CFSWITCH REGION AND FOLD {{{
" <cfswitch
" s^^^^^^^^
" </cfswitch>
" ^^^^^^^^^^e
sy region cfSwitchTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cfswitch"
  \ end="\c</cfswitch>"
" / CFSWITCH REGION AND FOLD }}}

" CFTRANSACTION REGION AND FOLD {{{
" <cftransaction
" s^^^^^^^^^^^^^
" </cftransaction>
" ^^^^^^^^^^^^^^^e
sy region cfTransactionTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cftransaction"
  \ end="\c</cftransaction>"
" / CFTRANSACTION REGION AND FOLD }}}

" CUSTOM TAG REGION AND FOLD {{{
" <cf_...>
" s^^^   ^
" </cf_...>
" ^^^^^   e
sy region cfCustomTagRegion
  \ fold
  \ keepend
  \ transparent
  \ start="\c<cf_[^>]*>"
  \ end="\c</cf_[^>]*>"
" / CUSTOM TAG REGION AND FOLD }}}

" / TAG REGION AND FOLDING }}}

" COMMENT {{{

" COMMENT BLOCK {{{
" /*...*/
" s^   ^e
sy region cfCommentBlock
  \ keepend
  \ start="/\*"
  \ end="\*/"
  \ contains=
    \cfMetaData
" / COMMENT BLOCK }}}

" COMMENT LINE {{{
" //...
" s^
sy match cfCommentLine
        \ "\/\/.*"
" / COMMENT LINE }}}

sy cluster cfComment
  \ contains=
    \cfCommentBlock,
    \cfCommentLine
" / COMMENT }}}

" TAG COMMENT {{{
" <!---...--->
" s^^^^   ^^^e
sy region cfTagComment
  \ keepend
    \ start="<!---"
    \ end="--->"
    \ contains=
      \cfTagComment
" / TAG COMMENT }}}

" FLOW STATEMENT {{{
" BRANCH FLOW KEYWORD {{{
sy keyword cfBranchFlowKeyword
  \ break
  \ continue
  \ return

" / BRANCH KEYWORD }}}

" DECISION FLOW KEYWORD {{{
sy keyword cfDecisionFlowKeyword
  \ case
  \ defaultcase
  \ else
  \ if
  \ switch

" / DECISION FLOW KEYWORD }}}

" LOOP FLOW KEYWORD {{{
sy keyword cfLoopFlowKeyword
  \ do
  \ for
  \ in
  \ while

" / LOOP FLOW KEYWORD }}}

" TRY FLOW KEYWORD {{{
sy keyword cfTryFlowKeyword
  \ catch
  \ finally
  \ rethrow
  \ throw
  \ try

" / TRY FLOW KEYWORD }}}

sy cluster cfFlowStatement
  \ contains=
    \cfBranchFlowKeyword,
    \cfDecisionFlowKeyword,
    \cfLoopFlowKeyword,
    \cfTryFlowKeyword

" / FLOW STATEMENT }}}

" STORAGE KEYWORD {{{
sy keyword cfStorageKeyword
    \ var
" / STORAGE KEYWORD }}}

" STORAGE TYPE {{{
sy match cfStorageType
  \ contained
  \ /\v<
    \(any
    \|array
    \|binary
    \|boolean
    \|date
    \|numeric
    \|query
    \|string
    \|struct
    \|uuid
    \|void
    \|xml
  \){1}\ze(\s*\=)@!/
" / STORAGE TYPE }}}

" CORE KEYWORD {{{
sy match cfCoreKeyword
  \ /\v<
    \(new
    \|required
    \)\ze\s/
" / CORE KEYWORD }}}

" CORE SCOPE {{{
sy match cfCoreScope
  \ /\v<
    \(application
    \|arguments
    \|attributes
    \|caller
    \|cfcatch
    \|cffile
    \|cfhttp
    \|cgi
    \|client
    \|cookie
    \|form
    \|local
    \|request
    \|server
    \|session
    \|super
    \|this
    \|thisTag
    \|thread
    \|variables
    \|url
    \){1}\ze(,|\.|\[|\)|\s)/
" / CORE SCOPE }}}

" SQL STATEMENT {{{
sy cluster cfSqlStatement
  \ contains=
    \@cfParenthesisRegion,
    \@cfQuote,
    \@cfQuotedValue,
    \@sqlSyntax,
    \cfBoolean,
    \cfDot,
    \cfEqualSign,
    \cfFunctionName,
    \cfHashSurround,
    \cfNumber
" / SQL STATEMENT }}}

" TAG IN SCRIPT {{{
sy match cfTagNameInScript
    \ "\vcf_*\w+\s*\ze\("
" / TAG IN SCRIPT }}}

" METADATA {{{
sy region cfMetaData
  \ contained
  \ keepend
  \ start="@\w\+"
  \ end="$"
  \ contains=
    \cfMetaDataName

sy match cfMetaDataName
    \ contained
    \ "@\w\+"
" / METADATA }}}

" COMPONENT DEFINITION {{{
sy region cfComponentDefinition
  \ start="component"
  \ end="{"me=e-1
  \ contains=
    \@cfAttribute,
    \cfComponentKeyword

sy match cfComponentKeyword
  \ contained
  \ "\v<component>"
" / COMPONENT DEFINITION }}}

" INTERFACE DEFINITION {{{
sy match cfInterfaceDefinition
  \ "interface\s.*{"me=e-1
  \ contains=
    \cfInterfaceKeyword

sy match cfInterfaceKeyword
    \ contained
    \ "\v<interface>"
" / INTERFACE DEFINITION }}}

" PROPERTY {{{
sy region cfProperty
  \ transparent
  \ start="\v<property>"
  \ end=";"me=e-1
  \ contains=
    \@cfQuotedValue,
    \cfAttrEqualSign,
    \cfAttrName,
    \cfAttrValue,
    \cfPropertyKeyword

sy match cfPropertyKeyword
        \ contained
        \ "\v<property>"
" / PROPERTY }}}

" FUNCTION DEFINITION {{{
sy match cfFunctionDefinition
  \ /\v
    \(<(public|private|package)\s){,1}
    \(<
      \(any
      \|array
      \|binary
      \|boolean
      \|date
      \|numeric
      \|query
      \|string
      \|struct
      \|uuid
      \|void
      \|xml
    \)\s){,1}
  \<function\s\w+\s*\(/me=e-1
  \ contains=
    \cfFunctionKeyword,
    \cfFunctionModifier,
    \cfFunctionName,
    \cfFunctionReturnType

" FUNCTION KEYWORD {{{
sy match cfFunctionKeyword
  \ contained
  \ "\v<function>"
" / FUNCTION KEYWORD }}}

" FUNCTION MODIFIER {{{
sy match cfFunctionModifier
  \ contained
    \ /\v<
    \(public
    \|private
    \|package
    \)>/
" / FUNCTION MODIFIER }}}

" FUNCTION RETURN TYPE {{{
sy match cfFunctionReturnType
  \ contained
    \ /\v
    \(any
    \|array
    \|binary
    \|boolean
    \|date
    \|numeric
    \|query
    \|string
    \|struct
    \|uuid
    \|void
    \|xml
    \)/
" / FUNCTION RETURN TYPE }}}

" FUNCTION NAME {{{
" specific regex for core functions decreases performance
" so use the same highlighting for both function types
sy match cfFunctionName
    \ "\v<(cf|if|elseif|throw)@!\w+\s*\ze\("
" / FUNCTION NAME }}}

" / FUNCTION DEFINITION }}}

" ODD FUNCTION {{{
sy region cfOddFunction
  \ transparent
  \ start="\v<
    \(abort
    \|exit
    \|import
    \|include
    \|lock
    \|pageencoding
    \|param
    \|savecontent
    \|thread
    \|transaction
    \){1}"
  \ end="\v(\{|;)"me=e-1
  \ contains=
    \@cfQuotedValue,
    \cfAttrEqualSign,
    \cfAttrName,
    \cfAttrValue,
    \cfCoreKeyword,
    \cfOddFunctionKeyword,
    \cfCoreScope

" ODD FUNCTION KEYWORD {{{
sy match cfOddFunctionKeyword
  \ contained
    \ /\v<
    \(abort
    \|exit
    \|import
    \|include
    \|lock
    \|pageencoding
    \|param
    \|savecontent
    \|thread
    \|transaction
    \)\ze(\s|$|;)/
" / ODD FUNCTION KEYWORD }}}

" / ODD FUNCTION }}}

" CUSTOM {{{

" CUSTOM KEYWORD {{{
sy match cfCustomKeyword
  \ contained
    \ /\v<
    \(customKeyword1
    \|customKeyword2
    \|customKeyword3
    \)>/
" / CUSTOM KEYWORD }}}

" CUSTOM SCOPE {{{
sy match cfCustomScope
  \ contained
    \ /\v<
    \(prc
    \|rc
    \|event
    \|(\w+Service)
    \){1}\ze(\.|\[)/
" / CUSTOM SCOPE }}}

" / CUSTOM }}}

" SGML TAG START AND END {{{
" SGML tag start
" <...>
" s^^^e
sy region cfSGMLTagStart
  \ keepend
  \ transparent
  \ start="\v(\<cf)@!\zs\<\w+"
  \ end=">"
  \ contains=
    \@cfAttribute,
    \@cfComment,
    \@cfOperator,
    \@cfParenthesisRegion,
    \@cfPunctuation,
    \@cfQuote,
    \@cfQuotedValue,
    \cfAttrEqualSign,
    \cfBoolean,
    \cfBrace,
    \cfCoreKeyword,
    \cfCoreScope,
    \cfCustomKeyword,
    \cfCustomScope,
    \cfEqualSign,
    \cfFunctionName,
    \cfNumber,
    \cfStorageKeyword,
    \cfStorageType,
    \cfTagBracket,
    \cfSGMLTagName

" SGML tag end
" </...>
" s^^^^e
sy match cfSGMLTagEnd
  \ transparent
  \ "\v(\<\/cf)@!\zs\<\/\w+\>"
  \ contains=
    \cfTagBracket,
    \cfSGMLTagName

" SGML tag name
" <...>
" s^^^e
sy match cfSGMLTagName
  \ contained
  \ "\v(\<\/*)\zs\w+"

" / SGML TAG START AND END }}}

" HIGHLIGHTING {{{

hi link cfNumber Number
hi link cfBoolean Boolean
hi link cfEqualSign Keyword
" HASH SURROUND
hi link cfHash PreProc
hi link cfHashSurround PreProc
" OPERATOR
hi link cfArithmeticOperator Function
hi link cfBooleanOperator Function
hi link cfDecisionOperator Function
hi link cfStringOperator Function
hi link cfTernaryOperator Function
" PARENTHESIS
hi link cfParenthesis1 Statement
hi link cfParenthesis2 String
hi link cfParenthesis3 Delimiter
" BRACE
hi link cfBrace PreProc
" PUNCTUATION - BRACKET
hi link cfBracket Statement
" PUNCTUATION - CHAR
hi link cfComma Comment
hi link cfDot Comment
hi link cfSemiColon Comment
" PUNCTUATION - QUOTE
hi link cfDoubleQuote String
hi link cfDoubleQuotedValue String
hi link cfSingleQuote String
hi link cfSingleQuotedValue String
" TAG START AND END
hi link cfTagName Function
hi link cfTagBracket Comment
" ATTRIBUTE NAME AND VALUE
hi link cfAttrName Type
hi link cfAttrValue Special
" COMMENT
hi link cfCommentBlock Comment
hi link cfCommentLine Comment
hi link cfTagComment Comment
" FLOW STATEMENT
hi link cfDecisionFlowKeyword Conditional
hi link cfLoopFlowKeyword Repeat
hi link cfTryFlowKeyword Exception
hi link cfBranchFlowKeyword Keyword
" STORAGE KEYWORD
hi link cfStorageKeyword Keyword
" STORAGE TYPE
hi link cfStorageType Keyword
" CORE KEYWORD
hi link cfCoreKeyword PreProc
" CORE SCOPE
hi link cfCoreScope Keyword
" TAG IN SCRIPT
hi link cfTagNameInScript Function
" METADATA
" meta data value = cfMetaData
hi link cfMetaData String
hi link cfMetaDataName Type
" COMPONENT DEFINITION
hi link cfComponentKeyword Keyword
" INTERFACE DEFINITION
hi link cfInterfaceKeyword Keyword
" PROPERTY
hi link cfPropertyKeyword Keyword
" FUNCTION DEFINITION
hi link cfFunctionKeyword Keyword
hi link cfFunctionModifier Keyword
hi link cfFunctionReturnType Keyword
hi link cfFunctionName Function
" ODD FUNCTION
hi link cfOddFunctionKeyword Function
" CUSTOM
hi link cfCustomKeyword Keyword
hi link cfCustomScope Structure
" SGML TAG
hi link cfSGMLTagName Ignore

" / HIGHLIGHTING }}}

let b:current_syntax = "cf"

let &cpo = s:cpo_save
unlet s:cpo_save
