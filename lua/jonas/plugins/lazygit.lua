return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitFilter",
    "LazyGitCurrentFile",
    "LazyGitFilterCurrentFile",
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  keys = {
  { "<leader>lg","<cmd>LazyGit<cr>", desc = "Open lazygit"},
  },
}
