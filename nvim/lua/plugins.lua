local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- UI related
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ishan9299/nvim-solarized-lua'

-- directory search 
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'majutsushi/tagbar'
Plug 'nvim-telescope/telescope.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

-- lsp
Plug 'neovim/nvim-lspconfig'

-- Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'onsails/lspkind-nvim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

-- AI assistance
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'zbirenbaum/copilot.lua'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug('yetone/avante.nvim', { ['branch'] = 'main', ['do'] = 'make' })

-- Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug "rcarriga/nvim-dap-ui"
Plug "nvim-neotest/nvim-nio"
Plug "theHamsta/nvim-dap-virtual-text"

vim.call('plug#end')

-- UI and theme --

-- Solarized
vim.o.background = "dark"
vim.g.solarized_termcolours = 16
vim.g.solarized_contrast = true
vim.cmd('colorscheme solarized')

vim.cmd('highlight ColorColumn ctermbg=darkgrey')
vim.cmd('highlight ExtraWhitespace ctermbg=red guibg=darkred') 

require("Comment").setup()
require('neo-tree').setup({})
require('telescope').load_extension('fzf')

-- LSP and Autocompletion --

vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    formatting = {
        format = lspkind.cmp_format(),
    },
    snippet = {
        expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
    end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<M-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<Down>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<Up>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp_signature_help' },
            { name = 'nvim_lsp' },
            { name = 'ultisnips' },
        },
        {
            { name = 'buffer' },
        }
    ),
})

local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=true }

    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.keymap.set('n', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.keymap.set('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    vim.keymap.set('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup("autoformatting_" .. bufnr, {clear=true}),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
            end,
        })
    end
end

vim.lsp.set_log_level("off")
vim.lsp.config("clangd", {on_attach = on_attach})
--vim.lsp.config("pyright", {on_attach = on_attach, settings={analysis = {autoSearchPaths = true, diagnosticMode = "openFilesOnly", useLibraryCodeForTypes = true, extraPaths = {"~/.local/lib/python3.14"}}}})
vim.lsp.enable("clangd")
vim.lsp.enable("pyright")
vim.lsp.enable("jsonls")
vim.lsp.enable("dockerls")
--vim.lsp.enable("bzl")
vim.lsp.enable('bazelrc_lsp')


-- DAP debugging --

local dap = require("dap")
local dap_python = require('dap-python')
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_virtual_text.setup()

ui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

dap.listeners.before.attach.dapui_config = function()
    ui.open()
end
dap.listeners.before.launch.dapui_config = function()
    ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
end

local dap = require('dap')
local dap_python = require('dap-python')

-- Path to your Python interpreter (adjust as needed)
dap_python.setup('~/.pyenv/shims/python3')

-- Optional: Set up keybindings or UI (e.g., nvim-dap-ui)
require('dapui').setup()

dap.configurations = {
    python = {
        {
            -- The first three options are required by nvim-dap
            type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = "launch",
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                    return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                    return cwd .. "/.venv/bin/python"
                else
                    return "/usr/bin/python3"
                end
            end,
        },
    },
}

dbg_toggle_bp = function()
    require("dap").toggle_breakpoint()
end
dbg_continue = function()
    require("dap").continue()
end
dbg_step_into = function()
    require("dap").step_into()
end
dbg_step_over = function()
    require("dap").step_over()
end
dbg_quit = function()
    require("dap").terminate()
    require("dapui").close()
    require("nvim-dap-virtual-text").toggle()
end

vim.keymap.set('n', '<Leader>dt', dbg_toggle_bp)
vim.keymap.set('n', '<Leader>dc', dbg_continue)
vim.keymap.set('n', '<Leader>di', dbg_step_into)
vim.keymap.set('n', '<Leader>do', dbg_step_over)
vim.keymap.set('n', '<Leader>dq', dbg_quit)

require("copilot").setup()
require('avante').setup({})
