"COPYRIGHT AND LICENSE {{{
"===============================================================================

"ColdFusion
"----------
"ColdFusion is either a registered trademark or trademark of Adobe Systems
"Incorporated (http://www.adobe.com).

"Vim
"---
"Vim is charityware. Its license is GPL-compatible, so it's distributed freely,
"but we ask that if you find it useful you make a donation to help children in
"Uganda through the ICCF (http://iccf-holland.org). The full license text can
"be found in the
"documentation (http://vimdoc.sourceforge.net/htmldoc/uganda.html#license).

"Syntax Highlighter
"------------------
"The MIT License (MIT)
"Copyright (c) 2016 Ernst M. van der Linden - ernst.vanderlinden@ernestoz.com
"
"Permission is hereby granted, free of charge, to any person obtaining a copy of
"this software and associated documentation files (the "Software"), to deal in
"the Software without restriction, including without limitation the rights to
"use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
"of the Software, and to permit persons to whom the Software is furnished to do
"so, subject to the following conditions:
"
"The above copyright notice and this permission notice shall be included in all
"copies or substantial portions of the Software.
"
"THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
"SOFTWARE.

"===============================================================================
" / COPYRIGHT AND LICENSE }}}
"
" Quit if a syntax file is already loaded.
if exists("b:current_syntax")
  finish
endif

sy sync fromstart
sy sync maxlines=1000
sy case ignore

" INCLUDES {{{
syn include @sqlSyntax $VIMRUNTIME/syntax/sql.vim
" do not load html, it contains huge keywords regex, so it will have impact on performance
" let's use simple SGML tag coloring instead
"runtime! syntax/html.vim
" INCLUDES }}}

" NUMBER {{{
sy match eozNumber
    \ "\v<\d+>"
" / NUMBER }}}

" EQUAL SIGN {{{
sy match eozEqualSign
    \ "\v\="
" / EQUAL SIGN }}}

" BOOLEAN {{{
sy match eozBoolean
    \ "\v<(true|false)>"
" / BOOLEAN }}}

" HASH SURROUNDED {{{
sy region eozHashSurround
  \ keepend
  \ oneline
  \ start="#"
  \ end="#"
  \ skip="##"
    \ contains=
        \@eozOperator,
        \@eozPunctuation,
        \eozBoolean,
        \eozCoreKeyword,
        \eozCoreScope,
        \eozCustomKeyword,
        \eozCustomScope,
        \eozEqualSign,
        \eozFunctionName,
        \eozNumber
" / HASH SURROUNDED }}}

" OPERATOR {{{

" OPERATOR - ARITHMETIC {{{
" +7 -7
" ++i --i
" i++ i--
" + - * / %
" += -= *= /= %=
" ^ mod
sy match eozArithmeticOperator
    \ "\v
    \(\+|-)\ze\d
    \|(\+\+|--)\ze\w
    \|\w\zs(\+\+|--)
    \|(\s(
    \(\+|-|\*|\/|\%){1}\={,1}
    \|\^
    \|mod
    \)\s)
    \"
" / OPERATOR - ARITHMETIC }}}

" OPERATOR - BOOLEAN {{{
" not and or xor eqv imp
" ! && ||
sy match eozBooleanOperator
    \ "\v\s
    \(not|and|or|xor|eqv|imp
    \|\!|\&\&|\|\|
    \)(\s|\))
    \|\s\!\ze\w
    \"
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
sy match eozDecisionOperator
    \ "\v\s
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
    \)\s"
" / OPERATOR - DECISION }}}

" OPERATOR - STRING {{{
" &
" &=
sy match eozStringOperator
    \ "\v\s\&\={,1}\s"
" / OPERATOR - STRING }}}

" OPERATOR - TERNARY {{{
" ? :
sy match eozTernaryOperator
    \ "\v\s
    \\?|\:
    \\s"
" / OPERATOR - TERNARY }}}

sy cluster eozOperator
    \ contains=
        \eozArithmeticOperator,
        \eozBooleanOperator,
        \eozDecisionOperator,
        \eozStringOperator,
        \eozTernaryOperator
" OPERATOR }}}

" PARENTHESIS {{{
sy cluster eozParenthesisRegionContains
    \ contains=
        \@eozAttribute,
        \@eozComment,
        \@eozFlowStatement,
        \@eozOperator,
        \@eozPunctuation,
        \eozBoolean,
        \eozBrace,
        \eozCoreKeyword,
        \eozCoreScope,
        \eozCustomKeyword,
        \eozCustomScope,
        \eozEqualSign,
        \eozFunctionName,
        \eozNumber,
        \eozStorageKeyword,
        \eozStorageType

