return {
  --{
    --  "bluz71/vim-nightfly-guicolors",
    --priority = 1000, -- make sure to load this before all the other start plugins
    --config = function()
       -- load the colorscheme here
      --vim.cmd([[colorscheme nightfly]])
      --end,
    --},

    {
      'uloco/bluloco.nvim',
      lazy = false,
      priority = 1000,
      dependencies = { 'rktjmp/lush.nvim' },
      config = function()
        require("bluloco").setup({
        style = "auto",               -- "auto" | "dark" | "light"
          transparent = true,
          italics = false,
          terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
          guicursor   = true,
        })

      vim.opt.termguicolors = true
      vim.cmd('colorscheme bluloco')
      -- your optional config goes here, see below.
      end,
    },
}
