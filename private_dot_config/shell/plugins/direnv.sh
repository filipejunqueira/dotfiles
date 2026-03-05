######################################################################
#  ~/.config/shell/plugins/direnv.sh
#  direnv — auto-loads .envrc files on directory entry. ZSH-SPECIFIC.
######################################################################

command -v direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
