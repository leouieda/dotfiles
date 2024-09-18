-- Use the old vimconfig language because lua isn't supported
vim.cmd [[
  let g:vimtex_view_method = 'zathura'
  let g:tex_flavor = 'latex'
  let g:vimtex_compiler_enabled=0
  let g:vimtex_complete_enabled=1
  let g:vimtex_complete_close_braces=1
]]
