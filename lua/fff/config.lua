local Debug = require("fff.util.debug")

---@class fff.Config.Paths.Dynamic
---@field path string The root directory paths
---@field scan_depth integer The depth of the search
---@field use_git boolean Whether to only include directories with a .git folder

---@class fff.Config.Paths
---@field static? table<string, string> A list of preset Paths
---@field dynamic? table<fff.Config.Paths.Dynamic> A list of dynamic paths

---@class fff.Config
---@field debug? boolean Prints useful logs about what event are triggered, and reasons actions are executed.
---@field backend? "fzflua" Which Picker to use. Currently only FzfLua is supported.
---@field change_dir? boolean Whether to change the directory to selected folders
---@field user_command? string Name for the user command to create
---@field paths? fff.Config.Paths Configuration for paths

local Config = {
    ---@type fff.Config
    config = {
        debug = false,
        backend = "fzflua",
        change_dir = false,
        user_command = nil,
        paths = {
            static = {},
            dynamic = {},
        },
    },
}

---@param opts fff.Config
---@private
function Config:init(opts)
    opts = opts or {}

    local defaults = vim.deepcopy(Config.config)
    local config = vim.tbl_deep_extend("force", defaults, opts)

    self.config = config

    -- Validate user options
    assert(type(self.config.debug) == "boolean", "`debug` must be a boolean (`true` or `false`).")

    -- Warn about deprecated options
    Debug.warnDeprecation(config)
end

---@return fff.Config
function Config:get()
    return self.config
end

return Config
