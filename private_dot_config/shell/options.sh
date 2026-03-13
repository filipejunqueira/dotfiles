######################################################################
#  ~/.config/shell/options.sh
#
#  Z-shell behaviour toggles.
#  Sourced by ~/.zshrc (skipped by .bashrc — zsh-specific syntax).
######################################################################

setopt correct                    # Auto-correct mistyped commands
setopt extendedglob               # Advanced globbing (foo/**/*~*.py)
setopt nocaseglob                 # Case-insensitive globbing
setopt rcexpandparam              # rc-style array expansion
setopt nocheckjobs                # Don't warn about bg jobs on exit
setopt numericglobsort            # Sort files "1 2 10", not "1 10 2"
setopt nobeep                     # Shh!
setopt appendhistory              # Don't overwrite history file
setopt histignorealldups          # Drop older duplicate commands
setopt autocd                     # Typing a dir name == cd into it
setopt inc_append_history         # Write history immediately
setopt histignorespace            # Cmds starting with space not saved
setopt interactivecomments        # Allows for # while on the terminal (not inside a script file)
