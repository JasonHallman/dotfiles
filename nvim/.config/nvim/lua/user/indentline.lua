local M = {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
}

function M.config()
  local icons = require "user.icons"

  require("ibl").setup()
end

return M
