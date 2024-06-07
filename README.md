# Liam's Neovim Config 🧙

My Neovim setup is a fully fledged code editor,
note taker, and general text editor. I do all
my file editing and Neovim and I'm never looking
back.

## Backstory & Reasoning

### IDE/Coding Background ⌨

TL;DR I went from Eclipse -> IntelliJ (for Java) and
switched around a lot for other languages but ended
on VSCode for its versatility and speed (over JetBrains products).
Your editor matters!

I started coding when I was around 11 years old. I was
obsessed with Minecraft and wanted to make mods. So I
followed some tutorials online and setup Eclipse
with Forge and started coding in good ol' Java.

A few years later I started making games in Unreal Engine,
and being a Windows user I used Visual Studio to write
C++. I thought VS was so great coming from Eclipse (it
looked cool).

I continued to use both Eclipse and VS for many years.
When I joined my FIRST Robotics (FRC) team, The BreakerBots,
in 8th grade, Eclipse was required so I kept it around
for even longer. Many things annoyed me about it, but
there wasn't anything I could really do. Luckily,
FRC switched from Eclipse projects to Gradle the next year. Many
people switched to either VSCode or IntelliJ. I had
dabbled with VSCode and Atom prior, but honestly
did not like them because I so was used to IDEs with a ton
of features out of the box. I decided to use IntelliJ
and absolutely loved it. I still believe today, that
IntelliJ is by far the best Java editor out there (luckily
I do not code in Java anymore 😆). What this whole experience
taught me, is that you're code editor really matters. It
can significantly change the way you code, how fast you
code, and how much you enjoy doing it.

