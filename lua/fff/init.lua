local M = require("fff.main")
local C = require("fff.config")

local Fff = {}

--- Toggle the plugin by calling the `enable`/`disable` methods respectively.
function Fff.toggle()
    if _G.Fff.config == nil then
        _G.Fff.config = C.options
    end

    M.toggle("publicAPI_toggle")
end

--- Initializes the plugin, sets event listeners and internal state.
function Fff.enable()
    if _G.Fff.config == nil then
        _G.Fff.config = C.options
    end

    M.enable("publicAPI_enable")
end

--- Disables the plugin, clear highlight groups and autocmds, closes side buffers and resets the internal state.
function Fff.disable()
    M.disable("publicAPI_disable")
end

-- setup Fff options and merge them with user provided ones.
function Fff.setup(opts)
    _G.Fff.config = C.setup(opts)
end

_G.Fff = Fff

return _G.Fff
