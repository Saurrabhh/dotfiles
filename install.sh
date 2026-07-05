#!/usr/bin/env bash

# =====================================================================
# 🚀 Dotfiles Installer Script
# Supported Platforms: macOS (Zsh) and Windows (Git Bash)
# Automates the package installation and symlinking/copying of 
# configurations for WezTerm, Tmux, Neovim, Bash, and Zsh.
# =====================================================================

# Fail immediately if any command exits with a non-zero status
set -e

# Resolve the absolute path to this dotfiles repository directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "====================================================="
echo "⚙️  Starting Dotfiles Installation & Package Setup"
echo "====================================================="

# ---------------------------------------------------------------------
# 1. DETECT OPERATING SYSTEM
# ---------------------------------------------------------------------
IS_WINDOWS=false
IS_MAC=false

if [[ "$(uname -s)" == *"MINGW"* || "$(uname -s)" == *"MSYS"* || "$(uname -s)" == *"CYGWIN"* ]]; then
    IS_WINDOWS=true
    echo "💻 Windows (Git Bash) environment detected."
elif [[ "$(uname -s)" == "Darwin" ]]; then
    IS_MAC=true
    echo "🍎 macOS (Zsh) environment detected."
else
    echo "❌ Unsupported environment. Only Windows (Git Bash) and macOS (Zsh) are supported."
    exit 1
fi

# ---------------------------------------------------------------------
# 2. PACKAGE & APPLICATION INSTALLATION
# ---------------------------------------------------------------------
echo "📦 Installing required applications..."

if [ "$IS_MAC" = true ]; then
    # Check for Homebrew
    if ! command -v brew &>/dev/null; then
        echo "📥 Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Load brew environment for the current script session
        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -f "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    
    echo "🍺 Installing packages via Homebrew..."
    brew install tmux neovim fzf zsh-autosuggestions zsh-syntax-highlighting
    
    # Install WezTerm cask if not present
    if ! brew list --cask wezterm &>/dev/null; then
        echo "📥 Installing WezTerm..."
        brew install --cask wezterm
    fi

elif [ "$IS_WINDOWS" = true ]; then
    # 1. Install WezTerm
    if ! command -v wezterm &>/dev/null && ! [ -f "/c/Program Files/WezTerm/wezterm.exe" ]; then
        echo "📥 Installing WezTerm via Winget..."
        winget.exe install --id=wez.wezterm -e --accept-source-agreements --accept-package-agreements
    else
        echo "✅ WezTerm is already installed."
    fi

    # 2. Install Neovim
    if ! command -v nvim &>/dev/null; then
        echo "📥 Installing Neovim via Winget..."
        winget.exe install --id=Neovim.Neovim -e --accept-source-agreements --accept-package-agreements
    else
        echo "✅ Neovim is already installed."
    fi

    # 3. Install Tmux and Script wrapper for Git Bash
    if ! command -v tmux &>/dev/null || ! tmux -V &>/dev/null || ! command -v script &>/dev/null; then
        echo "📥 Installing tmux and script utility for Git Bash..."
        TEMP_DIR="/tmp/tmux_install"
        mkdir -p "$TEMP_DIR"
        mkdir -p "$HOME/bin"
        
        # Download files
        curl -L -o "$TEMP_DIR/zstd.zip" "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-v1.5.7-win64.zip"
        curl -L -o "$TEMP_DIR/tmux.tar.zst" "https://mirror.clarkson.edu/msys2/msys/x86_64/tmux-3.4-2-x86_64.pkg.tar.zst"
        curl -L -o "$TEMP_DIR/libevent.tar.zst" "https://mirror.msys2.org/msys/x86_64/libevent-2.1.12-4-x86_64.pkg.tar.zst"
        curl -L -o "$TEMP_DIR/util-linux.tar.zst" "https://mirror.clarkson.edu/msys2/msys/x86_64/util-linux-2.35.2-4-x86_64.pkg.tar.zst"
        
        # Extract zstd
        unzip -d "$TEMP_DIR/zstd_extracted" "$TEMP_DIR/zstd.zip"
        ZSTD_EXE=$(find "$TEMP_DIR/zstd_extracted" -name "zstd.exe" | head -n 1)
        ZSTD_DIR=$(dirname "$ZSTD_EXE")
        
        # Add zstd to path for tar
        export PATH="$ZSTD_DIR:$PATH"
        
        # Extract tmux, libevent, and script
        cd "$TEMP_DIR"
        tar --force-local -xf tmux.tar.zst usr/bin/tmux.exe
        tar --force-local -xf libevent.tar.zst usr/bin/msys-event-2-1-7.dll usr/bin/msys-event_core-2-1-7.dll usr/bin/msys-event_extra-2-1-7.dll usr/bin/msys-event_openssl-2-1-7.dll usr/bin/msys-event_pthreads-2-1-7.dll
        tar --force-local -xf util-linux.tar.zst usr/bin/script.exe
        
        # Install to ~/bin
        cp usr/bin/tmux.exe "$HOME/bin/"
        cp usr/bin/msys-event*.dll "$HOME/bin/"
        cp usr/bin/script.exe "$HOME/bin/"
        cd - >/dev/null
        
        # Clean up
        rm -rf "$TEMP_DIR"
        echo "✅ tmux and script wrapper successfully installed to $HOME/bin"
    else
        echo "✅ tmux and script wrapper are already installed."
    fi

    # 4. Install ble.sh (Bash Line Editor) for Git Bash
    echo "🐚 Checking Bash Line Editor (ble.sh) for auto-suggestions..."
    if [ ! -f "$HOME/.local/share/blesh/ble.sh" ]; then
        echo "📥 Installing ble.sh..."
        if command -v git &>/dev/null && command -v make &>/dev/null && command -v gawk &>/dev/null; then
            TEMP_BLE="/tmp/ble_install"
            rm -rf "$TEMP_BLE"
            git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "$TEMP_BLE"
            make -C "$TEMP_BLE" install PREFIX=~/.local
            rm -rf "$TEMP_BLE"
            echo "✅ ble.sh installed successfully to ~/.local/share/blesh/"
        else
            echo "⚠️  Could not install ble.sh: git, make, or gawk not found in environment."
            exit 1
        fi
    else
        echo "✅ ble.sh is already installed."
    fi
