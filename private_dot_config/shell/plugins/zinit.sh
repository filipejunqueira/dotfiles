######################################################################
#  ~/.config/shell/plugins/zinit.sh
#
#  Zinit plugin manager bootstrap + plugin declarations.
#  ZSH-SPECIFIC — not sourced by .bashrc.
######################################################################

# ── Bootstrap zinit (self-installing) ─────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || {
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}
source "$ZINIT_HOME/zinit.zsh"

# ── Personal functions dir ─────────────────────────────────────────
fpath=("$HOME/.config/shell/functions" $fpath)
autoload -Uz extract mkcd quack

# ── Core plugins ───────────────────────────────────────────────────
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-history-substring-search
zinit light MichaelAquilina/zsh-you-should-use

# ── OMZ snippets ───────────────────────────────────────────────────
zinit snippet OMZL::git.zsh
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# ── Style overrides ────────────────────────────────────────────────
ZSH_HIGHLIGHT_STYLES[comment]='fg=#a89984,bold'

# ── Rebuild compdefs after plugin load ────────────────────────────
