" Vim syntax file
" Language:	Pandoc (superset of Markdown)
" Maintainer:	Jeremy Schultz <taozhyn@gmail.com>
" HackedUpBy:	David Sanson
" URL:
" Version:	2.1
" Changes: 
"
" 2011-07-20
"
"   - Improved support for definition lists: now allows both colon and tilda,
"     indented by 0, 1, or 2 spaces.
"
" 2011-07-19
"   - Fixed support for delimited code blocks
"
" 2011-06-13
" 	- Separate patterns for **strong** and *emphasis* 
" 	- Enabled bold and italic display (thanks to Dirk Laurie for help with
" 	this.) Note that my favorite fixed width font, Monaco, doesn't support
" 	italics :-(
"
" 2011-03-05 (David Sanson)	
"	- Added support for Numbered Examples
"
" TODO:
"   - Display definition terms in blue bold
" 	- Add support for citation keys
" 	- Tables: Headerless simple tables; Grid tables
" 	- Fix bug with multiline footnotes (? I've lost track of what this was)
"
" Remark:	Uses HTML and TeX syntax file
" 
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
syn match pdcHTML	/<\a[^>]\+>/	contains=@HTML

" Support HTML multi line comments
syn region pdcHTMLComment   start=/<!--/ end=/-->/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set embedded LaTex (pandoc extension) highlighting
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim

"   Single Tex command
syn match pdcLatex /\\\w\S/ contains=@LATEX
"   Math Tex
syn match pdcLatex	/\$.*\$/ contains=@LATEX

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Block Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Needed by other elements
syn match pdcBlankLine   /\(^\s*\n\|\%^\)/    nextgroup=pdcHeader,pdcCodeBlock,pdcListItem,pdcListItem1,pdcHRule,pdcTableHeader,pdcTableMultiStart,pdcBlockquote transparent

"""""""""""""""""""""""""""""""""""""""
" Title Block:
syn match pandocTitleBlock /\%^\(%.*\n\)\{1,3}$/

"""""""""""""""""""""""""""""""""""""""
" Headers:

"   Underlined, using == or --
syn match  pdcHeader    /^.\+\n[=-]\+$/ contains=@Spell,pdcLatex nextgroup=pdcHeader contained skipnl
"   Atx-style, Hash marks
syn region pdcHeader    start="^\s*#\{1,6}[^#]*" end="\($\|#\+\)" contains=@Spell,pdcLatex contained nextgroup=pdcHeader skipnl


"""""""""""""""""""""""""""""""""""""""
" Blockquotes:

syn match pdcBlockquote	    /\s*>.*$/  nextgroup=pdcBlockquote,pdcBlockquote2 contained skipnl contains=pdcPCite
syn match pdcBlockquote2    /[^>].*/  nextgroup=pdcBlockquote2 skipnl contained contains=pdcPCite


"""""""""""""""""""""""""""""""""""""""
" Code Blocks:

"   Indent with at least 4 space or 1 tab
"   This rule must appear for pdcListItem, or highlighting gets messed up
syn match pdcCodeBlock   /\(\s\{4,}\|\t\{1,}\).*\n/ contained nextgroup=pdcCodeBlock
"   HTML code blocks, pre and code
syn match pdcCodeStartPre	/<pre>/ nextgroup=pdcCodeHTMLPre skipnl transparent
syn match pdcCodeHTMLPre   /.*/  contained nextgroup=pdcCodeHTMLPre,pdcCodeEndPre skipnl
syn match pdcCodeEndPre  /\s*<\/pre>/ contained transparent

"   HTML code blocks, code
syn match pdcCodeStartCode	/<code>/ nextgroup=pdcCodeHTMLCode skipnl transparent
syn match pdcCodeHTMLCode   /.*/  contained nextgroup=pdcCodeHTMLCode,pdcCodeEndCode skipnl
syn match pdcCodeEndCode  /\s*<\/code>/ contained transparent

