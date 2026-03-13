######################################################################
#  ~/.config/shell/exports.sh
#
#  Environment variables. POSIX-compatible — sourced by both
#  ~/.zshrc and ~/.bashrc.
#  No secrets here. Secrets go in local.sh via pass (Phase 11b).
######################################################################

# ── XDG base directories ───────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"   # was missing from original
# ── XDG overrides (Phase 9) ────────────────────────────────────────
export HISTFILE="${XDG_STATE_HOME}/bash/history"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"

# ── Default applications ───────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export READER="zathura"

# ── Locale ─────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"

# ── Wine ───────────────────────────────────────────────────────────
export WINEARCH=win32              # 32-bit prefix for .wine/ (Vernissage)

# ── Git credential manager ─────────────────────────────────────────

# ── Bibliography ───────────────────────────────────────────────────
export BIB="$HOME/research/bibliography/bibliography.bib"

# ── Conda / Mamba ──────────────────────────────────────────────────
export CONDA_CHANGEPS1=false       # starship handles the prompt

# ── Coloured man pages ─────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

# ── Secrets (NOT here — handled via pass in local.sh, Phase 11b) ───
# BRAVE_API_KEY        → pass show brave/api-key
# GDRIVE CLIENT_ID     → pass show gdrive/client-id
# GDRIVE CLIENT_SECRET → pass show gdrive/client-secret
