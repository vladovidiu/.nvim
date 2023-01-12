return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })

      vim.o.background = "dark"
      -- vim.cmd([[colorscheme gruvbox"]])
      -- vim.api.nvim_set_hl(0, "Normal", { guibg = NONE, ctermbg = NONE })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { guibg = NONE, ctermbg = NONE })
      -- vim.api.nvim_set_hl(0, "Pmenu", { guibg = NONE, ctermbg = NONE })
      -- vim.api.nvim_set_hl(0, "PmenuSel", { guibg = NONE, ctermbg = NONE })
      -- vim.api.nvim_set_hl(0, "FloatBorder", { guibg = NONE, ctermbg = NONE })
      -- vim.api.nvim_set_hl(0, "FloatShadow", { guibg = NONE, ctermbg = NONE })
      -- vim.api.nvim_set_hl(0, "FloatShadowThrough", { guibg = NONE, ctermbg = NONE })
    end,
  },

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
