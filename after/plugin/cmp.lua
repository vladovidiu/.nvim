import({ "cmp", "luasnip", "lspkind", "luasnip/loaders/from_vscode" }, function(modules)
  modules["luasnip/loaders/from_vscode"].lazy_load()
  local cmp = modules.cmp
  local luasnip = modules.luasnip
  local lspkind = modules.lspkind

  local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
  end

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-g>"] = cmp.mapping.close(),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = lspkind.cmp_format {
        mode = "symbol_text",
        symbol_map = {
          Copilot = "",
        },
        before = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "copilot" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
    sorting = {
      comparators = {
        cmp.config.compare.exact,
        cmp.config.compare.locality,
        cmp.config.compare.recently_used,
        cmp.config.compare.score,
        cmp.config.compare.offset,
        cmp.config.compare.sort_text,
        cmp.config.compare.order,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      completion = cmp.config.window.bordered {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
      documentation = cmp.config.window.bordered {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  }

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = modules.cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = modules.cmp.mapping.preset.cmdline(),
    sources = modules.cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  vim.cmd [[
        set completeopt=menuone,noinsert,noselect
        highlight! default link CmpItemKind CmpItemMenuDefault
    ]]
end)
