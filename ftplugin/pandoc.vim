""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin/pandoc.vim
"
" Thrown together by David Sanson <https://github.com/dsanson>, who is
" a complete newbie when it comes to vim, so doesn't really know what he is
" doing.
"
" Use at your own risk!
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Soft word wrapping
"
set formatoptions=1
set linebreak
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Do not add two spaces at end of punctuation when joining lines
"
set nojoinspaces
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
set foldexpr=MarkdownLevel()  
set foldmethod=expr    
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Save folding between sessions
"
au BufWinLeave * mkview
au BufWinEnter * silent loadview
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Autocomplete dictionary of citationkeys
" 
" There must be a better way to do this. I've generated a list of citekeys from
" my bibtex file and put it in citationkeys.dict.
"
 set dictionary=~/.pandoc/citationkeys.dict
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Autocomplete citationkeys using function
"
"

"fun! CompleteKeys(findstart, base)
  "if a:findstart
	"" locate the start of the word
	"let line = getline('.')
	"let start = col('.') - 1
	"while start > 0 && line[start - 1] =~ '\a'
	  "let start -= 1
	"endwhile
	"return start
  "else
	"let res = system('bibkey -v ' . a:base) 
	"return res
  "endif
"endfun
"set completefunc=CompleteKeys

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" # Quick conversion into and viewing of html, pdf, and odt
"
" Two options here.
"
" ## Option 1: Call External Wrapper Script
"
" Simple commands that rely on my "pd" wrapper script, which can be
" found here:
"
" 	https://gist.github.com/857619
"
" The advantage is that you can set all your defaults once,
" and the conversions are available both in vim and from the cli.
"
" Generate html and open in default html viewer

	:command! Mh !pd html open %

" Generate pdf using citeproc and open in default pdf viewer

	:command! Mp !pd bib pdf open %

" Generate odt using citeproc and open in default odt viewer

	:command! Mo !pd bib odt open %

" ## Option 2: Call pandoc directly
"
" Three more complicated pandoc commands that don't rely on pd. The advantage
" is that you don't need to provide those external scripts. The disadvantage
" is that you have to manage all the cli options here.
"
" Note that these commands depend on OS X's "open" command. Linux users will
" want to rewrite them to use the "xdg-open" command. 
"
" Generate html and open in default html viewer

	:command! Mhd !out="%";out="${out\%.*}.html";pandoc -t html -sS -o "$out" %;open "$out"

" Generate pdf and open in default pdf viewer

  	:command! Mpd !out="%";out="${out\%.*}.pdf";markdown2pdf -o "$out" %;open "$out"

" Generate odt and open in default odt viewer

	:command Mod !out="%";out="${out\%.*}.odt";pandoc -t odt -sS -o "$out" %;open "$out"

" Easy to remember <leader> mappings for these conversion commands. I've
" mapped these to the commands that depend on "pd".
"
map <silent> <Leader>html :Mh<CR>
map <silent> <LEADER>pdf :Mp<CR>
map <silent> <LEADER>odt :Mo<CR>
