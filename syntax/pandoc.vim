" Vim syntax file
" Language:	Pandoc (superset of Markdown)
" Maintainer: David Sanson <dsanson@gmail.com> 	
" Maintainer: Felipe Morales 
" OriginalAuthor: Jeremy Schultz <taozhyn@gmail.com>
" Version: 3.0
" Remark:	Uses HTML and TeX syntax file
" 

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set embedded HTML highlighting
syn include @HTML syntax/html.vim
syn match pandocHTML	/<\a[^>]\+>/	contains=@HTML
" Support HTML multi line comments
syn region pandocHTMLComment   start=/<!--/ end=/-->/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set embedded LaTex (pandoc extension) highlighting
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim
"   Single Tex command
syn match pandocLatex /\\\w\S/ contains=@LATEX
"   Math Tex
syn match pandocLatex	/\$.\{-}\$/ contains=@LATEX

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Block Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Needed by other elements
syn match pandocBlankLine   /\(^\s*\n\|\%^\)/    nextgroup=pandocHeader,pandocCodeBlock,pandocListItem,pandocListItem1,pandocHRule,pandocTableHeader,pandocTableMultiStart,pandocBlockquote transparent

"""""""""""""""""""""""""""""""""""""""
" Title Block:
syn match pandocTitleBlock /\%^\(%.*\n\)\{1,3}$/

"""""""""""""""""""""""""""""""""""""""
" Headers:

"   Underlined, using == or --
syn match  pandocHeader    /^.\+\n[=-]\+$/ contains=@Spell,pandocLatex nextgroup=pandocHeader contained skipnl
"   Atx-style, Hash marks
syn region pandocHeader    start="^\s*#\{1,6}[^#]*" end="\($\|#\+\)" contains=@Spell,pandocLatex contained nextgroup=pandocHeader skipnl


"""""""""""""""""""""""""""""""""""""""
" Blockquotes:

syn match pandocBlockquote	    /\s*>.*$/  nextgroup=pandocBlockquote,pandocBlockquote2 contained skipnl contains=pandocPCite
syn match pandocBlockquote2    /[^>].*/  nextgroup=pandocBlockquote2 skipnl contained contains=pandocPCite


"""""""""""""""""""""""""""""""""""""""
" Code Blocks:

"   Indent with at least 4 space or 1 tab
"   This rule must appear for pandocListItem, or highlighting gets messed up
syn match pandocCodeBlock   /\(\s\{4,}\|\t\{1,}\).*\n/ contained nextgroup=pandocCodeBlock
"   HTML code blocks, pre and code
syn match pandocCodeStartPre	/<pre>/ nextgroup=pandocCodeHTMLPre skipnl transparent
syn match pandocCodeHTMLPre   /.*/  contained nextgroup=pandocCodeHTMLPre,pandocCodeEndPre skipnl
syn match pandocCodeEndPre  /\s*<\/pre>/ contained transparent
"   HTML code blocks, code
syn match pandocCodeStartCode	/<code>/ nextgroup=pandocCodeHTMLCode skipnl transparent
syn match pandocCodeHTMLCode   /.*/  contained nextgroup=pandocCodeHTMLCode,pandocCodeEndCode skipnl
syn match pandocCodeEndCode  /\s*<\/code>/ contained transparent

"""""""""""""""""""""""""""""""""""""""
" Lists:

"   These first two rules need to be first or the highlighting will be
"   incorrect

"   Continue a list on the next line
syn match pandocListCont /\s*[^-+*].*\n/ contained nextgroup=pandocListCont,pandocListItem,pandocListSkipNL transparent
"   Skip empty lines
syn match pandocListSkipNL /\s*\n/ contained nextgroup=pandocListItem,pandocListSkipNL
"   Unorder list
syn match  pandocListItem /\s*[-*+]\s\+/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl
"   Order list, numeric
syn match  pandocListItem  /\s*(\?\(\d\+\|#\)[\.)]\s\+/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl
"   Order list, roman numerals (does not guarantee correct roman numerals)
syn match  pandocListItem  /\s*(\?[ivxlcdm]\+[\.)]\s\+/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl
"   Order list, lowercase letters
syn match  pandocListItem  /\s*(\?\l[\.)]\s\+/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl
"   Order list, uppercase letters, does not include '.'
syn match  pandocListItem  /\s*(\?\u[\)]\s\+/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl
"   Order list, uppercase letters, special case using '.' and two or more spaces
syn match  pandocListItem  /\s*\u\.\([ ]\{2,}\|\t\+\)/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl
"  Numbered Example list (doesn't handle hyphens or underscores in labels)
syn match  pandocListItem  /\s*(\?@\a*[\.)]\s\+/ contained nextgroup=pandocListSkipNL,pandocListCont skipnl

"""""""""""""""""""""""""""""""""""""""
" Horizontal Rules:

