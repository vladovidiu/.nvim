return {
  name = "test script",
  condition = {
    filetype = { "rust" },
  },
  builder = function()
    local file = vim.fn.expand("%:p")
    local cmd = { file }
    if vim.bo.filetype == "rust" then
      cmd = { "cargo", "test", "--", "--nocapture" }
    end

    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
}
