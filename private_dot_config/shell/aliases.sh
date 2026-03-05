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

# ── File operations ────────────────────────────────────────────────
alias cp="cp -iv"
alias mv="mv -vi"
alias rm="rm -vI"
alias mkd="mkdir -pv"
alias ll='ls -alF'
alias la='ls -A'
alias ls="lsd -h --color=auto --group-dirs=first"

# ── Editors & viewers ──────────────────────────────────────────────
alias v="nvim"
alias za="zathura"
alias p="pdftk"
alias ccat="highlight --out-format=ansi"
alias cats="highlight -O ansi --force"
# bat binary is already named bat on Arch — no alias needed

# ── Git ────────────────────────────────────────────────────────────
alias g="git"

# ── System ─────────────────────────────────────────────────────────
alias c="clear"
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

# ── Navigation ─────────────────────────────────────────────────────
alias phd="cd ~/research/phd-thesis/"

# ── Discarded from old config ──────────────────────────────────────
# fd="cd"     → shadowed fd-find binary
# j="autojump"→ replaced by zoxide (use z)
# bat="batcat"→ Arch binary is already bat
# pipd=...    → absolute path to conda env on different machine
# dft=...     → desktop-only, goes in local.sh
