######################################################################
#  ~/.config/shell/plugins/fzf.sh
#  fzf initialisation + custom history widget. ZSH-SPECIFIC.
######################################################################

# fzf defaults — fd is faster than find and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Initialise fzf (sets default bindings; Ctrl-R overridden below)
eval "$(fzf --zsh)"

# Custom Ctrl-R history widget — deduplicates and previews
fzf-history-widget() {
  local selected
  selected=$(fc -rl 1 | awk '{cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0}' | \
    fzf --height 40% --layout=reverse --border \
        --preview "echo {}" \
        --preview-window=down:3:hidden \
        --header "• HISTORY •" \
        --with-nth=2.. \
        --query="$LBUFFER" +m)

  if [[ -n "$selected" ]]; then
    if [[ "$selected" =~ ^[[:space:]]*[0-9]+ ]]; then
      local cmd=$(echo "$selected" | sed 's/^[ \t]*[0-9]\+\**[ \t]*//')
      LBUFFER="$cmd"
    else
      LBUFFER="$selected"
    fi
  fi
  zle reset-prompt
}

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
bindkey '^[R' history-incremental-search-backward
