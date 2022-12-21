import({ "mason", "mason-lspconfig", "lspconfig", "cmp_nvim_lsp" }, function(modules)
  local mason = modules.mason
  local masonLspConfig = modules["mason-lspconfig"]
  local cmpLsp = modules["cmp_nvim_lsp"]

  local lsp_servers = {
    "sumneko_lua",
  }

  mason.setup {
    ui = {
      border = "rounded",
    },
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local lsp_opts = {
    capabilities = cmpLsp.default_capabilities(capabilities),
    on_attach = require("vt.lsp.on_attach").on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }

  masonLspConfig.setup {
    ensure_installed = lsp_servers,
  }

  masonLspConfig.setup_handlers {
    function(server_name)
      local has_custom_opts, custom_opts = pcall(require, "vt.lsp.settings." .. server_name)
      local server_opts = lsp_opts

      if has_custom_opts then
        server_opts = vim.tbl_deep_extend("force", custom_opts, lsp_opts)
      end

      modules.lspconfig[server_name].setup(server_opts)
    end,
  }

  require "vt.lsp.null_ls"
  require "vt.lsp.fidget"
  require "vt.lsp.lsp_signature"
end)
