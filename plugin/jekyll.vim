" plugin/jekyll.vim - Detect a Jekyll project
" Maintainer:  Noah Frederick (http://noahfrederick.com)

""
" @section Introduction, intro
" @stylized Jekyll.vim
" @plugin(stylized) provides conveniences for working with Jekyll 2
" projects. Some features include:
"
" - A :Jekyll wrapper around command-line utility with completion
" - A :Publish command to publish your drafts
" - Projections via projectionist.vim, which provide :Epost, :Edraft, etc.
" - Optional integration with dispatch.vim
"
" This plug-in is only available if 'compatible' is not set.

""
" @section About, about
" @plugin(stylized) is distributed under the same terms as Vim itself (see
" |license|)
"
" You can find the latest version of this plug-in on GitHub:
" https://github.com/noahfrederick/vim-@plugin(name)
"
" Please report issues on GitHub as well:
" https://github.com/noahfrederick/vim-@plugin(name)/issues

if (exists('g:loaded_jekyll') && g:loaded_jekyll) || &cp
  finish
endif
let g:loaded_jekyll = 1

" Detection {{{

""
" Determine whether the current or supplied [path] belongs to a Kohana project
function! s:jekyll_detect(...) abort
  if exists('b:jekyll_root')
    return 1
  endif

  let fn = fnamemodify(a:0 ? a:1 : expand('%'), ':p')

  if !isdirectory(fn)
    let fn = fnamemodify(fn, ':h')
  endif

  let config = findfile('_config.yml', escape(fn, ', ') . ';')

  if !empty(config)
    let b:jekyll_root = fnamemodify(config, ':p:h')
    let b:jekyll_has_bundler = filereadable(b:jekyll_root . '/Gemfile')
    return 1
  endif
endfunction

" }}}
" Initialization {{{

if !exists('g:jekyll_post_ext')
  ""
  " The file extension to use for posts
  "
  " Default: ".md"
  let g:jekyll_post_ext = '.md'
endif

augroup jekyll_detect
  autocmd!
  " Project detection
  autocmd BufNewFile,BufReadPost *
        \ if s:jekyll_detect(expand("<afile>:p")) && empty(&filetype) |
        \   call jekyll#buffer_setup() |
        \ endif
  autocmd VimEnter *
        \ if empty(expand("<amatch>")) && s:jekyll_detect(getcwd()) |
        \   call jekyll#buffer_setup() |
        \ endif
  autocmd FileType * if s:jekyll_detect() | call jekyll#buffer_setup() | endif
augroup END

" }}}
" Projections {{{

if !exists('g:jekyll_dispatch')
  ""
  " The :Dispatch command to run in Jekyll buffers
  "
  " Default: "jekyll build" ("bundle exec jekyll build" if a Gemfile is
  " present)
  let g:jekyll_dispatch = 'jekyll build'
endif

if !exists('g:jekyll_start')
  ""
  " The :Start command to run in Jekyll buffers
  "
  " Default: "jekyll serve" ("bundle exec jekyll serve" if a Gemfile is
  " present)
  let g:jekyll_start = 'jekyll serve'
endif

" Ensure that projectionist gets loaded first
if !exists('g:loaded_projectionist')
  runtime! plugin/projectionist.vim
endif

function! s:projectionist_detect()
  if s:jekyll_detect(get(g:, 'projectionist_file', ''))
    if b:jekyll_has_bundler && g:jekyll_dispatch =~# '^jekyll '
      let b:jekyll_dispatch = 'bundle exec ' . g:jekyll_dispatch
    else
      let b:jekyll_dispatch = g:jekyll_dispatch
    endif

    if b:jekyll_has_bundler && g:jekyll_start =~# '^jekyll '
      let b:jekyll_start = 'bundle exec ' . g:jekyll_start
    else
      let b:jekyll_start = g:jekyll_start
    endif

    call projectionist#append(b:jekyll_root, {
          \ "*": {
          \   "start": b:jekyll_start,
          \   "dispatch": b:jekyll_dispatch,
          \   "framework": "jekyll",
          \ },
          \ "README.md": {
          \   "type": "doc",
          \ },
          \ "_plugins/*.rb": {
          \   "type": "plugin",
          \ },
          \ "_layouts/*.html": {
          \   "type": "layout",
          \ },
          \ "_includes/*.html": {
          \   "type": "include",
          \ },
          \ "_posts/*": {
          \   "type": "post",
          \ },
          \ "_drafts/*": {
          \   "type": "draft",
          \ },
          \ "_config.yml": {
          \   "type": "config",
          \ }})
  endif
endfunction

augroup jekyll_projections
  autocmd!
  autocmd User ProjectionistDetect call s:projectionist_detect()
  autocmd User ProjectionistActivate call jekyll#projectionist_activate()
augroup END

" }}}
" vim: fdm=marker:sw=2:sts=2:et
