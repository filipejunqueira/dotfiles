######################################################################
#  ~/.config/shell/aliases.sh
#
#  POSIX-compatible — sourced by both ~/.zshrc and ~/.bashrc.
######################################################################

# ── Colour support ─────────────────────────────────────────────────
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# ── File listing (eza with lsd fallback) ───────────────────────────
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first'
    alias la='eza -lah --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
elif command -v lsd &>/dev/null; then
    alias ls='lsd -h --color=auto --group-dirs=first'
    alias ll='lsd -lh --color=auto --group-dirs=first'
    alias la='lsd -lAh --color=auto --group-dirs=first'
else
    alias ls='ls --color=auto'
    alias ll='ls -lhF --color=auto'
    alias la='ls -lAh --color=auto'
fi

# ── bat → cat ──────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catn='bat'
fi

# ── File operations ────────────────────────────────────────────────
alias cp="cp -iv"
alias mv="mv -vi"
alias rm="rm -vI"
alias mkd="mkdir -pv"
alias df='df -h'
alias du='du -h'

# ── Navigation ─────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias phd="cd ~/research/phd-thesis/"

# ── Editors & viewers ──────────────────────────────────────────────
alias v="nvim"
alias za="zathura"
alias p="pdftk"

# ── Git ────────────────────────────────────────────────────────────
alias g="git"
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gco='git checkout'

# ── System ─────────────────────────────────────────────────────────
alias c="clear"
alias q="exit"
alias h="history"
alias reload='source ~/.zshrc'
alias f="nautilus"
alias sdn="sudo shutdown -h now"
alias slp="systemctl suspend"
alias superpowers="sudo -E -s"
alias please="sudo"

# ── SSH tunnel ─────────────────────────────────────────────────────
alias tunnel="ssh -fCqNX -D 1080"

# ── Alert (notify after long commands) ─────────────────────────────
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ── Media ──────────────────────────────────────────────────────────
alias yt="yt-dlp --add-metadata -ic"
alias yta="yt-dlp --add-metadata -xic"

# ── Utility functions ──────────────────────────────────────────────
weather() { curl -s "wttr.in/${1:-}?format=3"; }
weatherfull() { curl -s "wttr.in/${1:-}"; }
cheat() { curl -s "cheat.sh/$1"; }
myip() { curl -s ifconfig.me; echo; }
sizeof() { du -sh "$@" 2>/dev/null; }
