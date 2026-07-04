# =====================================================================
# Saurrabhh's Unified .zshrc Configuration
# Supported on macOS & WSL (Windows Subsystem for Linux)
# =====================================================================

# --- 1. OS DETECTION ---
IS_MAC=false
IS_WSL=false
if [[ "$(uname)" == "Darwin" ]]; then
    IS_MAC=true
elif grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    IS_WSL=true
fi

# --- 2. ENVIRONMENT PATHS ---
# Add local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"

if $IS_MAC; then
    # Add Homebrew to PATH on macOS (both Apple Silicon /opt/homebrew and Intel)
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

if $IS_WSL; then
    # Set Windows default browser for WSL links
    export BROWSER="/mnt/c/Windows/System32/cmd.exe /c start"
fi

# --- 3. ZSH HISTORY SETTINGS ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt histignorealldups

# --- 4. THEME & PROMPT (JetBrains Blue) ---
# Clean, minimal prompt showing only current directory in JetBrains Blue
PROMPT='%F{#3574f0}%c%f $ '

# --- 5. PLUGINS & AUTO-COMPLETION ---
# 1. fzf completion & key bindings
if $IS_MAC; then
    # macOS Homebrew paths
    [ -f "$(brew --prefix)/shell/completion.zsh" ] && source "$(brew --prefix)/shell/completion.zsh"
    [ -f "$(brew --prefix)/shell/key-bindings.zsh" ] && source "$(brew --prefix)/shell/key-bindings.zsh"
else
    # WSL / Linux package manager paths
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# 2. zsh-autosuggestions
if $IS_MAC; then
    [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 3. zsh-syntax-highlighting (Must be sourced last!)
if $IS_MAC; then
    [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
