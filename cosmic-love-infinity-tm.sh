#!/bin/sh
# COSMIC_LOVE_INFINITY_TM
# Formal prime-index Turing machine with Godel event encoding.
# Bound: symbolic/computational certificate only. Not RH/TOE/physical claim.
command -v python3 >/dev/null || exit 127
python3 - "$@" <<'PY'
import json, math, os, sys

MODEL = "COSMIC_LOVE_INFINITY_TM"
VER = "1.1.0"
P = (2, 3, 5, 7, 11, 13)
Z = {"t": 0, "pc": 0, "n": 0, "p": 1, "c": 2, "d": 2, "E": [0, 0, 0, 0, 0, 0], "k": 0}

def is_prime(q):
    if q < 2:
        return False
    if q == 2:
        return True
    if q % 2 == 0:
        return False
    r = math.isqrt(q)
    d = 3
    while d <= r:
        if q % d == 0:
            return False
        d += 2
    return True

def next_prime(p):
    q = p + 1
    span = 16
    while True:
        lim = q + span
        while q < lim:
            if is_prime(q):
                return q
            q += 1
        span = min(span * 2, 1000000)

def core(o):
    return {k: o[k] for k in Z}

def dumps_core(o):
    return json.dumps(core(o), sort_keys=True, separators=(",", ":"))

def step(o):
    c, d = o["c"], o["d"]
    o["t"] += 1
    if o["pc"] == 0:
        o["c"] = next_prime(o["p"])
        o["d"] = 2 if o["c"] < 4 else 3
        o["pc"] = 1
        e = 0
    elif o["pc"] == 1:
        if c == 2 or d * d > c:
            o["pc"] = 2
            e = 1
        elif c % 2 == 0 or c % d == 0:
            o["c"] = next_prime(c)
            o["d"] = 3
            e = 2
        else:
            o["d"] = d + 2
            e = 1
    else:
        o["n"] += 1
        o["p"] = c
        o["c"] = next_prime(c)
        o["d"] = 2 if o["c"] < 4 else 3
        o["pc"] = 1
        e = 3
    o["E"][e] += 1
    return o

def replay(t):
    q = json.loads(json.dumps(Z))
    for _ in range(t):
        step(q)
    return q

def coerce(raw):
    o = {}
    for k, v in Z.items():
        x = raw.get(k, v)
        if k == "E":
            if not isinstance(x, list):
                x = list(v)
            x = [int(e) for e in x[:6]]
            if len(x) < 6:
                x = x + [0] * (6 - len(x))
            o[k] = x
        else:
            try:
                o[k] = int(x)
            except (TypeError, ValueError):
                o[k] = v
    return o

def load_state(path):
    if not (os.path.exists(path) and os.path.getsize(path)):
        return json.loads(json.dumps(Z)), None
    try:
        raw = json.load(open(path))
        if not isinstance(raw, dict):
            return json.loads(json.dumps(Z)), "NON_OBJECT_STATE"
        return coerce(raw), None
    except Exception as ex:
        return json.loads(json.dumps(Z)), type(ex).__name__

def godel(E):
    G = math.prod(p ** e for p, e in zip(P, E))
    x = G
    D = []
    for p in P:
        e = 0
        while x % p == 0:
            e += 1
            x //= p
        D.append(e)
    return G, D == list(E) and x == 1

def love(o, E):
    return {
        "V": [o[k] for k in ("t", "pc", "n", "p", "c", "d")] + list(E) + [o["k"]],
        "G": "*".join(f"{p}^{e}" for p, e in zip(P, E)),
        "log": "+".join(f"{e}*log({p})" for p, e in zip(P, E)),
        "AC": "L->L+2piik",
        "eq": "A=B<=>R=1<=>Log(R)=0 mod 2pi i Z",
        "Q": {
            "stirling": "u=1/n,R=Gamma(1/u)/(sqrt(2pi)*(1/u)**(1/u-0.5)*exp(-1/u)),lim=1",
            "riemann": "u=s-1,R=u*zeta(1+u),lim=1",
            "schwarz": "u=rho=1-rs/r,R=rho*g_rr,lim=1",
        },
    }

