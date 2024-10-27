local State = require("file-surfer.state")

-- TODO: Try to make headers work: https://github.com/ibhagwan/fzf-lua/issues/1351#issuecomment-2265742596

---TODO: put in lib
---@param dir string
local function change_dir(dir)
    vim.notify("Changing directory to " .. dir, vim.log.levels.INFO, { title = "file-surfer.nvim" })
    vim.cmd("cd " .. dir)
end

---@param config file-surfer.Config
---@param folder_map table<string, string>
local function create_actions(config, folder_map)
    local is_tmux_enabled = config.tmux.enable

    local actions = {
        ["default"] = {
            fn = function(choice)
                local selected_folder = folder_map[choice[1]]

                if config.change_dir then
                    change_dir(selected_folder)
                end

                require("fzf-lua").files({
                    cwd = selected_folder,
                })
            end,
            -- TODO:  make these work
            header = "Pick a project folder",
        },

        ["alt-d"] = {
            fn = function(choice)
                change_dir(folder_map[choice[1]])
            end,
            header = "Change directory",
        },
    }

    if is_tmux_enabled then
        actions["ctrl-n"] = {
            fn = function(choice)
                local tmux = require("file-surfer.util.tmux")
                local session_name = choice[1]
                local session_cwd = folder_map[choice[1]]

                tmux.start_session_in_cwd(session_name, session_cwd)
            end,
            header = "New session in TMUX",
        }
    end

    return actions
end

---@param config file-surfer.Config
---@param folder_map table<string, string>
---@param choices string[]
return function(config, folder_map, choices)
    require("fzf-lua").fzf_exec(choices, {
        defaults = {
            formatter = "path.filename_first",
            git_icons = false,
            file_icons = true,
            color_icons = true,
        },

        -- NOTE: For the folder pick there is nothing to preview
        -- But if we don't set the previewer here, the previewer would not show up in file picker window.
        -- TODO: Find a way to not show the previewer in folder picker, but show it in file picker.
        --@see [Advanced · ibhagwan/fzf-lua Wiki](https://github.com/ibhagwan/fzf-lua/wiki/Advanced#neovim-builtin-preview)
        previewer = "builtin",

        previewers = {
            builtin = {
                syntax = true,
                treesitter = { enable = true },
            },
        },

        fzf_opts = {
            ["--ansi"] = "",
            ["--prompt"] = "  ",
            -- ["--info"] = "hidden",
            ["--height"] = "100%",
            ["--layout"] = "reverse",
            ["--keep-right"] = "",
            ["--reverse"] = "",
            ["--padding"] = "2,10",
            ["--no-scrollbar"] = "",
            -- ["--no-separator"] = "",
        },

        fzf_colors = {
            ["fg"] = { "fg", "Normal" },
            ["fg+"] = { "fg", "CursorLineNr" },
            ["bg"] = { "bg", "NormalFloat" },
            ["hl"] = { "fg", "Comment" },
            ["hl+"] = { "fg", "Statement" },
            ["bg+"] = { "bg", "Normal" },
            ["border"] = { "fg", "CursorLineNr" },
            ["query"] = { "fg", "Statement" },
            ["info"] = { "fg", "PreProc" },
            ["label"] = { "fg", "CursorLineNr" },
            ["prompt"] = { "fg", "Conditional" },
            ["pointer"] = { "fg", "Exception" },
            ["marker"] = { "fg", "Keyword" },
            ["spinner"] = { "fg", "Label" },
            ["header"] = { "fg", "Comment" },
            ["gutter"] = { "bg", "NormalFloat" },
        },

        files = {
            prompt = "  ",
            multiprocess = true, -- run command in a separate process
            find_opts = [[-type f -not -path '*/\.git/*' -not -name '.DS_Store' -printf '%P\n']],
            rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!.DS_Store'",
            fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude .DS_Store",
            -- by default, cwd appears in the header only if {opts} contain a cwd
            -- parameter to a different folder than the current working directory
            -- uncomment if you wish to force display of the cwd as part of the
            -- query prompt string (fzf.vim style), header line or both
            cwd_prompt = true,
            cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
            cwd_prompt_shorten_val = 1, -- shortened path parts length
        },

        winopts = {
            height = 0.85, -- window height
            width = 0.85, -- window width
            row = 0.35, -- window row position (0=top, 1=bottom)
            col = 0.50, -- window col position (0=left, 1=right)
            border = "single",
            title = "file-surfer.nvim",
            title_pos = "center", -- 'left', 'center' or 'right'
            fullscreen = false, -- start fullscreen?
            preview = {
                default = "bat", -- override the default previewer?
                border = "border", -- border|noborder, applies only to
                hidden = "nohidden", -- hidden|nohidden
                vertical = "up:65%", -- up|down:size
                horizontal = "left:50%", -- right|left:size
                layout = "flex", -- horizontal|vertical|flex
                flip_columns = 200, -- #cols to switch to horizontal on flex
                title = true, -- preview border title (file/buf)?
                title_pos = "center", -- left|center|right, title alignment
                scrollbar = "float", -- `false` or string:'float|border'
                winopts = { -- builtin previewer window options
                    number = false,
                },
            },

            on_create = function()
                State:setIsOpen(true)
            end,
            on_close = function()
                State:setIsOpen(false)
            end,
        },

        actions = create_actions(config, folder_map),
    })
end
