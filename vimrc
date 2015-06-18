" Init
execute pathogen#infect()

" ------------------------------------------------------------------

" Keep backup files out of the way
set backupdir=~/.tmp
set directory=~/.tmp

" Don't act like vi
set nocompatible

" Use line numbers
set number

" (Don't) Highlight search results
set nohlsearch

" Highlight the current cursor line
set cursorline

" When tabbing, insert spaces instead
set expandtab
set bs=2
set tabstop=2
set shiftwidth=2

" When opening a file, tabbing will show all matches
set wildmode=longest,list,full
set wildmenu

" Don't set the terminal window title
set notitle

" Minimum number of lines to keep from the bottom of the screen
set scrolloff=2

" Disable code folding
set nofoldenable

" Don't wrap lines
set nowrap


" Always show status bar
set laststatus=2

" Assume the /g flag on :s substitutions to replace all matches in a line
" set gdefault

" tmux settings
set mouse=a
set ttymouse=xterm2

" GUI and theme settings
"let g:solarized_visibility="medium"
"let g:solarized_diffmode="high"
"set background=light " or dark
"colorscheme solarized
set background=dark
"colorscheme molokai
colorscheme Tomorrow-Night-Eighties

if has("gui_running")
  set guifont=Envy\ Code\ R:h18
  set fuoptions=maxvert,maxhorz
  set go-=T " Hide toolbars
endif

" Yank and Paste go to system clipboard
set clipboard=unnamed

" Display hidden characters
set list
set listchars=tab::\ ,eol:¬

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1

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

  " Treat ejs files like html
  au BufRead,BufNewFile *.ejs setfiletype html

  " Treat php files as... php
  au BufRead,BufNewFile *.php setfiletype php

  " Format xml files
  au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

  " Format Dockerfile comments
  au FileType dockerfile set commentstring=#\ %s

  " When loading text files, wrap them and don't split up words.
  au BufNewFile,BufRead *.txt setlocal wrap
  au BufNewFile,BufRead *.txt setlocal lbr

  " Format Go files with horrible big ugly tabs
  au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
endif

" Merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  split
  execute "buffer " . bufferName
endfunction

nmap <C-W>u :call MergeTabs()<CR>

" Disable arrow keys (aiee)
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Hardcore disabling
" noremap h <nop>
" noremap j <nop>
" noremap k <nop>
" noremap l <nop>

" ------------------------------------------------------------------

vmap <Leader>b :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
map <Leader>bb :!bundle install<cr>
map <Leader>gac :Gcommit -m -a ""<LEFT>
map <Leader>gc :Gcommit -m ""<LEFT>
map <Leader>gs :Gstatus<CR>

map <Leader>o :call RunCurrentLineInTest()<CR>
map <Leader>t :w<cr>:call RunCurrentTest()<CR>

" Edit another file in the same directory as the current file
" " uses expression to extract path from current file's path
map <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>

map <C-t> <esc>:tabnew<CR>
map <C-x> <C-w>c
map <C-n> :cn<CR>
map <C-p> :cp<CR>map <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>m :Rmodel

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
" Rename current file (thanks Gary Bernhardt, via r00k)

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <Leader>n :call RenameFile()<cr>

" ------------------------------------------------------------------
"
" Plugins
"
" Replace Ack with Ag
let g:ackprg = 'ag --nogroup --nocolor --column'

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

" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Vim Plugin setup for Go
" Some Linux distributions set filetype in /etc/vimrc.
" Clear filetype flags before changing runtimepath to force Vim to reload them.
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on