fi

# ---------------------------------------------------------------------
# 3. LINK/COPY HELPER FUNCTION
# ---------------------------------------------------------------------
# Robust function to handle linking on Windows/macOS/Linux.
# Falls back to copying if symlink creation fails or is blocked on Windows.
link_item() {
    local src="$1"
    local dest="$2"
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$dest")"
    
    # Remove existing file, directory, or link
    rm -rf "$dest"
    
    if ln -sf "$src" "$dest" 2>/dev/null; then
        echo "✅ Linked: $dest -> $src"
    else
        if [ -d "$src" ]; then
            cp -r "$src" "$dest"
        else
            cp "$src" "$dest"
        fi
        echo "✅ Copied (fallback): $dest -> $src"
    fi
}

# ---------------------------------------------------------------------
# 4. CONFIGURATION DEPLOYMENT
# ---------------------------------------------------------------------
echo "⚙️  Deploying configurations..."

# WezTerm Configuration Setup
echo "💻 Configuring WezTerm..."
link_item "$DIR/.wezterm.lua" "$HOME/.wezterm.lua"

# Tmux Configuration Setup
echo "🔗 Configuring Tmux..."
link_item "$DIR/.tmux.conf" "$HOME/.tmux.conf"

# Neovim Configuration Setup
echo "🔗 Configuring Neovim..."
if [ "$IS_WINDOWS" = true ]; then
    # Link standard ~/.config/nvim and Windows AppData/Local/nvim
    link_item "$DIR/.config/nvim" "$HOME/.config/nvim"
    link_item "$DIR/.config/nvim" "$HOME/AppData/Local/nvim"
else
    link_item "$DIR/.config/nvim" "$HOME/.config/nvim"
fi

# Shell Configuration Setup
echo "✏️  Configuring Shell Environments..."

# Helper to backup existing configuration files before overwriting
backup_and_link() {
    local src="$1"
    local dest="$2"
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "$dest.backup"
        echo "⚠️  Existing $dest backed up to $dest.backup"
    fi
    link_item "$src" "$dest"
}

if [ "$IS_MAC" = true ]; then
    backup_and_link "$DIR/.zshrc" "$HOME/.zshrc"
elif [ "$IS_WINDOWS" = true ]; then
    backup_and_link "$DIR/.bashrc" "$HOME/.bashrc"
    backup_and_link "$DIR/.bash_profile" "$HOME/.bash_profile"
    backup_and_link "$DIR/.blerc" "$HOME/.blerc"
fi

# ---------------------------------------------------------------------
# 5. ENVIRONMENT RELOADING
# ---------------------------------------------------------------------
# Reload the active Tmux configuration if the Tmux server is currently running.
if command -v tmux &>/dev/null && tmux info &>/dev/null; then
    echo "🔄 Reloading active Tmux configuration..."
    tmux source-file "$HOME/.tmux.conf"
fi

echo "====================================================="
echo "🎉 Dotfiles setup & installation completed successfully!"
echo "➡️  Reload your shell to apply changes:"
if [ "$IS_WINDOWS" = true ]; then
    echo "   source ~/.bashrc"
else
    echo "   source ~/.zshrc"
fi
echo "====================================================="
