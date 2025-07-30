# Building a Minimal Neovim Configuration

## Philosophy

With Neovim 0.12, many features that previously required plugins are now built-in. This guide helps you build a minimal, fast configuration that leverages these native capabilities.

## Core Principles

1. **Use built-in features first**
2. **Add plugins only when necessary**
3. **Prefer LSP for language features**
4. **Keep configuration simple and maintainable**
5. **Optimize for startup speed**

## Feature Comparison: Built-in vs Plugins

| Feature | Built-in Solution | Common Plugin | When to Use Plugin |
|---------|------------------|---------------|-------------------|
| Plugin Management | `vim.pack` | lazy.nvim | Never (built-in is sufficient) |
| Completion | LSP + built-in | nvim-cmp | Complex snippet expansion |
| LSP Config | `vim.lsp.config()` | nvim-lspconfig | Never (built-in is sufficient) |
| Fuzzy Finding | `:find`, `:grep` | telescope.nvim | Advanced filtering needs |
| File Explorer | netrw | nvim-tree | Heavy file management |
| Status Line | Built-in statusline | lualine | Custom aesthetics |
| Git Integration | Terminal + diff mode | gitsigns.nvim | Inline blame/changes |
| Syntax Highlighting | Treesitter (built-in) | None | Not needed |
| Comments | Built-in `gc` | comment.nvim | Never (built-in is sufficient) |
| Surround | Manual operations | nvim-surround | Frequent surround operations |

## Essential Configuration

### 1. Basic Options

```lua
-- init.lua
-- Performance
vim.loader.enable()  -- Enable byte-compiled cache

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Completion
vim.opt.completeopt = 'menuone,noselect,popup'
vim.opt.pumheight = 10

-- Performance
vim.opt.updatetime = 300
vim.opt.timeoutlen = 300
```

### 2. LSP Setup

```lua
-- Common LSP configurations
local servers = {
  -- JavaScript/TypeScript
  ts_ls = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', '.git' },
  },
  
  -- Python
  pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'setup.py', 'pyproject.toml', '.git' },
  },
  
  -- Go
  gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod' },
    root_markers = { 'go.mod', '.git' },
  },
  
  -- Rust
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
  },
}

-- Register all servers
for name, config in pairs(servers) do
  vim.lsp.config[name] = config
end

-- Auto-enable LSP for configured filetypes
vim.api.nvim_create_autocmd('FileType', {
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
```

### 3. Auto-completion Setup

```lua
-- Enable LSP completion on attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})
```

### 4. Minimal Keymaps

```lua
-- Leader key
vim.g.mapleader = ' '

-- Essential mappings
local map = vim.keymap.set

-- File navigation
map('n', '<leader>f', ':find **/*')
map('n', '<leader>b', ':ls<CR>:b<Space>')

-- Quick fix
map('n', '<leader>q', ':copen<CR>')
map('n', '[q', ':cprev<CR>')
map('n', ']q', ':cnext<CR>')

-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)

-- Window management
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
```

## When to Add Plugins

Consider adding a plugin only when:

1. **Frequency**: You use the feature multiple times daily
2. **Efficiency**: It saves significant time/keystrokes
3. **Complexity**: Built-in solution requires too many steps
4. **Integration**: It provides deep integration not possible otherwise

## Recommended Minimal Plugin Set

If you absolutely need plugins, consider these essentials:

```lua
vim.pack.add({
  -- Fuzzy finder (only if you need advanced search)
  { 
    src = 'github.com/nvim-telescope/telescope.nvim',
    version = vim.version.range('0.1'),
  },
  
  -- Git signs (only if you need inline git info)
  'github.com/lewis6991/gitsigns.nvim',
  
  -- Treesitter textobjects (advanced text manipulation)
  'github.com/nvim-treesitter/nvim-treesitter-textobjects',
})
```

## Performance Tips

1. **Lazy load plugins**: Use autocommands to load on demand
2. **Disable unused providers**:
   ```lua
   vim.g.loaded_perl_provider = 0
   vim.g.loaded_ruby_provider = 0
   vim.g.loaded_python3_provider = 0
   vim.g.loaded_node_provider = 0
   ```
3. **Profile startup**: `nvim --startuptime profile.log`
4. **Use vim.loader**: Already enabled in example
5. **Minimal syntax files**: Rely on treesitter instead

## Migration Checklist

- [ ] List current plugins and their purposes
- [ ] Identify built-in alternatives
- [ ] Test built-in features in isolation
- [ ] Gradually remove plugins
- [ ] Measure startup time improvements
- [ ] Document any custom functions needed

## Conclusion

A minimal Neovim 0.12 configuration can provide 90% of IDE features with:
- ~50 lines of config
- 0-3 essential plugins
- <50ms startup time
- Full LSP support
- Auto-completion
- Git integration (via terminal)

Start minimal, add only what you truly need.