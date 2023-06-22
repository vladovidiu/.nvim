return {
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      diagnostics = {
        globals = { "vim", "hs", "import", "NONE" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
        checkThirdParty = false,
      },
    },
  },
}
