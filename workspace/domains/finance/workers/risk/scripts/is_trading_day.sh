#!/usr/bin/env bash
# 判断 A 股是否交易日（Asia/Shanghai）
# 用法: is_trading_day.sh [trading_calendar.txt]
# 输出: TRADING | HOLIDAY | WEEKEND
# 规则: 文件每行一个**休市日** YYYY-MM-DD；# 开头为注释。
#       周六/日 → WEEKEND；今日在休市列表 → HOLIDAY；其余周一至周五 → TRADING。
set -u
CAL="${1:-/Users/sonic/.openclaw/workspace/domains/finance/workers/risk/data/trading_calendar.txt}"
TODAY="$(TZ=Asia/Shanghai date +%Y-%m-%d)"
DOW="$(TZ=Asia/Shanghai date +%u)"  # 1=Mon .. 7=Sun

if [ "$DOW" -ge 6 ]; then
  echo "WEEKEND"
  exit 0
fi

if [ -f "$CAL" ] && grep -qx "$TODAY" "$CAL" 2>/dev/null; then
  echo "HOLIDAY"
  exit 0
fi

# 也匹配行内无注释的精确日期（跳过 # 行）
if [ -f "$CAL" ] && grep -v '^[[:space:]]*#' "$CAL" | grep -qx "$TODAY" 2>/dev/null; then
  echo "HOLIDAY"
  exit 0
fi

echo "TRADING"
