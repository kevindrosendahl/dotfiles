" Colors
syntax enable                               " syntax highlighting
set background=dark
colorscheme hybrid_reverse

" Spacing 
set tabstop=4                               " number of visual spaces per TAB
set softtabstop=4                           " number of spaces in tab when editing
set shiftwidth=4
set noexpandtab
set autoindent

" UI
set number relativenumber                   " line numbers
set cursorline                              " show a visual line under the cursor's current line
set showmatch                               " show the matching part of the pair for [] {} and ()
let python_highlight_all = 1                " enable all Python syntax highlighting features
set wildmenu                                " visual autocomplete for command menu
set lazyredraw                              " redraw only when we need to
set colorcolumn=80,120

" Searching
set incsearch                               " searches as characters are entered
set hlsearch                                " highlight matches
nnoremap <leader><space> :nohlsearch<CR>    " turn off search highlight

" Deleting
set backspace=indent,eol,start
