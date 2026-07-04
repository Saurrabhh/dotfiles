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

    -- Rename current pane (Ctrl+Alt+r) -> Sends Prefix + t (opens rename prompt)
    {
        key = 'r',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02t',
    },

    -- Navigate panes using Ctrl+Alt + Arrow keys (sends clean unmodified arrow keys)
    {
        key = 'LeftArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'LeftArrow', mods = 'NONE' },
        },
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'RightArrow', mods = 'NONE' },
        },
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'UpArrow', mods = 'NONE' },
        },
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'DownArrow', mods = 'NONE' },
        },
    },

    -- Swap panes using Ctrl+Alt+Shift + Arrow keys (sends clean Shift+arrow keys)
    {
        key = 'LeftArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'LeftArrow', mods = 'SHIFT' },
        },
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'RightArrow', mods = 'SHIFT' },
        },
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'UpArrow', mods = 'SHIFT' },
        },
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'DownArrow', mods = 'SHIFT' },
        },
    },
}

-- Bind Ctrl + Alt + 1-9 to switch to tmux panes 1-9 directly using display-panes
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString('\x02q' .. tostring(i)),
    })
end

config.mouse_bindings = {
    -- Bind releasing the left mouse button after a selection to copy to clipboard
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
    },
}

return config