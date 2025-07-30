# Neovim 0.12 Quick Reference

## Plugin Management (vim.pack)

```lua
-- Add plugins
vim.pack.add({
  'github.com/user/plugin',
  { src = 'github.com/user/plugin2', version = 'v1.0' }
})

-- Update plugins
vim.pack.update()  -- Update all
vim.pack.update({ 'plugin-name' })  -- Update specific

-- Remove plugins
vim.pack.del({ 'plugin-name' })
```

## LSP Configuration

```lua
-- Define LSP config
vim.lsp.config['servername'] = {
  cmd = { 'language-server-executable' },
  filetypes = { 'javascript', 'typescript' },
  root_markers = { 'package.json', '.git' },
}

-- Enable LSP
vim.lsp.enable('servername')

-- Check LSP status
:checkhealth vim.lsp
```

## Built-in Completion

```lua
-- Enable LSP auto-completion
vim.lsp.completion.enable(true, client.id, bufnr, {
  autotrigger = true,
})

-- Manual completion triggers
-- <C-X><C-O>  - Omnifunc (LSP)
-- <C-X><C-N>  - Keywords in file
-- <C-X><C-F>  - File names
-- <C-X><C-L>  - Whole lines
-- <C-N>/<C-P> - Next/Previous match
```

## Default LSP Keymaps

### Global (Normal Mode)
- `grn` - Rename symbol
- `gra` - Code action
- `grr` - Find references
- `gri` - Go to implementation
- `grt` - Go to type definition
- `gO` - Document symbols

### Buffer-local
- `K` - Hover documentation
- `gq` - Format code
- `<C-]>` - Go to definition

### Visual Mode
- `an` - Expand selection
- `in` - Shrink selection

## Essential Commands

### File Navigation
```vim
:find <pattern>     " Find file in path
:grep <pattern>     " Search in files
:copen             " Open quickfix
:lopen             " Open location list
```

### Diagnostics
```vim
:lua vim.diagnostic.open_float()  " Show diagnostic at cursor
[d / ]d                          " Previous/Next diagnostic
```

### Windows & Buffers
```vim
<C-W>s / <C-W>v    " Split horizontal/vertical
<C-W>h/j/k/l       " Navigate windows
:ls                " List buffers
:b <name>          " Switch to buffer
```

## Minimal init.lua Template

```lua
-- Set options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.completeopt = 'menuone,noselect,popup'

-- Add plugins
vim.pack.add({
  -- Add essential plugins here
})

-- Configure LSP
vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
}

-- Enable LSP for Lua files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.lsp.enable('luals')
  end,
})

-- Set up completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.lsp.completion.enable(true, client.id, args.buf, {
      autotrigger = true,
    })
  end,
})
```

## Tips

1. **Start minimal**: Use built-in features before adding plugins
2. **Check health**: Run `:checkhealth` to diagnose issues
3. **Use help**: `:help lsp`, `:help vim.pack`, `:help ins-completion`
4. **Profile startup**: `nvim --startuptime startup.log`
5. **Lazy load**: Use autocmds to load features when needed