return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
  { 
    "max397574/better-escape.nvim",
    event = "BufReadPost",
    config = function()
      require("better_escape").setup({
        mapping = { "jk" },
      })
    end,
  },
  {
    "tpope/vim-sleuth",
    event = "BufReadPost",
  },
}
