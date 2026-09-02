return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory (oil)" },
    { "<leader>e", "<cmd>Oil<CR>", desc = "Open oil (file explorer)" },
  },
}
