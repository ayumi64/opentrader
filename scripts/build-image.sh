#!/usr/bin/env bash
set -euo pipefail
PRODUCT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(cat "${PRODUCT}/VERSION")"
IMAGE="${TRADER_IMAGE:-openclaw-trader:${VERSION}}"

export OPENCLAW_INSTALL_ROOT=/data
bash "${PRODUCT}/scripts/bundle.sh"

docker build \
  -f "${PRODUCT}/docker/Dockerfile" \
  -t "${IMAGE}" \
  "${PRODUCT}"

echo "[build] OK: ${IMAGE}"
