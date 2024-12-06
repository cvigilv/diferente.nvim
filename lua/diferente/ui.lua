---@module "diferente.ui"
---@author Carlos Vigil-Vasquez
---@license MIT

M = {}

--- Create split where commit's diff will be shown
function M.create_split(commit_win, ratio)
  -- Get orientation and size of splitting
  local width = vim.api.nvim_win_get_width(commit_win)
  local height = vim.api.nvim_win_get_height(commit_win)

  local split_func = nil
  local resize_func = nil
  if width > vim.o.textwidth * 2 then
    split_func = "vsplit"
    resize_func = "vertical resize " .. vim.o.textwidth
  else
    split_func = "split"
    resize_func = "resize " .. math.floor(ratio * height)
  end

  -- Create split
  vim.cmd(split_func)
  local diff_win = vim.api.nvim_get_current_win()
  local diff_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(diff_win, diff_buf)

  -- Resize `gitcommit` window
  vim.api.nvim_set_current_win(commit_win)
  vim.api.nvim_command(resize_func)

  return diff_win
end

return M
