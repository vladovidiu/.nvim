# Neovim 0.12 Features and Configuration Guide

## Overview

Neovim 0.12 introduces significant improvements that reduce the need for external plugins, making it easier to maintain a minimal, performant configuration. This guide covers the key features and recommendations for building a modern Neovim setup.

## Key New Features in Neovim 0.12

### 1. Built-in Plugin Manager (`vim.pack`)

Neovim 0.12 introduces a native plugin manager that eliminates the need for external solutions like lazy.nvim, packer, or vim-plug.

**Key Features:**
- Git-based plugin management
- Semver version constraints
- Parallel installation
- Update confirmation with diff preview
- Minimal API: `vim.pack.add()`, `vim.pack.update()`, `vim.pack.del()`

**Example Usage:**
```lua
vim.pack.add({
  -- Simple plugin
  'https://github.com/user/plugin1',
  
  -- With version constraint
  {
    src = 'https://github.com/user/plugin2',
    version = vim.version.range('1.0'),
  },
  
  -- With specific branch/tag
  {
    src = 'https://github.com/user/plugin3',
    version = 'main',
  },
})
```

### 2. Enhanced LSP Configuration

The LSP setup is now simpler and more powerful, with better defaults and built-in configurations.

**New LSP Features:**
- `vim.lsp.config()` for defining configurations
- `vim.lsp.enable()` for starting/stopping clients dynamically
- Built-in completion with `vim.lsp.completion`
- Support for new LSP features:
  - Document color and color presentation
  - Workspace diagnostics
  - Incremental selection
  - Linked editing ranges
  - Multiline semantic tokens
  - Code action "disabled" field

**Minimal LSP Setup:**
```lua
-- Define LSP configuration
vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' }
    }
  }
}

-- Enable the configuration
vim.lsp.enable('luals')
```

### 3. Built-in Completion

Neovim 0.12 provides enhanced completion capabilities without external plugins.

**New Completion Features:**
- `'completefuzzycollect'` - Fuzzy collection of candidates
- `'completeopt'` with "nearest" flag - Sort by cursor proximity
- New `'complete'` flags:
  - `F{func}` - Complete using custom function
  - `F` - Complete using 'completefunc'
  - `o` - Complete using 'omnifunc'
- LSP-driven auto-completion via `vim.lsp.completion`

**Enable LSP Auto-completion:**
```lua
vim.cmd[[set completeopt+=menuone,noselect,popup]]
-- In your LSP on_attach:
vim.lsp.completion.enable(true, client.id, bufnr, {
  autotrigger = true,
})
```

### 4. Default Keymaps

Neovim 0.12 provides sensible LSP keymaps out of the box:

**Global LSP Keymaps:**
- `grn` - Rename
- `gra` - Code action
- `grr` - References
- `gri` - Implementation
- `grt` - Type definition
- `gO` - Document symbols
- `<C-S>` (insert mode) - Signature help
- `an`/`in` (visual mode) - Incremental selection

**Buffer-local Defaults:**
- `K` - Hover documentation
- `<C-X><C-O>` - Trigger completion
- `gq` - Format using LSP

## Essential Features for Principal Engineers

### 1. Code Intelligence
- **LSP**: Full language server support for all major languages
- **Treesitter**: Syntax highlighting, code folding, text objects
- **Completion**: Context-aware suggestions with LSP integration
- **Diagnostics**: Real-time error detection and display

### 2. Code Navigation
- **Built-in**: `/`, `?`, `*`, `#` for searching
- **Tags**: `<C-]>` for go-to-definition (enhanced by LSP)
- **File navigation**: `:find`, `:grep`, `:vimgrep`
- **Quickfix/Location lists**: For navigating errors and search results

### 3. Version Control Integration
While Git support isn't built-in, Neovim provides:
- Diff mode (`:diffthis`, `:diffget`, `:diffput`)
- Sign column for external tools
- Terminal integration for git commands

### 4. Productivity Features
- **Registers**: Multiple clipboards and macros
- **Sessions**: Save and restore workspace state
- **Marks**: Quick navigation within and between files
- **Folding**: Code structure visualization
- **Terminal**: Built-in terminal emulator

### 5. Extensibility
- **Lua API**: Full scripting capabilities
- **Events**: Comprehensive autocmd system
- **Remote plugins**: Support for external processes

## Recommended Minimal Configuration Strategy

1. **Start with defaults**: Neovim 0.12's defaults are excellent
2. **Use built-in features first**: Before reaching for plugins
3. **Add only essential plugins**: Focus on what's missing
4. **Leverage LSP**: Most IDE features come from LSP servers
5. **Keep it simple**: Complexity hurts performance and maintainability

## Migration Tips from LazyVim

1. **Replace lazy.nvim with vim.pack**: Simpler, built-in solution
2. **Use native LSP config**: Instead of nvim-lspconfig wrappers
3. **Leverage built-in completion**: Before adding cmp or coq
4. **Check new defaults**: Many LazyVim features are now built-in
5. **Gradual migration**: Start minimal, add as needed

## Performance Considerations

- Neovim 0.12 has improved startup time with lazy loading
- Treesitter now uses async highlighting for better performance
- LSP clients can be dynamically enabled/disabled
- Built-in features are generally faster than plugin equivalents

## Next Steps

1. Review current LazyVim config for essential features
2. Set up minimal init.lua with vim.pack
3. Configure LSP for your languages
4. Add only necessary plugins
5. Optimize based on actual usage patterns