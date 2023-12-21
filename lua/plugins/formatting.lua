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
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
        },
      })
    end,
  },
}
