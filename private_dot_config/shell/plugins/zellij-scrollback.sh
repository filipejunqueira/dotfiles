######################################################################
#  Archive-on-clear for Zellij. User commands live in functions/:
#    clear  zhist  zhist-all  zhist-clean  zhist-clean-all  zhist-prune
######################################################################

typeset -g ZELLIJ_SCROLLBACK_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zellij"
_zj_sess="${ZELLIJ_SESSION_NAME:-default}"; _zj_sess="${_zj_sess//[^a-zA-Z0-9._-]/_}"
typeset -g ZELLIJ_SCROLLBACK_ARCHIVE="${ZELLIJ_SCROLLBACK_DIR}/scrollback-${_zj_sess}.log"
unset _zj_sess

typeset -g ZELLIJ_SCROLLBACK_WARN_BYTES=$((500 * 1024 * 1024))       # one session's file
typeset -g ZELLIJ_SCROLLBACK_WARN_TOTAL=$((2 * 1024 * 1024 * 1024))  # all logs combined

typeset -g _ZJ_DID_WORK=0
typeset -g _ZJ_WARNED=0

autoload -Uz add-zsh-hook
_zj_mark_work() {
  case "${1%% *}" in
    clear|c|zhist|zhist-all|zhist-clean|zhist-clean-all|zhist-prune|zcopy) ;;
    *) _ZJ_DID_WORK=1 ;;
  esac
}
add-zsh-hook preexec _zj_mark_work

_zj_housekeeping_check() {
  (( _ZJ_WARNED )) && return
  local files=( "$ZELLIJ_SCROLLBACK_DIR"/scrollback-*.log(N) )
  (( ${#files} )) || return
  local total=0 s
  while read -r s; do (( total += s )); done < <(stat -c%s "${files[@]}" 2>/dev/null)
  local cur=0
  [[ -f "$ZELLIJ_SCROLLBACK_ARCHIVE" ]] && cur=$(stat -c%s "$ZELLIJ_SCROLLBACK_ARCHIVE")

  if (( cur > ZELLIJ_SCROLLBACK_WARN_BYTES )); then
    print -u2 -- "⚠  this session's log is $(( cur/1048576 )) MB — run 'zhist-clean'."
    _ZJ_WARNED=1
  elif (( total > ZELLIJ_SCROLLBACK_WARN_TOTAL )); then
    print -u2 -- "⚠  scrollback logs total $(( total/1048576 )) MB across ${#files} files — run 'zhist-clean-all'."
    _ZJ_WARNED=1
  fi
}
