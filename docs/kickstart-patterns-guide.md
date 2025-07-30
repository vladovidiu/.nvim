# Kickstart Patterns in Minimal Neovim 0.12

This guide shows how to implement common kickstart.nvim patterns using Neovim 0.12's built-in features.

## Pattern 1: Plugin Management

### Kickstart Way (lazy.nvim)
```lua
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'plugin/name',
  { 'plugin/name2', opts = {} },
  { 'plugin/name3', event = 'VimEnter' },
})
```

### Minimal Way (vim.pack)
```lua
vim.pack.add({
  'github.com/plugin/name',
  { src = 'github.com/plugin/name2' },
  { src = 'github.com/plugin/name3' },
})
```

## Pattern 2: LSP Configuration

### Kickstart Way
```lua
-- Requires nvim-lspconfig, mason, mason-lspconfig
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  lua_ls = {
    settings = {
      Lua = { runtime = { version = 'LuaJIT' } }
    }
  }
}

require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup(servers[server_name])
    end,
  }
}
```

### Minimal Way
```lua
-- No external plugins needed!
vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
  settings = {
    Lua = { runtime = { version = 'LuaJIT' } }
  }
}

-- Enable on FileType
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function() vim.lsp.enable('lua_ls') end,
})
```

## Pattern 3: Completion Setup

### Kickstart Way
```lua
-- Requires blink.cmp, LuaSnip, etc.
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
})
```

### Minimal Way
```lua
-- Built-in completion!
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.lsp.completion.enable(true, client.id, args.buf, {
      autotrigger = true,
    })
  end,
})

-- Set completion options
vim.opt.completeopt = 'menuone,noselect,popup'
```

## Pattern 4: Keymaps with Descriptions

### Kickstart Way
```lua
-- With which-key
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
```

### Minimal Way
```lua
-- Descriptions still work without which-key!
vim.keymap.set('n', '<leader>f', ':find **/*', { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', ':grep ', { desc = 'Grep files' })

-- Or with a simple helper
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map('n', '<leader>f', ':find **/*', 'Find files')
map('n', '<leader>g', ':grep ', 'Grep files')
```

## Pattern 5: Autocommand Groups

### Both Ways (Same!)
```lua
-- This pattern is already optimal in kickstart
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
```

## Pattern 6: LSP Attach Handlers

### Kickstart Way
```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    
    -- Maps using telescope
    map('grr', require('telescope.builtin').lsp_references, 'Goto References')
    map('gri', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  end,
})
```

### Minimal Way
```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    -- Most keymaps are now defaults! (grn, grr, gra, gri, grt)
    -- Only add what's missing or custom
    
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    
    -- Enable completion
    if client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
      })
    end
  end,
})
```

## Pattern 7: Format on Save

### Kickstart Way
```lua
-- Using conform.nvim
require('conform').setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
})
```

### Minimal Way
```lua
-- Using LSP formatting
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    -- Only format if LSP client supports it
    local client = vim.lsp.get_clients({ bufnr = args.buf })[1]
    if client and client.supports_method('textDocument/formatting') then
      vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 500 })
    end
  end,
})
```

## Pattern 8: Status Line

### Kickstart Way
```lua
-- Using mini.statusline
require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }
```

### Minimal Way
```lua
-- Built-in statusline (exposed in 0.12)
-- Already configured by default!
-- Or customize with vim.opt.statusline
```

## Pattern 9: Diagnostics Configuration

### Both Ways (Similar)
```lua
-- This is already using built-in features
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded' },
  virtual_text = { spacing = 2 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✗',
      [vim.diagnostic.severity.WARN] = '!',
      [vim.diagnostic.severity.INFO] = 'i',
      [vim.diagnostic.severity.HINT] = '?',
    }
  }
}
```

## Common Patterns Summary

| Pattern | Kickstart Lines | Minimal Lines | Complexity Reduction |
|---------|----------------|---------------|---------------------|
| Plugin Management | ~20 | ~5 | 75% |
| LSP Setup | ~50 | ~15 | 70% |
| Completion | ~40 | ~10 | 75% |
| Keymaps | Same | Same | 0% |
| Autocommands | Same | Same | 0% |
| Formatting | ~20 | ~8 | 60% |

## Best Practices from Kickstart to Keep

1. **Clear Section Comments**: `-- [[ Section Name ]]`
2. **Descriptive Keymaps**: Always add `desc` field
3. **Autocommand Groups**: Use named groups
4. **Helper Functions**: Like `map()` for keybindings
5. **Logical Organization**: Options → Keymaps → Autocmds → Plugins
6. **Educational Comments**: Explain non-obvious choices

## Conclusion

Kickstart.nvim teaches excellent patterns that work just as well in a minimal setup. The main difference is replacing external plugins with built-in features, not changing the fundamental approach to configuration.

Keep the structure, lose the complexity.