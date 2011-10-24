call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

call togglebg#map("<F5>")

set nobackup
set nocompatible
set number
set hlsearch
set bs=2
set tabstop=2
set shiftwidth=2
set guifont=Envy\ Code\ R:h13
set noantialias
set expandtab
set wildmode=longest,list
runtime! macros/matchit.vim

let mapleader = ","
set wildmenu
set notitle
set scrolloff=3

syntax on
syntax enable

let g:gist_clip_command = 'pbcopy'

au! BufRead,BufNewFile *.js set ft=javascript.jquery
au! BufRead,BufNewFile *.json setfiletype json 

set list
set listchars=tab::\ ,eol:¬

if has("autocmd")
  autocmd FileType javascript.jquery setlocal ts=2 sts=2 sw=2 expandtab
  filetype plugin indent on

  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Fugitive autocmds
  autocmd User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
      \ endif

  autocmd BufReadPost fugitive://* set bufhidden=delete
endif

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

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

if has("gui_running")
  set fuoptions=maxvert,maxhorz
  set clipboard=unnamed
  set go-=T " Hide toolbars
endif

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"if has ("autocmd")
  "autocmd bufwritepost .vimrc source $MYVIMRC
"endif

" Always start on the first line in git commits
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>
" lazy method of appending this onto your .vimrc ":w! >> ~/.vimrc"
" ------------------------------------------------------------------
" this block of commands has been autogenerated by solarized.vim and
" includes the current, non-default Solarized option values.
" To use, place these commands in your .vimrc file (replacing any
" existing colorscheme commands). See also ":help solarized"

" ------------------------------------------------------------------
" Solarized Colorscheme Config
" ------------------------------------------------------------------
let g:solarized_visibility="medium"    "default value is normal
set background=dark
colorscheme solarized
" ------------------------------------------------------------------

" The following items are available options, but do not need to be
" included in your .vimrc as they are currently set to their defaults.

" let g:solarized_termtrans=1
" let g:solarized_degrade=0
" let g:solarized_bold=1
" let g:solarized_underline=1
" let g:solarized_italic=1
" let g:solarized_termcolors=16
" let g:solarized_contrast="normal"
" let g:solarized_diffmode="normal"
" let g:solarized_menu=1

set mouse=a
set ttymouse=xterm2
