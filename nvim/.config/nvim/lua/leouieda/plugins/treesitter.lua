require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua", "bibtex", "html", "css", "javascript", "c", "rust", "bash", "make", "markdown", "markdown_inline", "yaml" },

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