"""""""""""""""""""""""""""""""""""""""
" Lists:

"   These first two rules need to be first or the highlighting will be
"   incorrect

"   Continue a list on the next line
syn match pdcListCont /\s*[^-+*].*\n/ contained nextgroup=pdcListCont,pdcListItem,pdcListSkipNL transparent
"   Skip empty lines
syn match pdcListSkipNL /\s*\n/ contained nextgroup=pdcListItem,pdcListSkipNL
"   Unorder list
syn match  pdcListItem /\s*[-*+]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
"   Order list, numeric
syn match  pdcListItem  /\s*(\?\(\d\+\|#\)[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
"   Order list, roman numerals (does not guarantee correct roman numerals)
syn match  pdcListItem  /\s*(\?[ivxlcdm]\+[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
"   Order list, lowercase letters
syn match  pdcListItem  /\s*(\?\l[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
"   Order list, uppercase letters, does not include '.'
syn match  pdcListItem  /\s*(\?\u[\)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
"   Order list, uppercase letters, special case using '.' and two or more spaces
syn match  pdcListItem  /\s*\u\.\([ ]\{2,}\|\t\+\)/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl
"  Numbered Example list (doesn't handle hyphens or underscores in labels)
syn match  pdcListItem  /\s*(\?@\a*[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"""""""""""""""""""""""""""""""""""""""
" Horizontal Rules:

"   3 or more * on a line
syn match pdcHRule  /\s\{0,3}\(-\s*\)\{3,}\n/	contained nextgroup=pdcHRule
"   3 or more - on a line
syn match pdcHRule  /\s\{0,3}\(\*\s*\)\{3,}\n/	contained nextgroup=pdcHRule

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Span Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" inline links:
syn match pdcLinkArea /\[.\{-}\](.\{-})/ 
syn match pdcLinkText /\[.\{-}\]/hs=s+1,he=e-1 containedin=pdcLinkArea contained contains=@Spell
syn match pdcLinkURL /(.\{-})/hs=s+1,he=e-1 containedin=pdcLinkArea contained
syn match pdcLinkTitle /".\{-}"/ contained containedin=pdcLinkURL contains=@Spell

" Ref links
syn match pdcLinkArea /^\s*\[.\{-}\]:\s*http[^>]*$/
syn match pdcLinkURL /:\s*http[^>]*$/hs=s+2 contained containedin=pdcLinkArea
" explicit ref-text link
syn match pdcLinkText /\[.\{-}\]\[.\{-}\]/
" TODO: implicit ref-text link
" syn match pdcLinkText /\[.\{-}\]/ containedin=pdcLinkArea

" Link URL for inline <> links:
syn match pdcLinkURL /<http[^>]*>/
syn match pdcLinkURL /<[^>]*@[^>]*.[^>]*>/

"""""""""""""""""""""""""""""""""""""""
" Strong:
"
"   Using underscores
syn match pdcStrong /\s\(__\)\([^_ ]\|[^_]\( [^_]\)\+\)\+\1/    contains=@Spell

"   Using Asterisks
syn match pdcStrong /\s\(\*\*\)\([^\* ]\|[^\*]\( [^\*]\)\+\)\+\1/    contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Emphasis:
"
"Using underscores
syn match pdcEmphasis   /\s\(_\)\([^_ ]\|[^_]\( [^_]\)\+\)\+\1/    contains=@Spell

"Using Asterisks
syn match pdcEmphasis   /\s\(\*\)\([^\* ]\|[^\*]\( [^\*]\)\+\)\+\1/    contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Inline Code:

"   Using single back ticks
syn region pdcCode start=/`/		end=/`\|^\s*$/
"   Using double back ticks
syn region pdcCode start=/``[^`]*/      end=/``\|^\s*$/

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
syn match pdcSubscript   /\~\([^\~\\ ]\|\(\\ \)\)\+\~/   contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Superscript:
syn match pdcSuperscript /\^\([^\^\\ ]\|\(\\ \)\)\+\^/   contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Strikeout:
syn match pdcStrikeout   /\~\~[^\~ ]\([^\~]\|\~ \)*\~\~/ contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Definitions:
syn match pdcDefinitions /^\(:\|\~\)\(\t\|[ ]\{3,}\)/  nextgroup=pdcListItem,pdcCodeBlock,pdcBlockquote,pdcHRule

syn match pdcDefinitions /^ \(:\|\~\)\(\t\|[ ]\{2,}\)/  nextgroup=pdcListItem,pdcCodeBlock,pdcBlockquote,pdcHRule

syn match pdcDefinitions /^  \(:\|\~\)\(\t\|[ ]\{1,}\)/  nextgroup=pdcListItem,pdcCodeBlock,pdcBlockquote,pdcHRule

"""""""""""""""""""""""""""""""""""""""
" Footnote:
syn match pdcFootnoteID /\[\^[^\]]\+\]/ nextgroup=pdcFootnoteDef
"   Inline footnotes
syn region pdcFootnoteDef matchgroup=pdcFootnoteID start=/\^\[/ end=/\]/ contains=pdcLinkArea,pdcLatex,pdcPCite skipnl
syn region pdcFootnoteBlock start=/\[\^.*\]:\s*/ end=/^\n/ contains=pdcLinkArea,pdcLatex,pdcPCite skipnl
syn match pdcFootnoteID /\[\^.*\]/ contained containedin=pdcFootnoteBlock