sy region eozParenthesisRegion1
    \ extend
    \ matchgroup=eozParenthesis1
    \ transparent
    \ start=/(/
    \ end=/)/
    \ contains=
        \eozParenthesisRegion2,
        \@eozParenthesisRegionContains
sy region eozParenthesisRegion2
    \ matchgroup=eozParenthesis2
    \ transparent
    \ start=/(/
    \ end=/)/
    \ contains=
        \eozParenthesisRegion3,
        \@eozParenthesisRegionContains
sy region eozParenthesisRegion3
    \ matchgroup=eozParenthesis3
    \ transparent
    \ start=/(/
    \ end=/)/
    \ contains=
        \eozParenthesisRegion1,
        \@eozParenthesisRegionContains
sy cluster eozParenthesisRegion
    \ contains=
        \eozParenthesisRegion1,
        \eozParenthesisRegion2,
        \eozParenthesisRegion3
" PARENTHESIS }}}

" BRACE {{{
sy match eozBrace
    \ "{\|}"

sy region eozBraceRegion
    \ extend
    \ fold
    \ keepend
    \ transparent
    \ start="{"
    \ end="}"
" BRACE }}}

" PUNCTUATION {{{

" PUNCTUATION - BRACKET {{{
sy match eozBracket
    \ "\(\[\|\]\)"
    \ contained
" / PUNCTUATION - BRACKET }}}

" PUNCTUATION - CHAR {{{
sy match eozComma ","
sy match eozDot "\."
sy match eozSemiColon ";"

" / PUNCTUATION - CHAR }}}

" PUNCTUATION - QUOTE {{{
sy region eozSingleQuotedValue
    \ matchgroup=eozSingleQuote
    \ start=/'/
    \ skip=/''/
    \ end=/'/
    \ contains=
        \eozHashSurround

sy region eozDoubleQuotedValue
    \ matchgroup=eozDoubleQuote
    \ start=/"/
    \ skip=/""/
    \ end=/"/
    \ contains=
        \eozHashSurround

sy cluster eozQuotedValue
    \ contains=
        \eozDoubleQuotedValue,
        \eozSingleQuotedValue

sy cluster eozQuote
    \ contains=
        \eozDoubleQuote,
        \eozSingleQuote
" / PUNCTUATION - QUOTE }}}

sy cluster eozPunctuation
    \ contains=
        \@eozQuote,
        \@eozQuotedValue,
        \eozBracket,
        \eozComma,
        \eozDot,
        \eozSemiColon

" PUNCTUATION }}}

" TAG START AND END {{{
" tag start
" <cf...>
" s^^   e
sy region eozTagStart
    \ keepend
    \ transparent
    \ start="\c<cf_*"
    \ end=">"
    \ contains=
        \@eozAttribute,
        \@eozComment,
        \@eozOperator,
        \@eozParenthesisRegion,
        \@eozPunctuation,
        \@eozQuote,
        \@eozQuotedValue,
        \eozAttrEqualSign,
        \eozBoolean,
        \eozBrace,
        \eozCoreKeyword,
        \eozCoreScope,
        \eozCustomKeyword,
        \eozCustomScope,
        \eozEqualSign,
        \eozFunctionName,
        \eozNumber,
        \eozStorageKeyword,
        \eozStorageType,
        \eozTagBracket,
        \eozTagName

" tag end
" </cf...>
" s^^^   e
sy match eozTagEnd
    \ transparent
    \ "\c</cf_*[^>]*>"
    \ contains=
        \eozTagBracket,
        \eozTagName

" tag bracket
" </...>
" ^^   ^
sy match eozTagBracket
    \ contained
    \ "\(<\|>\|\/\)"

" tag name
" <cf...>
"  s^^^e
sy match eozTagName
    \ contained
    \ "\v<\/*\zs\ccf\w*"
" TAG START AND END }}}

" ATTRIBUTE NAME AND VALUE {{{
sy match eozAttrName
    \ contained
  \ "\v(var\s)@<!\w+\ze\s*\=([^\=])+"

sy match eozAttrValue
    \ contained
    \ "\v(\=\"*)\zs\s*\w*"

sy match eozAttrEqualSign
    \ contained
    \ "\v\="

