local map = vim.keymap.set

import("chatgpt", function(chatgpt)
  chatgpt.setup {}

  map("n", "<leader>cg", "<cmd>ChatGPT<cr>")
end)
