-- vimwiki
-- -------
local function directory_exists(path)
  if type(path) ~= "string" then return false end
  local response = os.execute("cd " .. path .. " 2> /dev/null")
  if response == 0 then
    return true
  end
  return false
end

vimwiki_dir = '~/Documents/notes/vimwiki'
if not directory_exists(vimwiki_dir) then
  vimwiki_dir = '~/documents/notes/vimwiki'
end

vim.g.vimwiki_list = {{
    path=vimwiki_dir,
    template_path=vimwiki_dir .. 'templates/',
    template_default='default',
    syntax='markdown',
    ext='.md',
    path_html=vimwiki_dir .. 'site_html/',
    custom_wiki2html='vimwiki_markdown',
    template_ext='.tpl',
}}
vim.g.vimwiki_global_ext = 0

