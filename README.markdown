Pandoc for Vim
==============

This is a bundle of pandoc-related stuff that I've thrown together for my own use. I don't really know what I am doing, so use at your own risk!

I need to write real vim-style documentation. For now, the documentation is here, and in the heavily commented ftplugin/pandoc.vim file. I encourage you to read through that file before using this plugin.

Known Gotchas
-------------

1.  Filetype detection does not play well with the [markdown-vim
    plugin](http://plasticboy.com/markdown-vim-mode/).
2.  Conversion commands assume you are using OS X (should be easy to
    fix).
3.  At various places, I assume that paths are POSIX paths, which
    will cause trouble on Windows (should be easy to fix).
4.  No vim help files.

Help From Others
----------------

Thanks to both [Felipe Morales](https://github.com/fmoralesc) and [Wei Dai](https://github.com/clvv) for lots of bug fixes and improvements. Special thanks to Felipe, who has made dramatic improvements to the syntax file.

Stuff From Elsewhere
--------------------

The syntax file was originally by jeremy schultz (found
[here](http://www.vim.org/scripts/script.php?script_id=2389)) as
githubbed by [wunki](https://github.com/wunki/vim-pandoc). 

The snippets file, for use with
[snipMate](http://www.vim.org/scripts/script.php?script_id=2540), is a
slight extension of the markdown.snippets file that is part of many of
the [vim-markdown repositories on
github](https://github.com/hallison/vim-markdown).

I implemented autocompletion by hacking away at [LaTeX Box]'s 
implementation. The results don't look much like the original, but
I learned a lot from copying.

[LaTeX Box]: http://www.vim.org/scripts/script.php?script_id=3109

Features
--------

Here are some key features:

+   Applies settings to make vim a pleasant writing environment.
	-    soft word wrapping
	-    intelligent line joining
	-    pandoc-powered tidying up
	-    other little tweaks along these lines

Specifically:

	setlocal formatoptions=1
	setlocal linebreak
	nnoremap <buffer> j gj
	nnoremap <buffer> k gk
	vnoremap <buffer> j gj
	vnoremap <buffer> k gk
	setlocal display=lastline
	setlocal nojoinspaces
	setlocal commentstring=<!--%s-->
	setlocal comments=s:<!--,m:\ \ \ \ ,e:-->

Additional tweaks welcome. Feedback also welcome on whether this is
appropriate. It would be easy to make some or all of this optional.

+	Syntax highlighting with support for definition lists, numbered
    examples, delimited code blocks, LaTeX and HTML, citations,
    footnotes, ....

+	Some snippets for use with snipMate (I never use these, so they
    could probably use improvement. If you improve them, let me know).

+   Folding of ATX styled sections. (See `:help fold-commands` if
    you haven't used vim's folding before.). Quick tips:

	+   `za` toggles folds open and closed (`zA` toggles fold and
		all its children open and closed)
    +   `zc` closes a fold (`zC` closes it and all its children)
    +	`zo` opens a fold (`zO` opens it and all its children).

+   Autocompletion of citations (more details below).

+	Some simple pandoc-powered conversion and tidying functions.

ftplugin/pandoc.vim is fairly well-commented. Take a look at it to see
what it does in detail.

Global Settings
---------------

The plugin recognizes two global settings, which can be set in your
vimrc:

+	g:PandocBibfile. If this is set to the path to a bibtex file 
	(a MODs file should also work), then that file will be used
	for citation autocompletion.

So, for example, one might put something like this in your vimrc:

    let g:PandocBibfile = "/Users/david/Documents/mybib.xml"

+	g:PandocLeaders. If this variable exists, then this plugin 
	will go ahead and define some leader mappings.

So, for example, I have this in my vimrc:

    let g:PandocLeaders = 1


Citation Autocompletion
-----------------------

If you have a bibtex file (or a symlink to a bibtex file)
named 'default.bib' in one of these folders,

    ~/.pandoc
    ~/Library/texmf/bibtex/bib
    ~/texmf/bibtex/bib

then the plugin will automatically use that file for citation
autocompletion. If you define `g:PandocBibfile` in your vimrc,

    let g:PandocBibfile = '/the/path/to/your/bibtex/file.bib'

then that file will be used instead.

To use autocompletion, start typing a citekey, e.g.,

    @geac

and then, while still in insert mode, hit ctrl-x ctrl-o (vim's 
shortcut for omnicompletion), and you'll get a popup window with
a list of matching keys, e.g.,

    @geach1970
    @geach1972

Regular expressions work too (but not with SuperTab for some reason):

    @le.*90

should suggest both '@leftow1990' and '@lewis1990', assuming
those are both keys in your bibliography.

The plugin also provides support for using this with [SuperTab]. I 
have the following in my vimrc:

    let g:SuperTabDefaultCompletionType = "context"

With this setting, I can just hit TAB in the middle of typing
a citation to autocomplete the citation. 

[SuperTab]: http://www.vim.org/scripts/script.php?script_id=1643

> **KNOWN BUGS**:
> 
> +  SuperTab autocompletion of citations only works after I use
> ctrl-x ctrl-o autocompletion once within a given file.
> +  Regular expressions don't work when using SuperTab.

> **TODO**: I'd like to pandoc.vim to be smarter about finding
> bibliography files. This includes:
> 
> +   finding the local texmf tree programatically
> +   using (all?) bibtex files found in any of the search
>     paths.
> +   including the directory that the file is in among the
>     search paths 
> +   better support for other bibliography database 
>     formats (the parser currently works with bibtex and 
>     MODS xml files, but the script doesn't look for MODS
>     xml files).

Dictionary-Based Citation Completions
-------------------------------------

I am leaving this in for now, but now that proper autocompletion is 
working, I'll probably get rid of it. If you create a text file,

    ~/.pandoc/citationkeys.dict

that contains a list of citation keys, one per line, like so

	@adams1967a
	@adams1971
	@adams1972a
	@adams1974
	@adams1977
	@adams1986a

these citekeys are added to vim's dictionary, allowing for autocompletion by typing part of a citekey, e.g.,

    @adams19

and then hitting ctrl-x ctrl-k (or via SuperTab).

Conversion and Tidying Up
-------------------------

Look at the comments in ftpugin/pandoc.vim to
see what is there. I've made no attempt to provide a complete
set of commands. Currently, the conversion commands come in two flavors. The first flavor depends on [an external wrapper script](https://gist.github.com/857619). The second flavor of commands call pandoc directly. I plan to remove the commands that depend on the external wrapper script at some point.

Also, the plugin sets

    setlocal equalprg=pandoc\ -t\ markdown\ --no-wrap
 

Leader Mappings
---------------

If you define `g:PandocLeaders` in your vimrc,
 
    let g:PandocLeaders = 1

then the plugin will define some leader mappings for you. The ones I use the most are

    <leader>pdf
	<leader>odt
	<leader>html

which convert the buffer to the relevant format and open the results.