def certificates(o, CF):
    E = o["E"]
    G, CG = godel(E)
    CSA = all(e >= 0 for e in E)
    CE = sum(E) == o["t"]
    CN = o["n"] == E[3]
    CP = o["p"] == 1 or is_prime(o["p"])
    CC = is_prime(o["c"])
    CK = o["k"] == o["n"]
    C = (CF is not False) and CG and CSA and CE and CN and CP and CC and CK
    return {
        "G": G,
        "CF": CF,
        "CG": CG,
        "CSA": CSA,
        "CE": CE,
        "CN": CN,
        "CP": CP,
        "CC": CC,
        "CK": CK,
        "C": C,
        "H_s": 0 if C else 1,
    }

def atomic_write(path, obj):
    tmp = path + ".tmp"
    data = json.dumps(obj, separators=(",", ":"))
    with open(tmp, "w") as fh:
        fh.write(data)
        fh.flush()
        os.fsync(fh.fileno())
    os.replace(tmp, path)

def parse_cmd(raw):
    c = (raw or "step").strip().lower()
    if c in ("s", "step", "tick"):
        return "step"
    if c in ("r", "rw", "rewind", "recon"):
        return "rewind"
    if c in ("v", "verify", "check"):
        return "verify"
    if c in ("status", "stat", "show"):
        return "status"
    if c in ("reset", "genesis", "zero"):
        return "reset"
    if c in ("help", "-h", "--help"):
        return "help"
    return "help"

def help_text():
    return {
        "model": MODEL,
        "ver": VER,
        "cmds": ["step", "rewind", "verify", "status", "reset"],
        "env": {
            "LOG_TM_STATE": "state json path (default state.json)",
            "CMD": "step|rewind|verify|status|reset",
            "N": "repeat count for step/rewind (default 1, max 100000)",
        },
        "E": {
            "0": "genesis pc=0",
            "1": "trial / confirm-prime",
            "2": "composite skip (integrity path)",
            "3": "accept prime",
            "4": "reserved",
            "5": "reserved",
        },
        "bound": "formal certificate only; not RH/TOE/physical claim",
    }

def main():
    path = os.getenv("LOG_TM_STATE", "state.json")
    cmd = parse_cmd(os.getenv("CMD", "step"))
    try:
        N = int(os.getenv("N", "1"))
    except ValueError:
        N = 1
    N = max(0, min(N, 100000))
    if cmd == "help":
        print(json.dumps(help_text(), separators=(",", ":")))
        return 0
    o, load_err = load_state(path)
    CF = None
    if cmd == "reset":
        o = json.loads(json.dumps(Z))
        CF = True
    elif cmd == "status":
        pass
    elif cmd == "verify":
        v = replay(o["t"])
        CF = dumps_core({**v, "k": 0}) == dumps_core({**o, "k": 0})
        if not CF:
            print("RECONSTRUCTION_FAILURE", file=sys.stderr)
            o["k"] = o["n"]
            cert = certificates(o, False)
            L = love(o, o["E"])
            print(json.dumps({
                "model": MODEL, "ver": VER, "t": o["t"], "n": o["n"], "p": o["p"],
                "E": o["E"], **cert, "load_err": load_err, "L": L
            }, separators=(",", ":")))
            return 2
    elif cmd == "rewind":
        for _ in range(N):
            if o["t"] == 0:
                break
            prev = replay(o["t"] - 1)
            nxt = json.loads(json.dumps(prev))
            step(nxt)
            CF = dumps_core({**nxt, "k": 0}) == dumps_core({**o, "k": 0})
            if not CF:
                raise SystemExit("RECONSTRUCTION_FAILURE")
            o = prev
    else:
        if N == 0:
            N = 1
        for _ in range(N):
            step(o)
    o["k"] = o["n"]
    cert = certificates(o, CF)
    L = love(o, o["E"])
    stored = dict(o)
    stored["model"] = MODEL
    stored["ver"] = VER
    stored["L"] = L
    stored["H_s"] = cert["H_s"]
    if load_err:
        stored["load_err"] = load_err
    atomic_write(path, stored)
    out = {
        "model": MODEL,
        "ver": VER,
        "cmd": cmd,
        "t": o["t"],
        "pc": o["pc"],
        "n": o["n"],
        "p": o["p"],
        "c": o["c"],
        "d": o["d"],
        "k": o["k"],
        "E": o["E"],
        **cert,
        "L": L,
    }
    if load_err:
        out["load_err"] = load_err
    print(json.dumps(out, separators=(",", ":")))
    return 0 if cert["C"] else 1

if __name__ == "__main__":
    raise SystemExit(main())
PY
