-- Minimal Neovim 0.12 Configuration
-- Inspired by kickstart.nvim's structure, powered by built-in features

-- Enable loader for faster startup
vim.loader.enable()

-- [[ Leader Keys ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Options ]]
local opt = vim.opt

-- UI
opt.number = true                  -- Show line numbers
opt.relativenumber = true          -- Relative line numbers
opt.signcolumn = 'yes'            -- Always show sign column
opt.cursorline = true             -- Highlight current line
opt.scrolloff = 10                -- Lines of context
opt.termguicolors = true          -- True color support

-- Editor
opt.expandtab = true              -- Use spaces instead of tabs
opt.shiftwidth = 2                -- Size of an indent
opt.smartindent = true            -- Insert indents automatically
opt.wrap = false                  -- Disable line wrap
opt.breakindent = true            -- Enable break indent

-- Search
opt.ignorecase = true             -- Ignore case
opt.smartcase = true              -- Don't ignore case with capitals
opt.hlsearch = false              -- Don't highlight search results

-- System
opt.undofile = true               -- Persistent undo
opt.updatetime = 250              -- Faster completion
opt.timeoutlen = 300              -- Faster key sequence completion
opt.clipboard = 'unnamedplus'     -- System clipboard
opt.mouse = 'a'                   -- Enable mouse support

-- Display
opt.list = true                   -- Show invisible characters
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'          -- Preview substitutions live

-- Splits
opt.splitright = true             -- Put new windows right of current
opt.splitbelow = true             -- Put new windows below current

-- Completion
opt.completeopt = 'menuone,noselect,popup'
opt.pumheight = 10                -- Maximum number of completion items

-- [[ Basic Keymaps ]]
local map = vim.keymap.set

-- Better escape
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Clear search highlighting
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to right window' })

-- File navigation
map('n', '<leader>f', ':find **/*', { desc = 'Find files' })
map('n', '<leader>b', ':ls<CR>:b<Space>', { desc = 'Switch buffers' })
map('n', '<leader>g', ':grep ', { desc = 'Grep in files' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Autocommands ]]
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- [[ LSP Configuration ]]
-- Define your language servers here
local servers = {
  -- Lua
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        telemetry = { enable = false },
      },
    },
  },

  -- TypeScript/JavaScript
  ts_ls = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', '.git' },
  },

  -- Python
  pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'setup.py', 'pyproject.toml', 'requirements.txt', '.git' },
  },

  -- Go
  gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.mod', 'go.work', '.git' },
  },

  -- Add more servers as needed
}

-- Register all servers
for name, config in pairs(servers) do
  vim.lsp.config[name] = config
end

-- Auto-enable LSP for configured filetypes
autocmd('FileType', {
  desc = 'Enable LSP for configured filetypes',
  pattern = vim.tbl_flatten(vim.tbl_map(function(s) return s.filetypes end, servers)),
  callback = function(ev)
    for name, config in pairs(servers) do
      if vim.tbl_contains(config.filetypes, ev.match) then
        vim.lsp.enable(name)
        break
      end
    end
  end,
})

-- Configure behavior when LSP attaches
autocmd('LspAttach', {
  desc = 'LSP actions',
  group = augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf

    -- Enable completion
    if client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
      })
    end

    -- Document highlights
    if client.supports_method('textDocument/documentHighlight') then
      local highlight_group = augroup('lsp-highlight', { clear = false })
      autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Format on save
    if client.supports_method('textDocument/formatting') then
      autocmd('BufWritePre', {
        buffer = bufnr,
        group = augroup('lsp-format', { clear = true }),
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 500 })
        end,
      })
    end

    -- Buffer local mappings
    local bmap = function(keys, func, desc)
      map('n', keys, func, { buffer = bufnr, desc = desc })
    end

    -- Custom keymaps (most are defaults in 0.12)
    bmap('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    bmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    bmap('<leader>td', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, 'Toggle inlay hints')
  end,
})

-- [[ Diagnostic Configuration ]]
vim.diagnostic.config({
  virtual_text = { spacing = 2 },
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✗',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ℹ',
      [vim.diagnostic.severity.HINT] = '➤',
    },
  },
})

-- [[ Minimal Plugins ]]
-- Only add truly essential plugins
vim.pack.add({
  -- Git signs in the gutter
  'https://github.com/lewis6991/gitsigns.nvim',
  
  -- Fuzzy finder (if built-in search isn't enough)
  -- { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1' },
  
  -- Color scheme (optional)
  -- 'https://github.com/folke/tokyonight.nvim',
})

-- [[ Plugin Configuration ]]
-- Configure gitsigns if installed
pcall(function()
  require('gitsigns').setup({
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  })
end)

-- [[ Status Line ]]
-- Neovim 0.12 exposes the default statusline
-- You can customize it with opt.statusline if needed

-- [[ Final Setup ]]
-- Set colorscheme (if you added one)
-- vim.cmd.colorscheme 'tokyonight'

-- vim: ts=2 sts=2 sw=2 et