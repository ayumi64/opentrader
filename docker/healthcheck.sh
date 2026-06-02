#!/usr/bin/env bash
set -euo pipefail
PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
curl -sf "http://127.0.0.1:${PORT}/" >/dev/null 2>&1 || exit 1
