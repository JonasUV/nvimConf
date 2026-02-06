return {
  'VonHeikemen/lsp-zero.nvim',
  branch = "v3.x",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    {
      "williamboman/mason.nvim",
      enabled = not vim.g.nix_managed,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      enabled = not vim.g.nix_managed,
    },
  },
  config = function()
    local lsp_zero = require('lsp-zero')
    
    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps({buffer = bufnr})
    end)
    
    local lspconfig = require('lspconfig')
    

    local servers = {
      "lua_ls",
      "rust_analyzer",
      "clangd",
      "pylsp",
      "dockerls",
      "cmake",
      "bashls",
      "gopls",
      "texlab",
      "jsonls",
      "html",
      "marksman",
    }

    if vim.g.nix_managed then
      table.insert(servers, "nil_ls")
    end
    -- Wenn auf Nix: LSPs direkt konfigurieren
    if vim.g.nix_managed then
      for _, server_name in ipairs(servers) do
        -- Einfach alle LSPs setup ohne executable check
        -- Die LSPs sind auf Nix garantiert verfügbar
        pcall(function()
          lspconfig[server_name].setup({})
        end)
      end
    else
      -- Wenn nicht auf Nix: Mason verwenden
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        },
      })
    end
  end,
}
