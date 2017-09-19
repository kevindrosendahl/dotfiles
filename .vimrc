" Colors 'n' stuff
syntax enable                               " syntax highlighting
colorscheme badwolf

set colorcolumn=80,120

" Spaces 'n' tabs
set tabstop=2                               " number of visual spaces per TAB
set softtabstop=2                           " number of spaces in tab when editing
set shiftwidth=2
set expandtab                               " tabs are spaces
set autoindent

" UI
set number                                  " line numbers
set cursorline                              " show a visual line under the cursor's current line
set showmatch                               " show the matching part of the pair for [] {} and ()
let python_highlight_all = 1                " enable all Python syntax highlighting features
set wildmenu                                " visual autocomplete for command menu
set lazyredraw                              " redraw only when we need to

" Searchin'
set incsearch                               " searches as characters are entered
set hlsearch                                " highlight matches
nnoremap <leader><space> :nohlsearch<CR>    " turn off search highlight

