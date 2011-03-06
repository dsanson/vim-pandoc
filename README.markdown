# Pandoc for Vim

This is a bundle of pandoc-related stuff that I've thrown together for
my own use. I don't really know what I am doing, so use at your own
risk!

## Known Gotchas

1.  Filetype detection does not play well with the [markdown-vim
    plugin](http://plasticboy.com/markdown-vim-mode/).
2.  Conversion commands assume you are using OS X (should be easy to
    fix).
3.  No vim help files.

## Stuff From Elsewhere

The syntax file is by jeremy schultz (found
[here](http://www.vim.org/scripts/script.php?script_id=2389)) as
githubbed by [wunki](https://github.com/wunki/vim-pandoc). It is a bit
out of date: I don't think it understands definition lists, numbered
example lists, or citations. I've renamed it to 'pandoc.vim'.

The snippets file, for use with
[snipMate](http://www.vim.org/scripts/script.php?script_id=2540), is a
slight extension of the markdown.snippets file that is part of many of
the [vim-markdown repositories on
github](https://github.com/hallison/vim-markdown).

## What the Plugin Does

ftplugin/pandoc.vim is fairly well-commented. Take a look at it to see
what the plugin does in detail.

Briefly, it sets soft word wrapping, eliminates the extra space that vim
likes to insert when joining lines, enables folding of ATX style
sections, implements very crude dictionary-based autocompletion of
citations (you'll need to generate the dictionary yourself), and
provides some basic commands for quick conversion of html, pdf, and odt
files.

The conversion commands come in two flavors. The first flavor depends on [an
external wrapper script](https://gist.github.com/857619).

The first commands are

    :Mh     converts to html, opens in default html browser
    :Mp     converts to pdf using citeproc, opens in default pdf viewer
    :Mo     converts to odt using citeproc, opens in default odt viewer

These are also mapped to

    <Leader>html
    <Leader>pdf
    <Leader>odt

The second flavor of commands call pandoc directly, and so don't depend on
the external wrapper script. These are

	:Mhd	converts to html, opens in default html browser
	:Mhp	converts to pdf, opens in default pdf viewer
	:Mop	converts to odt, opens in default odt viewer

It should be trivial to expand these commands to include other formats.
These are the formats I use most often.

Note that as written, all of these commands depend on OS X's 'open' command. 
Linux users will want to edit them to use the 'xdg-open' command (the commands
are defined toward the end of ftplugin/pandoc.vim). But
really, it should be rewritten to figure out what to use based on platform.
Maybe I'll do that sometime. Maybe someone else will do it first.

