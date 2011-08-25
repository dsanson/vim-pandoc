if exists('g:SuperTabCompletionContexts')
  let b:SuperTabCompletionContexts =
    \ ['PandocContext'] + g:SuperTabCompletionContexts
  function! PandocContext()
    let curline = getline('.')
    if curline =~ '.*@[^ ;\],]*$'      
		return "\<c-x>\<c-o>"
    endif
  endfunction
endif
"
" disable supertab completions after bullets and numbered list
" items
"
let b:SuperTabNoCompleteAfter = ['\s', '^\s*\(-\|\*\|+\|>\|:\)', '^\s*(\=\d\+\(\.\=\|)\=\)'] 
