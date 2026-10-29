require('options')
require("keymaps")
require("config.lazy")
if not vim.g.vscode then
  require("colorscheme")
  require('lsp')
end
