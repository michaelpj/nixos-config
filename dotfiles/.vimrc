" toggle NERDtree
nmap <Leader>n :NERDTreeToggle<CR>

" NERDtree directory stuff
let NERDTreeChDirMode=2

nmap <Leader>gs :Gstatus<CR>

" apparently I need this to get powerline to work
set laststatus=2

" highlight basic types in Haskell
let g:hs_highlight_types=1

" highlight booleans in Haskell
let g:hs_highlight_boolean=1

" BASICS

" try this for esc
inoremap jj <Esc> 

" fix for slow timeout on esc in insert mode
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

" leader mapped to ,
"let mapleader = ","

" turn off compatibility mode for vi (seriously)
set nocompatible

" show line numbers
set number

" syntax highlighting on
syntax on

" force syntax highlighting to sync from start of file
syntax sync fromstart

" enable filetype detection and language-dependent indenting.
filetype plugin on
filetype indent on

" completion
set omnifunc=syntaxcomplete#Complete

" apparently this stops some security problems
set modelines=0

" tab settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set shiftround
set smarttab

set encoding=utf-8

" nicer split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" enable the mouse
set mouse=a

" switch buffers without having to save
set hidden

" sane backspace behaviour
set backspace=indent,eol,start

" no swap files or backup
set noswapfile
set nobackup

" automatically change working directory to location of current file
set autochdir

" fold based on syntax, if we have it
set foldmethod=syntax
set foldnestmax=1
set foldlevel=20

" don't show the toolbar
set guioptions-=T

" make tilde (invert case) behave like an operator
set tildeop

" VISUAL

" set font
if has("gui_running")
  if has("gui_gtk2")
    set guifont=DejaVu\ Sans\ Mono\ 12
  elseif has("gui_win32")
    set guifont=DejaVu\ Sans\ Mono:h11:cANSI
  endif
endif

set display=lastline
set t_Co=256
" colorscheme solarized
colorscheme molokai

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" MOVEMENT
" no more arrow keys!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" j and k work sensibly with wrapped lines
nnoremap j gj
nnoremap k gk

" use tab instead of % for going to matching brackets
nnoremap <tab> %
vnoremap <tab> %

" SEARCH

" find the next match while typing
set incsearch

" highlight searches
set hlsearch

" clear search highlighting
nnoremap <Leader><space> :noh<CR>

" use normal regex syntax
nnoremap / /\v
vnoremap / /\v

" sensible case-sensitivity: none if search string is all lower-case
set ignorecase
set smartcase


" COMMANDS

" make semicolon work for commands
"nnoremap ; :

" insert new lines without leaving normal mode
"nmap <S-Enter> O<Esc>
"nmap <CR> o<Esc>

" delete (surrounding) function application
nmap <Leader>df lbdt(ds)
nmap <Leader>dsf ds)db

" vimrc editing and sourcing
nmap <Leader>e :e ~/.vimrc<CR>
nmap <Leader>s :so ~/.vimrc<CR>

" toggle relative line numbers
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <Leader>rn :call NumberToggle()<CR>

" better copying and pasting to/from external sources
nnoremap <leader>y "+y
vnoremap <leader>y "+y

nnoremap <leader>Y "+Y
vnoremap <leader>Y "+Y

nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap <leader>P "+P
vnoremap <leader>P "+P

" MISC

" ctags locations - look all the way up the tree
set tags=./tags;/
nnoremap <C-]> g<C-]>
