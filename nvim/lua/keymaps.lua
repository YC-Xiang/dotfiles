
local base_opts = {
	noremap = true;
	silent = true;
}

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs,
        vim.tbl_extend('force', base_opts, {desc = desc})
    )
end

vim.g.mapleader = " "

-- map("n", "<Up>", "<Nop>", opts)
-- map("n", "<Down>", "<Nop>", opts)
-- map("n", "<Left>", "<Nop>", opts)
-- map("n", "<Right>", "<Nop>", opts)
-- map("i", "<Up>", "<Nop>", opts)
-- map("i", "<Down>", "<Nop>", opts)
-- map("i", "<Left>", "<Nop>", opts)
-- map("i", "<Right>", "<Nop>", opts)


map("i", "jj", "<Esc>", opts)

-- Resize with arrows
-- delta: 2 lines
map("n", "<C-Up>", ":resize -2<CR>", "resize -2")
map("n", "<C-Down>", ":resize +2<CR>", "resize +2")
map("n", "<C-Left>", ":vertical resize -2<CR>", "vertical resize -2")
map("n", "<C-Right>", ":vertical resize +2<CR>", "vertical resize +2")

-- nvimTree
map('n', "<F2>", ":NvimTreeToggle<CR>", "NvimTreeToggle")

-- Telescope
map('n', '<leader>ff', ":Telescope find_files<CR>", ":Telescope find_files")
map('n', '<leader>fg', ":Telescope live_grep<CR>", ":Telescope live_grep")
map('n', '<leader>fb', ":Telescope buffers<CR>", ":Telescope buffers")
map('n', '<leader>fh', ":Telescope help_tags<CR>", ":Telescope help_tags")

map('n', '<leader>bn', ":bn<CR>", "next buffer")
map('n', '<leader>bp', ":bp<CR>", "previous buffer")

map('n', "<C-d>", "<C-d>zz")
map('n', "<C-u>", "<C-u>zz")
map('n', "n", "nzz")
map('n', "N", "Nzz")

map('n', "<leader>p", "\"_dP")
