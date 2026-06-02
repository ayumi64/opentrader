# 金融域 Runbook · 五层量化

手册：[`shared/A-SHARE-PLAYBOOK.md`](shared/A-SHARE-PLAYBOOK.md)

## 排错

```bash
openclaw agents list | grep -i finance
openclaw cron list | grep -E "A股|金融域|数据小时|闸门|候选|执行"
cat domains/finance/workers/risk/data/trading_gate.json
```

## 日常维护

1. 更新 `risk/data/portfolio_snapshot.json`、`orders_pending.json`
2. 更新 **`trader/data/watchlist.json`** 自选
3. 调 `risk/data/RISK-LIMITS.json` 上限
4. 休市写入 `trader/data/trading_calendar.txt`（与 risk 同步）

## 个人日程 Cron（trader）

见 [`../../trader/SCHEDULE.md`](../../trader/SCHEDULE.md)：08:30 / 11:00 / 16:00 / 18:00 日报；周一三财报；月初趋势。

## 流水线

`data` → `strategy`（信号）→ `risk`（gate）→ `execution`（仅模拟，gate 允许时）

## 实盘

**禁止** OpenClaw 自动实盘；execution 只写 `orders/simulated_*.json`。
