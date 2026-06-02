#!/usr/bin/env bash
# 将 risk gate 与 data 摘要同步到 strategy/inbox/
set -u
ROOT="/Users/sonic/.openclaw/workspace/domains/finance/workers"
mkdir -p "${ROOT}/strategy/inbox" "${ROOT}/strategy/data"
cp -f "${ROOT}/risk/data/trading_gate.json" "${ROOT}/strategy/inbox/" 2>/dev/null || true
cp -f "${ROOT}/risk/data/trading_calendar.txt" "${ROOT}/strategy/data/trading_calendar.txt" 2>/dev/null || true
latest_data="$(ls -t "${ROOT}/data/reports"/数据服务摘要_*.md 2>/dev/null | head -1)"
[ -n "$latest_data" ] && cp -f "$latest_data" "${ROOT}/strategy/inbox/" || true
echo "ok"
