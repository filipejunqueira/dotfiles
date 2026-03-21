# drift — terminal screensaver (idle trigger via TMOUT/TRAPALRM)
# Uses drift's native shell-init with PATH protection for conda ncurses
# Absolute path handles Distrobox $HOME mismatch
_drift_bin="/home/filipejunqueira/go/bin/drift"

if (( $+commands[drift] )) || [[ -x "$_drift_bin" ]]; then

  _drift_activate() {
    [[ -z "${DRIFT_ENABLED}" ]] && return
    [[ -n "${DRIFT_RUNNING}" ]] && return
    export DRIFT_RUNNING=1
    PATH="/usr/bin:/usr/local/bin:/home/filipejunqueira/go/bin:$PATH" command drift
    unset DRIFT_RUNNING
  }

  # Idle timer — fires TRAPALRM after DRIFT_TIMEOUT seconds of inactivity
  TMOUT="${DRIFT_TIMEOUT:-120}"
  TRAPALRM() {
    _drift_activate
  }
  export DRIFT_ENABLED=1

  # Manual trigger (uses command to avoid alias recursion)
  drift-now() {
    PATH="/usr/bin:/usr/local/bin:/home/filipejunqueira/go/bin:$PATH" command drift "$@"
  }
fi

unset _drift_bin
