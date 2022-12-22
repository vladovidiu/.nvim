import({ "telescope", "telescope.actions", "telescope.builtin" }, function(modules)
  local telescope = modules.telescope
  local actions = modules["telescope.actions"]
  local builtin = modules["telescope.builtin"]
  local map = vim.keymap.set

  telescope.setup {
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    defaults = {
      file_ignore_patterns = { "node_modules" },
      vimgrep_arguments = {
        "rg",
        "--line-number",
        "--column",
        "--smart-case",
        "--with-filename",
      },
    },
  }

  telescope.load_extension "fzf"

  -- Keymaps
  local opts = { noremap = true, silent = true }

  map("n", "<leader>pf", builtin.find_files, opts)
  map("n", "<leader>?", builtin.oldfiles, opts)
  map("n", "<leader>gf", builtin.git_files, opts)
  map("n", "<leader>sp", builtin.live_grep, opts)
  map("n", "<leader>bb", builtin.buffers, opts)
  map("n", "<leader>fh", builtin.help_tags, opts)
  map("n", "<leader>gp", function()
    builtin.grep_string { search = vim.fn.input "Grep > " }
  end, opts)
end)
