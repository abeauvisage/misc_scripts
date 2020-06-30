" Plugins List
call plug#begin('~/.vim/plugged')
	" UI related
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'altercation/vim-colors-solarized'

    " autocompletion and indentation
    " Plug 'ycm-core/YouCompleteMe'
    " Plug 'rdnetto/YCM-Generator', {'branch':'stable'}
    Plug 'Shougo/deoplete.nvim', {'do':'UpdateRemotePlugins'}
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'Yggdroot/indentLine'
    Plug 'vim-scripts/indentpython.vim'
    Plug 'tmhedberg/SimpylFold'
    Plug 'Townk/vim-autoclose'

    " Syntax check and autoformat
    Plug 'vim-syntastic/syntastic'
    Plug 'nvie/vim-flake8'
    Plug 'Chiel92/vim-autoformat'

    " directory search and file switching
    Plug 'vim-scripts/a.vim'
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'majutsushi/tagbar'
    Plug '~/.fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'yuki-ycino/fzf-preview.vim'

    " Console
    Plug 'skywind3000/asyncrun.vim'
    " Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
    Plug 'puremourning/vimspector'
    " Plug 'vim-vdebug/vdebug'
    " Plug 'gotcha/vimpdb'

    " git plugin
    " Plug 'tpope/vim-fugitive'

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
    au BufRead,BufNewFile *.py,*.pyw,*.c,*.cpp,*.h match BadWhitespace /\s\+$/

    " Go to definition
    function! GotoDefinition()
    let n = search("\\<".expand("<cword>")."\\>[^(]*([^)]*)\\s*\\n*\\s*{")
    endfunction

    " Shortcuts
        " General
            noremap <C-y> "+y
            noremap <C-p> "+p

            map <C-RightMouse> <S-C>
        " Normal mode
            nnoremap <A-Down> dd p
            nnoremap <A-Up> dd<Up>P
            nnoremap <C-Down> 5<Down>
            nnoremap <C-Up> 5<Up>
            nnoremap <C-Right> 1w
            nnoremap <C-Left> 1b
            nnoremap <BS> :noh<CR>
            " Save and quit
            nnoremap <C-S> :w<CR>
            nnoremap <C-Q> :q<CR>
            " Toogle
            nmap <C-n> :NERDTreeToggle<CR>
            " nmap <S-N> :NERDTree %<CR>
            nmap <C-m> :TagbarToggle<CR>
            " Show file name
            nnoremap <F4> :echo @%<CR>
            " Refresh current file
            nnoremap <F5> :e<CR>
            " GoTo definition
            " nnoremap <F8> :YcmCompleter GoTo<CR>
            map <F8> :call GotoDefinition()<CR>
            imap <F8> <c-o>:call GotoDefinition()<CR>
            " Go back to previous file
            nnoremap <F7> :e#<CR>
            " Switch header/cpp
            nnoremap <F9> :A<CR>
            " Duplicate line
            nnoremap <C-D> yyp
            " Open file in a new window
            " nnoremap <C-O> :vert new 
            " Open fzf
            nnoremap <C-F> :FZF<CR>
            noremap <C-B> :Buffers<CR>
            nnoremap <S-F> :FZF -q 'cd **'<CR>
            nnoremap <C-Z> <Undo>
            " comment line
            nmap <C-\> <Plug>NERDCommenterToggle

        " Visual block
            vmap <C-\> <Plug>NERDCommenterToggle
            vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

        " Insert mode
            inoremap <C-S> <ESC>:w<CR>
            inoremap <C-Z> <Undo>

" UI configuration

	syntax on
	syntax enable

	" Solarized
    set background=dark
    colorscheme solarized
    highlight ColorColumn ctermbg=darkgrey
    let g:solarized_termtrans = 0

	" True Color Support if it's avaiable in terminal
    " if has("termguicolors")
    " set termguicolors
    " endif

    " Spell check
    au BufRead,BufNewFile *.py,*.pyw,*.c,*.cpp,*.h,*.js,*.html,*.css,*.m setlocal spell spelllang=en_us

