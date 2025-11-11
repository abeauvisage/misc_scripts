local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- UI related
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
--Plug 'shaunsingh/solarized.nvim' -- bad plugin
Plug 'ishan9299/nvim-solarized-lua'

-- directory search 
Plug 'preservim/nerdtree'
-- Plug 'preservim/nerdcommenter' -- switch to Comment
Plug 'numToStr/Comment.nvim'
Plug 'majutsushi/tagbar'
Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install']})
Plug 'junegunn/fzf.vim'
-- lsp
Plug 'neovim/nvim-lspconfig'

vim.call('plug#end')

-- Solarized
vim.o.background = "dark"
--vim.g.solarized_termtrans = 0
vim.g.solarized_termcolours = 16
vim.g.solarized_contrast = true
vim.cmd('colorscheme solarized')
--require('solarized').set() -- only used for shaunsingh lua plugin

vim.cmd('highlight ColorColumn ctermbg=darkgrey')
vim.cmd('highlight ExtraWhitespace ctermbg=red guibg=darkred') 

require("Comment").setup()

local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
 
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
 
    local opts = { noremap=true, silent=true }
 
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

local servers = {
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoImportCompletions = "off",
                    }
                }
            },
        root_dir = function(fname)
            local root_files = {
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                'requirements.txt',
                'Pipfile',
                'pyrightconfig.json',
                'venv',
                '.venv',
                }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end
    },
    clangd = {
    },
}

for server_name, configuration in pairs(servers) do
    configuration.on_attach = on_attach
    nvim_lsp[server_name].setup(configuration)
end


