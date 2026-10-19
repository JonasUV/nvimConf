-- Plugins via the built-in package manager (Neovim >= 0.12, see :h vim.pack)
-- Lockfile: nvim-pack-lock.json in stdpath("config")
local gh = function(repo)
  return "https://github.com/" .. repo
end

-- Build hooks (must be defined before vim.pack.add to also run on install)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

local plugins = {
  -- shared dependencies
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("rktjmp/lush.nvim"),

  -- ui
  gh("uloco/bluloco.nvim"),
  gh("goolord/alpha-nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("nvim-tree/nvim-tree.lua"),

  -- navigation
  gh("nvim-telescope/telescope.nvim"),
  { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
  gh("christoomey/vim-tmux-navigator"),
  gh("MagicDuck/grug-far.nvim"),

  -- git
  gh("lewis6991/gitsigns.nvim"),
  gh("f-person/git-blame.nvim"),
  gh("kdheepak/lazygit.nvim"),

  -- treesitter
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

  -- lsp & completion
  gh("neovim/nvim-lspconfig"),
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
  gh("L3MON4D3/LuaSnip"),
  gh("saadparwaiz1/cmp_luasnip"),
  gh("rafamadriz/friendly-snippets"),
  gh("onsails/lspkind.nvim"),

  -- languages & misc
  -- v2.18: neuere Versionen brauchen Neovim >= 0.12.4 (Alpine hat 0.12.2)
  { src = gh("lervag/vimtex"), version = "v2.18" },
  gh("normen/vim-pio"),
  gh("elkowar/yuck.vim"),
  gh("lambdalisue/vim-suda"),
  gh("brianhuster/live-preview.nvim"),
}

-- LSP-Server kommen von Nix oder dem System (NVIM_SYSTEM_LSP=1, z.B. Docker), sonst von Mason
vim.g.use_mason = not vim.g.nix_managed and vim.env.NVIM_SYSTEM_LSP == nil
if vim.g.use_mason then
  vim.list_extend(plugins, {
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
  })
end

vim.pack.add(plugins, { confirm = false })
