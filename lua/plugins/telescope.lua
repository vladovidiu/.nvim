local util = require("util")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-rg.nvim",
  },
  keys = {
    {
      "<leader>pf",
      util.telescope("find_files"),
      desc = "Find Files",
    },
    {
      "<leader>bb",
      util.telescope("buffers"),
      desc = "Find Buffers",
    },
    {
      "<leader>sp",
      util.telescope("live_grep"),
      desc = "Grep",
    },
    {
      "<leader>gp",
      function()
        require("telescope.builtin").grep_string({
          ---@diagnostic disable-next-line: param-type-mismatch
          search = vim.fn.input("Grep > "),
        })
      end,
      desc = "Grep",
    },
  },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    defaults = {
      winblend = 0,
      file_ignore_patterns = { "node_modules" },
      vimgrep_arguments = {
        "rg",
        "--line-number",
        "--column",
        "--smart-case",
        "--with-filename",
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
