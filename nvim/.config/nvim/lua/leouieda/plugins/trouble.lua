-- ======================
-- Configure trouble.nvim
-- ======================

require("trouble").setup{
  icons = false, -- explicitly disable web-dev-icons so no warning is prompted
  use_diagnostic_signs = false,
}

-- Mappings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
