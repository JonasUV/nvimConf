local dashboard = require("alpha.themes.dashboard")

-- Buttons passend zu den eigenen Keymaps (der Theme-Default zeigt fremde Belegungen)
dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", "<cmd>ene<CR>"),
  dashboard.button("SPC f f", "󰈞  Find file"),
  dashboard.button("SPC f r", "󰊄  Recently opened files"),
  dashboard.button("SPC f g", "󰈬  Find word"),
  dashboard.button("SPC s r", "  Search & replace"),
  dashboard.button("SPC s l", "  Open last session"),
  dashboard.button("SPC l g", "  Lazygit"),
  dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
}

dashboard.section.footer.val = "config " .. require("jonas.core.version").get() .. " · nvim " .. tostring(vim.version())

require("alpha").setup(dashboard.config)
