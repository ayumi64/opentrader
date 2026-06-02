#!/usr/bin/env bash
# 从 OpenClaw 开发仓库同步源码到 opentrader 独立仓库（维护者执行，推送前运行）
set -euo pipefail

MONO="${OPENCLAW_MONO:-$(cd "$(dirname "$0")/../../.." && pwd)}"
PRODUCT="$(cd "$(dirname "$0")/.." && pwd)"

echo "[sync-source] mono=${MONO} → product=${PRODUCT}"

RSYNC_EX=(
  --exclude 'mx-output/'
  --exclude 'reports/'
  --exclude '紧急新闻监控报告/'
  --exclude '系统检查报告/'
  --exclude 'logs/'
  --exclude 'inbox/'
  --exclude 'repos/'
  --exclude 'allure-report/'
  --exclude '.pytest_cache/'
  --exclude 'ChatGPT每日三问/'
  --exclude 'wechat_publish_system/'
  --exclude 'publishing/'
  --exclude '*.pyc'
  --exclude '.git/'
)

mkdir -p "${PRODUCT}/workspace/trader" "${PRODUCT}/workspace/domains/finance" "${PRODUCT}/data/skills"

rsync -a "${RSYNC_EX[@]}" --delete \
  "${MONO}/workspace/trader/" "${PRODUCT}/workspace/trader/"

rsync -a "${RSYNC_EX[@]}" \
  "${MONO}/workspace/domains/finance/" "${PRODUCT}/workspace/domains/finance/"

rsync -a --delete \
  "${MONO}/data/skills/miaoxiang/" "${PRODUCT}/data/skills/miaoxiang/"

# 保留目录占位
for d in \
  "${PRODUCT}/workspace/trader/reports/daily" \
  "${PRODUCT}/workspace/trader/data/mx-output" \
  "${PRODUCT}/workspace/domains/finance/workers/data/reports"; do
  mkdir -p "$d"
  touch "$d/.gitkeep"
done

# Cron：仅 finance + trader
mkdir -p "${PRODUCT}/cron"
python3 <<PY
import json
from pathlib import Path
src = Path("${MONO}/cron/jobs.json")
dst = Path("${PRODUCT}/cron/jobs.trader.json")
keep = {"trader","finance-data","finance-strategy","finance-risk","finance-execution","finance-content"}
data = json.loads(src.read_text())
data["jobs"] = [j for j in data["jobs"] if j.get("agentId") in keep]
# 占位群 ID，安装时 render-config 替换
for j in data["jobs"]:
    d = j.get("delivery") or {}
    if d.get("mode") == "announce" and d.get("channel") == "feishu":
        d["to"] = "group:\${FEISHU_DELIVERY_GROUP_ID}"
        j["delivery"] = d
dst.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
print("[sync-source] cron →", dst)
PY

# openclaw agents 片段供 bundle 注入
python3 <<PY
import json
from pathlib import Path
mono = Path("${MONO}/openclaw.json")
out = Path("${PRODUCT}/config/agents.finance.json")
main = json.loads(mono.read_text())
keep = {"trader","finance-data","finance-strategy","finance-risk","finance-execution","finance-content"}
agents = [a for a in main.get("agents",{}).get("list",[]) if a.get("id") in keep]
out.write_text(json.dumps({"list": agents}, ensure_ascii=False, indent=2) + "\n")
print("[sync-source] agents →", out)
PY

echo "[sync-source] done"
