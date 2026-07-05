# =====================================================================
# 🐚 Saurrabhh's Unified Zsh Configuration (.zshrc)
# Supported Platforms: macOS & WSL (Windows Subsystem for Linux)
# Fully portable, OS-aware, and structured for modern productivity.
# =====================================================================

# ---------------------------------------------------------------------
# 1. OPERATING SYSTEM DETECTION
# ---------------------------------------------------------------------
# Set flags to customize behaviors and paths for Mac vs Windows/WSL.
IS_MAC=false
IS_WSL=false
if [[ "$(uname)" == "Darwin" ]]; then
    IS_MAC=true
elif grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    IS_WSL=true
fi

# ---------------------------------------------------------------------
# 2. ENVIRONMENT PATHS & SHELL VARIABLES
# ---------------------------------------------------------------------
# Append local user bin directories (useful for pip, cargo, and npm global installs)
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

if $IS_MAC; then
    # Initialize Homebrew paths dynamically on macOS.
    # Checks both Apple Silicon (/opt/homebrew) and Intel (/usr/local/bin).
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

if $IS_WSL; then
    # Set default browser to launch Windows default browser from inside WSL.
    # Allows links opened in your terminal or Neovim to show up in Windows Chrome/Edge.
    export BROWSER="/mnt/c/Windows/System32/cmd.exe /c start"
fi

# ---------------------------------------------------------------------
# 3. ZSH HISTORICAL COMMAND LINE SETTINGS
# ---------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Shell history behavior settings:
#   * appendhistory: Appends commands to history rather than overwriting.
#   * sharehistory: Shares history across all open terminal windows in real time.
#   * histignorealldups: Removes older duplicates from history lists to keep it tidy.
setopt appendhistory
setopt sharehistory
setopt histignorealldups

# ---------------------------------------------------------------------
# 4. CUSTOM VISUAL THEME & PROMPT (JetBrains Blue)
# ---------------------------------------------------------------------
# Configure a clean, minimal prompt displaying only the current directory:
#   * %F{#3574f0} : Starts foreground coloring using JetBrains Active Blue.
#   * %c          : Renders only the trailing folder name (basename) of your path.
#   * %f          : Resets text color back to your terminal's default foreground.
PROMPT='%F{#3574f0}%c%f $ '

# ---------------------------------------------------------------------
# 5. AUTO-COMPLETION AND CO-PLUGINS
# ---------------------------------------------------------------------

# A. Fuzzy Finder (fzf) Completions & Key Bindings
if $IS_MAC; then
    # Sourced from Homebrew install paths on macOS
    [ -f "$(brew --prefix)/shell/completion.zsh" ] && source "$(brew --prefix)/shell/completion.zsh"
    [ -f "$(brew --prefix)/shell/key-bindings.zsh" ] && source "$(brew --prefix)/shell/key-bindings.zsh"
else
    # Sourced from standard apt/pacman/dnf package locations on WSL/Linux
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# B. Zsh Auto-Suggestions (inline autocomplete as you type)
if $IS_MAC; then
    [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# C. Zsh Syntax Highlighting
# Note: This plugin MUST be loaded last in your .zshrc to work correctly!
if $IS_MAC; then
    [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Fix: Run agy using winpty inside a tmux session under MSYS2/Git Bash/Cygwin (PTY/TTY workaround)
if [[ -n "$TMUX" ]]; then
    if [[ "$(uname -s)" == *"MINGW"* || "$(uname -s)" == *"MSYS"* || "$(uname -s)" == *"CYGWIN"* ]]; then
        alias agy="winpty agy"
    fi
fi

