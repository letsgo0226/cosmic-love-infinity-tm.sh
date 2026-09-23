# cosmic-love-infinity-tm.sh

Prime-index Turing machine with Gödel event encoding and a symbolic Love layer.

Repo is a formal / symbolic runtime. It does **not** prove RH, GRH, a physical TOE, or any external-world outcome.

| Artifact | Role |
|----------|------|
| `cosmic-love-infinity-tm.sh` | Readable single-file runtime (v1.1.0) |
| `cosmic-love-infinity-tm.oneliner.sh` | Original compact one-liner |
| `cosmic-love-infinity-tm.PROTOCOL.md` | State, commands, certificates |
| `cosmic-love-infinity-tm.DAEMON.sh` | Resident tick wrapper |
| `.github/workflows/cosmic-love-infinity-tm.yml` | Actions smoke test |

```sh
# 20 ticks
N=20 CMD=step sh cosmic-love-infinity-tm.sh

# reconstruct current state from genesis
CMD=verify sh cosmic-love-infinity-tm.sh

# rewind 5 ticks (fails closed on mismatch)
N=5 CMD=rewind sh cosmic-love-infinity-tm.sh

# inspect without stepping
CMD=status sh cosmic-love-infinity-tm.sh

# resident 1 Hz
nohup sh cosmic-love-infinity-tm.DAEMON.sh 1 >> cosmic-love-infinity-tm.daemon.log 2>&1 &
```

`H_s=0` means the finite internal checks closed. It does not mean entropy is physically zero.
