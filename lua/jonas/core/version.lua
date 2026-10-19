-- Version der Config: von der Flake gesetzt (vim.g.config_version), sonst aus git
local M = {}

local cached

function M.get()
  if cached then
    return cached
  end
  if vim.g.config_version then
    cached = vim.g.config_version
  else
    local repo = vim.fn.stdpath("config")
    local res = vim.system({ "git", "-C", repo, "log", "-1", "--format=%h %cs" }):wait()
    if res.code == 0 and res.stdout ~= "" then
      local dirty = vim.system({ "git", "-C", repo, "status", "--porcelain" }):wait().stdout ~= ""
      cached = vim.trim(res.stdout):gsub(" ", dirty and "-dirty " or " ", 1)
    else
      cached = "unknown"
    end
  end
  return cached
end

vim.api.nvim_create_user_command("ConfigVersion", function()
  print("config " .. M.get() .. " · nvim " .. tostring(vim.version()))
end, { desc = "Show config version" })

return M
