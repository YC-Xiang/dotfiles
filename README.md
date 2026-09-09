# Dotfiles

我的个人开发环境配置备份：zsh、tmux、Neovim、Vim。AI 相关配置（pi / Claude Code / skills）已拆分到独立的 [`dotfiles-ai`](https://github.com/YC-Xiang/dotfiles-ai) 仓库。

通过 `install.sh` 把仓库里的文件软链接到 home 目录对应位置，所以改配置就是改这个仓库，`git commit` 即完成备份。

## 快速开始

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles

# 只做软链接（假设 zsh / nvim / tmux / oh-my-zsh 已装好）
./install.sh

# 顺便装好依赖：neovim、tmux、zsh、oh-my-zsh、p10k、zsh 插件
./install.sh --install-apps
```

链接时如果目标位置已存在文件，会先被移动到 `old_files/`（该目录已 gitignore），不会直接覆盖；重名时旧备份保留，新备份加时间戳后缀。已经正确链接过的文件会跳过，脚本可以反复运行。

首次进 Neovim，lazy.nvim 会自动 clone 自己并按 `lazy-lock.json` 装齐插件。

`--install-apps` **不含** `eza` 和 `fzf`，需要自己装：`.aliases` 把 `ls` 指向了 eza，没装的话 `ls` 会直接报错。

## 配置文件一览

| 文件 / 目录 | 链接到 | 用途 |
|------|--------|------|
| `.zshrc` | `~/.zshrc` | zsh 主配置：oh-my-zsh、主题、插件、PATH |
| `.aliases` | `~/.aliases` | 命令别名与 git 快捷函数，由 `.zshrc` 加载 |
| `.p10k.zsh` | `~/.p10k.zsh` | powerlevel10k 提示符外观（`p10k configure` 生成） |
| `.tmux.conf` | `~/.tmux.conf` | tmux 前缀键、分屏、复制模式 |
| `nvim/` | `~/.config/nvim` | Neovim 全套配置（主力编辑器） |
| `.vimrc` | `~/.vimrc` | 原生 vim 的兜底配置（没装 nvim 的机器上用） |
| `install.sh` | — | 安装脚本本身 |

> AI 相关配置（pi/agent、claude/hooks、osc-notify 工具、skills）见 [`~/dotfiles-ai`](https://github.com/YC-Xiang/dotfiles-ai)，本仓库不再包含。
---
