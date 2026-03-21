-- lua/core/options.lua — Vim option settings

local opt = vim.opt

-- Disable legacy remote plugin providers (not needed with LSP + treesitter)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Mouse
opt.mouse = 'a'

-- Don't show mode (statusline handles it)
opt.showmode = false

-- Sync clipboard with OS (scheduled for faster startup)
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Indentation
opt.breakindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- UI
opt.signcolumn = 'yes'
opt.cursorline = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.termguicolors = true
opt.pumheight = 10

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Whitespace display
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Live substitution preview
opt.inccommand = 'split'

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300

-- Undo persistence
opt.undofile = true

-- Confirm unsaved changes instead of failing
opt.confirm = true

-- Disable swap files (undo history is more useful)
opt.swapfile = false

-- File watching — essential for Claude Code external edits
opt.autoread = true
