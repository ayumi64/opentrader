# data/ 文件清单（finance-risk · 精确文件名）

**禁止**猜测扩展名（如 `RISK-LIMITS.md`、`sentiment_summary.json` 不存在）。

| 文件 | 用途 |
|------|------|
| `RISK-LIMITS.json` | 风控上限参数（**不是** `.md`） |
| `portfolio_snapshot.json` | 持仓与现金 |
| `orders_pending.json` | 未成交委托 |
| `trading_gate.json` | 闸门状态；内含 `sentiment_summary` 对象 |
| `sentiment_summary.txt` | 舆情文字摘要（**不是** `.json`） |
| `trading_calendar.txt` | 休市日列表 |

规则正文：`../HARD-RULES.md` 或 `../conf/HARD-RULES.txt`  
Playbook：`../A-SHARE-PLAYBOOK.md`

跨 Worker 舆情：先 `exec` `../scripts/sync_context.sh`，再 `glob` `../inbox/news/` 或读 `../data/reports/数据服务摘要_*.md`（**不在**本 risk 沙箱，须 sync 到 inbox）。
