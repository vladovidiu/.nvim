-- helper function to create autocmds
local function augroup(name)
  return vim.api.nvim_create_augroup("vt_" .. name, { clear = true })
end

vim.api.nvim_create_user_command("WatchTest", function()
  local overseer = require("overseer")
  overseer.run_template({ name = "test script" }, function(task)
    if task then
      task:add_component({ "restart_on_save", path = vim.fn.expand("%:p") })
      local main_win = vim.api.nvim_get_current_win()
      overseer.run_action(task, "open vsplit")
      vim.api.nvim_set_current_win(main_win)
    else
      vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
    end
  end)
end, {})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
