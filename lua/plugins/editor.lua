return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts) require("mini.pairs").setup(opts) end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mapping = { "jk" },
      })
    end,
  },
  {
    "Darazaki/indent-o-matic",
    config = true,
    event = "BufReadPost",
  },
  {
    "echasnovski/mini.surround",
    keys = { "gz" },
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    config = function(_, opts) require("mini.surround").setup(opts) end,
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>ha",
        function() require("harpoon.mark").add_file() end,
        desc = "Add file to harpoon",
      },
      {
        "<leader>hh",
        function() require("harpoon.ui").toggle_quick_menu() end,
        desc = "Toggle harpoon menu",
      },
      {
        "<leader>h1",
        function() require("harpoon.ui").nav_file(1) end,
      },
      {
        "<leader>h2",
        function() require("harpoon.ui").nav_file(2) end,
      },
      {
        "<leader>h3",
        function() require("harpoon.ui").nav_file(3) end,
      },
      {
        "<leader>h4",
        function() require("harpoon.ui").nav_file(4) end,
      },
      {
        "<leader>h5",
        function() require("harpoon.ui").nav_file(5) end,
      },
    },
    config = function()
      require("harpoon").setup({
        menu = {
          width = vim.api.nvim_win_get_width(0) - 30,
        },
      })
    end,
  },
  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 10,
        open_mapping = [[<c-\>]],
        shading_factor = 2,
        direction = "float",
        float_opts = {
          border = "rounded",
          highlights = { border = "Normal", background = "Normal" },
        },
      })
    end,
  },
  -- smart splits
  { "mrjones2014/smart-splits.nvim" },
  {
    "imsnif/kdl.vim",
    event = "BufReadPre *.kdl",
  },
  -- neoai
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<leader>ai", "<cmd>NeoAIToggle<cr>", desc = "summarize text" },
      { "<leader>ag", desc = "generate git message" },
      { "<leader>as", desc = "summarize text" },
    },
    config = function()
      require("neoai").setup({
        -- Options go here
        open_api_key_env = "OPENAI_API_KEY",
        models = {
          {
            name = "openai",
            model = "gpt-4-0314",
            params = nil,
          },
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set(
          "n",
          key,
          function() require("illuminate")["goto_" .. dir .. "_reference"](false) end,
          { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer }
        )
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
  {
    "nvim-pack/nvim-spectre",
  -- stylua: ignore
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
  },
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    opts = {},
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "ggandor/flit.nvim",
    opts = { labeled_modes = "nx" },
  },
}
