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

*The script will automatically detect whether you are on WSL or macOS, symlink the files to their correct locations, and append the JetBrains Blue prompt config to your `.bashrc` and `.zshrc` safely.*

---

## 🛠️ Manual Installation (Step-by-Step)

If you prefer to configure things manually, use the steps below:

### 1. Tmux Configuration
Symlink the Tmux configuration to your Unix home directory:
```bash
ln -sf ~/development/dotfiles/.tmux.conf ~/.tmux.conf
```
*Reload active session:* `tmux source-file ~/.tmux.conf`

### 2. WezTerm Configuration
*   **On macOS**: Symlink to your home directory:
    ```bash
    ln -sf ~/development/dotfiles/.wezterm.lua ~/.wezterm.lua
    ```
*   **On WSL (Windows)**: Create a native Windows directory link to your User Profile (`C:\Users\Saurabh`):
    ```bash
    cmd.exe /c "mklink %USERPROFILE%\.wezterm.lua C:\Users\Saurabh\development\dotfiles\.wezterm.lua"
    ```

### 3. Shell Prompts (JetBrains Blue Path)
To set up the minimal prompt showing only the active folder name in JetBrains Blue:

*   **For Zsh (`~/.zshrc` on macOS & WSL)**:
    Add the following lines to your `~/.zshrc`:
    ```zsh
    # Set up a clean, minimal JetBrains-themed prompt
    PROMPT='%F{#3574f0}%c%f $ '
    ```
*   **For Bash (`~/.bashrc` on WSL)**:
    Add the following lines to your `~/.bashrc`:
    ```bash
    # Set up a clean, minimal JetBrains-themed prompt
    if [ "$color_prompt" = yes ]; then
        PS1='\[\033[38;2;53;116;240m\]\W\[\033[00m\] \$ '
    else
        PS1='\W \$ '
    fi
    ```

---

## ⌨️ Custom Keybindings

Here is a quick reference for the custom layouts and pane shortcuts configured in this repository:

### Pane Management & Splitting
*   **Split Vertical** (Side-by-side): `Ctrl + Alt + v` (sends Prefix + `|`)
*   **Split Horizontal** (Top-to-bottom): `Ctrl + Alt + h` (sends Prefix + `-`)
*   **Zoom Active Pane** (Toggle fullscreen): `Ctrl + Alt + z` (sends Prefix + `z`)
*   **Close Active Pane**: `Ctrl + Alt + w` (sends Prefix + `x`)

### Navigation & Layout Swapping
*   **Navigate Panes**: `Ctrl + Alt + Arrow Keys`
*   **Swap Panes** (Move pane contents): `Ctrl + Alt + Shift + Arrow Keys`

### 🚀 Advanced: Join/Move Panes
*   **`Ctrl + Alt + j`**: Merges the current active pane **below** the last active pane (vertical split).
*   **`Ctrl + Alt + k`**: Merges the current active pane **to the right of** the last active pane (horizontal split).
