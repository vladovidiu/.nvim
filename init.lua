-- =====================================================================================
-- Neovim Minimal Configuration
-- Author: Vlad
-- Description: This configuration heavily relies on builtin functionality over plugins.
-- Principles: [built-in first, performance, simplicity]
-- =====================================================================================

-- =====================================================================================
-- [[ Performance ]]
-- =====================================================================================
vim.loader.enable() -- Enable byte-compiled Lua module cache for faster startup

-- =====================================================================================
-- [[ Leader Keys ]]
-- =====================================================================================
-- Set before plugins/mappings to ensure consistency
vim.g.mapleader = ' '      -- Space as leader
vim.g.maplocalleader = ' ' -- Same for local mappings

-- =====================================================================================
-- [[ Editor Options ]]
-- =====================================================================================

-- Line Numbers
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers for easy jumping

-- Visual Appearance
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.signcolumn = "yes"    -- Always show sign column to prevent text shifting
vim.opt.wrap = false          -- Don't wrap long lines

-- Indentation
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Size of an indent
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.smartindent = true    -- Insert indents automatically

-- System Integration
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.mouse = "a"               -- Enable mouse support in all modes

-- File Management
vim.opt.swapfile = false         -- Don't create swap files
vim.opt.backup = false           -- Don't create backup files
vim.opt.undofile = true          -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undodir"

-- Search
vim.opt.ignorecase = true     -- Ignore case when searching
vim.opt.smartcase = true      -- Override ignorecase if search contains capitals

-- Grep (using ripgrep)
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- Completion
vim.opt.completeopt = { "menuone", "noselect", "popup" } -- Better completion experience

-- Performance
vim.opt.updatetime = 250      -- Faster completion and CursorHold
vim.opt.timeoutlen = 300      -- Faster key sequence completion

-- File Watching
vim.opt.autoread = true       -- Reload files changed outside vim

-- Split Behavior
vim.opt.splitbelow = true     -- Open horizontal splits below
vim.opt.splitright = true     -- Open vertical splits to the right
vim.opt.splitkeep = "screen"  -- Keep the text on the same screen line

-- =====================================================================================
-- [[ Autocommands ]]
-- =====================================================================================

-- Auto-open quickfix after grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  callback = function()
    vim.cmd("copen")
  end,
})

-- =====================================================================================
-- [[ Commands ]]
-- =====================================================================================

-- Make :grep always run silently
vim.cmd("cnoreabbrev <expr> grep 'silent grep!'")

-- =====================================================================================
-- [[ Keymaps ]]
-- =====================================================================================

-- File Explorer
vim.keymap.set("n", "<leader>e", ":Lexplore<CR>", { desc = "Open file explorer" })

-- =====================================================================================
-- [[ Netrw Configuration ]]
-- =====================================================================================

vim.g.netrw_winsize = 20          -- Width of the explorer (20% of window)
vim.g.netrw_banner = 0            -- Supress netrw banner
vim.g.netrw_liststyle = 3         -- Tree style listing
vim.g.netrw_browse_split = 4      -- Open files in previous window
vim.g.netrw_altv = 1              -- Open splits to the right
vim.g.netrw_keepdir = 0           -- Keep current directory and browsing directory synced
