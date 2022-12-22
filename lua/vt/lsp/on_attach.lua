local M = {}

M.setup = function()
  local config = {
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

M.on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }
  local map = vim.keymap.set

  local augroup = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  vim.api.nvim_create_autocmd("CursorHold", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float { focusable = false, border = "rounded" }
    end,
  })

  if client.name == "sumneko_lua" then
    client.server_capabilities.document_formatting = false
    -- Since Treesitter and this don't play well together, disable
    -- semanticTokensProvider
    -- TODO: Find a way to make this work later
    -- https://github.com/neovim/neovim/pull/21100
    client.server_capabilities.semanticTokensProvider = nil
  end

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "K", vim.lsp.buf.hover)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

return M
