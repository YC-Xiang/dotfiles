#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_and_link() {
    local src="$1"
    local dst="$2"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "  already linked: $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$DOTFILES_DIR/old_files"
        mv -i "$dst" "$DOTFILES_DIR/old_files/"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  linked: $dst -> $src"
}

link_dotfiles() {
    echo "==> Linking dotfiles..."

    # Home dir
    backup_and_link "$DOTFILES_DIR/.vimrc"     "$HOME/.vimrc"
    backup_and_link "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    backup_and_link "$DOTFILES_DIR/.aliases"   "$HOME/.aliases"
    backup_and_link "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
    backup_and_link "$DOTFILES_DIR/.p10k.zsh"  "$HOME/.p10k.zsh"

    # Neovim (XDG config)
    backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Claude Code
    backup_and_link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
    backup_and_link "$DOTFILES_DIR/claude/statusline.sh" "$HOME/.claude/statusline.sh"

    # VSCode / Cursor (only if the editor config dir already exists)
    for editor_dir in "$HOME/.config/Code/User" "$HOME/.config/Cursor/User"; do
        if [ -d "$editor_dir" ]; then
            echo "==> Linking VSCode/Cursor config ($(basename "$(dirname "$editor_dir")"))"
            backup_and_link "$DOTFILES_DIR/vscode/settings.json"    "$editor_dir/settings.json"
            backup_and_link "$DOTFILES_DIR/vscode/keybindings.json" "$editor_dir/keybindings.json"
        fi
    done

    echo "==> Dotfiles linked."
}

install_apps() {
    echo "==> Installing apps..."

    # Neovim (official tarball — keeps the /opt/nvim-linux-x86_64 layout the .zshrc expects)
    if ! command -v nvim &>/dev/null; then
        echo "  Installing Neovim..."
        curl -Lo /tmp/nvim.tar.gz \
            https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo tar -xzf /tmp/nvim.tar.gz -C /opt
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
        rm /tmp/nvim.tar.gz
    fi

    # tmux
    if ! command -v tmux &>/dev/null; then
        echo "  Installing tmux..."
        sudo apt-get install -y tmux
    fi

    # zsh
    if ! command -v zsh &>/dev/null; then
        echo "  Installing zsh..."
        sudo apt-get install -y zsh
    fi

    # oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "  Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended
    fi

    # powerlevel10k theme
    local p10k_dir="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    if [ ! -d "$p10k_dir" ]; then
        echo "  Installing powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    fi

    # zsh-autosuggestions
    local autosugg_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if [ ! -d "$autosugg_dir" ]; then
        echo "  Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$autosugg_dir"
    fi

    # zsh-syntax-highlighting
    local syntax_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if [ ! -d "$syntax_dir" ]; then
        echo "  Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$syntax_dir"
    fi

    echo "==> Apps installed."
}

link_dotfiles

if [[ "${1:-}" == "--install-apps" ]]; then
    install_apps
else
    echo ""
    echo "Tip: run './install.sh --install-apps' to also install neovim, tmux, zsh, oh-my-zsh, and plugins."
fi
