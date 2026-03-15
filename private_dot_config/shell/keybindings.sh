######################################################################
#  ~/.config/shell/keybindings.sh
#  Key bindings. ZSH-SPECIFIC. Must be sourced after plugins/zinit.sh.
######################################################################

zmodload zsh/terminfo

# Up/down arrows: history-substring-search (searches prefix, not full string)
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# Ctrl+Space: accept autosuggestion without leaving home row
bindkey '^ ' autosuggest-accept
