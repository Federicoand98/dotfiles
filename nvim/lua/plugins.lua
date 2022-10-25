local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'svrana/neosolarized.nvim',
    requires = { 'tjdevries/colorbuddy.nvim' }
  }
  use 'glepnir/lspsaga.nvim'
  use 'kyazdani42/nvim-web-devicons' -- File icons
  use 'L3MON4D3/LuaSnip' -- Snippet
  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for nvim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'neovim/nvim-lspconfig' -- LSP
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'akinsho/nvim-bufferline.lua'
  use 'norcalli/nvim-colorizer.lua'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'MunifTanjim/prettier.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'rcarriga/nvim-notify'
  use {
    'mfussenegger/nvim-dap',
    requires = {
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
    }
  }
  use {
    'ray-x/go.nvim',
    requires = { 'ray-x/guihua.lua' }
  }
  use 'akinsho/nvim-toggleterm.lua'
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
  }
end)
