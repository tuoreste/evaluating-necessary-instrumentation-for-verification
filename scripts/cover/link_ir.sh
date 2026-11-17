#!/usr/bin/env bash
set -euo pipefail #stop on shell errors and missing variables.

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd) # 0 is at path used to start link_ir.sh

exec python3 "$SCRIPT_DIR/link_ir.py" "$@" # $@forwards the arguments unchanged tp py