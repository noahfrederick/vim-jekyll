" autoload/jekyll.vim - Jekyll autoloads
" Maintainer: Noah Frederick

""
" @public
" Get the version number of @plugin(stylized) (e.g., '1.0.0')
function! jekyll#version()
  return '0.1.0'
endfunction

""
" @private
" Publish a draft post by moving it into _posts/ and prepending the current
" date to the filename.
"
" This makes assumptions about the structure of your site, namely that
" _drafts/ and _posts/ are at the root of your project and that you do not use
" subdirectories in either.
function! jekyll#publish()
  let src = expand('%:p')
  let slug = strftime('%Y-%m-%d') . '-' . fnamemodify(src, ':t')
  let dst = fnamemodify(src, ':h:h') . '/_posts/' . slug

  if !isdirectory(fnamemodify(dst, ':h'))
    call mkdir(fnamemodify(dst, ':h'), 'p')
  endif

  if rename(src, dst)
    echoerr 'Failed to rename "' . src . '" to "' . dst . '"'
  else
    setlocal modified
    execute 'keepalt saveas! ' . fnameescape(dst)

    if src !=# expand('%:p')
      execute 'bwipe ' . fnameescape(src)
    endif
  endif
endfunction

""
" Set up buffer-local commands for draft buffers
function! s:draft_buffer_setup()
  ""
  " Publish the current draft post (only available in draft buffers).
  "
  " This command moves the current buffer's file from the _drafts/ directory
  " to the _posts/ directory and prepends the current date as the published
  " date.
  command! -buffer -bar -nargs=0 Publish call jekyll#publish()
endfunction

""
" @private
" Set up Jekyll buffers
function! jekyll#buffer_setup()
  " TODO
endfunction

""
" @private
" Set up commands that depend on Projectionist
function! jekyll#projectionist_activate()
  for [root, value] in projectionist#query('type')
    if value ==# 'draft'
      return s:draft_buffer_setup()
    endif
  endfor
endfunction

" vim: fdm=marker:sw=2:sts=2:et
