import({ "copilot", "copilot_cmp" }, function(modules)
  local copilot_cmp = modules["copilot_cmp"]
  local copilot = modules["copilot"]

  copilot.setup()
  copilot_cmp.setup()
end)
