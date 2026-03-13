######################################################################
#  ~/.config/shell/completion.sh
#  Zsh completion behaviour. ZSH-SPECIFIC — skipped by .bashrc.
######################################################################

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select

autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
