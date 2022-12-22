local map = vim.keymap.set

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

map({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Netrw
map("n", "<leader>pv", vim.cmd.Ex, opts)

-- Misc
map("n", "<ESC>", ":noh<CR>", opts) -- clear search results
map("n", "<leader>ps", "<cmd>PackerSync<CR>", opts) -- update packer plugins
