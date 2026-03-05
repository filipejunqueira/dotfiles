######################################################################
#  ~/.config/shell/path.sh
#
#  PATH construction. POSIX-compatible — sourced by both
#  ~/.zshrc and ~/.bashrc.
#  Add directories conditionally so missing paths don't clutter PATH.
#  Note: conda/mamba PATH is managed by the mamba init block in
#  ~/.zshrc directly — do not add miniforge3 here.
######################################################################

# ── XDG user binaries ──────────────────────────────────────────────
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# ── Rust / Cargo ───────────────────────────────────────────────────
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# ── Deduplicate PATH (zsh only) ────────────────────────────────────
# typeset -U tells zsh to treat `path` as a unique array — silently
# drops any entry that already appears earlier in the list.
[[ -n "$ZSH_VERSION" ]] && typeset -U path
