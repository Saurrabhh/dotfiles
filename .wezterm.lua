local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. Identify the Operating System
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

-- 2. Set the Default Program
if is_windows then
    -- On Windows, launch WSL directly
    config.default_prog = { 'wsl.exe' }
else
    -- On macOS, launch the default zsh shell
    config.default_prog = { '/bin/zsh' }
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

    -- --- TMUX PANE (PANEL) MANAGEMENT ---

    -- Split pane vertically (Ctrl+Alt+v) -> Sends Prefix + |
    {
        key = 'v',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02|',
    },

    -- Split pane horizontally (Ctrl+Alt+h) -> Sends Prefix + -
    {
        key = 'h',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02-',
    },

    -- Toggle Pane Zoom / Fullscreen (Ctrl+Alt+z) -> Sends Prefix + z
    {
        key = 'z',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02z',
    },

    -- Close current pane (Ctrl+Alt+w) -> Sends Prefix + x
    {
        key = 'w',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02x',
    },

    -- Toggle between the last two active panes (Ctrl+Alt+;) -> Sends Prefix + ;
    {
        key = ';',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02;',
    },

    -- Navigate panes using Ctrl+Alt + Arrow keys -> Sends Prefix + Arrow Key escape code
    {
        key = 'LeftArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02\x1b[D',
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02\x1b[C',
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02\x1b[A',
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02\x1b[B',
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