During high school, I explored many different languages and
a lot of web development. I switched around between
a lot of editors - Brackets, Atom, VS, VSCode, WebStorm and
never found anything I feel in love with. Eventually, I
just decided to adopt VSCode for everything because it
was pretty good and would work for basically any language
(and didn't take forever to launch). I continued
to use VSCode for many years, up until early 2024 (side note: the
live share was a great tool in college when working closely
with a partner).

### Note Taking Background 📓

TL;DR Handwritten -> iPad -> Google Docs (+ Equations Tool) -> Obsidian
All of them have major flaw(s).

In parallel with my code editor journey was my note taking
journey. I never really like taking notes by hand but also
couldn't type everything (especially math). But,
LaTeX looked to complicated for what I wanted. I took
notes on my iPad for about half a year, but a few times
it would die and I would be forced to take notes on my
laptop. I would write them in Google Docs and use the
`equation` tool. I really liked how neat it was and soon
adopted it as a primary note taking tool. I learned all
the shortcuts to create elements like fractions (`\frac` + space)
and square root (`\sqrt` + space) - not knowing this was just
LaTeX 😆.

I watched a video explaining [Obsidian.md by No Boilerplate](https://youtube.com/watch?v=DbsAQSIKQXk)
and instantly fell in love. I downloaded Obsidian and since I basically
already knew LaTeX from Google Docs it was a seamless and great
transition. I loved much easier it was to type my notes
and much better it looked than Docs. I was so fast now, I felt
like I could easily type everything that a teacher said and
wrote, while still fully pay attention. Some things were harder
than hand written notes (symbols for different math classes),
but some were much better like writing code with syntax highlighting.
Not only that, but having much notes in such a clean easily readable
and searchable format, made me go back my notes much more often
to use for studying and general reference. I felt like it helped
me get a lot more out of each class I took.

I also loved
to customize my Obsidian and used a ton of plugins. This made me
realize that Obsidian kinda sucks. Honestly, not to throw too
much shade to the Obsidian community (its the fault of the
Obsidian developers) but so many plugins are just
bad - actually bad. It also makes Obsidian take forever to launch
when you have just a few plugins (this can kinda be resolved with delayed
plugin loading). I got so frustrated that I tried to make my own
Obsidian plugins. Only to learn that Obsidian is completely closed
source, with horrible documentation that is extremely lacking, and
core features missing. I felt like I used Obsidian to customize
it, but writing plugins for it was such a headache it made
me start to hate the program as a whole. I needed to find an alternative.

### Switching to Neovim 😎

TL;DR Vim keybinds are cool & fast. Vim mode in VSCode & Obsidian
sucks. Neovim is hard to setup but worth it. I love Neovim.

I always envied people who used Vim. It was so fast and just looked
like black magic. I had attempted to learn multiple times, but
always had issues sticking with it because of its steep learning
curve. I was so inspired by ThePrimagen, that I decided to give it
another go. I turned on Vim mode in Obsidian and VSCode.

I was frustrated with Obsidian to begin with, but its Vim keybinds
being glitchy and incomplete, made me we really want to stop using it.
Neovim seemed really cool, would solve my issues with Obsidian, and
would replace VSCode an editor that I don't hate, but also don't love.

I setup my Neovim Lua config and spent a lot of time tweaking it to
get it just right. It wasn't too difficult to set it up as a VSCode
replacement, but note taking deemed to be more challenging (I'm picky). I didn't
really like the available markdown previewers so I decided to make
my own using Pandoc (export to HTML, preview in Falkon - similar
to Knap). It was a great experience,
that taught me a lot about how Vim works under the hood and
Lua, but it was just too slow. I abandoned that and replaced
it with my own fork of `peek.nvim` (so I could get the markdown
features I wanted and used in Obsidian) and have been very happy with it.
The main thing I lost from moving out of Obsidian was Excalidraw
but that is a sacrifice I'm willing to make and RNote is a good
replacement.

Although a JetBrains editor might have equivalent and more
features to my Neovim setup, I just wouldn't have known
about them or really used them. Using Neovim is similar
to why I use Arch Linux, I chose ever single part of it
so I know every feature and how to use it. If I don't like
a feature, I can remove or change it. If I want a feature
its one plugin away.

But the main reason I'm using Neovim (and Arch for that matter),
is because I love it. The bottom line in my opinion, is that you
should love your editor. It will make you want to code, and enjoy
the hours that do you spend coding.

### "Vim keybinds aren't that much faster" 🤓

TL;DR Yes they are.

Trust me, I used to be this guy. I used to always think that
my limiting factor was how fast I could think and not my ability to manipulate
text quickly - its not (probably).

If you think that Vim keybindings are not faster because you type
a file top to bottom than sure, its not. But realistically, nobody
writes their code top to bottom. You are constantly moving around
the file, changing small bits of text, etc. - things that Vim keybinds
massively speed up (and Neovim plugins/changes increase this even more).

It takes quite a while to pick it up, but after a few weeks, a month you
will be much faster. I genuinely think I code at double the speed I normally
would for sustained periods of time. And that's not even to mention macros.
Some people say there just a replacement for multiple cursors, but they
are so much more. Macros don't make sense outside of Vim, so I understand
why people don't get how powerful they are. The usefulness of macros comes
from having a modal editor (Vim) with text movement keybinds.
In Vim I can easily create
macros to modify many very different lines of text in complex,
but repeatable way. Ever time I use
a macro I just smile because it actually just so cool.


## My Setup 👑

The focus of my setup is to have minimal distractions.

### Philosophy

 1. 1 file in view at a time (ex. file explorer are full screen)
    - I love this because I can zoom in so much on my file without taking up a ton of my screen
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
 - __AI__: `pygpt` I didn't like any other implementations so I wrote my own plugin to interact with the Python Anthropic API (written in python because the API is and you shouldn't be converting their API to Lua because then you have to maintain it all the time). Uses full buffers/pages instead of floating. Honestly, I used to use GPT models to code/ask questions a lot, but now I am a big advocate of not doing that. Hallucinations are a big issues, you can become to reliant on it, and RTFM (`man` is your friend). If I need something quick or can't find an answer, I will put up with snarky people on StackOverflow because they are actually smart (-er than GPT models).

 - __Other Useful__:
     - `undotree`: View your entire undo tree/history, even from past sessions
     - `inc-rename`: Rename all occurances of variable
     - `comment.nvim`: Easily comment/uncomment selection
