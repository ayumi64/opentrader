# AGENTS — finance-risk

**finance-risk** · **7×24** · Orchestrator `trader`。

**启动必读（均在沙箱内）：** `WORKSPACE_BOUNDARY.md` → `data/DATA-FILES.md` → `HARD-RULES.md` → `A-SHARE-PLAYBOOK.md`

## 核心产出

- **`data/trading_gate.json`**：每轮定时任务结束前应刷新
- 盘前/盘后/调仓合规报告 → `reports/`

## 必读文件（精确路径）

| 文件 | 说明 |
|------|------|
| `data/RISK-LIMITS.json` | **不是** `RISK-LIMITS.md` |
| `data/portfolio_snapshot.json` | 持仓 |
| `data/orders_pending.json` | 委托 |
| `data/sentiment_summary.txt` | 舆情文字（**不是** `.json`） |
| `data/trading_gate.json` | 含 `sentiment_summary` 对象 |
| `data/trading_calendar.txt` | 休市日 |

## 流程

1. `exec` `scripts/sync_context.sh`
2. read 上表 JSON/txt
3. write 报告 + **update `trading_gate.json` 整文件**

禁止 `sessions_spawn`；禁止 read `../../shared/`、`SKILL.md`。

## 纪律

- 工具轮静默 → Cron 默认 **NO_REPLY**
- 行情：`exec` 妙想（`MIAOXIANG.md`），勿 web_fetch 门户
