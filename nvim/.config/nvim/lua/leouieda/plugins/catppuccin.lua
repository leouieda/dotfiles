-- =========================
-- Configure catpuccin theme
-- =========================
require("catppuccin").setup({
    no_italic = true, -- Force no italic
    native_lsp = {
        enabled = true,
        virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
        },
        underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
        },
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin-mocha"
