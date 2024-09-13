-- Custom functions for Neovim
-- ---------------------------

function trim_trailing_whitespaces()
    if not vim.o.binary and vim.o.filetype ~= 'diff' then
        local current_view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(current_view)
    end
end