" Navigation

    map <F1> :bprevious<CR>
    map <F2> :bnext<CR>
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
    set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    " PEP8 python indentation
    autocmd FileType python setlocal ts=4 sts=4 sw=4 tw=79 expandtab autoindent fileformat=unix colorcolumn=81
    " C/C++ indentation
    autocmd FileType c++ setlocal ts=4 sts=4 sw=4 tw=79 expandtab autoindent fileformat=unix colorcolumn=81
    " Web-based indentation
    au BufNewFile,BufRead *.js, *.html, *.css
        \ set tabstop=2
        \ set softtabstop=2
        \ set shiftwidth=2

" Plugins

    " NERDTree
    " autocmd vimenter * NERDTree %

    " vim-fugitive (git)
    "autocmd FileType gitcommit setlocal spell

    " help YCM
    " let g:ycm_autoclose_preview_window_after_completion=1
    " let g:ycm_max_num_candidates=10
    " let g:ycm_min_num_of_chars_for_completion = 3

    " Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:python3_host_prog  = '/home/axebea/Documents/madame-web/tools/venv/bin/python3'

    " Airline
    let g:airline_left_sep  = ''
    let g:airline_right_sep = ''

    " NERDCommenter
    let g:NERDSpaceDelims = 1
    let g:NERDCompactSexyComs = 1
    let g:NERDDefaultAlign = 'left'

    " CoC
"     set cmdheight=2
"     set updatetime=300
"     set shortmess+=c
"     set signcolumn=yes

" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" inoremap <silent><expr> <c-space> coc#refresh()
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" " Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" " Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" call fzf_preview#window#create_centered_floating_window() " Function to display the floating window used by this plugin

" " Example
" call fzf#run({'source':  '/home/axebea', 'sink':   'edit', 'window': 'call fzf_preview#window#create_centered_floating_window()'})

" Add fzf quit mapping
let g:fzf_preview_quit_map = 1

" Use floating window (for neovim)
let g:fzf_preview_use_floating_window = 1

" Commands used for fzf preview.
" The file name selected by fzf becomes {}
let g:fzf_preview_command = 'head -100 {-1}'                       " Not installed ccat and bat
" let g:fzf_preview_command = 'bat --color=always --style=grid {-1}' " Installed bat
" let g:fzf_preview_command = 'ccat --color=always {-1}'             " Installed ccat

" Commands used for binary file
let g:fzf_binary_preview_command = 'echo "{} is a binary file"'

" Commands used to get the file list from project
let g:fzf_preview_filelist_command = 'git ls-files --exclude-standard'               " Not Installed ripgrep
" let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"' " Installed ripgrep

" Commands used to get the file list from git reposiroty
let g:fzf_preview_git_files_command = 'git ls-files --exclude-standard'

" Commands used to get the file list from current directory
let g:fzf_preview_directory_files_command = 'rg --files --hidden --follow --no-messages -g \!"* *"'

" Commands used to get the git status file list
let g:fzf_preview_git_status_command = "git status --short --untracked-files=all | awk '{if (substr($0,2,1) !~ / /) print $2}'"

" Commands used for project grep
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading'

" Commands used for preview of the grep result
let g:fzf_preview_grep_preview_cmd = expand('<sfile>:h:h') . '/bin/preview_fzf_grep'

" Keyboard shortcuts while fzf preview is active
let g:fzf_preview_preview_key_bindings = 'ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview'

" Specify the color of fzf
let g:fzf_preview_fzf_color_option = ''

" Keyboard shortcut for opening files with split
let g:fzf_preview_split_key_map = 'ctrl-x'

" Keyboard shortcut for opening files with vsplit
let g:fzf_preview_vsplit_key_map = 'ctrl-v'

" Keyboard shortcut for opening files with tabedit
let g:fzf_preview_tabedit_key_map = 'ctrl-t'

" Keyboard shortcut for building quickfix
let g:fzf_preview_build_quickfix_key_map = 'ctrl-q'

" Command to be executed after file list creation
let g:fzf_preview_filelist_postprocess_command = ''
" let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" ls —color'          " Use dircolors
" let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" exa --color=always' " Use exa

" Use vim-devicons
let g:fzf_preview_use_dev_icons = 0

" devicons character width
let g:fzf_preview_dev_icon_prefix_length = 2

" DEPRECATED
" fzf window layout
let g:fzf_preview_layout = 'top split new'

" DEPRECATED
" Rate of fzf window
let g:fzf_preview_rate = 0.3

" DEPRECATED
" Key to toggle fzf window size of normal size and full-screen
let g:fzf_full_preview_toggle_key = '<C-s>'
