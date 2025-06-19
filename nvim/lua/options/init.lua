-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Nerd fonts
vim.g.have_nerd_font = true

-- Clipboard
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

-- Undo history
vim.opt.undofile = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Sign column
vim.opt.signcolumn = 'yes'

-- Active line
vim.opt.cursorline = true

-- Color column
vim.opt.colorcolumn = '100'

-- Update time
vim.opt.updatetime = 250

-- Wait time
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Render whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Scolloff
vim.opt.scrolloff = 10

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Disable dashboard
vim.opt.shortmess:append('I')

-- Terminal
vim.opt.hidden = true

-- Word wrap
vim.opt.wrap = false
