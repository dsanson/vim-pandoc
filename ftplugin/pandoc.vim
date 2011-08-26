"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin/pandoc.vim
"
" Thrown together by David Sanson <https://github.com/dsanson>, who is
" a complete newbie when it comes to vim, so doesn't really know what 
" he is doing.
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Soft word wrapping
setlocal formatoptions=1
setlocal linebreak

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remappings that make j and k behave properly with
" soft wrapping.
nnoremap <buffer> j gj
nnoremap <buffer> k gk
vnoremap <buffer> j gj
vnoremap <buffer> k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show partial wrapped lines
setlocal display=lastline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Do not add two spaces at end of punctuation when joining lines
"
setlocal nojoinspaces
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Use pandoc to tidy up text
"
" If you use this on your entire file, it will wipe out title blocks.
" To preserve title blocks, use :MarkdownTidy instead. (If you use
" :MarkdownTidy on a portion of your file, it will insert unwanted title
" blocks...)
"

setlocal equalprg=pandoc\ -t\ markdown\ --reference-links

"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HTML style comments
"
setlocal commentstring=<!--%s-->
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->

"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Folding sections with ATX style headers.
"
" Taken from
" http://stackoverflow.com/questions/3828606/vim-markdown-folding/4677454#4677454
"
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "="
endfunction
setlocal foldexpr=MarkdownLevel()
setlocal foldmethod=expr
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Save folding between sessions
"
autocmd BufWinLeave * if expand(&filetype) == "pandoc" | mkview | endif
autocmd BufWinEnter * if expand(&filetype) == "pandoc" | loadview | endif
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Use ctrl-X ctrl-K for dictionary completions. This adds citation keys from
" ~/.pandoc/citationkeys.dict to the dictionary. 
" 
setlocal dictionary+=~/.pandoc/citationkeys.dict
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Autocomplete citationkeys using function
"
let s:completion_type = ''

function! Pandoc_Complete(findstart, base)
	if a:findstart
		" return the starting position of the word
		let line = getline('.')
		let pos = col('.') - 1
		while pos > 0 && line[pos - 1] !~ '\\\|{\|\[\|<\|\s\|@\|\^'
			let pos -= 1
		endwhile

		let line_start = line[:pos-1]
		if line_start =~ '.*@$'
			let s:completion_type = 'bib'
		endif
		return pos
	else
		"return suggestions in an array
		let suggestions = []
		if s:completion_type == 'bib'
			" suggest BibTeX entries
			let suggestions = Pandoc_BibComplete(a:base)
		endif
		return suggestions
	endif
endfunction

function! Pandoc_BibComplete(regexp)

	if !exists('g:PandocBibfile')
		if filereadable($HOME . '/.pandoc/default.bib')
			let g:PandocBibfile = $HOME . '/.pandoc/default.bib'
		elseif filereadable($HOME . '/Library/texmf/bibtex/bib/default.bib')
			let g:PandocBibfile = $HOME . '/Library/texmf/bibtex/bib/default.bib'
		elseif filereadable($HOME . '/texmf/bibtex/bib/default.bib')
			let g:PandocBibfile = $HOME . '/texmf/bibtex/bib/default.bib'
		else
			return []
		endif
	endif

	let res = split(Pandoc_BibKey(a:regexp))
	return res

endfunction

function! Pandoc_BibKey(partkey)
	let myres = ''
ruby << EOL
bib = VIM::evaluate('g:PandocBibfile')
string = VIM::evaluate('a:partkey')

File.open(bib) { |file|
	text = file.read
	keys = []
	keys = keys + text.scan(/@.*?\{(#{string}.*?),/i)
	keys.uniq!
	keys.sort!
	results = keys.join(" ")
	VIM::command('let myres = "' "#{results}" '"')
}
EOL
return myres
endfunction

setlocal omnifunc=Pandoc_Complete

if exists('g:SuperTabCompletionContexts')
  let b:SuperTabCompletionContexts =
    \ ['PandocContext'] + g:SuperTabCompletionContexts
  function! PandocContext()
		" return the starting position of the word
	let line = getline('.')
	let pos = col('.') - 1
	while pos > 0 && line[pos - 1] !~ '\\\|{\|\[\|<\|\s\|@\|\^'
		let pos -= 1
	endwhile
	if line[pos - 1] == "@"
		return "\<c-x>\<c-o>"
	endif
  endfunction
endif
"
" disable supertab completions after bullets and numbered list
" items (since one commonly types something like `+<tab>` to 
" create a list.)
"
let b:SuperTabNoCompleteAfter = ['\s', '^\s*\(-\|\*\|+\|>\|:\)', '^\s*(\=\d\+\(\.\=\|)\=\)'] 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Commands that call Pandoc
"
" ## Tidying Commands
"
" Markdown tidy with hard wraps
" (Note: this will insert an empty title block if no title block 
" is present; it will wipe out any latex macro definitions)

	:command! MarkdownTidyWrap %!pandoc -t markdown -s

" Markdown tidy without hard wraps
" (Note: this will insert an empty title block if no title block 
" is present; it will wipe out any latex macro definitions)

	:command! MarkdownTidy %!pandoc -t markdown --no-wrap -s

" ## Complex commands
"
" Note that these commands depend on OS X's "open" command. Linux users will
" want to rewrite them to use the "xdg-open" command.
"
" Generate html and open in default html viewer

	:command! MarkdownHtmlOpen !out="%";out="${out\%.*}.html";pandoc -t html -sS -o "$out" %;open "$out"

" Generate pdf and open in default pdf viewer

  	:command! MarkdownPdfOpen !out="%";out="${out\%.*}.pdf";markdown2pdf -o "$out" %;open "$out"

" Generate odt and open in default odt viewer

	:command! MarkdownOdtOpen !out="%";out="${out\%.*}.odt";pandoc -t odt -sS -o "$out" %;open "$out"

" # Some suggested <Leader> mappings
"
" It is bad form to put <Leader> mappings in ftplugins. If you want to enable
" these mappings, put something like
" 
"   let g:PandocLeaders = 1
"
" in your .vimrc. Or just copy any you are interested in using into your vimrc.
"
if exists('g:PandocLeaders') 

	map <silent> <Leader>html :MarkdownHtmlOpen<CR>
	map <silent> <LEADER>pdf :MarkdownPdfCiteOpen<CR>
	map <silent> <LEADER>odt :MarkdownOdtCiteOpen<CR>

" While I'm at it, here are a few more functions mappings that are useful when
" editing pandoc files.
"
" Open link in browser (OS X only; based on Gruber's url regex)
"
" (This isn't very pandoc-specific, but I use it in the next mapping below.)
"
ruby << EOF
	  def open_uri
		re = %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}

		line = VIM::Buffer.current.line

		if url = line[re]
		  system("open", url)
		  VIM::message(url)
		else
		  VIM::message("No URI found in line.")
		end
	  end
EOF

	if !exists("*OpenURI")
	  function! OpenURI()
		:ruby open_uri
	  endfunction
	endif

	map <Leader>www :call OpenURI()<CR>

"" Open reference link in browser (depends on above mapping of <LEADER>w)
	map <Leader>wr ya[#<LEADER>www*

"" Jump forward to existing reference link (or footnote link)
	map <Leader>fr ya[#E

"" Jump back to existing reference link (or fn link)
	map <Leader>br {jwya[*E

"" Add new reference link (or footnote link) after current paragraph. (This
"" works better than the snipmate snippet for doing this.)

	map <Leader>nr ya[o<CR><ESC>p$a:

endif
