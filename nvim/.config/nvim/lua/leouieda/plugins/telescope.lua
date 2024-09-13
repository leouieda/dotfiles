-- Configure telescope
--
-- -------------------
function is_git_repo()
  -- Check if we are inside a git repo
  local status = os.execute("git rev-parse --show-toplevel 2> /dev/null")
  if status == 0 then
    return true
  end
  return false
end


function live_git_grep()
  -- Run live_grep with defaults or with git grep
  if is_git_repo() then
    local vimgrep_arguments = {
      "git",
       "grep",
       "--line-number",
       "--column",
       "--extended-regexp",
       "--ignore-case",
       "--no-color",
       "--recursive",
       "--recurse-submodules",
       "-I"
    }
    local opts = {
      prompt_title="Git Grep",
      vimgrep_arguments=vimgrep_arguments,
    }
    require('telescope.builtin').live_grep(opts)
  else
    require('telescope.builtin').live_grep()
  end
end


function find_files()
  -- Find files with find_files or git_files
  if is_git_repo() then
    require('telescope.builtin').git_files()
  else
    require('telescope.builtin').find_files()
  end
end


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', find_files, {})
vim.keymap.set('n', '<leader>fg', live_git_grep, {})
vim.keymap.set('n', '<leader>fl', builtin.find_files, {})
vim.keymap.set('n', '<leader>fm', builtin.marks, {})
vim.keymap.set('n', '<leader>fs', builtin.git_status, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fe', builtin.resume, {})


-- Configure telescope
require('telescope').setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { height = 0.95 },
  },
})
