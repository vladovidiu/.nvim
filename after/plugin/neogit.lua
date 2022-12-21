import("neogit", function(neogit)
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  neogit.setup {}

  map("n", "<leader>gg", ":Neogit<CR>", opts)
end)
