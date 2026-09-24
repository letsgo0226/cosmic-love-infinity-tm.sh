#!/bin/sh
command -v python3>/dev/null||exit 127
SELF=${SELF:-./cosmic-love-infinity-prime-godel-2kb.sh}
[ -f "$SELF" ]||exit 2
C=${CMD:-step}
case "$C" in step|rewind|s|r) :;;*) echo 'invalid grammar terminal' >&2;exit 3;;esac
O=$(ONCE=1 CMD="$C" sh "$SELF")||exit 4
printf '%s\n' "$O"|REQ="$C" python3 -S -c 'import json,os,sys;from cosmic_love_model_certificate import certificate;o=json.load(sys.stdin);o.update(certificate(o,os.environ["REQ"]));print(json.dumps(o,separators=(",",":")))'
