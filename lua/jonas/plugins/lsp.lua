-- Native LSP (vim.lsp.config / vim.lsp.enable), Server-Configs kommen aus nvim-lspconfig
-- Default-Keymaps von Neovim: grn (rename), gra (code action), grr (references),
-- gri (implementation), gO (symbols), K (hover), <C-s> (signature help, insert)
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
else
  -- Ohne Nix: Mason installiert die Server-Binaries
  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = false, -- enable passiert unten für beide Fälle
  })
end

vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
  end,
})
