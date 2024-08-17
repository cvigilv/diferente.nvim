---@module "diferente.spec"
---@author Carlos Vigil-Vasquez
---@license MIT

local ui = require("diferente.ui")

--- Create `gitdiff` buffer
local get_diff = function()
	-- Create `gitdiff` buffer and temporally place it in a window
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	local diff_buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(win, diff_buf)

	-- Configure `gitdiff` buffer
	vim.api.nvim_buf_set_name(diff_buf, "diferente :: diff")
	vim.bo.syntax = "diff"
	vim.bo.buftype = "nofile"
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.cursorline = false

	-- Add and clean-up information to buffer
	vim.api.nvim_command("r!git diff -u --cached --no-color --no-ext-diff")
	pcall(vim.api.nvim_command, [[g/^  (use "git.*/d]])
	pcall(vim.api.nvim_command, [[g/^$/d]])
	vim.api.nvim_win_set_cursor(win, { 1, 0 })
	vim.api.nvim_del_current_line()
	vim.bo.modifiable = false

	-- Place original buffer in current window
	vim.api.nvim_win_set_buf(win, buf)

	return diff_buf
end

--- Create `gitstatus` buffer
local get_status = function()
	-- Create `gitstatus` buffer and temporally place it in a window
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	local status_buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(win, status_buf)

	-- Configure `gitstatus` buffer
	vim.api.nvim_buf_set_name(status_buf, "diferente :: status")
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
local get_log = function()
	-- Create `gitstatus` buffer and temporally place it in a window
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()
	local log_buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(win, log_buf)

	-- Configure `gitstatus` buffer
	vim.api.nvim_buf_set_name(log_buf, "diferente :: log")
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

---@param opts Diferente.Config
local Diferente = function(opts)
	-- Constants
	local ratio = opts.ratio
	local preference = opts.preference
	local commit_win = vim.api.nvim_get_current_win()
	local commit_winid = vim.fn.win_getid()

	-- Create splits
	local diff_win = ui.create_split(commit_win, ratio)

	-- Create views
	local diff_buf = get_diff()
	local status_buf = get_status()
	local log_buf = get_log()
	local git_buffers = {
		diff = diff_buf,
		status = status_buf,
		log = log_buf,
	}
	vim.api.nvim_set_current_win(diff_win)
	vim.api.nvim_win_set_buf(diff_win, git_buffers[preference])

	-- Create user commands
	if opts.create_ex_commands then
		print("diferente.nvim :: Ex-commands created!")
		local commands = {
			DiferenteDiff = diff_buf,
			DiferenteStatus = status_buf,
			DiferenteLog = log_buf,
		}
		for name, buf in pairs(commands) do
			vim.api.nvim_create_user_command(name, function()
				vim.api.nvim_win_set_buf(0, buf)
			end, {})
		end
	end

	if opts.create_keymaps then
		print("diferente.nvim :: Keymaps created!")
		M.diferente_cycle = {
			diff_buf,
			status_buf,
			log_buf,
		}
		M.cycle_id = 1

		vim.api.nvim_set_keymap("n", "<S-Tab>", "", {
			noremap = true,
			callback = function()
				-- get `diferente` command to run
				local diferente_buf = M.diferente_cycle[M.cycle_id]

				-- cycle picker
				M.cycle_id = M.cycle_id + 1
				if M.cycle_id > 3 then
					M.cycle_id = 1
				end

				-- run `diferente` command
				vim.api.nvim_win_set_buf(diff_win, diferente_buf)
			end,
			desc = "Cycle through Diferente modes",
		})
	end

	-- HACK: this will close everything, without saving, if the COMMIT_EDITMSG/MERGE_MSG buffer
	-- is closed. This could be improved by adding a checker to see if the open buffers are only
	-- related to diferente.nvim
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(commit_winid),
		group = vim.api.nvim_create_augroup("diferente", { clear = false }),
		callback = function()
			vim.cmd("quitall!")
		end,
	})
end

M = {}

M.init = function(opts)
	-- create autocommands for skeleton insertion
	local group = vim.api.nvim_create_augroup("diferente", { clear = true })

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = group,
		pattern = { "COMMIT_EDITMSG", "MERGE_MSG" },
		callback = function()
			Diferente(opts)
		end,
	})
end

return M
