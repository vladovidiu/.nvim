import("gruvbox", function(gruvbox)
  gruvbox.setup {
    transparent_mode = true,
  }

  vim.o.background = "dark"
  vim.cmd [[colorscheme gruvbox"]]
  vim.api.nvim_set_hl(0, "Normal", { guibg = NONE, ctermbg = NONE })
  vim.api.nvim_set_hl(0, "NormalFloat", { guibg = NONE, ctermbg = NONE })
  vim.api.nvim_set_hl(0, "Pmenu", { guibg = NONE, ctermbg = NONE })
  vim.api.nvim_set_hl(0, "PmenuSel", { guibg = NONE, ctermbg = NONE })
  vim.api.nvim_set_hl(0, "FloatBorder", { guibg = NONE, ctermbg = NONE })
  vim.api.nvim_set_hl(0, "FloatShadow", { guibg = NONE, ctermbg = NONE })
  vim.api.nvim_set_hl(0, "FloatShadowThrough", { guibg = NONE, ctermbg = NONE })
end)
