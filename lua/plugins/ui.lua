return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function() require("mini.icons").mock_nvim_web_devicons() end,
  },
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  { "MunifTanjim/nui.nvim", event = "VeryLazy" },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>nd",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    keys = {
      {
        "<leader>cl",
        "<cmd>ColorizerToggle<cr>",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    config = true,
  },
}
