import("neural", function(neural)
  neural.setup {
    open_ai = {
      api_key = vim.fn.getenv "OPENAI_API_KEY",
    },
  }
end)
