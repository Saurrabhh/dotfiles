-- =====================================================================
-- 1. BASE SETTINGS (Sensible Vanilla Defaults)
-- =====================================================================
vim.g.mapleader = " " -- Set Spacebar as your leader key
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers (great for motions)
vim.opt.shiftwidth = 2 -- Flutter standard is 2 spaces
vim.opt.tabstop = 2
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.termguicolors = true -- Support true colors in WezTerm

-- =====================================================================
-- 2. BOOTSTRAP PLUGIN MANAGER (lazy.nvim)
-- =====================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================================
-- 3. INSTALL & CONFIGURE MINIMAL PLUGINS
-- =====================================================================
require("lazy").setup({
  "neovim/nvim-lspconfig", -- Native LSP configurations
  {
    "akinsho/flutter-tools.nvim", -- The core Flutter tool integration
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      flutter_path = nil, -- Autodetected from your PATH
      lsp = {
        color_files = true, -- Highlight color codes in widgets
        settings = {
          showTodos = true,
          completeFunctionCalls = true, -- Adds parentheses on autocomplete
        }
      }
    }
  }
})

-- =====================================================================
-- 4. FLUTTER KEYBINDINGS
-- =====================================================================
-- Wrap Widget / Code Actions (Space + a)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP Code Actions" })

-- Open Flutter DevTools (Space + fd)
vim.keymap.set("n", "<leader>fd", ":FlutterDevTools<CR>", { desc = "Flutter DevTools" })

-- Select Device / Run (Space + fr)
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter Run" })
vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
