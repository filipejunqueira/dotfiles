#!/usr/bin/env bash
# ── chill compile benchmark: time vs freq-cap, per mode ──────────────────────
# For every chill mode, sweep the CPU clock cap 1200→uncapped (200 MHz steps)
# and time a single-core compile and a parallel compile at each, recording
# wall-time + package energy. Run on AC. Designed to run for hours / overnight.
set -uo pipefail

# 0) keep the machine awake for the whole run (re-exec once under inhibit)
if [ -z "${CHILL_BENCH_INHIBITED:-}" ] && command -v systemd-inhibit >/dev/null; then
    export CHILL_BENCH_INHIBITED=1
    exec systemd-inhibit --what=idle:sleep:handle-lid-switch --why="chill overnight bench" -- "$0" "$@"
fi

CPUFREQ=/sys/devices/system/cpu/cpu0/cpufreq
CHILL="$(command -v chill 2>/dev/null || echo "$HOME/.local/bin/chill")"
CC="$(command -v cc 2>/dev/null || command -v gcc 2>/dev/null || true)"
[ -d "$CPUFREQ" ] || { echo "❌ no cpufreq sysfs"; exit 1; }
[ -x "$CHILL" ]   || { echo "❌ chill not found at $CHILL"; exit 1; }
[ -n "$CC" ]      || { echo "❌ no C compiler (sudo pacman -S gcc)"; exit 1; }
sudo -v || { echo "❌ sudo needed"; exit 1; }

# perf RAPL is OPTIONAL: it only adds the energy (Joules) column. The headline
# metric (compile wall-time) is measured with `date` regardless. Probe the event
# directly rather than trusting `perf list`, which doesn't always enumerate it.
PERF_OK=0
if command -v perf >/dev/null && sudo perf stat -a -e power/energy-pkg/ -- sleep 0.3 2>&1 | grep -q 'Joules'; then
    PERF_OK=1
else
    echo "  ⚠ perf RAPL unavailable — recording compile TIME only, energy column = '-'."
    echo "    (optional: sudo pacman -S perf, then rerun, to also get Joules)"
fi

LOG="$HOME/chill-bench-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee "$LOG") 2>&1
echo "=== chill compile benchmark — $(date) — run on AC, leave idle ==="

# sudo keepalive + cleanup
( while true; do sudo -n true 2>/dev/null; sleep 50; done ) & KA=$!
WORK="$(mktemp -d)"
cleanup(){ kill "$KA" 2>/dev/null; rm -rf "$WORK"; }
trap cleanup EXIT

# ── tunables ─────────────────────────────────────────────────────────────────
SETTLE=30           # seconds to stabilise after each config (your 30s)
MODE_SETTLE=30      # extra settle when switching modes
NFUNC=1000; NSTMT=18            # single.c size (single-core compile weight)
MFILES=$(( $(nproc) * 2 )); MFUNC=300   # parallel corpus (multi-core compile)
MODES="palpatine malinois samwise johnwick letitgo treebeard cp3o"
CAPS=""; for c in $(seq 1200 200 5000); do CAPS="$CAPS $c"; done; CAPS="$CAPS max"

# ── generate workloads once ──────────────────────────────────────────────────
echo "  generating compile corpus in $WORK ..."
awk -v NF=$NFUNC -v NS=$NSTMT 'BEGIN{for(i=0;i<NF;i++){printf "long f%d(long x){\n",i;for(j=0;j<NS;j++)printf " x=(x*%d+%d)^(x>>%d)+(x<<%d);\n",(j%7+3),(i+j),(j%5+1),(j%3+1);printf " return x;\n}\n"}}' > "$WORK/single.c"
for k in $(seq 0 $((MFILES-1))); do
    awk -v NF=$MFUNC -v NS=$NSTMT -v b=$k 'BEGIN{for(i=0;i<NF;i++){printf "long g%d_%d(long x){\n",b,i;for(j=0;j<NS;j++)printf " x=(x*%d+%d)^(x>>%d);\n",(j%7+3),(i+j),(j%5+1);printf " return x;\n}\n"}}' > "$WORK/p$(printf '%03d' $k).c"
done

SINGLE_CMD="$CC -O2 -c $WORK/single.c -o /dev/null"
MULTI_CMD="ls $WORK/p*.c | xargs -P $(nproc) -I{} $CC -O2 -c {} -o /dev/null"

tctl(){ sensors 2>/dev/null | sed -n 's/.*Tctl:[^0-9-]*\([0-9.]*\).*/\1/p' | head -1; }
# run cmd under perf; echo "secs joules"
# run cmd; echo "secs joules"  (joules = "-" when perf RAPL is unavailable)
timed(){
    if [ "$PERF_OK" = 1 ]; then
        sudo perf stat -a -e power/energy-pkg/ -- bash -c "$1" 2>&1 \
            | awk '/Joules/{gsub(/,/,"",$1);j=$1}/seconds time elapsed/{t=$1}END{printf "%s %s",t,(j==""?"-":j)}'
    else
        local t0 t1; t0=$(date +%s.%N); bash -c "$1" >/dev/null 2>&1; t1=$(date +%s.%N)
        awk -v a="$t0" -v b="$t1" 'BEGIN{printf "%.3f -", b-a}'
    fi
}

# ── calibration + ETA ────────────────────────────────────────────────────────
echo "=== calibration (uncapped) ==="
"$CHILL" palpatine -c max >/dev/null 2>&1; sleep 5
read cs cj < <(timed "$SINGLE_CMD")
read cm cmj < <(timed "$MULTI_CMD")
ncfg=$(( $(echo $MODES|wc -w) * $(echo $CAPS|wc -w) ))
eta=$(awk -v n=$ncfg -v s="$cs" -v m="$cm" -v set=$SETTLE 'BEGIN{printf "%.1f", n*(set+2*(s+m)+5)/3600}')
echo "  single=${cs}s  multi=${cm}s  | configs=$ncfg  rough ETA ~${eta}h (low caps run longer)"
echo "  starting in 20s — Ctrl-C to abort and retune NFUNC/MFUNC ..."; sleep 20

# ── sweep ────────────────────────────────────────────────────────────────────
printf "  %-10s %-5s %-9s %-9s %-9s %-9s %s\n" "MODE" "CAP" "single_s" "multi_s" "single_J" "multi_J" "Tctl(pre>post)"
for mode in $MODES; do
    echo "############ MODE: $mode  $(date +%H:%M:%S) ############"
    first=1
    for cap in $CAPS; do
        "$CHILL" "$mode" -c "$cap" >/dev/null 2>&1
        [ "$first" = 1 ] && { sleep "$MODE_SETTLE"; first=0; }
        sleep "$SETTLE"
        tp=$(tctl)
        read ss sj < <(timed "$SINGLE_CMD")
        read ms mj < <(timed "$MULTI_CMD")
        tq=$(tctl)
        printf "  %-10s %-5s %-9s %-9s %-9s %-9s %s>%s\n" "$mode" "$cap" "$ss" "$ms" "$sj" "$mj" "${tp:-?}" "${tq:-?}"
    done
done

"$CHILL" samwise >/dev/null 2>&1
echo "=== DONE $(date) — ended in Samwise. Upload: $LOG ==="
