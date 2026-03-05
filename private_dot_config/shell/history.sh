######################################################################
#  ~/.config/shell/history.sh
#
#  History file location and size limits.
#  POSIX-compatible — sourced by both ~/.zshrc and ~/.bashrc.
#  Note: history *behaviour* (appendhistory, histignorespace, etc.)
#  lives in options.sh — this file is just the file/size settings.
######################################################################

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