sy cluster eozAttribute
    \ contains=
        \@eozQuotedValue,
        \eozAttrEqualSign,
        \eozAttrName,
        \eozAttrValue,
        \eozCoreKeyword,
        \eozCoreScope
" ATTRIBUTE NAME AND VALUE }}}

" TAG REGION AND FOLDING {{{

" CFCOMPONENT REGION AND FOLD {{{
" <cfcomponent
" s^^^^^^^^^^^
" </cfcomponent>
" ^^^^^^^^^^^^^e
sy region eozComponentTagRegion
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
sy region eozFunctionTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cffunction"
    \ end="\c</cffunction>"
" / CFFUNCTION REGION AND FOLD }}}

" CFIF REGION AND FOLD {{{
" <cfif
" s^^^^^^^
" </cfif>
" ^^^^^^^^^e
sy region eozIfTagRegion
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
sy region eozLoopTagRegion
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
sy region eozOutputTagRegion
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
        "\@eozSqlStatement,
sy region eozQueryTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfquery"
    \ end="\c</cfquery>"
    \ contains=
        \@eozSqlStatement,
        \eozTagStart,
        \eozTagEnd,
        \eozTagComment
" / CFQUERY REGION AND FOLD }}}

" SAVECONTENT REGION AND FOLD {{{
" <savecontent
" s^^^^^^^^^^
" </savecontent>
" ^^^^^^^^^^^^^e
sy region eozSavecontentTagRegion
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
"\eozCustomScope,
sy region eozScriptTagRegion
    \ fold
    \ keepend
    \ transparent
    \ start="\c<cfscript>"
    \ end="\c</cfscript>"
    \ contains=
        \@eozComment,
        \@eozFlowStatement,
        \eozHashSurround,
        \@eozOperator,
        \@eozParenthesisRegion,
        \@eozPunctuation,
        \eozBoolean,
        \eozBrace,
        \eozCoreKeyword,
        \eozCoreScope,
        \eozCustomKeyword,
        \eozCustomScope,
        \eozEqualSign,
        \eozFunctionDefinition,
        \eozFunctionName,
        \eozNumber,
        \eozOddFunction,
        \eozStorageKeyword,
        \eozTagEnd,
        \eozTagStart
" / CFSCRIPT REGION AND FOLD }}}

" CFSWITCH REGION AND FOLD {{{
" <cfswitch
" s^^^^^^^^
" </cfswitch>
" ^^^^^^^^^^e
sy region eozSwitchTagRegion
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
sy region eozTransactionTagRegion
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
sy region eozCustomTagRegion
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
sy region eozCommentBlock
        \ keepend
        \ start="/\*"
        \ end="\*/"
        \ contains=
            \eozMetaData
" / COMMENT BLOCK }}}

" COMMENT LINE {{{
" //...
" s^
sy match eozCommentLine
        \ "\/\/.*"
" / COMMENT LINE }}}

sy cluster eozComment
    \ contains=
        \eozCommentBlock,
        \eozCommentLine
" / COMMENT }}}

" TAG COMMENT {{{
" <!---...--->
" s^^^^   ^^^e
sy region eozTagComment
  \ keepend
    \ start="<!---"
    \ end="--->"
    \ contains=eozTagComment
" / TAG COMMENT }}}

" FLOW STATEMENT {{{
" BRANCH FLOW KEYWORD {{{
sy keyword eozBranchFlowKeyword
    \ break
    \ continue
    \ return

" / BRANCH KEYWORD }}}

" DECISION FLOW KEYWORD {{{
sy keyword eozDecisionFlowKeyword
    \ case
    \ defaultcase
    \ else
    \ if
    \ switch

" / DECISION FLOW KEYWORD }}}

" LOOP FLOW KEYWORD {{{
sy keyword eozLoopFlowKeyword
    \ do
    \ for
    \ in
    \ while

" / LOOP FLOW KEYWORD }}}

" TRY FLOW KEYWORD {{{
sy keyword eozTryFlowKeyword
    \ catch
    \ finally
    \ rethrow
    \ throw
    \ try

" / TRY FLOW KEYWORD }}}

sy cluster eozFlowStatement
    \ contains=
        \eozBranchFlowKeyword,
        \eozDecisionFlowKeyword,
        \eozLoopFlowKeyword,
        \eozTryFlowKeyword

" FLOW STATEMENT }}}

