---@diagnostic disable: assign-type-mismatch
local opt = vim.opt

-- File Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Backups
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undodir"

-- UI
opt.termguicolors = true
opt.timeoutlen = 300
opt.updatetime = 50
opt.lazyredraw = true
opt.scrolloff = 5
opt.colorcolumn = "80"
opt.cmdheight = 0
opt.guicursor = ""
opt.wrap = false
opt.cursorline = true
opt.smoothscroll = true

opt.splitbelow = true
opt.splitright = true

opt.number = true
opt.relativenumber = true
opt.laststatus = 3
opt.signcolumn = "yes"

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

opt.showmode = false
opt.isfname:append("@-@")

-- Indenting
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Clipboard
opt.clipboard:append({ "unnamedplus" })

opt.backspace = { "start", "eol", "indent" }

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw options
vim.g.netrw_banner = 0
vim.g.netrw_silent = 1

-- Disable unneeded builtin plugins
local default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "machparen",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(default_plugins) do
  vim.g["loaded_" .. plugin] = 1
end

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.o.splitkeep = "screen"
  vim.o.shortmess = "filnxtToOFWcC"
  vim.opt.diffopt:append("linematch:60")
end
