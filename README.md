# Saurrabhh's Dotfiles

This repository contains my personal configurations for **WezTerm**, **Tmux**, and shell prompts, customized to recreate the modern **JetBrains IDEs (IntelliJ, WebStorm) "Island Dark" UI** for a unified, low-eye-strain developer workspace using **JetBrains Mono** only.

---

## 🎨 Theme Details: JetBrains Island Dark
*   **Terminal Background**: `#1e1f22` (IntelliJ Editor Background - soft, neutral dark charcoal)
*   **Terminal Foreground**: `#dfe1e5` (IntelliJ off-white text color)
*   **Tmux Status Line**: `#2b2d31` (IntelliJ UI Gray - creates the "island" tab look)
*   **Active Tab / Accents**: `#3574f0` (IntelliJ Active Blue)
*   **Directory Path (Shell Prompt)**: `#3574f0` (JetBrains Blue)
*   **Font**: **JetBrains Mono** (with ligatures and standard weight)

---

## ⚡ Automated Installation

To set up everything at once on a new machine:

1. Clone this repository to `~/development/dotfiles` (or `C:\Users\Saurabh\development\dotfiles` on Windows/WSL):
   ```bash
   git clone https://github.com/Saurrabhh/dotfiles.git ~/development/dotfiles
   ```
2. Navigate to the repository and run the install script:
   ```bash
   cd ~/development/dotfiles
   chmod +x install.sh
   ./install.sh
   ```

*The script will automatically detect whether you are on WSL or macOS, symlink the configuration files (including WezTerm, Tmux, Neovim, and Zsh) to their correct locations, and configure the minimal prompt for Bash.*


---

## 🛠️ Component Setup & Manual Installation

Below are the detailed manual setup instructions and configuration descriptions for each individual component.

---

### 💻 1. WezTerm Setup
WezTerm serves as the main graphical terminal window, styled with JetBrains-equivalent color overrides.

