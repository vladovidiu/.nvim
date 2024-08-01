-- helper function to create autocmds
local function augroup(name) return vim.api.nvim_create_augroup("vt_" .. name, { clear = true }) end

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
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "grug-far",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- INFO: Ignore deprecation messages
-- FIXME: this should be removed once I understand the TS issue
local orig_notify = vim.notify

local filter_notify = function(text, level, opts)
  if type(text) == "string" and string.find(text, ":help deprecated", 1, true) then return end

  if type(text) == "string" and string.find(text, "stack traceback", 1, true) then return end

  if type(text) == "string" and string.find(text, "No information available", 1, true) then return end

  orig_notify(text, level, opts)
end

vim.notify = filter_notify
