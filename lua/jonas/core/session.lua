-- Sessions pro Projektordner (:h :mksession)
-- Gespeichert wird automatisch beim Beenden, geladen mit <leader>sl oder über das Startmenü
local M = {}

local dir = vim.fn.stdpath("state") .. "/sessions/"
local ignore_ft = { alpha = true, NvimTree = true, ["grug-far"] = true, lazygit = true }

vim.opt.sessionoptions = "buffers,curdir,folds,tabpages,winsize"

-- /home/jonas/project -> ~/.local/state/nvim/sessions/%home%jonas%project.vim
function M.file()
  return dir .. vim.fn.getcwd():gsub("[/\\:]", "%%") .. ".vim"
end

local function is_file_buf(buf)
  return vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
end

function M.save()
  if not vim.iter(vim.api.nvim_list_bufs()):any(is_file_buf) then
    return -- nichts Sinnvolles offen, alte Session behalten
  end
  -- Explorer, Dashboard usw. nicht mitspeichern
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if (vim.bo[buf].buftype ~= "" or ignore_ft[vim.bo[buf].filetype]) and #vim.api.nvim_list_wins() > 1 then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  vim.fn.mkdir(dir, "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(M.file()))
end

function M.load()
  local file = M.file()
  if vim.fn.filereadable(file) == 0 then
    vim.notify("Keine Session für " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end
  vim.cmd("silent! source " .. vim.fn.fnameescape(file))
end

vim.api.nvim_create_autocmd("VimLeavePre", { callback = M.save })
vim.keymap.set("n", "<leader>sl", M.load, { desc = "Load session (cwd)" })

return M
