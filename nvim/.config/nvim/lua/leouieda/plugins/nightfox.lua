-- ========================
-- Configure NightFox theme
-- ========================
-- Default options
require('nightfox').setup({
  options = {
    dim_inactive = true,    -- Non focused panes set to alternative background
  },
})

-- setup must be called before loading
vim.cmd("colorscheme carbonfox")
