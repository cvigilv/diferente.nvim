---@module "diferente"
---@author Carlos Vigil-Vásquez
---@license MIT

local config = require("diferente.config")

local M = {}

--- Setup `diferente.nvim`
---@param opts Diferente.Config User configuration table
function M.setup(opts)
  -- Update defaults configuration
  opts = config.update_config(opts)
  require("diferente.spec").init(opts)
end

return M
