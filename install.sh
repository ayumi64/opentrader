#!/usr/bin/env bash
# OpenBigA / OpenClaw Trader 一键安装
set -euo pipefail

PRODUCT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-${HOME}/.openclaw-trader}"
VERSION="$(cat "${PRODUCT_DIR}/VERSION")"
IMAGE="${TRADER_IMAGE:-openclaw-trader:${VERSION}}"

API_KEY=""
SIM_TOKEN=""
MX_KEY=""
CONFIG_FILE=""
FEISHU_ENABLE=""
FEISHU_APP_ID=""
FEISHU_APP_SECRET=""
FEISHU_GROUP=""
NON_INTERACTIVE=false

usage() {
  cat <<EOF
OpenBigA (OpenClaw Trader) v${VERSION}

用法:
  ./install.sh --api-key <KEY> --sim-token <TOKEN>
  ./install.sh --config config/install.env

可选飞书:
  --feishu --feishu-app-id ID --feishu-app-secret SECRET --feishu-group oc_xxx

配置目录（安装后）: \${INSTALL_DIR}/config/
  install.env      环境变量（从 install.env.example 复制）
  feishu.yaml      飞书（从 feishu.yaml.example 复制）
  trader.yaml      业务参数
  advanced.yaml    代理/备用模型等

EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --api-key) API_KEY="$2"; shift 2 ;;
    --sim-token) SIM_TOKEN="$2"; shift 2 ;;
    --mx-key) MX_KEY="$2"; shift 2 ;;
    --config) CONFIG_FILE="$2"; shift 2 ;;
    --install-dir) INSTALL_DIR="$2"; shift 2 ;;
    --feishu) FEISHU_ENABLE=true; shift ;;
    --feishu-app-id) FEISHU_APP_ID="$2"; shift 2 ;;
    --feishu-app-secret) FEISHU_APP_SECRET="$2"; shift 2 ;;
    --feishu-group) FEISHU_GROUP="$2"; shift 2 ;;
    -y|--yes) NON_INTERACTIVE=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "未知参数: $1"; usage; exit 1 ;;
  esac
done

if [ -n "${CONFIG_FILE}" ] && [ -f "${CONFIG_FILE}" ]; then
  set -a
  # shellcheck disable=SC1090
  source "${CONFIG_FILE}"
  set +a
  API_KEY="${API_KEY:-${DEEPSEEK_API_KEY:-}}"
  SIM_TOKEN="${SIM_TOKEN:-${SIM_TRADING_TOKEN:-}}"
  MX_KEY="${MX_KEY:-${MX_APIKEY:-}}"
  FEISHU_ENABLE="${FEISHU_ENABLE:-${FEISHU_ENABLED:-}}"
  FEISHU_APP_ID="${FEISHU_APP_ID:-${FEISHU_APP_ID:-}}"
  FEISHU_APP_SECRET="${FEISHU_APP_SECRET:-${FEISHU_APP_SECRET:-}}"
  FEISHU_GROUP="${FEISHU_GROUP:-${FEISHU_DELIVERY_GROUP_ID:-}}"
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "错误: 需要 Docker"
  exit 1
fi

if [ -z "${API_KEY}" ] && [ "${NON_INTERACTIVE}" = false ]; then
  read -r -p "API Key（DeepSeek 大模型）: " API_KEY
fi
if [ -z "${SIM_TOKEN}" ] && [ "${NON_INTERACTIVE}" = false ]; then
  read -r -p "模拟盘 Token: " SIM_TOKEN
fi
if [ -z "${API_KEY}" ] || [ -z "${SIM_TOKEN}" ]; then
  echo "错误: API Key 与模拟盘 Token 必填"
  exit 1
fi

[ -z "${MX_KEY}" ] && MX_KEY="${API_KEY}"

truthy() { case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in true|1|yes|on) return 0;; *) return 1;; esac; }

if [ "${NON_INTERACTIVE}" = false ] && [ -z "${FEISHU_ENABLE}" ]; then
  read -r -p "启用飞书推送？(y/N): " _fs
  [ "${_fs}" = "y" ] || [ "${_fs}" = "Y" ] && FEISHU_ENABLE=true
