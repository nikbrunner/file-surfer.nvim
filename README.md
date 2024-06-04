<p align="center">
  <h1 align="center">file-surfer.nvim</h2>
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

## ☄ Usage

TODO

## 🏗️ Installation

Installation with [folke/lazy.nvim](https://github.com/folke/lazy.nvim).

```lua
---@module "lazy"
---@type LazyPluginSpec
return {
    "nikbrunner/file-surfer.nvim",
    dependencies = {
        "ibhagwan/fzf-lua" -- Required for the picker
    },
    event = "VeryLazy",
---@module "file-surfer"
---@type file-surfer.Config
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
                require("file-surfer").find()
            end,
            desc = "Find File in Folder",
        },
    },
}
```

## ⚙ Configuration

> **Note**: The options are also available in Neovim by calling `:h file-surfer.options`

https://github.com/nikbrunner/file-surfer.nvim/blob/main/lua/file-surfer/config.lua#L3-L31

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.

1. `make deps` to install docs/tests dependencies
2. `make lint` to format the code
3. `make documentation` to generate the documentation
4. `make test` to run the tests

To run the linter you can use this.

```bash
lua-language-server --configpath .luarc.json --logpath luals-log --check .
```

## 🎭 Motivations

I often found myself wanting to quickly reference or look for snippets in other files from my projects, so I made this to enhance my workflow.

## 🛣️ Roadmap

- [ ] Rename to `file-surfer.nvim` (Update Banner)
- [ ] Simply `opts.path` to be flat table
- [ ] Support Blob Patterns e.g. `~/.config/*`
- [ ] Improve git root finding algo ("lsp" & "pattern")
  - Look for other examples.
- [ ] Support for `~/.dotfiles/` directory
- [ ] `doc` - Improve
- [ ] `README` - Add usage
- [ ] `README` - Add video or gif
- [ ] `opts.paths.static` - Support single files
- [ ] `opts.picker.fzf` - Allow to override options to fzf
- [ ] `opts.picker` - Support `telescope`
- [ ] `opts.picker` - Support `mini.pick`
- [ ] `opts.change_dir` - If the user returns to the file where the picker was opened, automatically change the directory to the git root of the selected folder (if it is a git repo)
