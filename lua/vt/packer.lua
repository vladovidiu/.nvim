local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer..."
  vim.cmd [[packadd packer.nvim]]
end

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  -- Core
  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use "miversen33/import.nvim"
  use "MunifTanjim/nui.nvim"

  -- UI
  use "ellisonleao/gruvbox.nvim"
  use "folke/tokyonight.nvim"
  use "kyazdani42/nvim-web-devicons"
  use "feline-nvim/feline.nvim"
  use "stevearc/dressing.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  }
  use {
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
  }
  use {
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
  }
  use {
    "windwp/nvim-autopairs",
    after = "nvim-treesitter",
  }

  -- Editing
  use "max397574/better-escape.nvim"
  use "tpope/vim-sleuth"
  use "numToStr/Comment.nvim"
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable "make" == 1 }

  -- Cmp
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-nvim-lsp-signature-help"
  use "saadparwaiz1/cmp_luasnip"
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"
  use "onsails/lspkind.nvim"

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "simrat39/symbols-outline.nvim"
  use "ray-x/lsp_signature.nvim"
  use "j-hui/fidget.nvim"
  use "jose-elias-alvarez/null-ls.nvim"
  use "jayp0521/mason-null-ls.nvim"
  use "zbirenbaum/copilot.lua"
  use "zbirenbaum/copilot-cmp"

  -- Git
  use "TimUntersberger/neogit"
  use "lewis6991/gitsigns.nvim"

  -- Programming Language
  use "simrat39/rust-tools.nvim"
end)
