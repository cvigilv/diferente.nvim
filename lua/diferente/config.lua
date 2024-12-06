---@module "diferente.config"
---@author Carlos Vigil-Vásquez
---@license MIT

---@class Diferente.Config
---@field ratio number Window split
---@field preference string Which mode to launch whenever COMMIT/MERGE_MSG opens
---@field create_excmds boolean Create excommands related to diferente.nvim
---@field setup_keymaps boolean Setup keymaps related to diferente.nvim

---@type Diferente.Config
local defaults = {
  ratio = 0.3,
  preference = "diff",
  create_excmds = true,
  setup_keymaps = true,
}

local M = {}

---Update default configuration table by merging with user's configuration table
---@param opts Diferente.Config user configuration table
---@return Diferente.Config
M.update_config = function(opts)
  vim.validate({ config = { opts, "table", true } })

  opts = vim.tbl_deep_extend("force", defaults, opts or {})

  -- Validate setup
  vim.validate({
    ratio = { opts.ratio, { "number" } },
    preference = { opts.preference, "string" },
    create_excmds = { opts.create_excmds, "boolean" },
    setup_keymaps = { opts.setup_keymaps, "boolean" },
  })

  return opts
end

return M
