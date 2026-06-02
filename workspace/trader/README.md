# Trader · 总控 Orchestrator（7×24）

A 股量化域 **总控**：调度 Data / Strategy / Risk / Execution，汇总 `logs/` 与周报。

| 文档 | |
|------|--|
| [`ORCHESTRATOR.md`](ORCHESTRATOR.md) | 委派与流水线 |
| [`../domains/finance/shared/A-SHARE-PLAYBOOK.md`](../domains/finance/shared/A-SHARE-PLAYBOOK.md) | 五层手册 |

## 五层 Worker 目录

`../domains/finance/workers/{data,strategy,risk,execution,content}/`

## 维护

- 组合：`workers/risk/data/portfolio_snapshot.json`、`orders_pending.json`
- 闸门：`workers/risk/data/trading_gate.json`（风控写、执行读）
- **自选**：`trader/data/watchlist.json`
- 策略规则：`domains/finance/shared/STRATEGY-RULES.md`
- **日程**：[`SCHEDULE.md`](SCHEDULE.md) · 报告 [`reports/README.md`](reports/README.md)

## 运行说明

- **Gateway 常驻** = Orchestrator 7×24 载体；断线由 OpenClaw 自动重连
- **实盘**：Execution **仅模拟**；真实下单必须人工

历史归档：本目录 `调方案_*.md`、`系统检查报告/` 等。
