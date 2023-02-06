return {
  {
    "stevearc/overseer.nvim",
    event = "BufReadPost",
    config = function()
      require("overseer").setup({
        templates = { "builtin", "vt.test_script" },
      })
    end,
  },
}
