local Debug = require("file-surfer.util.debug")

---@class file-surfer.Config.Paths.Dynamic
---@field path string The root directory paths
---@field scan_depth integer The depth of the search
---@field use_git boolean Whether to only include directories with a .git folder

---@class file-surfer.Config.Paths
---@field static? table<string, string> A list of preset Paths
---@field dynamic? table<file-surfer.Config.Paths.Dynamic> A list of dynamic paths
---
---@class file-surfer.Config.Tmux Configuration for tmux integration
---@field enable? boolean Whether to enable tmux integration
---@field default_mappings? boolean Whether to create tmux integration bindings

---@class file-surfer.Config
---@field debug? boolean Prints useful logs about what event are triggered, and reasons actions are executed.
---@field backend? "fzflua" Which Picker to use. Currently only FzfLua is supported.
---@field change_dir? boolean Whether to change the directory to selected folders
---@field user_command? string Name for the user command to create
---@field paths? file-surfer.Config.Paths Configuration for paths
---@field tmux? file-surfer.Config.Tmux Configuration for tmux integration

local Config = {
    ---@type file-surfer.Config
    config = {
        debug = false,
        backend = "fzflua",
        change_dir = false,
        user_command = nil,
        paths = {
            static = {},
            dynamic = {},
        },
        tmux = {
            enable = true,
            default_mappings = false,
        },
    },
}

---@param opts file-surfer.Config
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

---@return file-surfer.Config
function Config:get()
    return self.config
end

return Config
