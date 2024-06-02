<p align="center">
  <h1 align="center">fff.nvim</h2>
</p>

<p align="center">
    Find your most important files fast. 🏃‍♀️ 💨
</p>

<div align="center">
    <img src="./assets/banner.jpg" alt="Banner" width="100%"/>
</div>

## ⚡️ Features

- ⚡ Quickly find files in a predefined set of directories
  - 📂 Define static paths
  - 📦 Define dynamic paths to scan for directories with a certain depth and optionally only include directories with a `.git` folder
- ✨ Automatically change directory to the selected Folder
- ⌘ Create a user command to quickly open the finder
- ⛏️ Use `FzfLua` as the picker (Others to be added in the future)

## 🏗️ Installation

Installation with [folke/lazy.nvim](https://github.com/folke/lazy.nvim).

```lua
---@module "lazy"
---@type LazyPluginSpec
return {
    "nikbrunner/fff.nvim",
    dependencies = {
        "ibhagwan/fzf-lua" -- Required for the picker
    },
    event = "VeryLazy",
---@module "fff"
---@type fff.Config
    opts = {
        -- Example opts for paths. By default, there are no paths defined.
        paths = {
            static = {
                ["~/.scripts"] = vim.fn.expand("$HOME") .. "/.scripts",
            },
            dynamic = {
                {
                    -- For example add your project folder where you clone all your repos
                    path = vim.fn.expand("~/repos"),
                    scan_depth = 2,
                    use_git = true, -- Only include directories with a .git folder
                },
                {
                    -- Or add your config folder to quickly find your config files
                    path = vim.fn.expand("$XDG_CONFIG_HOME"),
                    scan_depth = 1,
                },
            },
        },
    },
    keys = {
        {
            "<leader>f",
            function()
                require("fff").find()
            end,
            desc = "Find File in Folder",
        },
    },
}
```

## ☄ Getting started

> Describe how to use the plugin the simplest way

TODO

## ⚙ Configuration

<details>
<summary>Click to unfold the full list of options with their default values</summary>

> **Note**: The options are also available in Neovim by calling `:h fff.options`

```lua
---@class fff.Config.Paths.Dynamic
---@field path string The root directory paths
---@field scan_depth integer The depth of the search
---@field use_git boolean Wether to only include directories with a .git folder

---@class fff.Config.Paths
---@field static? table<string, string> A list of preset Paths
---@field dynamic? table<fff.Config.Paths.Dynamic> A list of dynamic paths

---@class fff.Config
---@field change_dir? boolean Wether to change the directory to the selected folder
---@field user_command? string Name for the user command to create
---@field paths? fff.Config.Paths Configuration for paths
M.config = {
  backend = "fzf",
  change_dir = false,
  user_command = nil,
  paths = {
    static = {},
    dynamic = {
      {
        path = vim.fn.expand("~/repos"),
        level = 1,
        use_git = true,
      },
    },
  },
}
```

</details>

## 🧰 Commands

| Command   | Description         |
| --------- | ------------------- |
| `:Toggle` | Enables the plugin. |

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

## 🗞 Wiki

You can find guides and showcase of the plugin on [the Wiki](https://github.com/nbr/fff.nvim/wiki)

## 🎭 Motivations

I often found myself wanting to quickly reference or look for snippets in other files from my projects, so I made this to enhance my workflow.

## TODO

- [ ] `README` - Add video or gif
- [ ] `opts.paths.static` - Support single files
- [ ] `opts.picker.fzf` - Allow to override options to fzf
- [ ] `opts.picker` - Support `telescope`
- [ ] `opts.picker` - Support `mini.pick`
- [ ] `opts.change_dir` - If the user returns to the file where the picker was opened, automatically change the directory to the git root of the selected folder (if it is a git repo)
