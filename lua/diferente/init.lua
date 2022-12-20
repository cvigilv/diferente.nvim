-- Different {{{

--- Create split where commit's diff will be shown
local function create_split(commit_win, ratio)
  -- Get orientation and size of splitting
  local width = vim.api.nvim_win_get_width(commit_win)
  local height = vim.api.nvim_win_get_height(commit_win)

  local split_func = nil
  local resize_func = nil
  if (width > vim.o.textwidth * 2)
  then
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

--- Create `gitdiff` buffer
local function get_diff()
  -- Create `gitdiff` buffer and temporally place it in a window
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local diff_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, diff_buf)

  -- Configure `gitdiff` buffer
  vim.api.nvim_buf_set_name(diff_buf, "different :: diff")
  vim.bo.syntax = "diff"
  vim.bo.buftype = "nofile"
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.cursorline = false

  -- Add and clean-up information to buffer
  vim.api.nvim_command("r!git diff -u --cached --no-color --no-ext-diff")
  vim.api.nvim_command([[g/^  (use "git.*/d]])
  vim.api.nvim_command([[g/^$/d]])
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
  vim.api.nvim_del_current_line()
  vim.bo.modifiable = false

  -- Place original buffer in current window
  vim.api.nvim_win_set_buf(win, buf)

  return diff_buf
end

--- Create `gitstatus` buffer
local function get_status()
  -- Create `gitstatus` buffer and temporally place it in a window
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local status_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, status_buf)

  -- Configure `gitstatus` buffer
  vim.api.nvim_buf_set_name(status_buf, "different :: status")
  vim.bo.syntax = "gitstatus"
  vim.bo.buftype = "nofile"
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.cursorline = false

  -- Add and clean-up information to buffer
  vim.api.nvim_command("r!git -c color.status=false status -b")
  vim.api.nvim_command([[g/^  (use "git.*/d]])
  vim.api.nvim_command([[g/^$/d]])
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
  vim.api.nvim_del_current_line()
  vim.bo.modifiable = false

  -- Place original buffer in current window
  vim.api.nvim_win_set_buf(win, buf)

  return status_buf
end

--- Create `gitlog` buffer
-- TODO(Carlos): Long description
-- @param diff_win ???: `gitdiff` window number
-- @return ???:
local function get_log()
  -- Create `gitstatus` buffer and temporally place it in a window
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local log_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, log_buf)

  -- Configure `gitstatus` buffer
  vim.api.nvim_buf_set_name(log_buf, "different :: log")
  vim.bo.syntax = "gitlog"
  vim.bo.buftype = "nofile"
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.cursorline = false

  -- Add and clean-up information to buffer
  vim.api.nvim_command("r!git log --oneline")
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
  vim.api.nvim_del_current_line()
  vim.bo.modifiable = false

  -- Place original buffer in current window
  vim.api.nvim_win_set_buf(win, buf)

  return log_buf
end

local function different()
  -- Constants
  local ratio = 0.3
  local commit_win = vim.api.nvim_get_current_win()
  local commit_buf = vim.api.nvim_get_current_buf()

  -- Create splits
  local diff_win = create_split(commit_win, ratio)

  -- Create views
  local diff_buf = get_diff()
  local status_buf = get_status()
  local log_buf = get_log()
  vim.api.nvim_set_current_win(diff_win)
  vim.api.nvim_win_set_buf(diff_win, diff_buf)

  -- Create user commands
  local commands = {
    DifferentCommit = commit_buf,
    DifferentDiff = diff_buf,
    DifferentStatus = status_buf,
    DifferentLog = log_buf,
  }
  for name, buf in pairs(commands) do
    vim.api.nvim_create_user_command(
      name,
      function() vim.api.nvim_win_set_buf(0, buf) end,
      {}
    )
  end

  local different_cycle = {
    diff_buf,
    status_buf,
    log_buf,
  }
  local cycle_id = 1

  vim.api.nvim_set_keymap(
    "n", "<S-Tab>", "", {
      noremap = true,
        callback = function()
        -- get `different` command to run
        local different_buf = different_cycle[cycle_id]

        -- cycle picker
        cycle_id = cycle_id + 1
        if cycle_id > 3 then
          cycle_id = 1
        end

        -- run `different` command
        vim.api.nvim_win_set_buf(diff_win, different_buf)

      end,
      desc = 'Cycle through Different modes'
    }
  )
end

vim.api.nvim_create_autocmd(
  { "BufWinEnter" },
  {
    pattern = { "COMMIT_EDITMSG", "MERGE_MSG" },
    callback = different,
  }
)

-- Close `different.nvim` windows if this are the last ones open
vim.api.nvim_create_autocmd(
  { "BufEnter" },
  {
    pattern = { "different :: diff", "different :: status", "different :: log" },
    command = 'if (winnr("$") == 1) | q | endif'
  }
)
-- }}}
