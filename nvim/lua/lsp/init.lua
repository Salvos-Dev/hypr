require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      workspace = {
        library = {
          "${3rd}/luv/library",
          "${3rd}/love2d/library",
          "/usr/local/share/lua/5.1",
          "/usr/share/lua/5.1",
        },
      },
      diagnostics = {
        globals = { "vim" }, -- Don't warn about the global 'vim' object
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

require('lspconfig').cssls.setup{}
require('lspconfig').html.setup{}
require('lspconfig').pyright.setup{}
require('lspconfig').clangd.setup{}

require('lspconfig').rust_analyzer.setup {
  -- Server-specific settings.
  settings = {
    ["rust-analyzer"] = {
      -- It's good practice to enable these for a better experience
      cargo = {
        loadOutDirsFromCheck = true, -- Load build script results
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
        ignored = {},
      },
      -- If rust-analyzer is not found in your PATH automatically,
      -- you might need to specify the path to the binary:
      -- server = {
      --   path = "/path/to/your/rust-analyzer/binary",
      -- },
    }
  },
  -- This function runs when the LSP attaches to a buffer.
  -- It's where you typically set keymaps for LSP actions.
  on_attach = function(client, bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr -- Map keybinding only for the current buffer
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Essential keymaps for LSP functionality
    map('n', 'K', vim.lsp.buf.hover, { desc = "LSP Hover" })
    map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
    map('n', 'gr', vim.lsp.buf.references, { desc = "Find References" })
    map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action" })
    map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format Code" })
    map('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })

    print("rust-analyzer attached to buffer: " .. bufnr)
    -- You can add a notification or a status line update here if you like
  end,
  -- If you use nvim-cmp for completion, you would add capabilities here.
  -- For just getting it working, this is often not strictly necessary initially.
  -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

