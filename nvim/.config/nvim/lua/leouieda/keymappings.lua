-- ==================
-- Define vim.keymap.setpings
-- ==================

-- Navigate between windows
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Move to the next and previous buffer
vim.keymap.set('n', '<leader>n', ':bnext<CR>')
vim.keymap.set('n', '<leader>p', ':bprevious<CR>')
vim.keymap.set('n', '<leader>d', ':bd<CR>')
vim.keymap.set('n', ']b', ':bnext<CR>')
vim.keymap.set('n', '[b', ':bprevious<CR>')

-- Remove search highlight
vim.keymap.set('n', '<leader><space>', ':noh<cr>')

-- Easier colon
vim.keymap.set('n', '<leader>;', ':')

-- Map "+y in order to copy to clipboard
-- In order to work, :echo has('clipboard') must return 1
-- Try installing xclip
vim.keymap.set('v', '<C-c>', '"+y')

-- Yank until end of line (source: ThePrimeagen)
vim.keymap.set('n', 'Y', 'y$')

-- Don't overwride the register when pasting over selection
-- (in visual mode this is done with P)
vim.keymap.set('v', 'p', 'P')

-- Keep searches centered (source: ThePrimeagen)
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Keep cursor fixed when joining lines (source: ThePrimeagen)
vim.keymap.set('n', 'J', 'mzJ`z')

-- Center cursor when jumping half pages (source: ThePrimeagen)
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- Map Esc to exit Terminal mode (in terminal)
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- Leader v to paste replacing but not overriding the register
-- (source: ThePrimeagen)
vim.keymap.set('x', '<leader>v', [["_dP]])

-- Enable/disable diagnostic
vim.keymap.set('n', '<leader>tdd', vim.diagnostic.disable)
vim.keymap.set('n', '<leader>tde', vim.diagnostic.enable)

-- Search selected text
vim.keymap.set("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
