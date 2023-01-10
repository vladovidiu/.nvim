return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "hs", "import", "NONE" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}
