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
      vim.cmd([[
        hi NeogitDiffAdd guifg=#31748f
        hi NeogitDiffDelete guifg=#eb6f92
      ]])
      vim.cmd([[colorscheme rose-pine]])
    end,
  },
}
