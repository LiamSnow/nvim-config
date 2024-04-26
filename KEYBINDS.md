
### Vim (Default)
Increment Number: `<C-a>` (opposite for strings)
Decrement Number: `<C-x>` (opposite for strings)

Text Objects:
 - Inner Word: `iw` (→ change is word:`ciw`)
 - Around Word: `aw`
 - Inner/Around Sentence: `is`, `as`
 - Inner/Around Paragraph: `ip`, `ap`
 - Inner/Around Paranthesis: `i(`, `a(`
 - Inner/Around HTML: `it`, `at`
 - Line: `c` (→ change line: `cc`)

Change Line: `cc`

Set Mark: `m[a-zA-Z]` (lowercase = local, uppercase = global)
Jump to Mark: `'[a-zA-Z]`

Delete to EOL: `D`

### General
Open Here: `nvim .`
Close: `:wqa`
Move Selection: `J` and `K`
Move Long Lines: `J`
Paste over without Copy: `<A-p>`
Delete without Copy: `<leader>d`

Paste to System: `<A-p>`, `<A-P>`
Yank to System: `<A-y>`, `<A-Y>`

Format Selection: `<leader>f`

Quick Fix List: `<C-k>`, `<C-j>`, `<leader>k`, `<leader>j`

Find/Replace Current Word: `<leader>s`

Chmod Bash File: `<leader>x`

Window Management:
 - Switch: `<A-h|k|k|l>`
 - V-Split: `<A-v>`
 - Resize: `<A-S-h|k|k|l>`

### LSP
Go to Definition: `gd`
Show Hover Information: `K`
Find Workspace Symbol: `<leader>vws`
Open Diagnostics Float: `<leader>vd`
Code Action: `<leader>vca`
Find References: `<leader>vrr`
Rename Symbol: `<leader>vrn`
Signature Help (Insert Mode): `<C-h>`
Go to Next Diagnostic: `[d`
Go to Previous Diagnostic: `]d`

Previous Item: `<A-,>`
Next Item: `<A-.>`
Confirm Selection: `<C-.>`
Trigger Autocompletion: `<C-/>`

Rename Variable: `<leader>rn` (`inc-rename.nvim`)

### LazyGit
Open: `<leader>lg`

### Harpoon
Add to List: `<A-a`
Quick Menu: `<A-e>`
Go to N: `<A-N>`
Set as N: `<S-A-N>`

### Telescope
Search Git or Files: `<leader>p`
Search Files: `<leader><S-p>`
Grep: `<leader>gs`
Grep Word: `<leader>gWs`
Help: `<leader>vh`

### Trouble
Toggle: `<leader>tt`
Next: `[t`
Past: `]t`

### Undo Tree
Toggle: `<leader>u`

### OGPT
Open/Close: `<leader>c`
Yank Last: `<C-y>`
Yank Last Code: `<C-i>`
New Session: `<C-n>`
Cycle Windows: `<Tab>`
Cycle Modes: `<C-f>`
Next Message: `J`
Prev Message: `K`
Select Session: `Enter`
Rename Session: `r`
Delete Session: `d`
Edit Message: `e`
Parameters: `<C-p>`
Message Role: `<C-r>`
System Role: `<C-s>`
Stop Generating: `<C-x>`

### Knap
Start HTML: `<leader>kh`
Start PDF: `<leader>kp`
Stop: `<leader>kk` (also stops when neovim quits)

### Surround
Visual Mode: `S` + replacement char
```
    Old text                    Command         New text
--------------------------------------------------------------------------------
    surr*ound_words             ysiw)           (surround_words)
    *make strings               ys$"            "make strings"
    [delete ar*ound me!]        ds]             delete around me!
    remove <b>HTML t*ags</b>    dst             remove HTML tags
    'change quot*es'            cs'"            "change quotes"
    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    delete(functi*on calls)     dsf             function calls
```

### Comment
Visual Mode:
 - Line: `gc`
 - Block: `gb`
Normal Mode:
 - Line: `gcc`
 - Block: `gbc`
 - Line Above: `gcO`
 - Line Below: `gco`
 - End Line: `gcA`

### UFO (Folding)
Create (Visual Mode): `zf`
Open: `zo`
Close: `zc`
Delete: `zd`
Delete All: `zE`
Open All: `zR`
Close All: `zM`
Open Folds Expect Kinds: `zr`
Close Fold With: `zm`


### Neo-Tree
