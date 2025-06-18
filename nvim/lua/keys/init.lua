-- Set leader key
vim.g.mapleader = " "

-- Clear search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Terminal
vim.keymap.set('n', '<leader>ft', '<cmd>ToggleTerm<CR>', {
  noremap = true,
  silent = true,
  desc = "Toggle floating terminal"
})

vim.keymap.set('t', '<leader>ft', '<cmd>ToggleTerm<CR>', {
  noremap = true,
  silent = true,
  desc = "Toggle floating terminal"
})
