" Plugins List

    call plug#begin('~/.vim/plugged')
    " UI related
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'altercation/vim-colors-solarized'

    " autocompletion and indentation
        Plug 'Shougo/deoplete.nvim', {'do':'UpdateRemotePlugins'}
        Plug 'deoplete-plugins/deoplete-lsp'
        Plug 'Yggdroot/indentLine'
        Plug 'vim-scripts/indentpython.vim'
        Plug 'tmhedberg/SimpylFold'
        Plug 'Townk/vim-autoclose'
        Plug 'neovim/nvim-lspconfig'
        Plug 'weilbith/nvim-lsp-smag'   " Server Smart Tags
        Plug 'Chiel92/vim-autoformat'   " Autoformat on save

    " directory search and file switching
        " Plug 'vim-scripts/a.vim'
        " Plug 'derekwyatt/vim-fswitch'
        Plug 'preservim/nerdtree'
        Plug 'preservim/nerdcommenter'
        Plug 'majutsushi/tagbar'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        " Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release/rpc'}

    " Console
        Plug 'skywind3000/asyncrun.vim'
        " Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
        Plug 'puremourning/vimspector'
        " Plug 'vim-vdebug/vdebug'
        " Plug 'gotcha/vimpdb'
        Plug 'cpiger/NeoDebug'

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


" Shortcuts

    " General
        noremap <C-y> "+y
        noremap <C-p> "+p
        map <C-RightMouse> <S-C>
        nnoremap <C-Z> <Undo>
        nnoremap <C-E> :vsplit

    " From normal mode
        nnoremap <A-Down> dd p
        nnoremap <A-Up> dd<Up>P
        nnoremap <C-Down> 5<Down>
        nnoremap <C-Up> 5<Up>
        nnoremap <C-Right> 1w
        nnoremap <C-Left> 1b
        nnoremap <BS> :noh<CR>

        " Save and quit
        nnoremap <C-S> :w<CR>
        nnoremap <S-S> :noautocmd w<CR>
        nnoremap <C-Q> :q<CR>
        " Toogle NERDTree
        nmap <C-n> :NERDTreeToggle<CR>
        " nmap <S-N> :NERDTree %<CR>
        nmap <C-m> :TagbarToggle<CR>
        " Show file name
        nnoremap <F4> :echo @%<CR>
        " Refresh current file
        nnoremap <F5> :e<CR>
        " Go to definition
        nnoremap <F9> <C-]>
        " Go back from definition
        nnoremap <F10> <C-t>
        " Go back to previous file
        nnoremap<F12> <C-W>
        nnoremap <F6> :e#<CR>
        " Switch header/cpp
        nnoremap <F8> :ClangdSwitchSourceHeader<CR>
        " Duplicate line
        nnoremap <C-D> yyp
        " Open fzf
        " nmap <C-F> [fzf-p]
        " xmap <C-F> [fzf-p]
        " nnoremap <silent> [fzf-p]gst    :<C-u>FzfPreviewGitStatusRpc<CR>
        " nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStashesRpc<CR>
        " nnoremap <silent> [fzf-p]lg    :<C-u>FzfPreviewGitLogsRpc<CR>
        " nnoremap <silent> [fzf-p]b    :<C-u>FzfPreviewGitStashesBranchesRpc<CR>
        " nnoremap <silent> [fzf-p]<C-F> :<C-u>FzfPreviewProjectFilesRpc<CR>
        " nnoremap <silent> [fzf-p]<C-F> :GFiles<CR>
        " nnoremap <silent> [fzf-p]f :Files<CR>

        nnoremap <C-F> :Files<CR>
        nnoremap <C-G> :GFiles<CR>
        " noremap <C-B> :FzfPreviewBuffersRpc<CR>
        noremap <C-B> :Buffers<CR>

        " comment line
        nmap <C-\> <Plug>NERDCommenterToggle

    " From visual block
        vmap <C-\> <Plug>NERDCommenterToggle
        vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

    " From insert mode
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
        "     set termguicolors
        " endif


" Spell check

    au BufRead,BufNewFile *.py,*.pyw,*.c,*.cpp,*.h,*.js,*.html,*.css,*.m,*.md setlocal spell spelllang=en_us
    highlight ExtraWhitespace ctermbg=red guibg=dtarkred
    match ExtraWhitespace /\s\+$/
    au BufWinEnter * match ExtraWhitespace /\s\+$/
    au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    au InsertLeave * match ExtraWhitespace /\s\+$/
    au BufWinLeave * call clearmatches()
    highlight BadWhitespace ctermbg=red guibg=dtarkred


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


