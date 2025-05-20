# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## The filing of LazyVim

From Dante_A [comment](https://www.reddit.com/r/neovim/comments/1242n83/comment/je1phhf/?utm_source=share&utm_medium=web2x&context=3)

1. It is best practice to leave `config/lazy.lua` alone (i.e. with typescript plugins commented out), and add a separate `plugins/lazy.lua` section. This should include only core lua plugins which one wants to enable (like the typescript one mentioned above)
1. Instead of using Mason GUI-esque installer, it seems to be advised to create `plugins/mason.lua` file with "ensure_installed" list of language servers/linters/formatters. This should automagically get Mason to install the stuff one needs.
1. Similarly, one should create `plugins/nvim-treesitter.lua` with the list of treesitter modules in "ensure_installed" section.
1. Hence, adding a new language is usually a mixture of: **(a)** adding it to the `plugins/mason.lua` **(b)** `plugins/nvim-treesitter.lua`; and **(c)** `nvim-lspconfig.lua`.
Figuring out what should be added is... an art (e.g. mason expects `"bash-language-server"`, treesitter `"bash"`, lspconfig `"bashls"`). The official docs with the official naming can be helpful here ( (nvim-lspconfig)[https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md] , [treesitter](https://github.com/nvim-treesitter/nvim-treesitter#supported-languages) , [mason](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md) )

#### Q&A

1. What does Mason actually do? I.e. what happens if I install something with Mason and do nothing else?

    - It downloads packages like language servers and [puts them in a folder that is then added to neovim's copy of your $PATH](https://github.com/williamboman/mason.nvim/blob/92fe8b7b3795ebb9e856124ae9ef5d4a1502f230/lua/mason/init.lua#L23) so lspconfig can run shell commands to execute the language servers and stuff.

    You can actually just not use mason and install the language servers in other ways, eg. putting it on your $PATH globally by installing it using your system package manager. this misses out on the auto-setup that mason-lspconfig can do, though.

    If you install something with Mason and don't have mason-lspconfig+nvim-lspconfig installed to auto-configure it, then nothing happens except you now have the files and binary for that language server in a [mason/ folder under your neovim's standard path for "data"](https://github.com/williamboman/mason.nvim#default-configuration) (run `:lua = vim.fn.stdpath("data")` in neovim to get said path, and you'll see a mason/ folder there)

1. What does `nvim-lpsconfig.lua`  actually do, by adding these language servers there? What happens if I add something which I did not include in Mason?
    - It provides presets for setting up language servers such as the command neovim should run, the file types neovim should wait for until it invokes said command, etc. When require('lspconfig').language-server-name.setup(opts) is run, it sets that all up for the language server in question. the optional opts table lets you override the preset with whatever settings you want.
1. Mason recommends `mason-lspconfig.nvim` in addition to `nvim-lpsconfig.lua`. It is a part of core Lazy plugins. What does it actually do, which is not done by virtue of mason.lua and nvim-lspconfig.lua? (I note that /u/Some_Derpy_Pineapple very kindly explains below that it does some magic, so perhaps my step (4) above, involving `nvim-lspconfig.lua` is unnecessary?)
    - [The README does explain this](https://github.com/williamboman/mason-lspconfig.nvim#introduction)

    Basically it makes it easier to hook up nvim-lspconfig to language servers installed by mason, since mason does some things differently than lspconfig, which expects users to just be globally installing language servers. primarily, mason has different names for the packages.

    The more important function nowadays is that mason-lspconfig has nowadays though is that it allows you [to automatically setup](https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature) servers set up with Mason, usually involving nvim-lspconfig at some point. Before this existed, you'd have to manually specify which servers neovim should set up since neovim has no awareness of what servers you have.

    [in my dotfiles](https://github.com/pynappo/dotfiles/blob/b09ea64a52b363316c3826e90e6905f981092ca3/.config/nvim/lua/pynappo/plugins/lsp.lua#L127), I have a default function that runs lspconfig for every language server, except for rust-analyzer where it invokes [rust-tools](https://github.com/simrat39/rust-tools.nvim) which will run lspconfig for me with some extra features.
1. How do I know I haven't made any typos, or haven't failed to pre-install some pre-requisites? Will something scream at me telling me so?
    - Depends where you're doing this. Wrong name of a plugin? your plugin manager's git clone will fail and it will yell at you.

    Accidentally passed in an invalid option for a plugin, like `require('plugin').setup({gibberish = false})?` Depending on whether that plugin checks for invalid options, it will usually do nothing or yell at you.

    If you fail to install a prerequisite, usually some require() call will fail when the plugin tries to use that prerequisite's code, and neovim will echo the runtime error at you.
1. To clarify then - looking at [these dot files](https://github.com/lucazz/dotfiles/blob/main/nvim/lua/plugins/nvim-lspconfig.lua), am I right in saying that the file `nvim-lspconfig.lua` there is unnecessary and does nothing, since the server registration/activation will work automagically by virtue of `mason-lspconfig.nvim`?
    - Yeah the file's unnecessary for now since all of those server options are empty.


> [!NOTE]
> big kudos to lucazz whose [dotfiles](https://github.com/lucazz/dotfiles/blob/main/nvim/lua/plugins/nvim-lspconfig.lua) I have been looking at, in search for understanding :). Oh and obviously big kudos to [/u/folke](https://www.reddit.com/u/folke/) for creating all the exciting stuff, whose full power I am still figuring out :-D
