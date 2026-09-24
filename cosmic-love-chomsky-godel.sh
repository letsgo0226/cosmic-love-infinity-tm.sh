#!/bin/sh
command -v python3>/dev/null||exit 127
SELF=${SELF:-./cosmic-love-infinity-prime-godel-2kb.sh}
[ -f "$SELF" ]||exit 2
C=${CMD:-step}
case "$C" in step|rewind|s|r) :;;*) echo 'invalid grammar terminal' >&2;exit 3;;esac
O=$(ONCE=1 CMD="$C" sh "$SELF")||exit 4
printf '%s\n' "$O"|python3 -S -c 'import json,sys;o=json.load(sys.stdin);q=("CF","CR","CG","CE");z=all(o.get(x)is True for x in q);o["grammar"]="S -> STEP S | REWIND S | epsilon";o["terminal"]="REWIND" if o.get("rev") else "STEP";o["N_struct"]=1 if z else 0;o["H_struct"]=0 if z else None;o["zero_ambiguity"]=z;o["entropy_scope"]="finite internal derivation only";print(json.dumps(o,separators=(",",":")))'
