# Neovim 插件说明

## 外观

| 插件 | 作用 |
|------|------|
| **tokyonight.nvim** | 配色主题，使用 `day` 浅色风格。设了最高优先级确保最先加载。 |
| **lualine.nvim** | 底部状态栏，显示当前模式、文件名、行列号、Git 分支等信息。 |
| **indent-blankline.nvim** | 在缩进处显示竖线，方便看清代码块的层级结构。 |
| **bufferline.nvim** | 顶部 buffer 标签栏（类似编辑器 tab）。⚠️ 当前 `enabled = false`，已禁用。 |

## 文件浏览 & 搜索

| 插件 | 作用 |
|------|------|
| **nvim-tree.lua** | 左侧文件树面板，可以浏览、打开、创建、删除文件。配置了当它是最后一个窗口时自动退出 Neovim。 |
| **telescope.nvim** | 模糊搜索神器，可以搜文件名、文件内容、Git 记录、buffer 等。带了 `fzf-native` 扩展提升性能。 |

## 代码理解 & 高亮

| 插件 | 作用 |
|------|------|
| **nvim-treesitter** | 基于语法树的代码高亮，比正则高亮更准确。自动安装缺失的语言解析器，超过 100KB 的大文件会自动禁用以保性能。 |
| **nvim-treesitter-context** | 在文件顶部固定显示当前光标所在的函数/类名，滚动长函数时不会迷失位置。 |
| **todo-comments.nvim** | 高亮并收集代码里的 `TODO`、`FIXME`、`NOTE`、`HACK` 等注释，可以用 Telescope 搜索全部待办。 |

## 代码编辑

| 插件 | 作用 |
|------|------|
| **blink.cmp** | 自动补全引擎，集成 LSP、路径、代码片段、buffer 四个来源。用 `Enter` 确认补全，`Tab`/`↑↓` 选择候选项。 |
| **nvim-autopairs** | 自动补全括号、引号等成对符号。进入 Insert 模式时懒加载。 |
| **nvim-surround** | 快速添加、修改、删除包围符号（括号、引号、HTML 标签等）。例如 `ysiw"` 给单词加引号，`ds"` 删除引号。 |
| **Comment.nvim** | 快速注释/反注释代码，`gcc` 注释当前行，`gc` + 动作注释一段。 |
| **conform.nvim** | 代码格式化，配置了：Lua 用 `stylua`，Python 用 `isort` + `black`，C 用 `clang-format`。 |
| **multicursor.nvim** | 多光标编辑，可同时编辑多处。⚠️ 当前 `enabled = false`，已禁用。 |

## Git

| 插件 | 作用 |
|------|------|
| **gitsigns.nvim** | 在行号旁显示 Git 变更标记（新增/修改/删除），并提供 hunk 级别的暂存、回滚、diff 预览等操作。 |

## 辅助工具

| 插件 | 作用 |
|------|------|
| **which-key.nvim** | 按下 `<leader>` 等前缀键后弹出提示面板，显示所有可用的按键绑定。按 `<leader>?` 查看当前 buffer 的快捷键。 |
| **hardtime.nvim** | 强制养成好的 Vim 习惯，当你反复按同一个移动键时会提示或阻止，逼你用更高效的动作。方向键已豁免不受限制。 |

---

> 依赖库（不直接使用，被其他插件依赖）：`nvim-web-devicons`（图标）、`plenary.nvim`（工具函数库）、`friendly-snippets`（代码片段集合）、`nui.nvim`（UI 组件库）