" STORAGE KEYWORD {{{
sy keyword eozStorageKeyword
    \ var
" / STORAGE KEYWORD }}}

" STORAGE TYPE {{{
sy match eozStorageType
  \ contained
  \ "\v<
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
  \){1}\ze(\s*\=)@!"
" / STORAGE TYPE }}}

" CORE KEYWORD {{{
sy match eozCoreKeyword
        \ "\v<
        \(new
        \|required
        \)\ze\s"
" / CORE KEYWORD }}}

" CORE SCOPE {{{
sy match eozCoreScope
    \ "\v<
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
    \){1}\ze(,|\.|\[|\)|\s)"
" / CORE SCOPE }}}

" SQL STATEMENT {{{
sy cluster eozSqlStatement
    \ contains=
        \@eozParenthesisRegion,
        \@eozQuote,
        \@eozQuotedValue,
        \@sqlSyntax,
        \eozBoolean,
        \eozDot,
        \eozEqualSign,
        \eozFunctionName,
        \eozHashSurround,
        \eozNumber
" SQL STATEMENT }}}

" TAG IN SCRIPT {{{
sy match eozTagNameInScript
    \ "\vcf_*\w+\s*\ze\("
" / TAG IN SCRIPT }}}

" METADATA {{{
sy region eozMetaData
    \ contained
    \ keepend
    \ start="@\w\+"
    \ end="$"
    \ contains=
        \eozMetaDataName

sy match eozMetaDataName
    \ contained
    \ "@\w\+"
" / METADATA }}}

" COMPONENT DEFINITION {{{
sy region eozComponentDefinition
    \ start="component"
    \ end="{"me=e-1
    \ contains=
        \@eozAttribute,
        \eozComponentKeyword

sy match eozComponentKeyword
    \ contained
    \ "\v<component>"
" / COMPONENT DEFINITION }}}

" INTERFACE DEFINITION {{{
sy match eozInterfaceDefinition
    \ "interface\s.*{"me=e-1
    \ contains=
        \eozInterfaceKeyword

sy match eozInterfaceKeyword
    \ contained
    \ "\v<interface>"
" / INTERFACE DEFINITION }}}

" PROPERTY {{{
sy region eozProperty
    \ transparent
    \ start="\v<property>"
    \ end=";"me=e-1
    \ contains=
        \@eozQuotedValue,
        \eozAttrEqualSign,
        \eozAttrName,
        \eozAttrValue,
        \eozPropertyKeyword

sy match eozPropertyKeyword
        \ contained
        \ "\v<property>"
" PROPERTY }}}

" FUNCTION DEFINITION {{{
sy match eozFunctionDefinition
    \ "\v
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
    \<function\s\w+\s*\("me=e-1
    \ contains=
        \eozFunctionKeyword,
        \eozFunctionModifier,
        \eozFunctionName,
        \eozFunctionReturnType

" FUNCTION KEYWORD {{{
sy match eozFunctionKeyword
    \ contained
    \ "\v<function>"
" / FUNCTION KEYWORD }}}

" FUNCTION MODIFIER {{{
sy match eozFunctionModifier
    \ contained
    \ "\v<
    \(public
    \|private
    \|package
    \)>"
" / FUNCTION MODIFIER }}}

" FUNCTION RETURN TYPE {{{
sy match eozFunctionReturnType
    \ contained
    \ "\v
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
    \)"
" / FUNCTION RETURN TYPE }}}

" FUNCTION NAME {{{
" specific regex for core functions decreases performance
" so use the same highlighting for both function types
sy match eozFunctionName
    \ "\v<(cf|if|elseif|throw)@!\w+\s*\ze\("
" / FUNCTION NAME }}}

" / FUNCTION DEFINITION }}}

" ODD FUNCTION {{{
sy region eozOddFunction
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
        \@eozQuotedValue,
        \eozAttrEqualSign,
        \eozAttrName,
        \eozAttrValue,
        \eozCoreKeyword,
        \eozOddFunctionKeyword,
        \eozCoreScope

" ODD FUNCTION KEYWORD {{{
sy match eozOddFunctionKeyword
        \ contained
        \ "\v<
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
        \)\ze(\s|$|;)"
" / ODD FUNCTION KEYWORD }}}

" / ODD FUNCTION }}}

" CUSTOM {{{

" CUSTOM KEYWORD {{{
sy match eozCustomKeyword
    \ contained
    \ "\v<
    \(customKeyword1
    \|customKeyword2
    \|customKeyword3
    \)>"