"   3 or more * on a line
syn match pandocHRule  /\s\{0,3}\(-\s*\)\{3,}\n/	contained nextgroup=pandocHRule
"   3 or more - on a line
syn match pandocHRule  /\s\{0,3}\(\*\s*\)\{3,}\n/	contained nextgroup=pandocHRule

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Span Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" inline links:
syn match pandocLinkArea /\[.\{-}\](.\{-})/ 
syn match pandocLinkText /\[.\{-}\]/hs=s+1,he=e-1 containedin=pandocLinkArea contained contains=@Spell
syn match pandocLinkURL /(.\{-})/hs=s+1,he=e-1 containedin=pandocLinkArea contained
syn match pandocLinkTitle /".\{-}"/ contained containedin=pandocLinkURL contains=@Spell

" Ref links
syn match pandocLinkArea /^\s*\[.\{-}\]:\s*http[^>]*$/
syn match pandocLinkURL /:\s*http[^>]*$/hs=s+2 contained containedin=pandocLinkArea
" explicit ref-text link
syn match pandocLinkText /\[.\{-}\]\[.\{-}\]/
" TODO: implicit ref-text link
" syn match pandocLinkText /\[.\{-}\]/ containedin=pandocLinkArea

" Link URL for inline <> links:
syn match pandocLinkURL /<http[^>]*>/
syn match pandocLinkURL /<[^>]*@[^>]*.[^>]*>/

"""""""""""""""""""""""""""""""""""""""
" Strong:
"
"   Using underscores
syn match pandocStrong /\(__\)\([^_ ]\|[^_]\( [^_]\)\+\)\+\1/    contains=@Spell skipnl
"   Using Asterisks
syn match pandocStrong /\(\*\*\)\([^\* ]\|[^\*]\( [^\*]\)\+\)\+\1/    contains=@Spell skipnl

"""""""""""""""""""""""""""""""""""""""
" Emphasis:
"
"Using underscores
syn match pandocEmphasis   /\(_\)\([^_ ]\|[^_]\( [^_]\)\+\)\+\1/    contains=@Spell skipnl
"Using Asterisks
syn match pandocEmphasis   /\(\*\)\([^\* ]\|[^\*]\( [^\*]\)\+\)\+\1/    contains=@Spell skipnl

"""""""""""""""""""""""""""""""""""""""
" Inline Code:

"   Using single back ticks
syn region pandocCode start=/`/		end=/`\|^\s*$/
"   Using double back ticks
syn region pandocCode start=/``[^`]*/      end=/``\|^\s*$/

"""""""""""""""""""""""""""""""""""""""
" Images:
"   Handled by link syntax

"""""""""""""""""""""""""""""""""""""""
" Misc:

"   Pandoc escapes all characters after a backslash
syn match NONE /\\\W/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Span Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" Subscripts:
syn match pandocSubscript   /\~\([^\~\\ ]\|\(\\ \)\)\+\~/   contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Superscript:
syn match pandocSuperscript /\^\([^\^\\ ]\|\(\\ \)\)\+\^/   contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Strikeout:
syn match pandocStrikeout   /\~\~[^\~ ]\([^\~]\|\~ \)*\~\~/ contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Definitions:
syn match pandocDefinitions /^\(:\|\~\)\(\t\|[ ]\{3,}\)/  nextgroup=pandocListItem,pandocCodeBlock,pandocBlockquote,pandocHRule

syn match pandocDefinitions /^ \(:\|\~\)\(\t\|[ ]\{2,}\)/  nextgroup=pandocListItem,pandocCodeBlock,pandocBlockquote,pandocHRule

syn match pandocDefinitions /^  \(:\|\~\)\(\t\|[ ]\{1,}\)/  nextgroup=pandocListItem,pandocCodeBlock,pandocBlockquote,pandocHRule

"""""""""""""""""""""""""""""""""""""""
" Footnote:
syn match pandocFootnoteID /\[\^[^\]]\+\]/ nextgroup=pandocFootnoteDef
"   Inline footnotes
syn region pandocFootnoteDef matchgroup=pandocFootnoteID start=/\^\[/ end=/\]/ contains=pandocLinkArea,pandocLatex,pandocPCite,@Spell skipnl
syn region pandocFootnoteBlock start=/\[\^.\{-}\]:\s*/ end=/^\n^\s\@!/ contains=pandocLinkArea,pandocLatex,pandocPCite,pandocStrong,pandocEmphasis,@Spell skipnl
syn match pandocFootnoteID /\[\^.\{-}\]/ contained containedin=pandocFootnoteBlock

