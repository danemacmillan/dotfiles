set ai " always set autoindenting on
set backup " keep a backup file
set number
set syntax=on
set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ [%{(&fenc==\"\"?&enc:&fenc)}]\ [%{&ff}]\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ ln:%l\/%L\ col:%c%V\ pos:%o\ %P
set background=dark
colorscheme zellner
set fileencodings=utf-8
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=2
set tabstop=2
set title
set nowrap
set ignorecase
set smartcase
set wildmenu
highlight Pmenu ctermfg=0 ctermbg=3
highlight PmenuSel ctermfg=0 ctermbg=7
"set colorcolumn=80 "only in vim <7.3
