#!/usr/bin/env bash
# 将 Worker 风控/组合数据同步到 trader/inbox/（workspaceOnly 可读）
set -u
TRADER="/Users/sonic/.openclaw/workspace/trader"
RISK="/Users/sonic/.openclaw/workspace/domains/finance/workers/risk"
DATA="/Users/sonic/.openclaw/workspace/domains/finance/workers/data"
STRAT="/Users/sonic/.openclaw/workspace/domains/finance/workers/strategy"
mkdir -p "${TRADER}/inbox"

for f in trading_gate.json portfolio_snapshot.json orders_pending.json RISK-LIMITS.json trading_calendar.txt; do
  [ -f "${RISK}/data/${f}" ] && cp -f "${RISK}/data/${f}" "${TRADER}/inbox/" 2>/dev/null || true
  [ -f "${RISK}/data/${f}" ] && cp -f "${RISK}/data/${f}" "${TRADER}/data/" 2>/dev/null || true
done

latest_data="$(ls -t "${DATA}/reports"/数据服务摘要_*.md 2>/dev/null | head -1)"
[ -n "$latest_data" ] && cp -f "$latest_data" "${TRADER}/inbox/" || true

latest_pool="$(ls -t "${STRAT}/pool"/*_候选池.md 2>/dev/null | head -1)"
[ -n "$latest_pool" ] && cp -f "$latest_pool" "${TRADER}/inbox/" || true

echo "inbox=$(ls "${TRADER}/inbox" 2>/dev/null | wc -l | tr -d ' ')"
