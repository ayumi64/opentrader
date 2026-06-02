#!/usr/bin/env bash
# 在 workspaceOnly 下将投研/新闻产出同步到 risk/inbox/ 供 read
set -u
ROOT="/Users/sonic/.openclaw/workspace/domains/finance/workers"
RISK="${ROOT}/risk"
INBOX="${RISK}/inbox"
mkdir -p "${INBOX}/plans" "${INBOX}/news"

# 最新调仓方案（1 份）
latest_plan="$(ls -t "${ROOT}/strategy/reports"/调仓交易方案_*.md 2>/dev/null | head -1)"
if [ -n "$latest_plan" ]; then
  cp "$latest_plan" "${INBOX}/plans/"
fi

# 今日紧急新闻报告（最多 2 份）
today="$(TZ=Asia/Shanghai date +%Y-%m-%d)"
find "${ROOT}/data/reports" -maxdepth 1 -name "紧急新闻监控报告_${today}_*.md" 2>/dev/null | head -2 | while read -r f; do
  cp "$f" "${INBOX}/news/"
done

# 最新数据服务摘要（1 份，供 risk 读舆情）
latest_data="$(ls -t "${ROOT}/data/reports"/数据服务摘要_*.md 2>/dev/null | head -1)"
[ -n "$latest_data" ] && cp -f "$latest_data" "${INBOX}/news/" || true

echo "plan=$(ls "${INBOX}/plans" 2>/dev/null | wc -l | tr -d ' ')"
echo "news=$(ls "${INBOX}/news" 2>/dev/null | wc -l | tr -d ' ')"
