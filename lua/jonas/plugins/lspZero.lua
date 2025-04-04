return {
  'VonHeikemen/lsp-zero.nvim',
  branch="v3.x",
  dependencies={"neovim/nvim-lspconfig","hrsh7th/cmp-nvim-lsp","hrsh7th/nvim-cmp","L3MON4D3/LuaSnip","williamboman/mason.nvim","williamboman/mason-lspconfig.nvim"},
  config=function()
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(client, bufnr)
      -- see :help lsp-zero-keybindings
      -- to learn the available actions
      lsp_zero.default_keymaps({buffer = bufnr})
    end)

    -- to learn how to use mason.nvim
    -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {"lua_ls", "rust_analyzer","clangd","taplo","zls","yamlls","pylsp","dockerls","cssls","cmake","bashls","rnix", "gopls", "texlab", "jsonls", "html","marksman","asm_lsp"},
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
      },
    })
  end,
}
