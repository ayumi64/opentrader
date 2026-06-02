#!/usr/bin/env bash
set -u
ROOT="/Users/sonic/.openclaw/workspace/domains/finance/workers"
EXEC="${ROOT}/execution"
mkdir -p "${EXEC}/inbox" "${EXEC}/data"
cp -f "${ROOT}/risk/data/trading_gate.json" "${EXEC}/inbox/" 2>/dev/null || true
cp -f "${ROOT}/risk/data/RISK-LIMITS.json" "${EXEC}/data/RISK-LIMITS.json" 2>/dev/null || true
latest="$(ls -t "${ROOT}/strategy/signals"/信号_*.json 2>/dev/null | head -1)"
[ -n "$latest" ] && cp -f "$latest" "${EXEC}/inbox/" || true
echo "signal=${latest:-none}"
