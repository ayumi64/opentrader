#!/usr/bin/env bash
set -euo pipefail

DATA="${OPENCLAW_HOME:-/data}"
mkdir -p "${DATA}/agents" "${DATA}/cron" "${DATA}/logs" "${DATA}/workspace"

if [ ! -f "${DATA}/.initialized" ]; then
  echo "[entrypoint] initializing ${DATA} ..."
  cp -rn /app/workspace/* "${DATA}/workspace/" 2>/dev/null || true
  cp -rn /app/data/skills "${DATA}/data/" 2>/dev/null || true
  cp -f /app/cron/jobs.json "${DATA}/cron/jobs.json"
  cp -f /app/openclaw.agents.json "${DATA}/openclaw.agents.json" 2>/dev/null || true
  touch "${DATA}/.initialized"
fi

if [ -f "${DATA}/.env" ]; then
  set -a
  # shellcheck disable=SC1090
  source "${DATA}/.env"
  set +a
elif [ -f "/config/../.env" ]; then
  :
fi

: "${DEEPSEEK_API_KEY:?DEEPSEEK_API_KEY is required}"
: "${SIM_TRADING_TOKEN:?SIM_TRADING_TOKEN is required}"
export MX_APIKEY="${MX_APIKEY:-}"

CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-/config}"
INSTALL_ROOT="$(dirname "${DATA}")"
if [ -d "${CONFIG_DIR}" ] && [ -f /app/scripts/render-config.py ]; then
  python3 /app/scripts/render-config.py "${INSTALL_ROOT}" "${CONFIG_DIR}" || true
fi

if [ ! -f "${DATA}/openclaw.json" ]; then
  cp -f /app/openclaw.json "${DATA}/openclaw.json"
fi

exec openclaw gateway --port "${OPENCLAW_GATEWAY_PORT:-18789}" --bind 0.0.0.0
