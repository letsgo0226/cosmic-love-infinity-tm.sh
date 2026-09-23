#!/usr/bin/env bash
# COSMIC_LOVE_INFINITY_TM resident loop
set -u
HZ="${1:-${CLI_HZ:-1}}"
LOG="${CLI_LOG:-cosmic-love-infinity-tm.daemon.log}"
DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || pwd)"
SCRIPT="${CLI_SCRIPT:-$DIR/cosmic-love-infinity-tm.sh}"
RAW_URL="https://raw.githubusercontent.com/letsgo0226/cosmic-love-infinity-tm.sh/main/cosmic-love-infinity-tm.sh"
WORKDIR="${CLI_WORKDIR:-$DIR/run}"
mkdir -p "$WORKDIR"
if [[ ! -f "$SCRIPT" ]]; then
  command -v curl >/dev/null || exit 127
  SCRIPT="${TMPDIR:-/tmp}/cosmic-love-infinity-tm.sh"
  curl -fsSL "$RAW_URL" -o "$SCRIPT" || exit 1
fi
command -v python3 >/dev/null || exit 127
python3 -c "import time; assert float('$HZ')>0"
echo "{\"daemon\":\"COSMIC_LOVE_INFINITY_TM\",\"hz\":$HZ,\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" | tee -a "$LOG"
while true; do
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  line=$(cd "$WORKDIR" && N=1 CMD=step sh "$SCRIPT" 2>>"$LOG") || {
    echo "{\"ts\":\"$TS\",\"status\":\"run_fail\"}" >>"$LOG"
    sleep 1
    continue
  }
  echo "$line" >>"$LOG.ticks"
  if python3 - "$WORKDIR/state.json" "$line" <<'PY'
import json, sys
try:
    tick = json.loads(sys.argv[2])
    o = json.load(open(sys.argv[1]))
except Exception:
    raise SystemExit(2)
ok = (
    o.get("model") == "COSMIC_LOVE_INFINITY_TM"
    and tick.get("model") == "COSMIC_LOVE_INFINITY_TM"
    and tick.get("H_s") == 0
    and tick.get("C") is True
    and tick.get("t") == o.get("t")
    and isinstance(o.get("t"), int) and o.get("t") >= 1
)
raise SystemExit(0 if ok else 2)
PY
  then echo "{\"ts\":\"$TS\",\"status\":\"pass\",\"t\":$(python3 -c 'import json,sys;print(json.loads(sys.argv[1])["t"])' "$line")}" >>"$LOG"
  else echo "{\"ts\":\"$TS\",\"status\":\"assert_fail\",\"tick\":$line}" >>"$LOG"
  fi
  python3 -c "import time; time.sleep(1/float('$HZ'))"
done
