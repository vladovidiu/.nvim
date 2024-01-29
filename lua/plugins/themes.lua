return {
  -- rose-pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        bold_vert_split = true,
        disable_background = true,
        disable_float_background = true,
      })

      vim.o.background = "dark"
      vim.cmd([[colorscheme rose-pine]])
    end,
  },
}
