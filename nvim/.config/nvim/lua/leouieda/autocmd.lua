-- ===================
-- Define autocommands
-- ===================

-- ------------------------
-- Custom styles on augroup
-- ------------------------
vim.api.nvim_create_augroup("custom_style", { clear = true })
-- Change text last column for Python files
vim.api.nvim_create_autocmd("FileType", {
    group = "custom_style",
    pattern = { "python" },
    command = "setlocal colorcolumn=89",
})
-- Change text last column for Rust files
vim.api.nvim_create_autocmd("FileType", {
    group = "custom_style",
    pattern = { "rust" },
    command = "setlocal colorcolumn=100",
})
-- Set indentation to 2 characters for html, yml, markdown and lua files
vim.api.nvim_create_autocmd("FileType", {
    group = "custom_style",
    pattern = { "html", "htmldjango", "yml", "lua", "markdown" },
    command = "setlocal ts=2 sts=2 sw=2 expandtab",
})
-- Set indentation to 3 characters for rst files
vim.api.nvim_create_autocmd("FileType", {
    group = "custom_style",
    pattern = { "rst" },
    command = "setlocal ts=3 sts=3 sw=3 expandtab",
})
-- Configure Git commits
vim.api.nvim_create_autocmd("FileType", {
    group = "custom_style",
    pattern = { "gitcommit", "pullrequest" },
    command = "setlocal spell textwidth=72",
})


-- ------------------------------
-- Remove trailing spaces on save
-- ------------------------------
vim.api.nvim_create_augroup("trailing_spaces", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "trailing_spaces",
    pattern = { "*" },
    callback = trim_trailing_whitespaces,
})


-- ----------------------------------------------
-- Enable spellcheck by default on some filetypes
-- ----------------------------------------------
vim.api.nvim_create_augroup("spelling", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "spelling",
    pattern = { "html", "markdown", "python", "tex", "rst" },
    command = "setlocal spell | set spelllang=en",
})


-- -------------------------------------------------------------
-- Show cursor line and set relativenumber only in active window
-- -------------------------------------------------------------
-- (don't change relativenumber on NvimTree window)
vim.api.nvim_create_augroup("cursorline_active_window", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
    group = "cursorline_active_window",
    pattern = { "*" },
    command = "set cursorline",
})
vim.api.nvim_create_autocmd("WinEnter", {
    group = "cursorline_active_window",
    pattern = { "*" },
    command = "if &l:number | set relativenumber | endif",
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = "cursorline_active_window",
    pattern = { "*" },
    command = "set nocursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = "cursorline_active_window",
    pattern = { "*" },
    command = "if &l:number | set norelativenumber | endif",
})


-- -----------------------------------------------------
-- Remove the "o" option in formatoptions for every file
-- -----------------------------------------------------
-- When filetype plugin is on, it usually adds the formatoptions "o" argument,
-- that adds comment leader character on new lines created with the "o" key.
-- This annoys me a lot: I'd rather add a comment character than delete it.
vim.api.nvim_create_augroup("fo_without_o", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = "fo_without_o",
    pattern = { "*" },
    command = "set formatoptions-=o",
})
