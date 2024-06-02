local D = require("fff.util.debug")

local Fff = {}

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
Fff.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = false,
}

---@private
local defaults = vim.deepcopy(Fff.options)

--- Defaults Fff options by merging user provided options with the default plugin values.
---
---@param options table Module config table. See |Fff.options|.
---
---@private
function Fff.defaults(options)
    local tde = function(t1, t2)
        return vim.deepcopy(vim.tbl_deep_extend("keep", t1 or {}, t2 or {}))
    end

    Fff.options = tde(options, defaults)

    -- let your user know that they provided a wrong value, this is reported when your plugin is executed.
    assert(type(Fff.options.debug) == "boolean", "`debug` must be a boolean (`true` or `false`).")

    return Fff.options
end

--- Define your fff setup.
---
---@param options table Module config table. See |Fff.options|.
---
---@usage `require("fff").setup()` (add `{}` with your |Fff.options| table)
function Fff.setup(options)
    Fff.options = Fff.defaults(options or {})

    -- Useful for later checks that requires nvim 0.9 features at runtime.
    Fff.options.hasNvim9 = vim.fn.has("nvim-0.9") == 1

    D.warnDeprecation(Fff.options)

    return Fff.options
end

return Fff
