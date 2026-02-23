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
vim.keymap.set('n', '<C-B>', ':Buffers<CR>')
vim.keymap.set('n', '<C-F>',  ':Files<CR>')
vim.keymap.set('n', '<C-G>', ':GFiles<CR>')

-- NERDTree
vim.keymap.set('n', '<C-N>', ':NERDTreeToggle<CR>')
vim.keymap.set('n', '<C-M>', ':TagbarToggle<CR>')

-- NERD Commenter
-- vim.keymap.set('n', '<C-\\', '<Plug>NERDCommenterToggle')
-- vim.keymap.set('v', '<C-\\', '<Plug>NERDCommenterToggle')

-- Comment
vim.keymap.set('n', '<C-\\>', 'gcc')
