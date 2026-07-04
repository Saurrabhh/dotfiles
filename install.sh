#!/usr/bin/env bash

# Resolve the absolute path to this dotfiles repository directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "==========================================="
echo "⚙️  Installing Dotfiles for WezTerm & Tmux"
echo "==========================================="

# 1. Tmux Configuration Symlink (Works on WSL and macOS)
echo "🔗 Symlinking .tmux.conf..."
ln -sf "$DIR/.tmux.conf" "$HOME/.tmux.conf"
echo "✅ Symlinked .tmux.conf to ~/.tmux.conf"

# 2. WezTerm Configuration Symlink
# Detect if running in WSL (Windows Subsystem for Linux)
if grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    echo "💻 WSL detected. Creating native Windows symlink for WezTerm..."
    # Query Windows %USERPROFILE% environment variable and convert to WSL path
    WIN_USER_PROFILE=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')
    if [ -n "$WIN_USER_PROFILE" ]; then
        WIN_HOME=$(wslpath "$WIN_USER_PROFILE")
        if [ -d "$WIN_HOME" ]; then
            # Convert WSL directory path to a Windows path
            WIN_FILE_PATH=$(wslpath -w "$DIR/.wezterm.lua")
            
            # Delete existing file/symlink if it exists on Windows
            cmd.exe /c "del %USERPROFILE%\.wezterm.lua" 2>/dev/null
            
            # Create Windows symlink via cmd.exe (requires developer mode or admin, falls back to copy)
            if cmd.exe /c "mklink %USERPROFILE%\.wezterm.lua \"$WIN_FILE_PATH\"" &>/dev/null; then
                echo "✅ Created Windows symlink for .wezterm.lua in %USERPROFILE%"
            else
                # Fallback to direct file copy if mklink fails due to permissions
                cp "$DIR/.wezterm.lua" "$WIN_HOME/.wezterm.lua"
                echo "✅ Copied .wezterm.lua to $WIN_HOME/.wezterm.lua (symlink fallback)"
            fi
        else
            echo "⚠️ Could not resolve Windows home directory path: $WIN_HOME"
        fi
    else
        echo "⚠️ Could not read %USERPROFILE% from cmd.exe"
    fi
else
    # macOS or standard Linux
    echo "🍎 macOS/Linux detected. Symlinking WezTerm config to Unix Home..."
    ln -sf "$DIR/.wezterm.lua" "$HOME/.wezterm.lua"
    echo "✅ Symlinked .wezterm.lua to ~/.wezterm.lua"
fi

# 3. Add Minimal JetBrains Blue Prompts
echo "✏️  Configuring Shell Prompts..."

# Bash Setup (~/.bashrc)
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "53;116;240" "$HOME/.bashrc"; then
        echo -e "\n# JetBrains Blue Minimal Prompt (Added by installer)" >> "$HOME/.bashrc"
        echo "PS1='\[\033[38;2;53;116;240m\]\W\[\033[00m\] \$ '" >> "$HOME/.bashrc"
        echo "✅ Configured minimal prompt in ~/.bashrc"
    else
        echo "ℹ️  Minimal prompt already configured in ~/.bashrc"
    fi
fi

# Zsh Setup (~/.zshrc)
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "#3574f0" "$HOME/.zshrc"; then
        echo -e "\n# JetBrains Blue Minimal Prompt (Added by installer)" >> "$HOME/.zshrc"
        echo "PROMPT='%F{#3574f0}%c%f $ '" >> "$HOME/.zshrc"
        echo "✅ Configured minimal prompt in ~/.zshrc"
    else
        echo "ℹ️  Minimal prompt already configured in ~/.zshrc"
    fi
fi

# Reload active tmux configuration if tmux is running
if tmux info &>/dev/null; then
    echo "🔄 Reloading active Tmux configuration..."
    tmux source-file "$HOME/.tmux.conf"
fi

echo "==========================================="
echo "🎉 Installation completed successfully!"
echo "➡️  Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo "==========================================="
