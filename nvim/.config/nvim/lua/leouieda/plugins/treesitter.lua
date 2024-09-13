require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua", "latex", "c", "rust", "vimdoc" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  highlight = {
    enable = true,

    -- Totally disable treesitter indentation in Python
    additional_vim_regex_highlighting = {'python'}, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4464

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },

  indent = {
    -- Disable treesitter indent for Python
    enable = false,
    disable = { "python" },
  }

}

require('treesitter-context').setup{
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
}

vim.keymap.set("n", "[n", function()
  require("treesitter-context").go_to_context()
end, { silent = true })
