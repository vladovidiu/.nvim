**LSP Minimal**
- Starts common servers if installed; buffer-local LSP maps and inlay hints.
```
-- LSP: minimal and robust
local function lsp_on_attach(client, buf)
  local map = function(m, lhs, rhs, desc) vim.keymap.set(m, lhs, rhs, { buffer =
 buf, silent = true, desc = desc }) end
  vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  map('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
  map('n', 'gr', vim.lsp.buf.references, 'Goto References')
  map('n', 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
  map('n', 'gi', vim.lsp.buf.implementation, 'Goto Implementation')
  map('n', 'K', vim.lsp.buf.hover, 'Hover Docs')
  map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
  map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  map('n', '<leader>f', function() vim.lsp.buf.format({ async = false }) end, 'F
ormat Buffer')
  pcall(function()
    if vim.lsp.inlay_hint then
      local ok = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = buf })
      if not ok then pcall(vim.lsp.inlay_hint, buf, true) end
    end
  end)
end

local function lsp_root(markers)
  local root = vim.fs.find(markers or { '.git' }, { upward = true })[1]
  return vim.fs.dirname(root or vim.api.nvim_buf_get_name(0))
end

local function start_server(cfg)
  if vim.fn.executable(cfg.cmd[1]) == 0 then return end
  cfg.root_dir = cfg.root_dir or lsp_root(cfg.root_markers)
  cfg.on_attach = lsp_on_attach
  vim.lsp.start(cfg)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('MinimalLsp', { clear = true }),
  callback = function(args)
    local ft = args.match
    if ft == 'lua' then
      start_server({
        name = 'lua_ls',
        cmd = { 'lua-language-server' },
        root_markers = { '.git' },
        settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
      })
    elseif ft == 'python' then
      start_server({
        name = 'pyright',
        cmd = { 'pyright-langserver', '--stdio' },
        root_markers = { '.git', 'pyproject.toml', 'setup.py', 'setup.cfg' },
      })
    elseif ft == 'go' or ft == 'gomod' then
      start_server({
        name = 'gopls',
        cmd = { 'gopls' },
        root_markers = { 'go.work', 'go.mod', '.git' },
      })
    elseif ft == 'typescript' or ft == 'typescriptreact' or ft == 'javascript' o
r ft == 'javascriptreact' then
      start_server({
        name = 'tsserver',
        cmd = { 'typescript-language-server', '--stdio' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git
' },
      })
    elseif ft == 'rust' then
      start_server({
        name = 'rust-analyzer',
        cmd = { 'rust-analyzer' },
        root_markers = { 'Cargo.toml', '.git' },
      })
    end
  end,
})
```

**Diagnostics UX**
- Navigation, float, and loclist without touching your `<leader>e`.
```
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' }
)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' }
)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Line diagnostics'
 })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Diagnosti
cs → loclist' })
```

**Format on Save**
- Safe default; runs only if the server supports it.
```
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
  pattern = { '*.lua', '*.go', '*.rs', '*.ts', '*.tsx', '*.js', '*.jsx', '*.py'
},
  callback = function(args)
    vim.lsp.buf.format({ async = false, bufnr = args.buf, timeout_ms = 2000 })
  end,
})

**Search Helper**
vim.api.nvim_create_user_command('Rg', function(opts)
  local q = opts.args ~= '' and opts.args or vim.fn.input('Rg > ')
  if q == '' then return end
  vim.cmd('silent grep! ' .. vim.fn.shellescape(q))
  vim.cmd('copen')
end, { nargs = '*', complete = 'file' })
vim.keymap.set('n', '<leader>/', ':Rg ', { desc = 'Ripgrep search' })
**Window + Terminal Ergonomics**
- Quick split/nav and a clean terminal flow.
```
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Up window' })
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Horizontal split' })

vim.keymap.set('n', '<leader>t', function() vim.cmd('split | terminal') end, { d
esc = 'Open terminal' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Terminal normal mode' })
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])
```

**Statusline + Colors**
- Clean, built-in statusline and a default colorscheme.
```
vim.o.laststatus = 3
vim.o.statusline = table.concat({
  ' %f%m%r', ' %=',
  ' %y', ' [%{&ff}]',
  ' %l:%c', ' %p%% ',
})
pcall(vim.cmd.colorscheme, 'habamax')
```

**Completion Trigger**
- Keep built-in completion; easy trigger.
```
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Omni completion' })
```
