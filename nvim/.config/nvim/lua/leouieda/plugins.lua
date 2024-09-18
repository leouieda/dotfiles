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

  -- Catpuccin: Nice pastel theme theme
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

  -- Tree-sitter: Better code parsing for syntax highlighting 
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('leouieda.plugins.treesitter')
    end,
  }

  -- Git signs: Show git diff status in the left side bar and more
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('leouieda.plugins.gitsigns') end,
  }

  -- Lualine: Status line at the bottom
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('leouieda.plugins.lualine') end,
  }

  -- Autopairs: Add matching brackets automatically
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  -- LaTeX
  use {
    'lervag/vimtex',
    config = function() require('leouieda.plugins.vimtex') end,
  }

  -- Colorizer: Display CSS colors inline
  use {
      "norcalli/nvim-colorizer.lua",
      config = function() require('leouieda.plugins.colorizer') end,
  }

  -- Mason: Package manager for LSPs
  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function() require('leouieda.plugins.mason') end,
  }

  -- Language Server Protocol (LSP) configuration
  use {
    'neovim/nvim-lspconfig',
    config = function() require('leouieda.plugins.lspconfig') end,
  }

  -- CMP: Complements for the LSPs
  use {
    'hrsh7th/nvim-cmp',
    config = function() require('leouieda.plugins.cmp') end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
      'hrsh7th/cmp-path',         -- Complete paths with nvim-cmp
    }
  }

end)
