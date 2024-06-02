-- You can use this loaded variable to enable conditional parts of your plugin.
if _G.FffLoaded then
    return
end

_G.FffLoaded = true

-- Useful if you want your plugin to be compatible with older (<0.7) neovim versions
if vim.fn.has("nvim-0.7") == 0 then
    vim.cmd("command! Fff lua require('fff').toggle()")
else
    vim.api.nvim_create_user_command("Fff", function()
        require("fff").toggle()
    end, {})
end
