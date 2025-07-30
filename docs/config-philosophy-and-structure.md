# Neovim Configuration Philosophy and Structure Guide

This document captures the philosophy and structural patterns for creating well-documented, maintainable Neovim configurations.

## Core Philosophy

### 1. **Clarity Over Cleverness**
- Every line should be understandable by someone new to Neovim
- Explicit is better than implicit
- Comments explain "why", code shows "what"

### 2. **Progressive Disclosure**
- Start with essentials, add complexity gradually
- Group related functionality together
- Build from foundation up: options → keymaps → autocommands → plugins

### 3. **Minimal Dependencies**
- Use built-in features first
- Add plugins only when they provide significant value
- Each plugin should solve a specific, frequently-encountered problem

### 4. **Documentation as First-Class Citizen**
- Comments are part of the code, not an afterthought
- Use descriptive variable names
- Include examples where helpful

## Structural Pattern

```lua
-- ============================================================================
-- Configuration Name/Purpose
-- Author: Your Name
-- Description: Brief description of what this config achieves
-- ============================================================================

-- [[ Section Headers ]]
-- Use double brackets to clearly delineate major sections
-- This makes navigation easier and structure obvious

-- Single line comments explain specific choices
-- Multi-line comments for complex explanations

-- Group related settings with blank lines between groups
-- This creates visual hierarchy without nesting
```

## Standard Configuration Structure

### 1. File Header
```lua
-- Minimal Neovim Configuration
-- Focused on: [productivity/development/specific language]
-- Principles: [built-in first, performance, simplicity]
```

### 2. Performance Settings
```lua
-- [[ Performance ]]
-- Enable byte-compiled Lua module cache
vim.loader.enable()
```

### 3. Leader Keys
```lua
-- [[ Leader Keys ]]
-- Set before plugins/mappings to ensure consistency
vim.g.mapleader = ' '      -- Space as leader
vim.g.maplocalleader = ' ' -- Same for local mappings
```

### 4. Options
```lua
-- [[ Options ]]
-- See `:help vim.o`
local opt = vim.opt

-- UI Settings
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Relative line numbers for easy jumping
-- ... grouped by category

-- Editor Behavior
opt.expandtab = true      -- Use spaces instead of tabs
opt.shiftwidth = 2        -- Size of an indent
-- ... grouped by purpose
```

### 5. Keymaps
```lua
-- [[ Keymaps ]]
-- See `:help vim.keymap.set()`
local map = vim.keymap.set

-- Essential mappings
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Navigation
-- Group by function: navigation, editing, etc.
```

### 6. Autocommands
```lua
-- [[ Autocommands ]]
-- See `:help lua-guide-autocommands`
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
-- Briefly highlight text after yanking (copying)
autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
```

### 7. Plugin Management
```lua
-- [[ Plugins ]]
-- Minimal plugin set focusing on essential enhancements
vim.pack.add({
  -- Plugin with explanation of why it's needed
  'url',  -- Brief description of unique value
})
```

### 8. LSP Configuration
```lua
-- [[ LSP Configuration ]]
-- Language servers provide IDE features
local servers = {
  language_name = {
    -- Server configuration with explanatory fields
  },
}
```

### 9. Plugin Configuration
```lua
-- [[ Plugin Configuration ]]
-- Configure plugins after they're loaded
-- Use pcall to handle missing plugins gracefully
```

## Documentation Patterns

### Pattern 1: Section Headers
```lua
-- [[ Major Section ]]      -- Double brackets for major sections
-- Minor Section           -- Single line for subsections
```

### Pattern 2: Inline Explanations
```lua
opt.scrolloff = 10  -- Keep 10 lines visible above/below cursor
```

### Pattern 3: Block Explanations
```lua
-- Window navigation keymaps
-- These mirror common editor conventions while using
-- Vim's window commands under the hood
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window' })
```

### Pattern 4: Reference Documentation
```lua
-- See `:help 'option-name'` for detailed explanation
-- See `:help lua-guide` for Lua in Neovim
```

### Pattern 5: Descriptive Keymaps
```lua
-- Always include desc field for discoverability
map('n', '<leader>f', ':find **/*', { desc = 'Find files' })
```

## Best Practices

### 1. **Logical Grouping**
- Group related options together
- Separate groups with blank lines
- Use consistent ordering

### 2. **Progressive Complexity**
```lua
-- Basic (everyone needs)
opt.number = true

-- Intermediate (most developers want)
opt.relativenumber = true

-- Advanced (specific workflows)
opt.colorcolumn = '80,120'
```

### 3. **Explain Non-Obvious Choices**
```lua
-- Good: Explains why
opt.updatetime = 250  -- Faster completion and diagnostic messages

-- Bad: Just restates code
opt.updatetime = 250  -- Set updatetime to 250
```

### 4. **Handle Missing Dependencies**
```lua
-- Gracefully handle missing plugins
pcall(function()
  require('plugin').setup({})
end)
```

### 5. **Use Meaningful Names**
```lua
-- Good
local enable_lsp_for_filetype = function(filetype)

-- Bad  
local elf = function(ft)
```

## Configuration Lifecycle

1. **Initial Setup**: Core options and mappings
2. **Enhancement**: Add LSP and essential plugins
3. **Customization**: Personal preferences and workflows
4. **Optimization**: Profile and remove unused features
5. **Maintenance**: Regular updates and cleanup

## Anti-Patterns to Avoid

### 1. **Over-Engineering**
```lua
-- Bad: Creating abstractions for single use
local create_keymap_factory = function(mode)
  return function(lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
```

### 2. **Copy-Paste Without Understanding**
```lua
-- Bad: Copying complex configs without knowing what they do
-- Always understand what you're adding
```

### 3. **Plugin Accumulation**
```lua
-- Bad: Adding plugins for minor conveniences
-- Each plugin should solve a real, frequent problem
```

### 4. **Premature Optimization**
```lua
-- Bad: Optimizing before measuring
-- Profile first, optimize second
```

## Template Structure

```lua
-- ============================================================================
-- Neovim Configuration
-- ============================================================================

-- [[ Performance ]]
vim.loader.enable()

-- [[ Leaders ]]
vim.g.mapleader = ' '

-- [[ Options ]]
-- UI
-- Editor
-- Search
-- System

-- [[ Keymaps ]]
-- Navigation
-- Editing
-- Search

-- [[ Autocommands ]]
-- Behavior modifications

-- [[ Plugins ]]
-- Essential tools only

-- [[ LSP ]]
-- Language server configurations

-- [[ Plugin Configuration ]]
-- Setup for loaded plugins

-- vim: ts=2 sts=2 sw=2 et
```

## Summary

A well-structured Neovim configuration is:
- **Self-documenting**: Comments explain decisions
- **Organized**: Logical sections and grouping
- **Minimal**: Only what's needed
- **Maintainable**: Easy to understand and modify
- **Personal**: Reflects your workflow

The best configuration is one you understand completely and can explain to others.