" Indentation

    "General indentation
    set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    " Black python indentation
    autocmd FileType python setlocal ts=4 sts=4 sw=4 tw=100 expandtab autoindent fileformat=unix colorcolumn=100
    " Markdown
    autocmd FileType markdown setlocal ts=4 sts=4 sw=4 tw=79 expandtab autoindent fileformat=unix colorcolumn=79
    " C/C++ indentation
    autocmd FileType cpp setlocal ts=4 sts=4 sw=4 tw=100 expandtab autoindent fileformat=unix colorcolumn=100
    " Web-based indentation
    au BufNewFile,BufRead *.js, *.html, *.css
                \ set tabstop=2
                \ set softtabstop=2
                \ set shiftwidth=2


" Plugins

    " Autoformat
        let g:autoformat_verbosemode=1
        noremap <F6> :AutoformatLine<CR>
        au BufWrite *.py,*.cpp,*.bazel,*.js :Autoformat
        let g:formatdef_autopep8 = "'autopep8 - -a -a'"
        let g:formatters_python = ['black']
        let g:formatters_cpp = ['clangformat']


    " NERDTree
        " autocmd vimenter * NERDTree %
        nnoremap <S-M> :NERDTreeRefreshRoot<CR>

    " Deoplete
        let g:deoplete#enable_at_startup = 1
        let g:python3_host_prog  = '/usr/bin/python3'

    " Airline
        let g:airline_left_sep  = ''
        let g:airline_right_sep = ''

    " NERDCommenter
        let g:NERDSpaceDelims = 1
        let g:NERDCompactSexyComs = 1
        let g:NERDDefaultAlign = 'left'

    " " FZF
    "     " Add fzf quit mapping
    "     let g:fzf_preview_quit_map = 1
    "     " Use floating window (for neovim)
    "     let g:fzf_preview_use_floating_window = 1
    "     " Commands used for fzf preview.
    "     " The file name selected by fzf becomes {}
    "     let g:fzf_preview_command = 'head -100 {-1}'                       " Not installed ccat and bat
    "     " let g:fzf_preview_command = 'bat --color=always --style=grid {-1}' " Installed bat
    "     " let g:fzf_preview_command = 'ccat --color=always {-1}'             " Installed ccat
    "     " Commands used for binary file
    "     let g:fzf_binary_preview_command = 'echo "{} is a binary file"'
    "     " Commands used to get the file list from project
    "     let g:fzf_preview_filelist_command = 'git ls-files --exclude-standard'               " Not Installed ripgrep
    "     " Commands used to get the file list from git reposiroty
    "     let g:fzf_preview_git_files_command = 'git ls-files --exclude-standard'
    "     " Commands used to get the file list from current directory
    "     let g:fzf_preview_directory_files_command = 'rg --files --hidden --follow --no-messages -g \!"* *"'
    "     " Commands used to get the git status file list
    "     let g:fzf_preview_git_status_command = "git status --short --untracked-files=all | awk '{if (substr($0,2,1) !~ / /) print $2}'"
    "     " Commands used for project grep
    "     let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading'
    "     " Commands used for preview of the grep result
    "     let g:fzf_preview_grep_preview_cmd = expand('<sfile>:h:h') . '/bin/preview_fzf_grep'
    "     " Keyboard shortcuts while fzf preview is active
    "     let g:fzf_preview_preview_key_bindings = 'ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview'
    "     " Specify the color of fzf
    "     let g:fzf_preview_fzf_color_option = ''
    "     " Keyboard shortcut for opening files with split
    "     let g:fzf_preview_split_key_map = 'ctrl-x'
    "     " Keyboard shortcut for opening files with vsplit
    "     let g:fzf_preview_vsplit_key_map = 'ctrl-v'
    "     " Keyboard shortcut for opening files with tabedit
    "     let g:fzf_preview_tabedit_key_map = 'ctrl-t'
    "     " Keyboard shortcut for building quickfix
    "     let g:fzf_preview_build_quickfix_key_map = 'ctrl-q'
    "     " Command to be executed after file list creation
    "     let g:fzf_preview_filelist_postprocess_command = ''
    "     " Use vim-devicons
    "     let g:fzf_preview_use_dev_icons = 0
    "     " devicons character width
    "     let g:fzf_preview_dev_icon_prefix_length = 2


    " LSP config
        lua require'lspconfig'.clangd.setup{}
        lua require'lspconfig'.pylsp.setup{}
