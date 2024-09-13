-- ------
-- vimtex
-- ------
vim.cmd [[
  " filetype plugin indent on
  " let maplocalleader = ","
  let g:vimtex_view_method = 'zathura'
  let g:tex_flavor = 'latex'
  let g:vimtex_compiler_enabled=1
  " let g:vimtex_compiler_method = 'tectonic'
  let g:vimtex_compiler_latexmk = {'build_dir' : '_output'}
  let g:vimtex_compiler_tectonic = {'build_dir' : '_output'}
  let g:vimtex_complete_enabled=1
  let g:vimtex_complete_close_braces=1
]]
