# diferente.nvim
## What is `diferente.nvim`?

`diferente.nvim` is a plugin that aims to improve the experience when commiting and merging
changes in a Git repository.

This plugin could be seen as a _Lua-rewrite spiritual succesor_ of [commitia.vim](), while
trying to remaining minimal and modular.
The end goal is to enhance the `COMMIT_MSG` and `MERGE_MSG` file types with tools and UI
that (1) help improve commit messages and (2) have a better overview of the commit history.

![Preview](https://i.imgur.com/)


## Installation

Install `diferente` with your preferred package manager:
[vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'cvigilv/diferente.nvim'
```
[packer](https://github.com/wbthomason/packer.nvim)
```lua
use 'cvigilv/diferente.nvim'
```

## Usage & configuration

In order to configure `diferente` and use it, the following should be present in
your `init.lua`:
```lua
require("diferente").setup({})
```
This will setup the keybind `<S-Tab>`, that will allow to switch to different modes inside the
diferente UI.

The default values of `diferente.nvim` setup are:
```lua
{
  ratio = 0.3,                -- UI size, value must be between 0 and 1
  preference = "diff",        -- Buffer to open at startup, value is any of "diff", "log", "status"
  create_ex_commands = true,  -- Creates "Diferente*" ex-commands
  create_keymaps = true,      -- Sets <S-Tab> for fast switching between diferente UI buffers
}
```

## Contributing

Pull requests are welcomed for improvement of tool and community templates.
Please contribute using [Github Flow](https://guides.github.com/introduction/flow/).
Create a branch, add commits, and 
[open a pull request](https://github.com/cvigilv/diferente.nvim/compare/).

Please [open an issue](https://github.com/cvigilv/diferente.nvim/issues/new) for
support.

