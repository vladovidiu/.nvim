local Util = require("util")

local map = vim.keymap.set

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

map({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Netrw
map("n", "<leader>pv", vim.cmd.Ex, opts)

-- Misc
map("n", "<ESC>", ":noh<CR>", opts) -- clear search results
map("n", "<leader>ll", "<cmd>Lazy<CR>", opts) -- Lazy
map("n", "<leader>ps", "<cmd>Lazy sync<CR>", opts) -- update lazy plugins
map("n", "<leader>ss", ":vsplit | term<CR>", opts)

-- Terminal
map("t", "<ESC>", "<C-\\><C-N>", term_opts)
map("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
map("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
map("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
map("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

map("n", "<leader>ft", "<cmd>ToggleTerm<cr>", opts)

-- Line navigation
map("i", "<C-b>", "<ESC>^i", opts)
map("i", "<C-e>", "<END>", opts)

-- Move to window using <ctrl> hjkl keys
map("n", "<C-h>", require("smart-splits").move_cursor_left, opts)
map("n", "<C-j>", require("smart-splits").move_cursor_down, opts)
map("n", "<C-k>", require("smart-splits").move_cursor_up, opts)
map("n", "<C-l>", require("smart-splits").move_cursor_right, opts)

-- Resize windows
map("n", "<A-h>", require("smart-splits").resize_left, opts)
map("n", "<A-j>", require("smart-splits").resize_down, opts)
map("n", "<A-k>", require("smart-splits").resize_up, opts)
map("n", "<A-l>", require("smart-splits").resize_right, opts)

-- lazygit
map(
  "n",
  "<leader>gg",
  function() Util.float_term({ "lazygit" }, { cwd = Util.get_root() }) end,
  { desc = "Lazygit (root dir)" }
)
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }) end, { desc = "Lazygit (cwd)" })
