-- Configure the LSPs downloaded through Mason

local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- C language server
lspconfig.ccls.setup {
  capabilities = capabilities,
}

-- Bash language server
lspconfig.bashls.setup {
  capabilities = capabilities,
}

-- Python language server
local python_lsp = "pyright"
if python_lsp == "pyright" then
  lspconfig.pyright.setup {
    -- Use the following capabilities to disable pyright diagnostics
    capabilities = {
      textDocument = {
        publishDiagnostics = {
          tagSupport = {
            valueSet = { 2 },
          },
        },
      },
    },
    -- change default settings to make it run faster
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly", -- default to "workspace"
          useLibraryCodeForTypes = true
        }
      }
    },
    -- avoid running pyright on the entire home directory
    -- (https://github.com/microsoft/pyright/issues/4176)
    root_dir = function()
      return vim.fn.getcwd()
    end,
  }
elseif python_lsp == "jedi" then
  lspconfig.jedi_language_server.setup{
    capabilities = capabilities,
  }
else
  lspconfig.pylsp.setup {
    capabilities = capabilities,
    settings = {
      -- configure plugins in pylsp
      pylsp = {
        plugins = {
          pyflakes = {enabled = false},
          pylint = {enabled = false},
          flake8 = {enabled = false},
          pycodestyle = {enabled = false},
        },
      },
    },
  }
end

-- Ruff (python linter) language server
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
lspconfig.ruff.setup {
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

-- LaTeX language server
lspconfig.texlab.setup {
  capabilities = capabilities,
}

-- Rust language server
lspconfig.rust_analyzer.setup{
  capabilities = capabilities,
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ['rust_analyzer'] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
}

-- Lua language server
lspconfig.lua_ls.setup {
  capabilities = capabilities,
}

-- HTML language server
lspconfig.html.setup {
  capabilities = capabilities,
}

-- CSS language server
lspconfig.cssls.setup {
  capabilities = capabilities,
}


-------------------------------------------------------------------------------
-- Global key mappings
-------------------------------------------------------------------------------

-- Use LspAttach autocommand to only map the following keys after the language
-- server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
