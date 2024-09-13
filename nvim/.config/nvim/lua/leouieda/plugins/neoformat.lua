-- Configure neoformat
-- -------------------
-- Don't stop when running the first formatter, run all
vim.g.neoformat_run_all_formatters = 1
-- Configure isort and black autoformatters
vim.g.neoformat_enabled_python = {'isort', 'black'}
vim.g.neoformat_python_isort = {args = {'--profile black'}}

-- Run neoformat after saving some chosen files
vim.api.nvim_create_augroup("neoformat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "neoformat",
    pattern = { "*.py", "*.rs" },
    command = "Neoformat",
})

