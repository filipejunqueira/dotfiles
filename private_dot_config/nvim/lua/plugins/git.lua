-- lua/plugins/git.lua — Git integration

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map('n', ']h', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, 'Next git [h]unk')

      map('n', '[h', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, 'Previous git [h]unk')

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, 'Git [h]unk [s]tage')
      map('n', '<leader>hr', gs.reset_hunk, 'Git [h]unk [r]eset')
      map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Git [h]unk [s]tage')
      map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Git [h]unk [r]eset')
      map('n', '<leader>hS', gs.stage_buffer, 'Git stage buffer')
      map('n', '<leader>hu', gs.undo_stage_hunk, 'Git [h]unk [u]ndo stage')
      map('n', '<leader>hR', gs.reset_buffer, 'Git reset buffer')
      map('n', '<leader>hp', gs.preview_hunk, 'Git [h]unk [p]review')
      map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Git [h]unk [b]lame line')
      map('n', '<leader>hd', gs.diffthis, 'Git [h]unk [d]iff')
      map('n', '<leader>hD', function() gs.diffthis '~' end, 'Git [h]unk [D]iff against ~')

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, '[T]oggle git [b]lame')
    end,
  },
}
