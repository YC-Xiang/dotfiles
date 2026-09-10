#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_and_link() {
    local src="$1"
    local dst="$2"
    if [ ! -e "$src" ]; then
        echo "  skipped (not in repo): $src" >&2
        return
    fi
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "  already linked: $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        # Never prompt and never clobber an earlier backup: on a name collision
        # the new backup gets a timestamp suffix.
        local backup="$DOTFILES_DIR/old_files/$(basename "$dst")"
        mkdir -p "$DOTFILES_DIR/old_files"
        if [ -e "$backup" ] || [ -L "$backup" ]; then
            backup="$backup.$(date +%Y%m%d-%H%M%S)"
        fi
        mv "$dst" "$backup"
        echo "  backed up: $dst -> $backup"
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

    echo "==> Dotfiles linked."
}

# apt-get install, refreshing the package lists once per run (a fresh container
# has none, and install would fail).
apt_install() {
    if [ "${APT_UPDATED:-}" != yes ]; then
        sudo apt-get update
        APT_UPDATED=yes
    fi
    sudo apt-get install -y "$@"
}

# nvim-treesitter's `main` branch (the only one that supports Neovim 0.12+) shells
# out to the tree-sitter CLI to build parsers, so without it every startup errors
# with `Error during "tree-sitter build"`.
install_tree_sitter_cli() {
    if command -v tree-sitter &>/dev/null; then
        echo "  already installed: tree-sitter ($(tree-sitter --version))"
        return
    fi
    echo "  Installing tree-sitter CLI..."

    if [ "$(uname -s)" = "Darwin" ]; then
        brew install tree-sitter
        return
    fi

    # Releases after 0.25.10 are built on Ubuntu 24.04 and need glibc >= 2.39, so
    # older distros (e.g. Ubuntu 22.04 with glibc 2.35) get the last 22.04 build.
    # An unparseable ldd output falls through to the pinned version, which runs
    # everywhere the newer one does.
    local glibc url
    glibc="$(ldd --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+$' || true)"
    if [ -n "$glibc" ] && [ "$(printf '%s\n2.39\n' "$glibc" | sort -V | head -1)" = "2.39" ]; then
        url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
    else
        url="https://github.com/tree-sitter/tree-sitter/releases/download/v0.25.10/tree-sitter-linux-x64.gz"
    fi

    mkdir -p "$HOME/.local/bin"
    curl -fL "$url" | gunzip >"$HOME/.local/bin/tree-sitter"
    chmod +x "$HOME/.local/bin/tree-sitter"
}

install_apps() {
    echo "==> Installing apps..."

    # Neovim (official tarball — keeps the /opt/nvim-linux-x86_64 layout the .zshrc expects)
    if ! command -v nvim &>/dev/null; then
        echo "  Installing Neovim..."
        curl -fLo /tmp/nvim.tar.gz \
            https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo tar -xzf /tmp/nvim.tar.gz -C /opt
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
        rm /tmp/nvim.tar.gz
    fi

    # tree-sitter CLI + a C compiler for nvim-treesitter parser builds
    # (on macOS `cc` comes from the Xcode command line tools, not apt)
    if [ "$(uname -s)" != "Darwin" ] && ! command -v cc &>/dev/null; then
        echo "  Installing build-essential..."
        apt_install build-essential
    fi
    install_tree_sitter_cli

    # tmux
    if ! command -v tmux &>/dev/null; then
        echo "  Installing tmux..."
        apt_install tmux
    fi

    # zsh
    if ! command -v zsh &>/dev/null; then
        echo "  Installing zsh..."
        apt_install zsh
    fi

    # oh-my-zsh
    # --keep-zshrc is required: without it the installer moves the ~/.zshrc symlink
    # we just created to ~/.zshrc.pre-oh-my-zsh and drops in its own template, and
    # --unattended suppresses the confirmation prompt, so it happens silently.
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "  Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended --keep-zshrc
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

# Validate before touching anything, so a mistyped flag doesn't half-run.
case "${1:-}" in
    ""|--install-apps) ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Usage: ./install.sh [--install-apps]" >&2
        exit 1
        ;;
esac

link_dotfiles

if [ "${1:-}" = "--install-apps" ]; then
    install_apps
else
    echo ""
    echo "Tip: run './install.sh --install-apps' to also install neovim, tmux, zsh, oh-my-zsh, and plugins."
fi