" / CUSTOM KEYWORD }}}

" CUSTOM SCOPE {{{
sy match eozCustomScope
    \ contained
    \ "\v<
    \(prc
    \|rc
    \|event
    \|(\w+Service)
    \){1}\ze(\.|\[)"
" / CUSTOM SCOPE }}}

" / CUSTOM }}}

" SGML TAG START AND END {{{
" SGML tag start
" <...>
" s^^^e
sy region eozSGMLTagStart
    \ keepend
    \ transparent
  \ start="\v(\<cf)@!\zs\<\w+"
    \ end=">"
    \ contains=
        \@eozAttribute,
        \@eozComment,
        \@eozOperator,
        \@eozParenthesisRegion,
        \@eozPunctuation,
        \@eozQuote,
        \@eozQuotedValue,
        \eozAttrEqualSign,
        \eozBoolean,
        \eozBrace,
        \eozCoreKeyword,
        \eozCoreScope,
        \eozCustomKeyword,
        \eozCustomScope,
        \eozEqualSign,
        \eozFunctionName,
        \eozNumber,
        \eozStorageKeyword,
        \eozStorageType,
        \eozTagBracket,
        \eozSGMLTagName

" SGML tag end
" </...>
" s^^^^e
sy match eozSGMLTagEnd
    \ transparent
    \ "\v(\<\/cf)@!\zs\<\/\w+\>"
    \ contains=
        \eozTagBracket,
        \eozSGMLTagName

" SGML tag name
" <...>
" s^^^e
sy match eozSGMLTagName
  \ contained
  \ "\v(\<\/*)\zs\w+"

" SGML TAG START AND END }}}

" HIGHLIGHTING {{{

hi link eozNumber Number
hi link eozBoolean Boolean
hi link eozEqualSign Keyword
" HASH SURROUND
hi link eozHash PreProc
hi link eozHashSurround PreProc
" OPERATOR
hi link eozArithmeticOperator Function
hi link eozBooleanOperator Function
hi link eozDecisionOperator Function
hi link eozStringOperator Function
hi link eozTernaryOperator Function
" PARENTHESIS
hi link eozParenthesis1 Statement
hi link eozParenthesis2 String
hi link eozParenthesis3 Delimiter
" BRACE
hi link eozBrace PreProc
" PUNCTUATION - BRACKET
hi link eozBracket Statement
" PUNCTUATION - CHAR
hi link eozComma Comment
hi link eozDot Comment
hi link eozSemiColon Comment
" PUNCTUATION - QUOTE
hi link eozDoubleQuote String
hi link eozDoubleQuotedValue String
hi link eozSingleQuote String
hi link eozSingleQuotedValue String
" TAG START AND END
hi link eozTagName Function
hi link eozTagBracket Comment
" ATTRIBUTE NAME AND VALUE
hi link eozAttrName Type
hi link eozAttrValue Special
" COMMENT
hi link eozCommentBlock Comment
hi link eozCommentLine Comment
hi link eozTagComment Comment
" FLOW STATEMENT
hi link eozDecisionFlowKeyword Conditional
hi link eozLoopFlowKeyword Repeat
hi link eozTryFlowKeyword Exception
hi link eozBranchFlowKeyword Keyword
" STORAGE KEYWORD
hi link eozStorageKeyword Keyword
" STORAGE TYPE
hi link eozStorageType Keyword
" CORE KEYWORD
hi link eozCoreKeyword PreProc
" CORE SCOPE
hi link eozCoreScope Keyword
" TAG IN SCRIPT
hi link eozTagNameInScript Function
" METADATA
" meta data value = eozMetaData
hi link eozMetaData String
hi link eozMetaDataName Type
" COMPONENT DEFINITION
hi link eozComponentKeyword Keyword
" INTERFACE DEFINITION
hi link eozInterfaceKeyword Keyword
" PROPERTY
hi link eozPropertyKeyword Keyword
" FUNCTION DEFINITION
hi link eozFunctionKeyword Keyword
hi link eozFunctionModifier Keyword
hi link eozFunctionReturnType Keyword
hi link eozFunctionName Function
" ODD FUNCTION
hi link eozOddFunctionKeyword Function
" CUSTOM
hi link eozCustomKeyword Keyword
hi link eozCustomScope Structure
" SGML TAG
hi link eozSGMLTagName Ignore

" / HIGHLIGHTING }}}
