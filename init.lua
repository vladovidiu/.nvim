-- Leader key -> " "
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

for _, source in ipairs({
  "config.lazy",
  "config.options",
  "config.keymaps",
  "config.autocmds",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Error loading " .. source .. "\n\n" .. fault) end
end
