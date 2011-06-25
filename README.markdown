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

Stuff From Elsewhere
--------------------

The syntax file was originally by jeremy schultz (found
[here](http://www.vim.org/scripts/script.php?script_id=2389)) as
githubbed by [wunki](https://github.com/wunki/vim-pandoc). I and others (see the forks!) have made some tweaks to add support for
definition lists, numbered example lists, and some other stuff.

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

+	Enables syntax highlighting.

+	Provides some snippets for use with snipMate.

+   Enables folding of ATX style sections.

+   Provides autocompletion of citations (more info below).

+	Provides some simple pandoc-powered conversion functions.

ftplugin/pandoc.vim is fairly well-commented. Take a look at it to see
what it does in detail.

Global Settings
---------------

The plugin recognizes two global settings, which can be set in your
vimrc:

+	g:PandocBibfile. If this is set to the path to a bibtex file 
	(a MODs file should also work), then that file will be used
	for citation autocompletion.

+	g:PandocLeaders. If this variable exists, then this plugin 
	will go ahead and define some leader mappings.

Citation Autocompletion
-----------------------

If you have a bibtex file (or a symlink to a bibtex file)
named 'default.bib' in

    ~/.pandoc/default.bib
    ~/Library/texmf/bibtex/bib
    ~/texmf/bibtex/bib

then the plugin will automatically use that file for citation
autocompletion. If you define `g:PandocBibfile` in your vimrc,

    let g:PandocBibfile = '/the/path/to/your/bibtex/file.bib'

then that file will be used instead.

To use autocompletion, start typing a citekey, e.g.,

    @geac

and then, while still in insert mode, hit ctrl-X ctrl-O (vim's 
shortcut for omnicompletion), and you'll get a popup window with
a list of matching keys, e.g.,

    @geach1970
    @geach1972

Regular expressions work too!

    @le.*90

should suggest both '@leftow1990' and '@lewis1990', assuming
those are both keys in your bibliography.

This also works well with [SuperTab]. I have the following in my 
vimrc:

    let g:SuperTabDefaultCompletionType = "context"

With this setting, I can just hit TAB to autocomplete.

[SuperTab]: http://www.vim.org/scripts/script.php?script_id=1643


Dictionary-Based Citation Completions
-------------------------------------

I am leaving this in, but now that proper autocompletion is 
working, I'll probably get rid of it eventually. If you create
a text file,

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

and then hitting ctrl-x ctrl-k.

Folding
-------

This plugin enables folding at ATX style sections. If you have 
never used folding in vim before, take a look at `:help fold-commands`.
If you want to get your feet wet, put yourself inside a section
(with ATX style headers), and try typing `za`, which toggles folds 
open and closed.

Conversion and Tidying Up
-------------------------

You really need to look at the comments in ftpugin/pandoc.vim to
see what is there. I've made no attempt to provide a complete
set of commands. Currently, the conversion commands come in two flavors. The first flavor depends on [an external wrapper script](https://gist.github.com/857619). The second flavor of commands call pandoc directly. I plan to remove the commands that depend on the external wrapper script at some point. 

Leader Mappings
---------------

If you define `g:PandocLeaders` in your vimrc,
 
    let g:PandocLeaders = 1

then the plugin will define some leader mappings for you. The ones I use the most are

    ,pdf
	,odt
	,html

which convert the buffer to the relevant format and open the results.

