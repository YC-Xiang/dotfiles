vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
--vim.opt.background = 'light'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes' -- 固定符号列，避免 gitsigns/诊断导致布局抖动
vim.opt.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 折叠范围由 treesitter 语法树决定（函数/类/代码块），没有 parser 的 filetype 会退化成不折叠。
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 打开文件时全部展开，只在手动 zc/zM 时才折；否则每次打开文件都是一堆折叠。
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldtext = "" -- nvim 0.10+：折叠行保留语法高亮，而不是灰扑扑的 +-- 摘要
vim.opt.fillchars:append({ fold = " " })

local ft_settings = {
  python    = { textwidth = 80,  colorcolumn = "+1" },
  c         = { textwidth = 80,  colorcolumn = "+1" },
  sh        = { textwidth = 80,  colorcolumn = "+1" },
  rust      = { textwidth = 100, colorcolumn = "+1" },
  java      = { textwidth = 100, colorcolumn = "+1" },
  gitcommit = { textwidth = 72,  colorcolumn = "51,73", spell = true },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(ft_settings),
  callback = function(args)
    for opt, val in pairs(ft_settings[args.match]) do
      vim.opt_local[opt] = val
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "py", "lua" },
	callback = function()
		vim.opt.tabstop = 4 -- the number of visual spaces per TAB
		vim.opt.softtabstop = 4 -- number of spaces in tab when editing
		vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
		vim.opt.expandtab = true -- tabs are spaces, mainly because of Python
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "ocaml" },
	callback = function()
		vim.opt.tabstop = 8 -- the number of visual spaces per TAB
	end,
})

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 300 -- 影响 gitsigns 与 LSP 诊断浮窗的响应速度
vim.opt.termguicolors = true
vim.opt.list = true
-- vim.opt.listchars = {
--     lead = '·',
--     tab = '▸ ',
--     trail = '·',
--     extends = '›',
--     precedes = '‹',
--     nbsp = '␣'
-- }
