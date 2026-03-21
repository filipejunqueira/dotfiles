-- lua/core/autocmds.lua — Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text briefly
autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-reload files changed outside neovim (essential for Claude Code workflow)
-- autoread alone only triggers on certain events; this forces checks more aggressively
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Auto-reload files modified externally (Claude Code, git, etc.)',
  group = augroup('auto-reload', { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Notify when a file has been auto-reloaded
autocmd('FileChangedShellPost', {
  desc = 'Notify on file reload',
  group = augroup('auto-reload-notify', { clear = true }),
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.WARN)
  end,
})

-- Resize splits when terminal window is resized
autocmd('VimResized', {
  desc = 'Auto-resize splits on terminal resize',
  group = augroup('resize-splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Go to last cursor position when opening a buffer
autocmd('BufReadPost', {
  desc = 'Go to last cursor position on file open',
  group = augroup('last-position', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_position_restored then
      return
    end
    vim.b[buf].last_position_restored = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Remove trailing whitespace on save (skip for certain filetypes)
autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace on save',
  group = augroup('trim-whitespace', { clear = true }),
  callback = function()
    local exclude_ft = { 'markdown', 'diff' }
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      return
    end
    local save_cursor = vim.fn.getpos '.'
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Close certain filetypes with just 'q'
autocmd('FileType', {
  desc = 'Close certain windows with q',
  group = augroup('close-with-q', { clear = true }),
  pattern = { 'help', 'man', 'qf', 'checkhealth', 'lspinfo', 'notify', 'query', 'startuptime' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, silent = true })
  end,
})
