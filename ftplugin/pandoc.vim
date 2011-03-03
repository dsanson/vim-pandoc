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
" # Quick conversion into and viewing of html, pdf, and odt
"
" Two options here.
"
" ## Option 1: Call External Wrapper Scripts
"
" First, three simple commands that rely on three external wrapper scripts:
" 'html', 'pdf', and 'odt'. You'll need to supply these scripts on your own;
" mine are not ready for primetime. The advantage is that you can set all your
" defaults just as you like, and the conversions will be available both in vim
" and from the cli.
"
" To use these, uncomment the following, and comment out the alternative
" definitions provided under Option 2 below.
"
" Generate html and open in default html viewer
"
"if !exists(':Mh')
	":command Mh !html %
"endif
"
" Generate pdf and open in default pdf viewer
"
"if !exists(':Mp')
  ":command Mp !pdf %
"endif
"
" Generate odt and open in default odt viewer
;"
"if !exists(':Mo')	
  ":command Mo !odt %
"endif
"
" ## Option 2: Call pandoc directly
"
" Three more complicated pandoc commands that don't rely on custom wrapper
" scripts. The advantage is that you don't need to provide those external
" scripts. The disadvantage is that you have to manage all the cli options
" here.
"
" Note that these commands depend on OS X's "open" command. Linux users will
" want to rewrite them to use the xdg-open command. 
"
" Generate html and open in default html viewer
"
if !exists(':Mh')
	:command Mh !out="%";out="${out\%.*}.html";pandoc -t html -sS -o "$out" %;open "$out" 
endif
"
"Generate pdf and open in default pdf viewer
"
if !exists(':Mp')
  :command Mp !out="%";out="${out\%.*}.pdf";markdown2pdf -o "$out" %;open "$out" 

endif
"
"Generate odt and open in default odt viewer
"
if !exists(':Mo')	
  :command Mo !out="%";out="${out\%.*}.odt";pandoc -t odt -sS -o "$out" %;open "$out" 
endif
"
"Easy to remember <leader> mappings for these conversion commands
"
map <silent> <Leader>html :Mh
map <silent> <LEADER>pdf :Mp
map <silent> <LEADER>odt :Mo
