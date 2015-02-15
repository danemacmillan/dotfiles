set nocompatible              " be iMproved, required
filetype on                   " required for compatibility with Mac OS X, See https://github.com/gmarik/Vundle.vim/issues/167#issuecomment-51679609
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.

Plugin 'Solarized'
Plugin 'tpope/vim-fugitive'
"Plugin 'Command-T'
"Plugin 'SuperTab'
Plugin 'kien/ctrlp.vim'
Plugin 'closetag.vim'
Plugin 'Tagbar'
Plugin 'delimitMate.vim'
Plugin 'elzr/vim-json'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'airblade/vim-gitgutter'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Map Vundle commands
nnoremap <leader>pl :PluginList<CR>
nnoremap <leader>pi :PluginInstall!<CR>
nnoremap <leader>ps :PluginSearch!<Space>
nnoremap <leader>pc :PluginClean!<CR>

" Use the Solarized Dark theme
" Installed using Vundler (see above)
" .vimrc typically throws an error about this the first time Vundler is
" run, so suppress the message so the plugins install without interruption.
"silent! set background=dark
silent! set background=dark
silent! colorscheme solarized

" Map command-T
noremap <leader>o <Esc>:CommandT<CR>
noremap <leader>O <Esc>:CommandTFlush<CR>
noremap <leader>m <Esc>:CommandTBuffer<CR>

" Map Tagbar
let g:tagbar_usearrows = 1
nnoremap <F8> :TagbarToggle<CR>

" Map NERDTREE
nnoremap <leader>n :NERDTreeToggle<CR>

" Customize Airline
"https://github.com/bling/vim-airline/wiki/FAQ
let g:airline_powerline_fonts = 1
let g:airline_theme= 'dark'

" CtrlP
let g:ctrlp_working_path_mode = 'ra'

" Toggle annoying paste indenting
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Pasting between different systems when line numbers are visible means that
" they will be included in the paste. This will strip them. Only strip 
" whitespace before (from 0 to 2) and after number (0 to 1). Anything more
" greedy can result in undesired replacements.
nnoremap <F3> :%s/^\s\{0,2\}\d\+\s\?//<CR>

" Toggle line number visibility for copying from other systems with mouse.
nnoremap <F4> :set invnumber<CR>

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
set shiftwidth=2
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
"
set linespace=0

" Set and show column at 80 characters
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Use relative line numbers
"if exists("&relativenumber")
"	set relativenumber
"	au BufReadPost * set relativenumber
"endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
"function! StripWhitespace()
""	let save_cursor = getpos(".")
""	let old_query = getreg('/')
""	:%s/\s\+$//e
""	call setpos('.', save_cursor)
""	call setreg('/', old_query)
"endfunction
"noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Treat extensionless files as bash scripts.
au BufRead,BufNewFile * setfiletype sh

" When invoking dotfiles through vagrant provisioning script, Vundler throws a
" pair of warnings:
" Vim: Warning: Output is not to a terminal 
" Vim: Warning: Input is not from a terminal
" https://stackoverflow.com/questions/16517568/vim-exec-command-in-command-line-and-vim-warning-input-is-not-from-a-terminal
"au StdinReadPost * set buftype=nofile

