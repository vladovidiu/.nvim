return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      { "ray-x/lsp_signature.nvim", config = true },
      { "j-hui/fidget.nvim" },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      servers = {
        jsonls = {},
        lua_ls = require("plugins.lsp.languages.lua"),
        clangd = {},
        pyright = {},
        astro = {},
        elixirls = {},
      },
      setup = {
        ["*"] = function(_, _) end,
      },
      -- add any global capabilities here
      capabilities = {},
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
    },
    config = function(_, opts)
      require("util").on_attach(function(client, buffer)
        -- disable certain client features
        if client.name == "lua_ls" or client.name == "rust_analyzer" or client.name == "tsserver" then
          client.server_capabilities.semanticTokensProvider = nil
        end

        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics
      for name, icon in pairs(require("config").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Fidget
      require("fidget").setup({
        notification = {
          -- Options related to the notification window and buffer
          window = {
            winblend = 0, -- Background color opacity in the notification window
          },
        },
      })

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      require("lspconfig.ui.windows").default_options.border = "rounded"
      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
      require("mason-lspconfig").setup_handlers({
        function(server)
          local server_opts = servers[server] or {}
          server_opts.capabilities = capabilities
          if opts.setup[server] then
            if opts.setup[server](server, server_opts) then return end
          elseif opts.setup["*"] then
            if opts.setup["*"](server, server_opts) then return end
          end
          require("lspconfig")[server].setup(server_opts)
        end,
      })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        "prettierd",
        "eslint_d",
      },
      ui = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end,
  },

  -- tool to install some other binaries, like stylua
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "stylua",
      },
    },
    config = function(_, opts) require("mason-tool-installer").setup(opts) end,
  },
}
