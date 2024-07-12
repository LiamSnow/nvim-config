# Liam's Neovim Config 🧙

My Neovim setup is a fully fledged code editor,
note taker, and general text editor. I do all
my file editing and Neovim and I'm never looking
back.

## Reasoning

### Backstory

I used Eclipse and Visual Studio growing up and never
thought to much about it. When I started using IntelliJ
and other JetBrains products I realized how much of a
difference your editor can make. When I started doing
more web development I used VSCode as my primary editor.

When I came to college I started with handwritten notes
and later switched to my iPad. I found that on both
platforms my organization and handwritting was so
bad that it was not even worth going back to my
notes, which frustrated me. I started taking
all my notes in Google Docs - not knowing
that I was basically writing LaTeX by using the Google
Docs shortcuts like `\frac`. In my second year I switched
to Obsidian (because of No Boilerplates video) which I
fell in love with. My notes were very organized, on my
own computer, had fancy LaTeX equations, and hand
drawn portions (excalidraw). Overall, I loved Obsidian
but it became frustratingly slow with over 10 plugins,
and was very hard to write my own plugins for because
of its poorly documented API.

### Switching to Vim

I had tried learning Vim keybinds multiple times but
the steep learning curve always steered me away
eventually. Inspired by ThePrimagen, I decided to give
it another shot. I enalbed Vim-mode on Obsidian and
VSCode. After around 2 weeks I became frustrated
with their Vim implementations and decided to make
my Neovim config.

I wanted a lot from Neovim and I was very picky so it
took me quite some time to get to a place I was happy
with. Setting up Neovim as a code editor was not
too difficult and had a lot of resources. For note
taking its a bit of a different story. I didn't really
like `obsidian.nvim` because it was a lot more than
I wanted. I tried to make my own preview plugin
using Pandoc and WebView but it was too slow. Eventually
I landed on `peek.nvim` which is pretty much exactly
what I wanted.

### Why Vim

This argument is actually two-fold - there is why Vim keybindings
and why Neovim. For the keybindings its a no brainer. Its a
steep learning curve, but if you stick with it you can signifcantly
improve you're programming speed. All I can say is that I really
wish I started using Vim keybindings sooner.

The argument for Neovim is much less strong. It's like using Arch
Linux. If you are editor nerd/power user and love to tweak every
little thing and have it just how you want - you should use Neovim.
Otherwise Neovim might be too much hassle than its worth.

## My Setup 👑

### Philosophy

 1. Zen/minimal distractions -> 1 file in view at a time (ex. file explorer is full screen)
 2. Load fast
 3. No Sacrifices - If I liked in feature in Obsidian or VSCode
 I will figure out how to get it into neovim
 4. Quickly move between files (`harpoon` + `telescope` is goated)
 5. No mouse (its _mostly_ disabled)

### Packages

 - __Package Manager__: `Lazy`
 - __Git__: `Fugitive`
 - __LSP__: `nvim-lspconfig + Mason`
 - __Formatter__: `conform.nvim`
 - __Linter__: `nvim-lint`
 - __Status Bar__: `lualine`
 - __File Explorer__: `neo-tree` (although usually I will use yazi externally)
 - __Markdown Preview__: `peek.nvim` (my forked version)
 - __File Search__: `telescope`
 - __Quick Switcher__: `harpoon` (basically simulated tabs, but better)
 - __Theme__: `nightfox` (with no/black background)
 - __AI__: `pygpt` I didn't like any other implementations so I wrote my own plugin to interact with the Python Anthropic API (written in python because the API is and you shouldn't be converting their API to Lua because then you have to maintain it all the time). Uses full buffers/pages instead of floating.
    - \*NOTE: I have basically stopped using GPT models to code. Hallucinations are a big issue, you can become too reliant on them (in the long term actually slowing you down), and docs/StackOverflow is better 9/10 times. I think [this video](https://www.youtube.com/watch?v=Wap2tkgaT1Q) provides some good insight on the topic too.
 - __Other Useful__:
     - `undotree`: View your entire undo tree/history, even from past sessions
     - `inc-rename`: Rename all occurances of variable
     - `comment.nvim`: Easily comment/uncomment selection
