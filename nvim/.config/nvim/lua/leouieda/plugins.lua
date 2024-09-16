-- =================================
-- Install plugins using packer.nvim
-- =================================

-- -----------------------
-- Autoinstall packer.nvim
-- -----------------------
local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer. Close and reopen Neovim."
    vim.cmd [[packadd packer.nvim]]
end


-- ---------------
-- Install plugins
-- ---------------
return require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Catpuccin theme
  use {
    "catppuccin/nvim",
    as = "catppuccin" ,
    config = function() require('leouieda.plugins.catppuccin') end,
  }

  -- Comment.nvim: Commenting blocks and lines
  use {
    'numToStr/Comment.nvim',
    config = function() require('leouieda.plugins.comment') end,
  }

  -- Mason (package manager for LSPs)
  -- use {
  --   "williamboman/mason.nvim",
  --   run = ":MasonUpdate", -- :MasonUpdate updates registry contents
  --   config = function() require('leouieda.plugins.mason') end,
  -- }

  -- Git
  -- use {
  --   'tpope/vim-fugitive',
  --   config = function() require('leouieda.plugins.fugitive') end,
  -- }
  -- use {
  --   'lewis6991/gitsigns.nvim',
  --   config = function() require('leouieda.plugins.gitsigns') end,
  -- }

  -- Surrounding characters
  -- use 'tpope/vim-surround'

  -- LaTeX
  -- use {
  --   'lervag/vimtex',
  --   config = function() require('leouieda.plugins.vimtex') end,
  -- }

  -- Webdev
  -- use 'ap/vim-css-color'
  -- use {
  --   'mattn/emmet-vim',
  --    config = function()
  --        vim.g.user_emmet_leader_key = '<C-Z>'
  --    end
  -- }

  -- nvim-tree: File explorer
  -- use {
  --   'nvim-tree/nvim-tree.lua',
  --   config = function() require('leouieda.plugins.nvim-tree') end,
  -- }

  -- lualine.nvim
  -- use {
  --   'nvim-lualine/lualine.nvim',
  --   config = function() require('leouieda.plugins.lualine') end,
  -- }

  -- bufferline
  -- use {
  --   'akinsho/bufferline.nvim',
  --   -- after="catppuccin",
  --   config = function() require('leouieda.plugins.bufferline') end,
  -- }

  -- -- nvim-autopairs
  -- use {
  --   "windwp/nvim-autopairs",
  --   config = function() require("nvim-autopairs").setup {} end
  -- }

  -- nvim-lint
  -- use {
  --   'mfussenegger/nvim-lint',
  --   config = function() require('leouieda.plugins.nvim-lint') end,
  -- }

  -- LSP
  -- use {
  --   'neovim/nvim-lspconfig',
  --   config = function() require('leouieda.plugins.lspconfig') end,
  -- }

  -- cmp
  -- use {
  --   'hrsh7th/nvim-cmp',
  --   config = function() require('leouieda.plugins.cmp') end,
  --   requires = {
  --     'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
  --     'hrsh7th/cmp-path',         -- complete paths with nvim-cmp
  --     'hrsh7th/vim-vsnip',        -- Snippets plugin
  --     'hrsh7th/cmp-vsnip',
  --   }
  -- }

  -- Tree-sitter and:
  --   * treesitter-context
  -- use {
  --   'nvim-treesitter/nvim-treesitter',
  --   run = ':TSUpdate',
  --   config = function()
  --     require('leouieda.plugins.treesitter')
  --   end,
  --   requires = {
  --     'nvim-treesitter/nvim-treesitter-context',
  --   },
  -- }

  -- telescope
  -- use {
  --   'nvim-telescope/telescope.nvim',
  --   requires = 'nvim-lua/plenary.nvim',
  --   config = function() require('leouieda.plugins.telescope') end,
  -- }

  -- neogen (autogenerate docstrings)
  -- use {
  --   "danymat/neogen",
  --   config = function()
  --       require('leouieda.plugins.neogen')
  --   end,
  --   requires = "nvim-treesitter/nvim-treesitter",
  --   -- Uncomment next line if you want to follow only stable versions
  --   tag = "*"
  -- }

  -- undotree
  -- use {
  --   'mbbill/undotree',
  -- }

  -- nvim-coverage
  -- use({
  --   "andythigpen/nvim-coverage",
  --   requires = "nvim-lua/plenary.nvim",
  --   config = function()
  --     require("coverage").setup({
  --         signs = {
  --           -- use your own highlight groups or text markers
  --           covered = { hl = "CoverageCovered", text = "✓" },
  --           uncovered = { hl = "CoverageUncovered", text = "✗" },
  --           partial = { hl = "CoveragePartial", text = "!" },
  --         },
  --     })
  --   end,
  -- })

  -- fold
  -- use {
  --   'kevinhwang91/nvim-ufo',
  --   requires = 'kevinhwang91/promise-async',
  --   config = function()
  --       require('leouieda.plugins.nvim-ufo')
  --   end,
  -- }

end)
