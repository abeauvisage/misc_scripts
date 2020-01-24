" Plugins List
call plug#begin('~/.vim/plugged')
	" UI related
    Plug 'chriskempson/base16-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'altercation/vim-colors-solarized'

    " autocompletion and indentation
    Plug 'ycm-core/YouCompleteMe'
    Plug 'rdnetto/YCM-Generator'
    Plug 'Yggdroot/indentLine'
    Plug 'vim-scripts/indentpython.vim'
    Plug 'tmhedberg/SimpylFold'
    Plug 'Townk/vim-autoclose'

    " syntax check and autoformat
    Plug 'vim-syntastic/syntastic'
    Plug 'nvie/vim-flake8'
    Plug 'Chiel92/vim-autoformat'

    " directory search and file switching
    Plug 'vim-scripts/a.vim'
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'majutsushi/tagbar'

    " git plugin
    Plug 'tpope/vim-fugitive'

call plug#end()

" Basic Vim config

    set exrc
    set secure
    set number
    set hidden
    set mouse=a
    set noshowmode
    set noshowmatch
    set nolazyredraw
    set encoding=utf-8
    let python_highlight_all=1
    " Turn off backup
    set nobackup
    set noswapfile
    set nowritebackup
    " Search configuration
    set ignorecase                    " ignore case when searching
    set smartcase                     " turn on smartcase
    " clipboard
    set clipboard=unnamed
    " highlight bad white spaces
    highlight BadWhitespace ctermbg=red guibg=dtarkred
    au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
    " Shortcuts
        " save and quit
        nnoremap <C-S> :w<CR>
        nnoremap <C-Q> :q<CR>
        " GoTo definition
        nnoremap <F8> :YcmCompleter GoTo<CR>
        " switch header/cpp
        nnoremap <F9> :A
        nnoremap <C-D> yyp

" UI configuration

	syntax on
	syntax enable
	" GruvBox
	"let base16colorspace=256
	"colorscheme base16-gruvbox-dark-hard
	"set background=dark

	" Solarized
	set background=dark
	colorscheme solarized
	set colorcolumn=80
	highlight ColorColumn ctermbg=darkgrey
 	"let g:solarized_termtrans = 0

	" True Color Support if it's avaiable in terminal
	"if has("termguicolors")
	"set termguicolors
	"endif
	"if has("gui_running")
	"  set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:blocks
	"endif

" Navigation

    "split navigations
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>  

    "Code folding
    set foldmethod=indent
    set foldlevel=99
    nnoremap <space> za
    let g:SimpylFold_docstring_preview=1

    "open includes
    let &path.="src/include,/usr/include/AL,/home/axebea/Documents/src/**,"
    
" Indentation

    "General indentation
    set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab
    " PEP8 python indentation
    autocmd FileType python setlocal ts=4 sts=4 sw=4 tw=79 expandtab autoindent fileformat=unix
    " C/C++ indentation
    autocmd FileType c++ setlocal ts=4 sts=4 sw=4 tw=79 expandtab autoindent fileformat=unix
    " Web-based indentation
    au BufNewFile,BufRead *.js, *.html, *.css
        \ set tabstop=2
        \ set softtabstop=2
        \ set shiftwidth=2

" Plugins

    " NERDTree
    nmap <C-n> :NERDTreeToggle<CR>
    "autocmd vimenter * NERDTree

    " vim-fugitive (git)
    autocmd FileType gitcommit setlocal spell

    " help YCM
    let g:ycm_autoclose_preview_window_after_completion=1
    let g:ycm_max_num_candidates=10
    let g:ycm_min_num_of_chars_for_completion = 3

    " Airline
    let g:airline_left_sep  = ''
    let g:airline_right_sep = ''
