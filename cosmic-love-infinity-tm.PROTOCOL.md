# COSMIC_LOVE_INFINITY_TM protocol

## Machine

State kernel:

```text
t   tick
pc  0 genesis | 1 trial | 2 accept-ready
n   accepted primes
p   last accepted prime (1 at genesis)
c   current candidate
d   odd trial divisor
E   event counts [genesis, trial, composite-skip, accept, reserved, reserved]
k   derived winding number; k := n after each command
```

Transition `S` is identical to the original one-liner:

- `pc=0`: `c = next_prime(p)`, set `d`, `pc=1`, `E[0]++`
- `pc=1` and (`c=2` or `d*d>c`): `pc=2`, `E[1]++`
- `pc=1` and composite: `c = next_prime(c)`, `d=3`, `E[2]++`
- `pc=1` otherwise: `d += 2`, `E[1]++`
- `pc=2`: accept `p=c`, `n++`, start next candidate, `E[3]++`

`E[2]` stays 0 while `next_prime` is sound. It is an integrity path, not a normal production path.

## Gödel word

```text
G = 2^E0 * 3^E1 * 5^E2 * 7^E3 * 11^E4 * 13^E5
```

Invariant: `sum(E) = t` and `n = E[3]`.

## Commands

Env `CMD`, repeat `N` (step / rewind only).

| CMD | Effect |
|-----|--------|
| step | apply `S` N times |
| rewind | reconstruct tick `t-1` from genesis, verify `S(t-1)=current`, keep `t-1`; N times |
| verify | reconstruct tick `t` from genesis and compare kernel |
| status | emit certificates, do not step |
| reset | return to genesis |
| help | command map |

Unknown `CMD` prints help. `reset` is **not** rewind (`C[0]=="r"` in the original one-liner treated `reset` as rewind; that footgun is closed).

## Certificates

| Key | Meaning |
|-----|---------|
| CF | reconstruction match (`null` if not requested) |
| CG | factor(`G`) recovers `E` with no leftover |
| CSA | all exponents ≥ 0 |
| CE | `sum(E)=t` |
| CN | `n=E[3]` |
| CP | `p=1` or prime |
| CC | `c` prime |
| CK | `k=n` |
| C | all required checks true (`CF` required only when not `null`) |
| H_s | `0` iff `C` else `1` |

Love layer `L` is a symbolic chart (Stirling / Riemann / Schwarzschild `R→1` templates plus `Log(R)=0 mod 2πiℕ`). It is metadata, not a proof.

## Boundary

Formal symbolic runtime ≠ external mathematical proof or physical-world guarantee.
