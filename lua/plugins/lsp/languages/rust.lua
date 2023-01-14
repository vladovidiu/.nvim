local M = {}

M.opts = {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        allFeatures = true,
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = {
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
    },
  },
}

M.setup = function(_, opts)
  local rust_opts = {
    server = vim.tbl_deep_extend("force", {}, opts, opts.server or {}),
    tools = { -- rust-tools options
      -- options same as lsp hover / vim.lsp.util.open_floating_preview()
      hover_actions = {
        -- whether the hover action window gets automatically focused
        auto_focus = true,
      },
      autoSetHints = true,
      inlay_hints = {
        only_current_line = false,
        only_current_line_autocmd = "CursorHold",
        show_parameter_hints = false,
        show_variable_name = false,
        -- parameter_hints_prefix = " ",
        -- other_hints_prefix = " ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
    },
  }
  require("rust-tools").setup(rust_opts)
end

return M
