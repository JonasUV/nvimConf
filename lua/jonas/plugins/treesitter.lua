return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- WICHTIG: Verwende opts statt config für automatisches Laden
  opts = {
    ensure_installed = {
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
    },

    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  },
}
