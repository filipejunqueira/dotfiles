######################################################################
#  ~/.config/shell/plugins/zoxide.sh
#  zoxide smart cd replacement. ZSH-SPECIFIC.
#  z  = smart jump (learns from usage)
#  zi = interactive picker (requires fzf)
#  cd = unchanged real builtin
######################################################################

command -v zoxide > /dev/null 2>&1 && eval "$(zoxide init zsh)"
unalias zi 2>/dev/null  # zinit also defines zi — zoxide's picker takes priority
