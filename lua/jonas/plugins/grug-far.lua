-- Suchen & Ersetzen im ganzen Projekt (ripgrep)
-- Im grug-far Buffer: <localleader>r ersetzen, <localleader>q -> Quickfix, <localleader>c schließen, g? Hilfe
local grug = require("grug-far")
grug.setup({})

vim.keymap.set("n", "<leader>sr", function() grug.open() end, { desc = "Search & replace (project)" })
vim.keymap.set("n", "<leader>sw", function()
  grug.open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & replace word under cursor" })
vim.keymap.set("x", "<leader>sr", function() grug.with_visual_selection() end, { desc = "Search & replace selection" })
vim.keymap.set("n", "<leader>sf", function()
  grug.open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & replace (current file)" })
