local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. Identify the Operating System
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

-- 2. Set the Default Program (Auto-launch tmux)
if is_windows then
    -- On Windows, launch WSL and immediately attach/create a tmux session named "main"
    config.default_prog = { 'wsl.exe', '--exec', 'tmux', 'new-session', '-A', '-s', 'main' }
else
    -- On macOS, use zsh to attach/create a tmux session named "main"
    -- Adjust '/bin/zsh' if you use bash or fish
    config.default_prog = { '/bin/zsh', '-c', 'tmux new-session -A -s main' }
end

-- 3. UI and Aesthetics (Optional but recommended)
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font 'JetBrains Mono'
config.hide_tab_bar_if_only_one_tab = true -- Let tmux handle the tabs

config.keys = {
    -- PASTE: CTRL+V on Windows, CMD+V on Mac
    {
        key = 'v',
        mods = is_windows and 'CTRL' or 'SUPER', 
        action = wezterm.action.PasteFrom 'Clipboard',
    },
    -- COPY: CTRL+SHIFT+C on Windows, CMD+C on Mac
    {
        key = 'c',
        mods = is_windows and 'CTRL|SHIFT' or 'SUPER', 
        action = wezterm.action.CopyTo 'Clipboard',
    },
}

config.mouse_bindings = {
    -- Bind releasing the left mouse button after a selection to copy to clipboard
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
    },
}

return config