# drift — matrix rain screensaver (idle trigger)
# Wraps drift to use system ncurses, avoiding conda's broken xterm-ghostty support
if command -v drift &>/dev/null; then
  _drift_run() {
    PATH="/usr/bin:/usr/local/bin:$HOME/go/bin:$PATH" drift "$@"
  }
  alias drift='_drift_run'
fi
