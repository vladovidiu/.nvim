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

-- Line navigation
map("i", "<C-b>", "<ESC>^i", opts)
map("i", "<C-e>", "<END>", opts)