fi
if truthy "${FEISHU_ENABLE:-false}" || [ "${FEISHU_ENABLED:-false}" = "true" ]; then
  FEISHU_ENABLED=true
  if [ -z "${FEISHU_APP_ID}" ] && [ "${NON_INTERACTIVE}" = false ]; then
    read -r -p "飞书 App ID: " FEISHU_APP_ID
    read -r -p "飞书 App Secret: " FEISHU_APP_SECRET
    read -r -p "推送群 chat_id (oc_...): " FEISHU_GROUP
  fi
else
  FEISHU_ENABLED=false
fi

mkdir -p "${INSTALL_DIR}/data" "${INSTALL_DIR}/config"

# 首次安装：复制配置模板
for f in install.env feishu.yaml trader.yaml advanced.yaml; do
  if [ ! -f "${INSTALL_DIR}/config/${f}" ] && [ -f "${PRODUCT_DIR}/config/${f}.example" ]; then
    cp "${PRODUCT_DIR}/config/${f}.example" "${INSTALL_DIR}/config/${f}"
  fi
done

GATEWAY_TOKEN="${OPENCLAW_GATEWAY_TOKEN:-$(openssl rand -hex 24 2>/dev/null || python3 -c 'import secrets; print(secrets.token_hex(24))')}"

cat > "${INSTALL_DIR}/.env" <<EOF
DEEPSEEK_API_KEY=${API_KEY}
MX_APIKEY=${MX_KEY}
SIM_TRADING_TOKEN=${SIM_TOKEN}
OPENCLAW_HOME=${INSTALL_DIR}/data
OPENCLAW_GATEWAY_TOKEN=${GATEWAY_TOKEN}
OPENCLAW_CONFIG_DIR=${INSTALL_DIR}/config
GATEWAY_PORT=${GATEWAY_PORT:-18789}
TZ=Asia/Shanghai
TRADER_IMAGE=${IMAGE}
INSTALL_DIR=${INSTALL_DIR}
FEISHU_ENABLED=${FEISHU_ENABLED}
FEISHU_APP_ID=${FEISHU_APP_ID}
FEISHU_APP_SECRET=${FEISHU_APP_SECRET}
FEISHU_DELIVERY_GROUP_ID=${FEISHU_GROUP}
FEISHU_ACCOUNT_ID=${FEISHU_ACCOUNT_ID:-sonicteam}
EOF

# 写入 feishu.yaml
python3 "${PRODUCT_DIR}/scripts/patch-feishu-config.py" \
  "${INSTALL_DIR}/config/feishu.yaml" "${FEISHU_ENABLED}" "${FEISHU_GROUP}" "${FEISHU_APP_ID}" "${FEISHU_APP_SECRET}" \
  2>/dev/null || true

EXEC_DATA="${INSTALL_DIR}/data/workspace/domains/finance/workers/execution/data"
mkdir -p "${EXEC_DATA}"
python3 -c "
import json, pathlib
pathlib.Path('${EXEC_DATA}/sim-trading.json').write_text(json.dumps({
  'provider':'simulation','token':'${SIM_TOKEN}','account_type':'simulation','enabled':True
}, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
"

cp "${PRODUCT_DIR}/docker-compose.yml" "${INSTALL_DIR}/docker-compose.yml"

if [ "${SKIP_DOCKER_BUILD:-0}" != "1" ]; then
  export OPENCLAW_INSTALL_ROOT="${INSTALL_DIR}/data"
  (cd "${PRODUCT_DIR}" && bash scripts/build-image.sh)
fi

# 预渲染配置（宿主机）
pip3 install -q pyyaml 2>/dev/null || true
python3 "${PRODUCT_DIR}/scripts/render-config.py" "${INSTALL_DIR}" "${INSTALL_DIR}/config" || true

echo ""
echo "=============================================="
echo " OpenBigA 已安装: ${INSTALL_DIR}"
echo " 配置: ${INSTALL_DIR}/config/"
echo " 启动: cd ${INSTALL_DIR} && docker compose up -d"
echo " 飞书: ${FEISHU_ENABLED}  群: ${FEISHU_GROUP:-（未配置）}"
echo "=============================================="
