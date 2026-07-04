-- =====================================================================
-- 📝 Neovim Configuration (init.lua)
-- Linked to: ~/.config/nvim/init.lua (WSL and macOS)
-- Integrates Flutter development support and rich inline Markdown previews
-- =====================================================================

-- =====================================================================
-- 1. BASE SETTINGS (Sensible Vanilla Defaults)
-- =====================================================================
-- Set Spacebar as the map leader key (used as a prefix for custom shortcuts)
vim.g.mapleader = " "

-- Line numbers config
vim.opt.number = true          -- Show absolute line number for the current line
vim.opt.relativenumber = true  -- Relative line numbers (helps quickly calculate jump distances)

-- Indentation defaults (conforms to Flutter and web standards of 2 spaces)
vim.opt.shiftwidth = 2         -- Number of spaces to use for each step of indent
vim.opt.tabstop = 2            -- Number of spaces that a Tab in the file counts for
vim.opt.expandtab = true       -- Convert Tab keystrokes into spaces

-- Enable 24-bit RGB TrueColor support (essential for WezTerm/Tokyo Night theme rendering)
vim.opt.termguicolors = true

-- =====================================================================
-- 2. BOOTSTRAP PLUGIN MANAGER (lazy.nvim)
-- =====================================================================
-- Installs lazy.nvim automatically if it is not already present on the system.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
-- Prepend the installer directory path to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)

-- =====================================================================
-- 3. INSTALL & CONFIGURE PLUGINS
-- =====================================================================
require("lazy").setup({
  -- Native LSP configuration support
  "neovim/nvim-lspconfig",
  
  -- Akinsho's Flutter Tools (automatically manages LSP, debugging, runs DevTools)
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      flutter_path = nil, -- Autodetects Flutter binary location from system PATH
      lsp = {
        color_files = true, -- Highlight hex/color codes inside widget properties
        settings = {
          showTodos = true, -- Highlight TODO tags in the codebase
          completeFunctionCalls = true, -- Auto-appends parentheses on autocomplete
        }
      }
    }
  },

  -- Treesitter configuration for parsing and syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-p>", desc = "Decrement selection", mode = "x" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "markdown_inline", "dart" },
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- In-buffer Markdown rendering (Obsidian-like editing preview)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = {
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎰 ", "󰎳 " },
      },
      checkbox = {
        enabled = true,
      },
    },
    ft = { "markdown" },
  },

  -- Synchronized browser markdown previewer (Space + m + p)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && ./install.sh",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
    },
  },

  -- Git integration (signs in status column, hunk previews, and diffs)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true, -- Adds inline blame annotations to lines
      })
      
      -- Keymaps for git navigation and actions
      local gs = require('gitsigns')
      vim.keymap.set('n', ']c', gs.next_hunk, { desc = "Next Git Hunk" })
      vim.keymap.set('n', '[c', gs.prev_hunk, { desc = "Previous Git Hunk" })
      vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = "Git Diff Current File" })
      vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = "Git Preview Hunk" })
      vim.keymap.set('n', '<leader>gb', gs.blame_line, { desc = "Git Blame Line" })
      vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = "Git Reset Hunk" })
    end
  },

  -- Interactive side-by-side git diff views for the whole project
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('diffview').setup({
        enhanced_diff_hl = true, -- Use Neovim's built-in enhancement for diff highlights
      })
      
      -- Keymaps to open/close Diffview and view history
      vim.keymap.set('n', '<leader>do', ':DiffviewOpen<CR>', { desc = "Open Git Diffview" })
      vim.keymap.set('n', '<leader>dc', ':DiffviewClose<CR>', { desc = "Close Git Diffview" })
      vim.keymap.set('n', '<leader>dh', ':DiffviewFileHistory %<CR>', { desc = "Git File History" })
    end
  },
})

-- =====================================================================
-- 4. DEVELOPMENT KEYBINDINGS & LSP SHORTCUTS
-- =====================================================================
-- Wrap Widget / LSP Code Actions (Space + a)
-- Triggers context-aware actions like wrapping, extracting, and renaming
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP Code Actions" })

-- Open Flutter DevTools in your browser (Space + fd)
vim.keymap.set("n", "<leader>fd", ":FlutterDevTools<CR>", { desc = "Flutter DevTools" })

-- Select Device / Run Flutter application in the active buffer (Space + fr)
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter Run" })

-- Quit active Flutter debugging run (Space + fq)
vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
