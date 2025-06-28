local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Theme
    { 'ellisonleao/gruvbox.nvim', priority = 1000 , config = true, opts = ... },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "lua", "bash", "python", "markdown" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    -- Lsp
    { 'neovim/nvim-lspconfig' },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
        },
        config = function()
            local cmp = require('cmp') -- You need to require cmp here within the config function

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-e>'] = cmp.mapping.abort(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
            })
        end,
    },

    -- Remove background
    {
        'xiyaowong/transparent.nvim',
    },

    -- Terminal
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true, -- This will run the default setup()
        -- You can also add custom configuration here
        opts = {
            shade_terminals = false,
            direction = 'float',
            highlights = {
                FloatBorder = {
                    guifg = '#b16286'
                },
            },

            float_opts = {
                border = 'rounded',
            },
        }
    },

    -- Tmux integration
    {
        'christoomey/vim-tmux-navigator',
        lazy = false,
    },
})
