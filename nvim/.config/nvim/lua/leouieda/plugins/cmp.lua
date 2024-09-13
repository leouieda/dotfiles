-- Require needed packages
-- -----------------------
vim.o.completeopt="menu,menuone,noselect"

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')

-- -------------
-- Configure cmp
-- -------------
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  -- Define keybindings
  mapping = cmp.mapping.preset.insert({

    -- Start completion
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- navigate items in the list
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    -- Scroll docs
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),

  -- Configure sources
  sources = {
    { name = 'nvim_lsp'},
    { name = 'vsnip' },
    { name = 'path' },
  },
}

-- Define function to toggle autocompletion
function set_autocompletion(mode)
  if mode then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
  end
end

-- enable automatic completion popup on typing
vim.cmd('command EnableAutocompletion lua set_autocompletion(true)')

-- disable automatic competion popup on typing
vim.cmd('command DisableAutocompletion lua set_autocompletion(false)')