"""""""""""""""""""""""""""""""""""""""
" Tables:
"
"   Regular Table
syn match pandocTableHeader /\s*\w\+\(\s\+\w\+\)\+\s*\n\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pandocTableBody
syn match pandocTableBody	 /\s*\w\+\(\s\+\w\+\)\+\s*\n/ contained nextgroup=pandocTableBody,pandocTableCaption skipnl
syn match pandocTableCaption /\n\+\s*Table.*\n/ contained nextgroup=pandocTableCaptionCont
syn match pandocTableCaptionCont /\s*\S.\+\n/ contained nextgroup=pandocTableCaptionCont

"   Multi-line Table
syn match pandocTableMultiStart /^\s\{0,3}-\+\s*\n\ze\(\s*\w\+\(\s\+\w\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pandocTableMultiHeader
syn match pandocTableMultiEnd /^\s\{0,3}-\+/ contained nextgroup=pandocTableMultiCaption skipnl
syn match pandocTableMultiHeader /\(\s*\w\+\(\s\+\w\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pandocTableMultiBody
syn match pandocTableMultiBody /^\(\s\{3,}[^-]\|[^-\s]\).*$/ contained nextgroup=pandocTableMultiBody,pandocTableMultiSkipNL,pandocTableMultiEnd skipnl
syn match pandocTableMultiSkipNL /^\s*\n/ contained nextgroup=pandocTableMultiBody,pandocTableMultiEnd skipnl
syn match pandocTableMultiCaption /\n*\s*Table.*\n/ contained nextgroup=pandocTableCaptionCont

"""""""""""""""""""""""""""""""""""""""
" Delimited Code Block: (added in 1.0)
syn region pandocCodeBlock matchgroup=pandocCodeStart start=/^\z(\~\{3,}\) \( {[^}]\+}\)\?/ matchgroup=pandocCodeEnd end=/^\z1\~*/

"""""""""""""""""""""""""""""""""""""""
" Citations:
" parenthetical citations
syn match pandocPCite /\[-\?@.\{-}\]/ contains=pandocEmphasis,pandocStrong,pandocLatex,@Spell
" syn match pandocPCite /\[\w.\{-}\s-\?.\{-}\]/ contains=pandocEmphasis,pandocStrong
" in-text citations without location
syn match pandocPCite /@\w*/
" in-text citations with location
syn match pandocPCite /@\w*\s\[.\{-}\]/

"""""""""""""""""""""""""""""""""""""""
" Newline, 2 spaces at the end of line means newline
" (commenting out because this seems to slow things down)
" syn match pandocNewLine /  $/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight groups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link pandocHeader		Title
hi link pandocBlockquote	    	Comment
hi link pandocBlockquote2	    	Comment

hi link pandocHTMLComment		Comment

hi link pandocHRule		Underlined
"hi link pandocHRule		Special

hi link pandocListItem		Operator
hi link pandocDefinitions		Operator

hi link pandocEmphasis  htmlItalic	
hi link pandocStrong  	htmlBold
hi link pandocSubscript		Special
hi link pandocSuperscript		Special
hi link pandocStrikeout	 	Special

hi link pandocLinkArea		Special
hi link pandocLinkText		Type
hi link pandocLinkURL	Underlined
hi link pandocLinkTitle Identifier

hi link pandocFootnoteID		Identifier
hi link pandocFootnoteDef		Comment
hi link pandocFootnoteBlock	Comment

hi link pandocCodeBlock		String
hi link pandocCodeHTMLPre		String
hi link pandocCodeHTMLCode		String
hi link pandocCode			String
hi link pandocCodeStart		Comment
hi link pandocCodeEnd		Comment

hi link pandocTitleBlock	Comment

hi link pandocTableMultiStart	Comment
hi link pandocTableMultiEnd	Comment
hi link pandocTableHeader		Define
hi link pandocTableMultiHeader	Define
hi link pandocTableBody		Identifier
hi link pandocTableMultiBody	Identifier
hi link pandocTableCaption		Label
hi link pandocTableMultiCaption	Label
hi link pandocTableCaptionCont	Label

hi link pandocPCite Label

" hi link pandocNewLine		Error


" For testing
hi link pandoctest		Error


let b:current_syntax = "pandoc"
