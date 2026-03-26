# atuin — shell history database (replaces fzf Ctrl-R)
# Sourced AFTER fzf.sh so atuin wins the Ctrl-R binding.
# fzf retains Ctrl-T (files) and Alt-C (directories).
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
