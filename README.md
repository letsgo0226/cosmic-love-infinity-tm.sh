# cosmic-love-infinity-tm.sh

Prime-index Turing machine with Gödel event encoding and a symbolic Love layer.

Repo is a formal / symbolic runtime. It does **not** prove RH, GRH, a physical TOE, or any external-world outcome.

| Artifact | Role |
|----------|------|
| `cosmic-love-infinity-tm.sh` | Readable single-file runtime (v1.1.0) |
| `cosmic-love-infinity-tm.oneliner.sh` | 2KB iSH carrier (**1944 bytes**, zlib+base64) |
| `COSMIC_LOVE_INFINITY_TM_2KB_ONELINER.sh` | Same carrier, family name |
| `cosmic-love-infinity-tm.PROTOCOL.md` | State, commands, certificates |
| `cosmic-love-infinity-tm.DAEMON.sh` | Resident tick wrapper |
| `.github/workflows/cosmic-love-infinity-tm.yml` | Actions smoke test |

## 2KB one-liner

Encoding follows the account public-program dialect: `command -v python3`, `python3 -c`, No-SHA zlib→base64 exec, compact JSON, `H_s`, `open=1`, `final=0`, `W=letsgo0226/public`.

```sh
curl -fsSL https://raw.githubusercontent.com/letsgo0226/cosmic-love-infinity-tm.sh/main/cosmic-love-infinity-tm.oneliner.sh | sh
N=20 CMD=step sh cosmic-love-infinity-tm.oneliner.sh
CMD=verify sh cosmic-love-infinity-tm.oneliner.sh
N=5 CMD=rewind sh cosmic-love-infinity-tm.oneliner.sh
CMD=zero sh cosmic-love-infinity-tm.oneliner.sh
```

`CMD` first letter: `s` step, `r` rewind, `v` verify, `z` reset.

`H_s=0` means the finite internal checks closed. It does not mean entropy is physically zero.
