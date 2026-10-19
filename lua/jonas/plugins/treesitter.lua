-- nvim-treesitter (main branch): installiert nur Parser, Highlighting/Indent macht Neovim selbst
-- Incremental selection ist seit 0.12 eingebaut: v_an / v_in (siehe :h treesitter-incremental-selection)
local parsers = {
  "lua",
  "vim",
  "vimdoc",
  "query",
  "c",
  "cpp",
  "rust",
  "go",
  "python",
  "bash",
  "markdown",
  "markdown_inline",
  "latex",
  "json",
  "html",
  "css",
  "javascript",
  "typescript",
  "nix",
}

local install = require("nvim-treesitter").install(parsers)
-- headless (z.B. Docker-Build): auf die Installation warten, sonst bricht +qa sie ab
if #vim.api.nvim_list_uis() == 0 then
  install:wait(300000)
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    -- schlägt still fehl, wenn für den Filetype kein Parser installiert ist
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
