-- General
local opt = { noremap = true, silent = true, nowait = true }
vim.keymap.set('n', '<C-Z>', '<Undo>')
vim.keymap.set('i', '<C-Z>', '<Undo>')

--copy/paste/duplicate
vim.keymap.set('n', '<C-C>', '"+y')
vim.keymap.set('n', '<C-P>', '"+p')
vim.keymap.set('n', '<C-D>', 'yyp')

vim.keymap.set('n', '<C-S>', ':w<CR>', opt)
vim.keymap.set('n', '<S-S>', ':noautocommand w<CR>')
vim.keymap.set('i', '<C-S>', '<ESC>:w<CR>')
vim.keymap.set('n', '<C-Q>', ':q<CR>')
vim.keymap.set('n', '<C-Q>', '<ESC>:q<CR>')
vim.keymap.set('n', '<BS>', ':noh<CR>')

-- Buffers
vim.keymap.set('n', '<C-E>', ':vsplit<CR>')

-- Tree structure
vim.keymap.set('n', '<C-N>', ':Neotree filesystem toggle<CR>')
vim.keymap.set('n', '<leader>gst', ':Neotree git_status toggle<CR>')


-- Comment
vim.keymap.set('n', '<C-\\>', 'gcc')

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-F>', builtin.find_files, {})
vim.keymap.set('n', '<C-G>', builtin.git_files, {})
vim.keymap.set('n', '<C-B>', builtin.buffers, {})
vim.keymap.set('n', '<C-R>', builtin.command_history, {})
vim.keymap.set('n', '<C-H>', builtin.git_commits, {})
vim.keymap.set('n', '<leader>grep', builtin.live_grep, {})
