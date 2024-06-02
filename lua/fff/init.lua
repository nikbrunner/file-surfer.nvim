local State = require("fff.state")
local Config = require("fff.config")
local PathMap = require("fff.path_map")

local M = {
    ---TODO: put into config and type the keys
    backend_picker_map = {
        fzflua = "fff.pickers.fzflua",
    },
}

---Open the fff finder
---@return nil
M.find = function()
    local config = Config:get()
    local path_map = State:getPathMap()

    local choices = vim.tbl_keys(path_map)

    table.sort(choices)

    local picker_module = M.backend_picker_map[config.backend]

    require(picker_module)(config, path_map, choices)
end

-- Set up function for plugin configuration
---@param opts fff.Config Module config table. See |Fff.options|.
---
---@usage `require("fff").setup()` (add `{}` with your |Fff.options| table)
M.setup = function(opts)
    Config:init(opts)

    local config = Config:get()

    PathMap.populate(config)

    if config.user_command then
        vim.api.nvim_create_user_command(config.user_command, function()
            M.find()
        end, {})
    end
end

return M
