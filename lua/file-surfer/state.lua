local D = require("file-surfer.util.debug")

---@alias file-surfer.State.PathMap table<string, string>

---@class file-surfer.State
---@field is_open boolean
---@field path_map file-surfer.State.PathMap
local State = {
    is_open = false,
    path_map = {},
}

---@param path_map file-surfer.State.PathMap
function State:setPathMap(path_map)
    D.log("state.setPathMap", "Setting path map.", path_map)
    self.path_map = path_map
end

function State:getPathMap()
    return self.path_map
end

---@param state boolean
function State:setIsOpen(state)
    D.log("state.setIsOpen", "Setting state to " .. tostring(state))
    self.is_open = state
end

function State:getIsOpen()
    return self.is_open
end

return State