"""""""""""""""""""""""""""""""""""""""
" Tables:
"
"   Regular Table
syn match pdcTableHeader /\s*\w\+\(\s\+\w\+\)\+\s*\n\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableBody
syn match pdcTableBody	 /\s*\w\+\(\s\+\w\+\)\+\s*\n/ contained nextgroup=pdcTableBody,pdcTableCaption skipnl
syn match pdcTableCaption /\n\+\s*Table.*\n/ contained nextgroup=pdcTableCaptionCont
syn match pdcTableCaptionCont /\s*\S.\+\n/ contained nextgroup=pdcTableCaptionCont

"   Multi-line Table
syn match pdcTableMultiStart /^\s\{0,3}-\+\s*\n\ze\(\s*\w\+\(\s\+\w\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableMultiHeader
syn match pdcTableMultiEnd /^\s\{0,3}-\+/ contained nextgroup=pdcTableMultiCaption skipnl
syn match pdcTableMultiHeader /\(\s*\w\+\(\s\+\w\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableMultiBody
syn match pdcTableMultiBody /^\(\s\{3,}[^-]\|[^-\s]\).*$/ contained nextgroup=pdcTableMultiBody,pdcTableMultiSkipNL,pdcTableMultiEnd skipnl
syn match pdcTableMultiSkipNL /^\s*\n/ contained nextgroup=pdcTableMultiBody,pdcTableMultiEnd skipnl
syn match pdcTableMultiCaption /\n*\s*Table.*\n/ contained nextgroup=pdcTableCaptionCont

"""""""""""""""""""""""""""""""""""""""
" Delimited Code Block: (added in 1.0)
syn region pdcCodeBlock matchgroup=pdcCodeStart start=/^\z(\~\{3,}\) \( {[^}]\+}\)\?/ matchgroup=pdcCodeEnd end=/^\z1\~*/

"""""""""""""""""""""""""""""""""""""""
" Citations:
" parenthetical citations
syn match pdcPCite /\[-\?@.\{-}\]/ contains=pdcEmphasis,pdcStrong
" syn match pdcPCite /\[\w.\{-}\s-\?.\{-}\]/ contains=pdcEmphasis,pdcStrong
" in-text citations without location
syn match pdcPCite /@\w*/
" in-text citations with location
syn match pdcPCite /@\w*\s\[.\{-}\]/

"""""""""""""""""""""""""""""""""""""""
" Newline, 2 spaces at the end of line means newline
syn match pdcNewLine /  $/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight groups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link pdcHeader		Title
hi link pdcBlockquote	    	Comment
hi link pdcBlockquote2	    	Comment

hi link pdcHTMLComment		Comment

hi link pdcHRule		Underlined
"hi link pdcHRule		Special

hi link pdcListItem		Operator
hi link pdcDefinitions		Operator

hi link pdcEmphasis   htmlItalic
hi link pdcStrong  			htmlBold
hi link pdcSubscript		Special
hi link pdcSuperscript		Special
hi link pdcStrikeout	 	Special

hi link pdcLinkArea		Special
hi link pdcLinkText		Type
hi link pdcLinkURL	Underlined
hi link pdcLinkTitle Identifier

hi link pdcFootnoteID		Identifier
hi link pdcFootnoteDef		Comment
hi link pandocFootnoteCont 	Error
hi link pdcFootnoteBlock	Comment

hi link pdcCodeBlock		String
hi link pdcCodeHTMLPre		String
hi link pdcCodeHTMLCode		String
hi link pdcCode			String
hi link pdcCodeStart		Comment
hi link pdcCodeEnd		Comment

hi link pandocTitleBlock	Comment

hi link pdcTableMultiStart	Comment
hi link pdcTableMultiEnd	Comment
hi link pdcTableHeader		Define
hi link pdcTableMultiHeader	Define
hi link pdcTableBody		Identifier
hi link pdcTableMultiBody	Identifier
hi link pdcTableCaption		Label
hi link pdcTableMultiCaption	Label
hi link pdcTableCaptionCont	Label

hi link pdcPCite Label

hi link pdcNewLine		Error


" For testing
hi link pdctest		Error


let b:current_syntax = "pandoc"
