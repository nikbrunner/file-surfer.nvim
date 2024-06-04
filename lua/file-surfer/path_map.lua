local M = {}

---Helper function to get subdirectories of a given path and return them as a list
---@param dynamic_path file-surfer.Config.Paths.Dynamic
---@return table
---@private
local function dynamically_scan_dirs(dynamic_path)
    ---Recursively scan directories up to a specified depth.
    ---@param path string The current directory path
    ---@param level integer The current depth level
    ---@return table
    local function scan_dir(path, level)
        local dirs = {}

        -- Early exit if we've reached the maximum scanning depth
        if level > dynamic_path.scan_depth then
            return dirs
        end

        local items = vim.fn.readdir(path)
        if not items then
            return dirs
        end

        for _, item in ipairs(items) do
            local full_path = path .. "/" .. item

            -- Check if the item is a directory
            if vim.fn.isdirectory(full_path) == 1 then
                -- Determine project status based on `use_git` setting
                if
                    not dynamic_path.use_git
                    or (dynamic_path.use_git and vim.fn.isdirectory(full_path .. "/.git") == 1)
                then
                    table.insert(dirs, full_path)
                end

                -- Always scan subdirectories
                local sub_dirs = scan_dir(full_path, level + 1)
                for _, sub_dir in ipairs(sub_dirs) do
                    table.insert(dirs, sub_dir)
                end
            end
        end

        return dirs
    end

    return scan_dir(dynamic_path.path, 1)
end

---Populate folder presets with user-defined paths and repositories
---@param config file-surfer.Config
---@private
function M.populate(config)
    local State = require("file-surfer.state")

    local path_map = {}

    for name, path in pairs(config.paths.static) do
        path_map[name] = path
    end

    -- for each entry in dynamic paths, find the project directories
    for _, dynamic_path in ipairs(config.paths.dynamic) do
        local dirs = dynamically_scan_dirs(dynamic_path)

        for _, dir in ipairs(dirs) do
            -- Extract the trailing and preceeding folder names as entry name
            local repo_name = dir:match("([^/]+/[^/]+)/?$")
            path_map[repo_name] = dir
        end
    end

    State:setPathMap(path_map)
end

return M
