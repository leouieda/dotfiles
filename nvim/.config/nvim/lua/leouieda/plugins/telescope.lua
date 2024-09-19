-- Source: ThePrimeagen https://youtu.be/w7i4amO_zaE

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>gg", function()
    builtin.grep_string({ search = vim.fn.input("grep: ") })
end)
