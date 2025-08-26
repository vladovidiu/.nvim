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
vim.opt.cursorline = true     -- Highlight current line
vim.opt.colorcolumn = "120"   -- Show column at 120 characters

-- Indentation
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Size of an indent
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.softtabstop = 2       -- Number of spaces of soft tabs
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
vim.opt.ignorecase = true          -- Ignore case when searching
vim.opt.smartcase = true           -- Override ignorecase if search contains capitals

-- Grep (using ripgrep)
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- Completion
vim.opt.completeopt = { "menuone", "noselect", "popup", "noinsert" } -- Better completion experience

-- Performance
vim.opt.updatetime = 250      -- Faster completion and CursorHold
vim.opt.timeoutlen = 300      -- Faster key sequence completion

-- File Watching
vim.opt.autoread = true       -- Reload files changed outside vim

-- Split Behavior
vim.opt.splitbelow = true     -- Open horizontal splits below
vim.opt.splitright = true     -- Open vertical splits to the right
vim.opt.splitkeep = "screen"  -- Keep the text on the same screen line

-- Diffs
vim.opt.diffopt:append("vertical")           -- Vertical diff splits
vim.opt.diffopt:append("algorithm:patience") -- Better diff algorithm
vim.opt.diffopt:append("linematch:60")       -- Better diff highlighting (smart line matching)

-- Behaviour
vim.opt.backspace = "indent,eol,start" -- Make backspace behave naturally
vim.opt.path:append("**")              -- Search into subfolders with `gf`

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
-- [[ Plugins ]]
-- =====================================================================================

vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },                                    -- Oil.nvim - edit filesystem like a buffer
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },  -- Treesitter
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },                 -- Rose Pine theme
})

local oil = require("oil")
oil.setup({
  keymaps = {
    ["q"] = "actions.close",
  },
})

-- Treesitter
require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  ensure_installed = {
    "lua",
  },
})

require("rose-pine").setup({
  styles = {
    transparency = true,
  },
})
vim.cmd("colorscheme rose-pine")

-- =====================================================================================
-- [[ Keymaps ]]
-- =====================================================================================

-- FZF File Finding (minimal)
vim.keymap.set("n", "<leader>ff", function()
  vim.cmd('split | terminal fzf')
  vim.cmd('resize 15')
  vim.cmd('startinsert')
  
  -- Auto-open selected file when fzf exits
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    once = true,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      for _, line in ipairs(lines) do
        if line ~= '' and vim.fn.filereadable(line) == 1 then
          vim.cmd('bdelete!')
          vim.cmd('edit ' .. vim.fn.fnameescape(line))
          break
        end
      end
    end
  })
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>e", function()
  require("oil").toggle_float(".")
end)
