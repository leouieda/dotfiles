require("mason").setup()

-- Add function to install all packages in the following array
-- -----------------------------------------------------------

local MASON_PACKAGES = {
  "pyright",
  "jedi-language-server",
  "black",
  "flake8",
  "mypy",
  "ruff-lsp",
  "prettier",
  "rstcheck",
  "stylelint",
  "proselint",
  "shellcheck",
  "markdownlint",
  "rstcheck",
  "rust-analyzer",
  "tree-sitter-cli",
  "texlab",
  "lua-language-server",
  "ltex-ls",
}

function MasonAutoInstall(start_mason)

  if start_mason == nil then
    start_mason = true
  end

  local level = vim.log.levels.INFO
  local registry = require("mason-registry")

  for _, pkg_name in pairs(MASON_PACKAGES) do
    local package = registry.get_package(pkg_name)
    if not package:is_installed() then
      vim.notify("Installing " .. pkg_name, level)
      package:install()
    else
      vim.notify("Skipping " .. pkg_name, level)
    end
  end

  if start_mason then
    vim.api.nvim_command("Mason")
  end
end
