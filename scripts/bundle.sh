#!/usr/bin/env bash
# 在 openbigA 仓库根目录打 bundle（独立仓库，不依赖上级 monorepo）
set -euo pipefail

PRODUCT="$(cd "$(dirname "$0")/.." && pwd)"
BUNDLE="${PRODUCT}/bundle"
INSTALL_ROOT="${OPENCLAW_INSTALL_ROOT:-/data}"

echo "[bundle] PRODUCT=${PRODUCT} INSTALL_ROOT=${INSTALL_ROOT}"
rm -rf "${BUNDLE}"
mkdir -p "${BUNDLE}/workspace" "${BUNDLE}/data/skills" "${BUNDLE}/cron"

rsync -a "${PRODUCT}/workspace/" "${BUNDLE}/workspace/"
rsync -a "${PRODUCT}/data/skills/" "${BUNDLE}/data/skills/"
cp "${PRODUCT}/cron/jobs.trader.json" "${BUNDLE}/cron/jobs.product.json"

sed -i.bak "s|/Users/sonic/.openclaw|${INSTALL_ROOT}|g" "${BUNDLE}/cron/jobs.product.json" 2>/dev/null || \
  sed -i '' "s|/Users/sonic/.openclaw|${INSTALL_ROOT}|g" "${BUNDLE}/cron/jobs.product.json"
sed -i.bak 's|\${FEISHU_DELIVERY_GROUP_ID}|PLACEHOLDER_GROUP|g' "${BUNDLE}/cron/jobs.product.json" 2>/dev/null || \
  sed -i '' 's|\${FEISHU_DELIVERY_GROUP_ID}|PLACEHOLDER_GROUP|g' "${BUNDLE}/cron/jobs.product.json"
rm -f "${BUNDLE}/cron/jobs.product.json.bak"

cp "${PRODUCT}/config/openclaw.product.json.template" "${BUNDLE}/openclaw.json"

python3 <<PY
import json
from pathlib import Path
root = Path("${INSTALL_ROOT}")
agents_file = Path("${PRODUCT}/config/agents.finance.json")
bundle_oc = Path("${BUNDLE}/openclaw.json")
product = json.loads(bundle_oc.read_text())
if agents_file.is_file():
    product["agents"]["list"] = json.loads(agents_file.read_text())["list"]
for a in product["agents"]["list"]:
    for k in ("workspace", "agentDir"):
        if k in a and isinstance(a[k], str):
            a[k] = a[k].replace("/Users/sonic/.openclaw", str(root))
product["skills"]["load"]["extraDirs"] = [str(root / "data/skills/miaoxiang")]
bundle_oc.write_text(json.dumps(product, ensure_ascii=False, indent=2) + "\n")
Path("${BUNDLE}/openclaw.agents.json").write_text(
    json.dumps({"list": product["agents"]["list"]}, ensure_ascii=False, indent=2) + "\n"
)
print("[bundle] agents injected")
PY

echo "[bundle] done → ${BUNDLE}"
