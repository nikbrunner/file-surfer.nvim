local S = require("fff.state")
local D = require("fff.util.debug")

-- internal methods
local Fff = {}

-- Toggle the plugin by calling the `enable`/`disable` methods respectively.
--
--- @param scope string: internal identifier for logging purposes.
---@private
function Fff.toggle(scope)
    if S.getEnabled(S) then
        return Fff.disable(scope)
    end

    return Fff.enable(scope)
end

--- Initializes the plugin, sets event listeners and internal state.
---
--- @param scope string: internal identifier for logging purposes.
---@private
function Fff.enable(scope)
    if S.getEnabled(S) then
        D.log(scope, "Plugin is already enabled.")

        return
    end

    -- sets the plugin as `enabled`
    S.setEnabled(S)

    -- saves the state globally to `_G.Fff.state`
    S.save(S)
end

--- Disables the plugin for the given tab, clear highlight groups and autocmds, closes side buffers and resets the internal state.
---
--- @param scope string: internal identifier for logging purposes.
---@private
function Fff.disable(scope)
    if not S.getEnabled(S) then
        D.log(scope, "Plugin is already disabled.")

        return
    end

    -- resets the state to its initial value
    S.init(S)

    -- saves the state globally to `_G.Fff.state`
    S.save(S)
end

return Fff
