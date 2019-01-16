""
" .vimrc at https://github.com/danemacmillan/dotfiles
"
" Notes:
" <leader> is equal to \

" Only use modern vim.
set nocompatible

filetype plugin indent on

" Vim-Plug
call plug#begin('~/.vim/plugged')
	Plug 'altercation/vim-colors-solarized'
	Plug 'morhetz/gruvbox'
	Plug 'blueshirts/darcula'

	Plug 'editorconfig/editorconfig-vim'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-commentary'
	Plug 'alvan/vim-closetag'
	Plug 'majutsushi/tagbar'
	Plug 'raimondi/delimitmate'
	Plug 'elzr/vim-json'
	Plug 'ntpeters/vim-better-whitespace'
	Plug 'nathanaelkane/vim-indent-guides'
	Plug 'airblade/vim-gitgutter'
	Plug 'ap/vim-css-color'
	Plug 'ervandew/supertab'
	Plug 'mbbill/undotree'
	Plug 'scrooloose/nerdtree'
	Plug 'scrooloose/nerdcommenter'

	Plug '/usr/local/opt/fzf'
	Plug 'junegunn/fzf.vim'

	Plug 'stanangeloff/php.vim'
	Plug 'shawncplus/phpcomplete.vim'
	Plug 'jetbrains/phpstorm-stubs'

	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

" Theme.
set background=dark
colorscheme solarized
"colorscheme gruvbox
"colorscheme darcula
let g:solarized_termcolors=256
let g:gruvbox_contrast_dark = "hard"
" Make invisible characters less prominent.
let g:solarized_visibility = "low"

" Always show status line
set laststatus=2

" Airline
" https://github.com/vim-airline/vim-airline/wiki/FAQ
let g:airline_powerline_fonts = 1
let g:airline_theme= 'solarized'
"let g:airline_theme= 'jellybeans'
" Displaying nice buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Tagbar
let g:tagbar_usearrows = 1
nnoremap <F8> :TagbarToggle<CR>

" NERDTREE
let g:NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeToggle<CR>
" Auto-open.
"au VimEnter *  NERDTree
" Close if only buffer left.
" https://stackoverflow.com/a/4319165/2973534
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open when no file specified.
autocmd StdinReadPre * let g:isReadingFromStdin = 1
autocmd VimEnter * if !argc() && !exists('g:isReadingFromStdin') | NERDTree | endif
" Auto-focus on document.
autocmd VimEnter * wincmd p

" FZF search.
map ; :Files<CR>

" Indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 0
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234

" Better whitespace
let g:strip_whitespace_on_save = 1
nnoremap <leader>s :StripWhitespace<CR>

" Undo tree
let g:undotree_WindowLayout = 1
nnoremap <F5> :UndotreeToggle<CR>
if has("persistent_undo")
	set undodir='~/.vim/undo/'
	set undofile
endif

" Map buffer cycling
set pastetoggle=<F2>
nnoremap <S-Tab> :bprevious<CR>

" Pasting between different systems when line numbers are visible means that
" they will be included in the paste. This will strip them. Only strip
" whitespace before (from 0 to 2) and after number (0 to 1). Anything more
" greedy can result in undesired replacements.
"
" In addition, copying from other systems may also copy the list characters
" (lcs) settings defined in vim. For this .vimrc file, those characters match
" the ones defined later. This mapping will run both search and replaces.
nnoremap <F3> :%s/^\s\{0,2\}\d\+\s\?//e <Bar> %s/➝*·*¬*_*»*▸*$//e<CR>

" Toggle line number visibility for copying from other systems with mouse.
nnoremap <F4> :set invnumber <Bar> :set list!<CR>

" Reload vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" Remap D to behave exactly the same, except also move the next line up. This
" is done by preceding the dd cut mapping with a blackhole register:
" http://vimhelp.appspot.com/change.txt.html#registers
nnoremap <S-d> "_dd

" Set default file format
set ff=unix

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

" Set .viminfo location
set viminfo+=n~/.vim/.viminfo

" Respect modeline in files
set modeline
set modelines=4

" Disable per-directory .vimrc files and disable unsafe commands in them
set noexrc
set secure

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Highlight current line
" The cursorline can be a huge performance hog and slows scrolling to a crawl.
set cursorline
"set nocursorline
set lazyredraw
set ttyfast
set foldlevel=0

" Make tabs as wide as two spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Show “invisible” characters
" triangle-headed rightwards arrow: http://unicode-table.com/en/279D/
set lcs=tab:➝\ ,trail:·,eol:¬,nbsp:_
set list

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Highlight dynamically as pattern is typed
set incsearch

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

" Set title string to just be filename
set titlestring=%t

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

" Start scrolling three lines before the horizontal window border
set scrolloff=10

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Treat extensionless files as bash scripts.
au BufRead,BufNewFile * setfiletype sh

" Jump to the last position when reopening a file.
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" When invoking dotfiles through vagrant provisioning script, Vundler throws a
" pair of warnings:
" Vim: Warning: Output is not to a terminal
" Vim: Warning: Input is not from a terminal
" https://stackoverflow.com/questions/16517568/vim-exec-command-in-command-line-and-vim-warning-input-is-not-from-a-terminal
"au StdinReadPost * set buftype=nofile
