local State = require("file-surfer.state")
local Config = require("file-surfer.config")
local PathMap = require("file-surfer.path_map")

local M = {
    ---TODO: put into config and type the keys
    backend_picker_map = {
        fzflua = "file-surfer.pickers.fzflua",
    },
}

---Open the file-surfer finder
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
---@param opts file-surfer.Config Module config table. See |file-surfer.options|.
---
---@usage `require("file-surfer").setup()` (add `{}` with your |file-surfer.options| table)
M.setup = function(opts)
    Config:init(opts)

    local config = Config:get()

    PathMap.populate(config)

    if config.user_command then
        vim.api.nvim_create_user_command(config.user_command, function()
            M.find()
        end, {})
    end

    if config.tmux.default_mappings then
        require("file-surfer.util.tmux").create_tmux_integration_bindings()
    end
end

return M
