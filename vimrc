" Init

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" ------------------------------------------------------------------

" Don't create backup files
set nobackup
set nowritebackup

" Don't act like vi
set nocompatible

" Use line numbers
set number

" Highlight search results
set hlsearch

" When tabbing, insert spaces instead
set expandtab
set bs=2
set tabstop=2
set shiftwidth=2

" When opening a file, tabbing will show all matches
set wildmenu

" Don't set the terminal window title
set notitle

" Minimum number of lines to keep from the bottom of the screen
set scrolloff=5

" tmux settings
set mouse=a
set ttymouse=xterm2

" GUI and theme settings
let g:solarized_visibility="medium"
set background=dark
colorscheme solarized

if has("gui_running")
  set guifont=Envy\ Code\ R:h16
  set fuoptions=maxvert,maxhorz
  set clipboard=unnamed
  set go-=T " Hide toolbars
endif

" Display hidden characters
set list
set listchars=tab::\ ,eol:¬

" Syntax highlighting
" syntax on
syntax enable

" Keyboard mappings
let mapleader = ","
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
call togglebg#map("<F5>")

" Turn on filetype detection, filetype plugins, indent files
if has("autocmd")
  filetype plugin indent on
endif

" Disable arrow keys (aiee)

noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Hardcore disabling
noremap h <nop>
noremap l <nop>

" ------------------------------------------------------------------
"
" Filetype specific settings
"
if has("autocmd")
  autocmd FileType javascript.jquery setlocal ts=2 sts=2 sw=2 expandtab
  autocmd! BufRead,BufNewFile *.js set ft=javascript.jquery
  autocmd! BufRead,BufNewFile *.json setfiletype json 
endif

" ------------------------------------------------------------------
"
" Plugins
"

" TODO: Not sure what this does. Enables % to jump between tag start/ends?
runtime! macros/matchit.vim

" gist.vim
let g:gist_clip_command = 'pbcopy'

" fugitive.vim
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

  " Close hidden fugitive buffers
  if has("autocmd")
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    autocmd User fugitive
          \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)' |
          \   nnoremap <buffer> .. :edit %:h<CR> |
          \ endif

    autocmd BufReadPost fugitive://* set bufhidden=delete
  endif
