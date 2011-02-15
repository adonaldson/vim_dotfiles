call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set nobackup
set nocompatible
set number
set hlsearch
set bs=2
set tabstop=2
set shiftwidth=2
"set guifont=Andale\ Mono:h12
set guifont=Inconsolata:h14
set expandtab
runtime! macros/matchit.vim
" set number

let mapleader = ","
set wildmenu
set notitle
set scrolloff=3

au BufRead,BufNewFile *.js set ft=javascript.jquery

set list
set listchars=tab::\ ,eol:¬

if has("autocmd")
  autocmd FileType javascript.jquery setlocal ts=2 sts=2 sw=2 expandtab
  filetype plugin indent on

  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


if &t_Co > 2 || has("gui_running")
  "colorscheme tictoc
  colorscheme blackboard
  syntax on

  set go-=T
endif

map <C-a> :Ack 
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

if has ("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Always start on the first line in git commits
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

:silent exe "g:flog_enable"

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>
