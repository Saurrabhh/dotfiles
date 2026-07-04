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

return config