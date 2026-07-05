# Saurrabhh's Dotfiles

This repository contains my personal configurations for **WezTerm**, **Tmux**, **Neovim**, and shell prompts, customized to recreate the modern **JetBrains IDEs (IntelliJ, WebStorm) "Island Dark" UI** for a unified, low-eye-strain developer workspace using **JetBrains Mono** only.

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

To set up everything at once:

1. Clone this repository to `~/development/dotfiles` (or `C:\Users\Saurabh\development\dotfiles` on Windows):
   ```bash
   git clone https://github.com/Saurrabhh/dotfiles.git ~/development/dotfiles
   ```
2. Navigate to the repository and run the install script:
   ```bash
   cd ~/development/dotfiles
   chmod +x install.sh
   ./install.sh
   ```

*The script will automatically detect whether you are on Windows (Git Bash), macOS, or Linux, and link/copy the configuration files (including WezTerm, Neovim, Bash, and Zsh) to their correct locations.*

---

## 🛠️ Component Setup & Manual Installation

Below are the detailed manual setup instructions and configuration descriptions for each individual component.

---

### 💻 1. WezTerm Setup
WezTerm serves as the main graphical terminal window, styled with JetBrains-equivalent color overrides.

*   **Config File**: [.wezterm.lua](file:///C:/Users/Saurabh/development/dotfiles/.wezterm.lua)
*   **Aesthetics**: Base scheme is `Tokyo Night`, with background and text overridden to match the JetBrains IntelliJ IDEs (`#1e1f22` background, `#dfe1e5` text, and `#214283` selection blue). Has thin window padding (`10px`), disabled scrollbar, and launches maximized on Windows or in native fullscreen space on macOS.
*   **Mac Setup**:
    ```bash
    ln -sf ~/development/dotfiles/.wezterm.lua ~/.wezterm.lua
    ```
*   **Windows (Git Bash) Setup**:
    Run this command in Git Bash to link the config directly to your Windows User Profile:
    ```bash
    ln -sf ~/development/dotfiles/.wezterm.lua ~/.wezterm.lua
    ```

---

### 📦 2. Tmux Setup
Tmux handles layout splitting, session multiplexing, and in-terminal tabs (primarily for macOS and Linux environments).

*   **Config File**: [.tmux.conf](file:///C:/Users/Saurabh/development/dotfiles/.tmux.conf)
*   **Aesthetics**: Styled like a modern browser tab bar. Active pane borders are highlighted in JetBrains Blue (`#3574f0`).
*   **Setup**:
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

*   **Config Folder**: [.config/nvim](file:///C:/Users/Saurabh/development/dotfiles/.config/nvim/)
*   **Setup (macOS / Linux)**:
    ```bash
    mkdir -p ~/.config
    ln -sfn ~/development/dotfiles/.config/nvim ~/.config/nvim
    ```
*   **Setup (Windows / Git Bash)**:
    We link to both Git Bash's configuration directory and native Windows Neovim configuration directory:
    ```bash
    ln -sfn ~/development/dotfiles/.config/nvim ~/.config/nvim
    ln -sfn ~/development/dotfiles/.config/nvim ~/AppData/Local/nvim
    ```

---

### 🐚 4. Shell Prompts & Configurations

This repository provides portable configuration files for both **Bash** (for Git Bash on Windows, Linux, macOS) and **Zsh** (for macOS, Linux).

#### 💻 A. Bash Setup (Git Bash & Linux)
Styles your prompt to show only the current folder name in JetBrains Blue (`#3574f0`) and integrates **`ble.sh` (Bash Line Editor)** for rich autosuggestions, syntax highlighting, and auto-completion.
*   **Config Files**: [.bashrc](file:///C:/Users/Saurabh/development/dotfiles/.bashrc) and [.bash_profile](file:///C:/Users/Saurabh/development/dotfiles/.bash_profile)
*   **Automated Setup via `./install.sh`**:
    The installation script automatically detects Git Bash on Windows and handles:
    1. Installing `tmux` and its dependencies locally (`~/bin`).
    2. Installing `ble.sh` by building it into `~/.local/share/blesh/`.
*   **Manual Setup**:
    ```bash
    ln -sf ~/development/dotfiles/.bashrc ~/.bashrc
    ln -sf ~/development/dotfiles/.bash_profile ~/.bash_profile
    ```
*   **Apply Config**: Run `source ~/.bashrc` to refresh.

#### 🍎 B. Zsh Setup (macOS & Linux)
*   **Config File**: [.zshrc](file:///C:/Users/Saurabh/development/dotfiles/.zshrc)
*   **Setup**:
    ```bash
    ln -sf ~/development/dotfiles/.zshrc ~/.zshrc
    ```
*   **Apply Config**: Run `source ~/.zshrc` to refresh.

---

## ⌨️ Keyboard Shortcuts Reference

This repository maps complex Tmux pane management functions to highly intuitive, modern WezTerm hotkeys. You can use either the WezTerm global shortcuts or the native Tmux prefix commands.

### 💻 1. WezTerm Custom Shortcuts

| Action | Shortcut (Windows) | Shortcut (macOS) | Under-the-Hood Tmux Command |
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