*   **Config File**: [.wezterm.lua](file:///mnt/c/Users/Saurabh/development/dotfiles/.wezterm.lua)
*   **Aesthetics**: Base scheme is `Tokyo Night`, with background and text overridden to match the JetBrains IntelliJ IDEs (`#1e1f22` background, `#dfe1e5` text, and `#214283` selection blue). Has thin window padding (`10px`), disabled scrollbar, and launches maximized on Windows or in native fullscreen space on macOS.
*   **Mac Setup**:
    ```bash
    ln -sf ~/development/dotfiles/.wezterm.lua ~/.wezterm.lua
    ```
*   **Windows / WSL Setup**:
    Run this command in WSL to link the config directly to your Windows User Profile (`C:\Users\Saurabh\.wezterm.lua`):
    ```bash
    cmd.exe /c "mklink %USERPROFILE%\.wezterm.lua C:\Users\Saurabh\development\dotfiles\.wezterm.lua"
    ```

---

### 📦 2. Tmux Setup
Tmux handles layout splitting, session multiplexing, and in-terminal tabs.

*   **Config File**: [.tmux.conf](file:///mnt/c/Users/Saurabh/development/dotfiles/.tmux.conf)
*   **Aesthetics**: Styled like a modern browser tab bar. The status line background matches the IntelliJ UI gray (`#2b2d31`). Active window tab matches the editor background (`#1e1f22`) with bold text, while inactive tabs blend in. Active pane borders are highlighted in JetBrains Blue (`#3574f0`).
*   **Setup (WSL & Mac)**:
    ```bash
    ln -sf ~/development/dotfiles/.tmux.conf ~/.tmux.conf
    ```
*   **Apply Config**: Inside an active Tmux session, run:
    ```bash
    tmux source-file ~/.tmux.conf
    ```

---

### 📝 3. Neovim Setup
Neovim is configured as a lightweight coding IDE, equipped with Native LSP configs, Flutter development tools, and in-editor rich Markdown preview.

*   **Config Folder**: [.config/nvim](file:///mnt/c/Users/Saurabh/development/dotfiles/.config/nvim/)
*   **Aesthetics**: Integrates `render-markdown.nvim` to automatically parse and render Markdown headers, code blocks, lists, and tables inline directly inside the editor buffer.
*   **Setup (WSL & Mac)**:
    Make sure your local config directory exists, then link the folder:
    ```bash
    mkdir -p ~/.config
    ln -sfn ~/development/dotfiles/.config/nvim ~/.config/nvim
    ```
*   **Apply Config**: Launch `nvim`. On the first startup, `lazy.nvim` will automatically download and install `render-markdown.nvim`, `nvim-treesitter`, and the required markdown syntax parsers.

---

### 🐚 4. Shell Prompts & Zsh Configuration

This repository provides a portable Zsh configuration file that handles OS-specific variables, history settings, completions, and styles your prompt to show only the current folder name in JetBrains Blue (`#3574f0`).

*   **Config File**: [.zshrc](file:///mnt/c/Users/Saurabh/development/dotfiles/.zshrc)
*   **Zsh Setup (macOS & WSL)**:
    We recommend symlinking the repository's `.zshrc` to your home directory (the install script will back up your old one to `~/.zshrc.backup` automatically):
    ```bash
    ln -sf ~/development/dotfiles/.zshrc ~/.zshrc
    ```
*   **Bash Setup (WSL)**:
    If you use Bash instead of Zsh in WSL, append these lines to your `~/.bashrc`:
    ```bash
    # Set up a clean, minimal JetBrains-themed prompt
    if [ "$color_prompt" = yes ]; then
        PS1='\[\033[38;2;53;116;240m\]\W\[\033[00m\] \$ '
    else
        PS1='\W \$ '
    fi
    ```
*   **Apply Config**: Run `source ~/.zshrc` or `source ~/.bashrc` to refresh.

---

## ⌨️ Keyboard Shortcuts Reference

This repository maps complex Tmux pane management functions to highly intuitive, modern WezTerm hotkeys. You can use either the WezTerm global shortcuts or the native Tmux prefix commands.

### 💻 1. WezTerm Custom Shortcuts (WSL & macOS)

| Action | Shortcut (WSL / Windows) | Shortcut (macOS) | Under-the-Hood Tmux Command |
| :--- | :--- | :--- | :--- |
| **Copy Selected Text** | `Ctrl + Shift + c` | `Cmd + c` | Copy selection to system clipboard |
| **Paste Clipboard Text** | `Ctrl + v` | `Cmd + v` | Paste from system clipboard |
| **Split Pane Vertically** (Left/Right) | `Ctrl + Alt + v` | `Ctrl + Alt + v` | `split-window -h` (Prefix + `|`) |
| **Split Pane Horizontally** (Top/Bottom) | `Ctrl + Alt + h` | `Ctrl + Alt + h` | `split-window -v` (Prefix + `-`) |
| **Toggle Zoom / Fullscreen Pane** | `Ctrl + Alt + z` | `Ctrl + Alt + z` | `resize-pane -Z` (Prefix + `z`) |
| **Close Active Pane** | `Ctrl + Alt + w` | `Ctrl + Alt + w` | `kill-pane` (Prefix + `x`) |
| **Toggle Last Active Pane** | `Ctrl + Alt + ;` | `Ctrl + Alt + ;` | Toggle back-and-forth (Prefix + `;`) |
| **Rename Active Pane** | `Ctrl + Alt + n` | `Ctrl + Alt + n` | `select-pane -T` (Prefix + `r`) |
| **Navigate Panes** | `Ctrl + Alt + Arrow Keys` | `Ctrl + Alt + Arrow Keys` | Focus adjacent pane (Prefix + Arrow) |
| **Swap Panes** (Exchange layout content) | `Ctrl + Alt + Shift + Arrows` | `Ctrl + Alt + Shift + Arrows` | Swap active pane (Prefix + Shift + Arrow) |
| **Join Pane Vertically** (Place below last active) | `Ctrl + Alt + j` | `Ctrl + Alt + j` | `join-pane -v -t !` (Prefix + `J`) |
| **Join Pane Horizontally** (Place right of last active) | `Ctrl + Alt + k` | `Ctrl + Alt + k` | `join-pane -h -t !` (Prefix + `K`) |
| **Switch directly to Pane 1-9** | `Ctrl + Alt + [1-9]` | `Ctrl + Alt + [1-9]` | Switch directly (Prefix + `q` + `[1-9]`) |

---

### 📦 2. Native Tmux Bindings (Used after pressing Prefix: `Ctrl + b`)

If you are using Tmux directly or want to use the default bindings, these custom overrides are defined in your `.tmux.conf`:

| Tmux Command Sequence | Action Description |
| :--- | :--- |
| `Ctrl + b` then `\|` | Split current pane vertically (side-by-side) |
| `Ctrl + b` then `-` | Split current pane horizontally (top-bottom) |
| `Ctrl + b` then `r` | Prompts to rename the current active pane title |
| `Ctrl + b` then `Shift + Arrow Keys` | Swap the active pane with an adjacent pane in that direction |
| `Ctrl + b` then `J` | Move current pane and join it **below** the last active pane |
| `Ctrl + b` then `K` | Move current pane and join it **to the right** of the last active pane |
| `Ctrl + b` then `q` | Displays pane numbers temporarily (press `1-9` to jump directly) |

