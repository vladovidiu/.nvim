local M = {}

---@param opts ConformOpts
function M.setup(_, opts) require("conform").setup(opts) end

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function() require("conform").format({ formatters = { "injected" } }) end,
        mode = { "n", "v" },
        desc = "Format Injected Languages",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ConformFormat", {}),
        callback = function(args) require("conform").format({ bufnr = args.buf }) end,
      })
    end,
    ---@class ConformOpts
    opts = function()
      local opts = {
        format = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
        },

        ---@type table<string, conform.FormatterUnit[]>
        formatters_by_ft = {
          lua = { "stylua" },
        },

        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }

      return opts
    end,
    config = M.setup,
  },
}
