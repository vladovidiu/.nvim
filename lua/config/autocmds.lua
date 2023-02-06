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
