vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

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
