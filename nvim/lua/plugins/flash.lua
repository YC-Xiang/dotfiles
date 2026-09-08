return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        -- f/t/F/T 只在当前行匹配（flash 默认会跨行高亮）
        multi_line = false,
        -- f/t 输入后给每个匹配显示字母标签，直接按字母跳到对应位置
        jump_labels = true,
        jump = {
          -- 当前行只有一个匹配时自动跳转，无需再按标签
          autojump = true,
        },
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          -- 唯一匹配时自动跳转，无需再按标签
          jump = { autojump = true },
        })
      end,
      desc = "Flash 跳转",
    },
    -- 注意：不映射 visual 模式，避免覆盖 nvim-surround 的 visual `S`（包围所选区域）
    {
      "S",
      mode = { "n", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter 节点选择",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
