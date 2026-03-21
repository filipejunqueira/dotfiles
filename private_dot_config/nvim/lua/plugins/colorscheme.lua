-- lua/plugins/colorscheme.lua — Gruvbox Dark (matching Ghostty + Zellij theme stack)

return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  config = function()
    require('gruvbox').setup {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = '', -- "hard", "soft", or "" (medium)
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    }
    vim.cmd.colorscheme 'gruvbox'
  end,
}
