# diferente.nvim

pun

## What is `diferente.nvim`?

`diferente.nvim` is a plugin that aims to improve the experience when commiting and merging
changes in a Git repository.

This plugin could be seen as a _ Lua-rewrite spiritual succesor_ of [commitia.vim](), while
trying to remaining minimal and modular.
The end goal is to enhance the `COMMIT_MSG` and `MERGE_MSG` file types with tools and UI
that (1) help improve commit messages and (2) have a better overview of the commit history.

![Preview](https://i.imgur.com/)


## Installation

Install `diferente` with your preferred package manager:

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
# Stable
Plug 'cvigilv/diferente.nvim'

# Development (lastest)
Plug 'cvigilv/diferente.nvim', { 'branch': 'develop'}
```

[packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Stable
use 'cvigilv/diferente.nvim'

-- Development (lastest)
use {'cvigilv/diferente.nvim', branch = 'develop'}
```

## Usage & configuration

In order to configure `` and use it, the following should be present in
your `init.lua`:
```lua
require("diferente").setup({})
```
For more information, refer to docs (`:h diferente`).

## Contributing

Pull requests are welcomed for improvement of tool and community templates.
Please contribute using [Github Flow](https://guides.github.com/introduction/flow/).
Create a branch, add commits, and 
[open a pull request](https://github.com/cvigilv/diferente.nvim/compare/).

Please [open an issue](https://github.com/cvigilv/diferente.nvim/issues/new) for
support.

