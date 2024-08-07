local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local lazy_status_ok, lazy = pcall(require, "lazy")
if not lazy_status_ok then return end

lazy.setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.extras.dap" },
    { import = "plugins.extras.test" },
    { import = "plugins.lsp.languages.rust" },
    { import = "plugins.lsp.languages.ts" },
    { import = "plugins.lsp.languages.tailwind" },
    { import = "plugins.lsp.languages.ruby" },
    -- { import = "plugins.lsp.languages.markdown" },
  },
  ui = {
    border = "rounded",
    backdrop = 100,
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  checker = { enabled = true, notify = false }, -- automatically check for plugin updates
  change_detection = { notify = false },
})
