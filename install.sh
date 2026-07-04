#!/usr/bin/env bash

# =====================================================================
# 🚀 Dotfiles Installer Script
# Supported Platforms: macOS, Linux, and WSL (Windows Subsystem for Linux)
# Automates the symlinking of configurations and configures shell prompts.
# =====================================================================

# Fail immediately if a command exits with a non-zero status
set -e

# Resolve the absolute path to this dotfiles repository directory
# This allows the script to be run from any working directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "====================================================="
echo "⚙️  Starting Dotfiles Installation (WezTerm & Tmux & Neovim)"
echo "====================================================="

# ---------------------------------------------------------------------
# 1. TMUX CONFIGURATION SETUP
# ---------------------------------------------------------------------
# Symlinks the .tmux.conf file to the user's home directory.
# Works natively on both WSL/Linux and macOS.
echo "🔗 Symlinking Tmux configuration..."
ln -sf "$DIR/.tmux.conf" "$HOME/.tmux.conf"
echo "✅ Symlinked .tmux.conf to ~/.tmux.conf"

# ---------------------------------------------------------------------
# 2. WEZTERM CONFIGURATION SETUP
# ---------------------------------------------------------------------
# WezTerm runs as a host desktop application.
#   * On WSL: It runs on Windows, reading its config from %USERPROFILE%\.wezterm.lua
#   * On macOS: It runs natively, reading from ~/.wezterm.lua
if grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    echo "💻 WSL environment detected. Configuring Windows WezTerm..."
    
    # Query the Windows %USERPROFILE% environment variable and trim carriage returns
    WIN_USER_PROFILE=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')
    
    if [ -n "$WIN_USER_PROFILE" ]; then
        # Convert the Windows file path (e.g. C:\Users\Saurabh) into WSL format (/mnt/c/Users/Saurabh)
        WIN_HOME=$(wslpath "$WIN_USER_PROFILE")
        
        if [ -d "$WIN_HOME" ]; then
            # Convert the WSL dotfiles path of .wezterm.lua to a Windows NTFS path
            WIN_FILE_PATH=$(wslpath -w "$DIR/.wezterm.lua")
            
            # Remove any existing WezTerm files or links in the Windows profile
            cmd.exe /c "del %USERPROFILE%\.wezterm.lua" 2>/dev/null || true
            
            # Attempt to create a native Windows NTFS symbolic link using cmd.exe.
            # This requires Developer Mode or Admin rights on the Windows host.
            if cmd.exe /c "mklink %USERPROFILE%\.wezterm.lua \"$WIN_FILE_PATH\"" &>/dev/null; then
                echo "✅ Created Windows NTFS symlink for .wezterm.lua in %USERPROFILE%"
            else
                # Fallback: Copy the file directly if NTFS symlink creation is blocked
                cp "$DIR/.wezterm.lua" "$WIN_HOME/.wezterm.lua"
                echo "✅ Copied .wezterm.lua to $WIN_HOME/.wezterm.lua (symlink fallback)"
            fi
        else
            echo "⚠️  Could not resolve Windows home directory path: $WIN_HOME"
        fi
    else
        echo "⚠️  Could not retrieve Windows %USERPROFILE% via cmd.exe"
    fi
else
    # macOS or native Linux environment
    echo "🍎 macOS/Linux environment detected. Configuring native WezTerm..."
    ln -sf "$DIR/.wezterm.lua" "$HOME/.wezterm.lua"
    echo "✅ Symlinked .wezterm.lua to ~/.wezterm.lua"
fi

# ---------------------------------------------------------------------
# 3. NEOVIM CONFIGURATION SETUP
# ---------------------------------------------------------------------
# Symlinks the .config/nvim folder to ~/.config/nvim.
# This configures LSP parameters, Flutter tooling, and inline Markdown rendering.
echo "🔗 Symlinking Neovim configuration..."
mkdir -p "$HOME/.config"
ln -sfn "$DIR/.config/nvim" "$HOME/.config/nvim"
echo "✅ Symlinked .config/nvim directory to ~/.config/nvim"

# ---------------------------------------------------------------------
# 4. SHELL PROMPT & CONFIGURATION SETUP
# ---------------------------------------------------------------------
echo "✏️  Configuring Shell Environments..."

# Zsh Shell Setup (Symlink ~/.zshrc)
# Symlinks the portable, OS-aware .zshrc from the dotfiles repository.
# Keeps your previous .zshrc file safe by backing it up to .zshrc.backup.
echo "🔗 Symlinking Zsh configuration..."
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    echo "⚠️  Existing ~/.zshrc backed up to ~/.zshrc.backup"
fi
ln -sf "$DIR/.zshrc" "$HOME/.zshrc"
echo "✅ Symlinked .zshrc to ~/.zshrc"

# ---------------------------------------------------------------------
# 5. ENVIRONMENT RELOADING
# ---------------------------------------------------------------------
# Reload the active Tmux configuration if the Tmux server is currently running.
if tmux info &>/dev/null; then
    echo "🔄 Reloading active Tmux configuration..."
    tmux source-file "$HOME/.tmux.conf"
fi

echo "====================================================="
echo "🎉 Dotfiles installation completed successfully!"
echo "➡️  Reload your shell to apply: source ~/.zshrc"
echo "====================================================="
