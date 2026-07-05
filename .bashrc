# =====================================================================
# 🐚 Saurrabhh's Unified Bash Configuration (.bashrc)
# Supported Platforms: macOS, Linux, and Windows (Git Bash)
# Fully portable, OS-aware, and structured for modern productivity.
# =====================================================================

# ---------------------------------------------------------------------
# 0. BASH LINE EDITOR (ble.sh) - Initialize
# ---------------------------------------------------------------------
# Ensure USER environment variable is populated (required by ble.sh on Windows/Git Bash)
[ -z "$USER" ] && export USER="${USERNAME:-$(id -un)}"

# Enable auto-suggestions, syntax highlighting, and Zsh-like features.
[[ $- == *i* ]] && [ -f ~/.local/share/blesh/ble.sh ] && source ~/.local/share/blesh/ble.sh --noattach

# ---------------------------------------------------------------------
# 1. ENVIRONMENT PATHS & SHELL VARIABLES
# ---------------------------------------------------------------------
# Append local user bin directories (useful for pip, cargo, and npm global installs)
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------
# 2. BASH HISTORICAL COMMAND LINE SETTINGS
# ---------------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000

# Append to history file rather than overwriting
shopt -s histappend

# ---------------------------------------------------------------------
# 3. CUSTOM VISUAL THEME & PROMPT (JetBrains Blue)
# ---------------------------------------------------------------------
# Configure a clean, minimal prompt displaying only the current directory:
#   * \[\e[38;2;53;116;240m\] : Hex color `#3574f0` (JetBrains Active Blue)
#   * \W                     : Renders only the trailing folder name (basename) of your path
#   * \[\e[0m\]              : Resets text color back to your terminal's default foreground
PS1='\[\e[38;2;53;116;240m\]\W\[\e[0m\] $ '

# ---------------------------------------------------------------------
# 4. ALIASES & SHORTCUTS
# ---------------------------------------------------------------------
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias gp='git push'
alias gd='git diff'
alias gco='git checkout'

# Fix: Run agy using winpty inside a tmux session under MSYS2/Git Bash/Cygwin (PTY/TTY workaround)
if [[ -n "$TMUX" ]]; then
    if [[ "$(uname -s)" == *"MINGW"* || "$(uname -s)" == *"MSYS"* || "$(uname -s)" == *"CYGWIN"* ]]; then
        alias agy="winpty agy"
    fi
fi

# Workaround for Git Bash PTY/TTY issue on Windows: runs tmux inside script session to allocate pseudo-terminal
if [[ "$(uname -s)" == *"MINGW"* || "$(uname -s)" == *"MSYS"* || "$(uname -s)" == *"CYGWIN"* ]]; then
    tmux() {
        if [ $# -eq 0 ]; then
            script -qO /dev/null -c tmux
        else
            local cmd=""
            for arg in "$@"; do
                cmd="$cmd '${arg//\'/\'\\\'\'}'"
            done
            script -qO /dev/null -c "tmux $cmd"
        fi
    }
fi

# ---------------------------------------------------------------------
# 5. BASH LINE EDITOR (ble.sh) - Attach
# ---------------------------------------------------------------------
# Attach ble.sh to the terminal session to apply suggestions.
[[ $- == *i* ]] && [ -f ~/.local/share/blesh/ble.sh ] && ble-attach

