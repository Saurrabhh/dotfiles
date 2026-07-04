-- =====================================================================
-- 💻 WezTerm Configuration
-- Linked to: ~/.wezterm.lua (macOS) or %USERPROFILE%\.wezterm.lua (Windows)
-- Core Theme: Tokyo Night with JetBrains Island Dark Overrides
-- =====================================================================

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ---------------------------------------------------------------------
-- 1. OPERATING SYSTEM DETECTION
-- ---------------------------------------------------------------------
-- Identify the host OS using the target triple compiler identifier.
local is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

-- ---------------------------------------------------------------------
-- 2. DEFAULT SHELL PROGRAM
-- ---------------------------------------------------------------------
-- Select the default shell program depending on the platform.
if is_windows then
    -- On Windows, launch WSL directly into your default Linux distro.
    config.default_prog = { 'wsl.exe' }
else
    -- On macOS, launch the standard login Zsh shell.
    config.default_prog = { '/bin/zsh' }
end

-- ---------------------------------------------------------------------
-- 3. UI AND AESTHETICS (JetBrains Island Dark Overrides)
-- ---------------------------------------------------------------------
-- Use the Tokyo Night syntax theme but override the editor canvas and 
-- text colors to match the modern JetBrains IntelliJ New UI colors.
config.color_scheme = 'Tokyo Night'
config.colors = {
    background = '#1e1f22',   -- IntelliJ New UI editor background (neutral charcoal)
    foreground = '#dfe1e5',   -- IntelliJ New UI default text color (soft off-white)
    selection_bg = '#214283', -- IntelliJ New UI active selection highlight (blue)
}

-- Typographic Settings
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 11.5

-- Window Padding (adds subtle breathing room inside the window frame)
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

-- Disable window scrollbars for a clean, distraction-free interface
config.enable_scroll_bar = false

-- Tab Bar Handling (let Tmux manage all terminal splits/tabs)
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- ---------------------------------------------------------------------
-- 4. KEYBOARD SHORTCUTS & KEYBINDINGS
-- ---------------------------------------------------------------------
-- Maps complex Tmux multiplexer controls to global WezTerm shortcuts.
-- Note: '\x02' represents Ctrl+b (the default Tmux command prefix).
config.keys = {
    -- CLIPBOARD CONTROLS
    -- Paste text: Ctrl+V on Windows/WSL, Cmd+V on macOS
    {
        key = 'v',
        mods = is_windows and 'CTRL' or 'SUPER', 
        action = wezterm.action.PasteFrom 'Clipboard',
    },
    -- Copy text: Ctrl+Shift+C on Windows/WSL, Cmd+C on macOS
    {
        key = 'c',
        mods = is_windows and 'CTRL|SHIFT' or 'SUPER', 
        action = wezterm.action.CopyTo 'Clipboard',
    },

    -- PANE CREATION
    -- Split vertical (side-by-side) -> Sends Ctrl+b followed by |
    {
        key = 'v',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02|',
    },
    -- Split horizontal (top-to-bottom) -> Sends Ctrl+b followed by -
    {
        key = 'h',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02-',
    },

    -- PANE LAYOUT MODIFIERS
    -- Zoom/Fullscreen the current pane -> Sends Ctrl+b followed by z
    {
        key = 'z',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02z',
    },
    -- Close the active pane -> Sends Ctrl+b followed by x
    {
        key = 'w',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02x',
    },
    -- Toggle focus between last active panes -> Sends Ctrl+b followed by ;
    {
        key = ';',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02;',
    },
    -- Rename active pane title -> Sends Ctrl+b followed by r
    {
        key = 'n',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02r',
    },

    -- PANE FOCUS NAVIGATION
    -- Navigate focus using Ctrl+Alt + Arrow keys
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

    -- PANE POSITION SWAPPING
    -- Swap active pane location using Ctrl+Alt+Shift + Arrow keys
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

    -- PANE RESIZING
    -- Resize active pane using Ctrl+Shift + Arrow keys (sends Ctrl+b followed by Ctrl+Arrow)
    {
        key = 'LeftArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'LeftArrow', mods = 'CTRL' },
        },
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'RightArrow', mods = 'CTRL' },
        },
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'UpArrow', mods = 'CTRL' },
        },
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.Multiple {
            wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
            wezterm.action.SendKey { key = 'DownArrow', mods = 'CTRL' },
        },
    },

    -- ADVANCED: JOIN/MERGE PANES
    -- Move current active pane and stack it BELOW the last active pane (Ctrl+Alt+j)
    {
        key = 'j',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02J',
    },
    -- Move current active pane and place it to the RIGHT of the last active pane (Ctrl+Alt+k)
    {
        key = 'k',
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString '\x02K',
    },
}

-- DIRECT PANE SWITCHING INDEX LOOP
-- Maps Ctrl+Alt + 1-9 keys to jump directly to Tmux panes 1-9.
-- Emulates sending: Ctrl+b followed by q followed by the pane number.
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL|ALT',
        action = wezterm.action.SendString('\x02q' .. tostring(i)),
    })
end

-- ---------------------------------------------------------------------
-- 5. MOUSE INTERACTION RULES
-- ---------------------------------------------------------------------
config.mouse_bindings = {
    -- Release left mouse button after drag-selection to automatically copy text
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
    },
}

-- ---------------------------------------------------------------------
-- 6. STARTUP EVENT LIFECYCLE HANDLERS
-- ---------------------------------------------------------------------
-- OS-specific window opening rules:
--   * Windows: Maximize window to fill screen but retain taskbar/controls.
--   * macOS: Enter native fullscreen Space, auto-hiding controls to top hover.
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    local gui_window = window:gui_window()
    if is_windows then
        gui_window:maximize()
    else
        gui_window:toggle_fullscreen()
    end
end)

return config