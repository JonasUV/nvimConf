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

if vim.g.use_mason then
  -- Mason installiert die Server-Binaries
  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = false, -- enable passiert unten für alle Fälle
  })
else
  -- Server vom System (Nix/apk): zusätzliche Server, nur aktivieren was installiert ist
  vim.list_extend(servers, { "nil_ls", "neocmake" })
  servers = vim.tbl_filter(function(name)
    local cmd = (vim.lsp.config[name] or {}).cmd
    return type(cmd) ~= "table" or vim.fn.executable(cmd[1]) == 1
  end, servers)
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
