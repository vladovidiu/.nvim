return {
  tools = {
    autoSetHints = true,
    on_initialized = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
        pattern = { "*.rs" },
        callback = function()
          vim.lsp.codelens.refresh()
        end,
      })
    end,
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
    hover_actions = {
      auto_focus = false,
      border = "rounded",
      width = 60,
      -- height = 30,
    },
    runnables = {
      use_telescope = true,
    },
  },
  server = {
    on_attach = require("vt.lsp.on_attach").on_attach,
    capabilities = require("vt.lsp.on_attach").capabilities,
    settings = {
      ["rust-analyzer"] = {
        lens = {
          enable = true,
        },
        checkOnSave = {
          command = "clippy",
          allFeatures = true,
          overrideCommand = {
            "cargo",
            "clippy",
            "--workspace",
            "--message-format=json",
            "--all-targets",
            "--all-features",
          },
        },
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate",
        },
        cargo = {
          allFeatures = true,
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true,
          },
        },
      },
    },
  },
}
