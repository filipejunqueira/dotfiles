######################################################################
#  ~/.config/shell/completion.sh
#  Zsh completion behaviour. ZSH-SPECIFIC — skipped by .bashrc.
######################################################################

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu no

# fzf-tab: preview directory contents on cd completion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --group-directories-first --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza --icons --group-directories-first --color=always $realpath'

autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
