# TOOLS — finance-risk

工作区：`/Users/sonic/.openclaw/workspace/domains/finance/workers/risk`（`workspaceOnly`）。见 **`WORKSPACE_BOUNDARY.md`**、**`data/DATA-FILES.md`**。

| 文件 | 用途 |
|------|------|
| `data/portfolio_snapshot.json` | 持仓与现金 |
| `data/orders_pending.json` | 未成交委托 |
| `data/RISK-LIMITS.json` | 上限参数（**勿读** `.md`） |
| `data/sentiment_summary.txt` | 舆情摘要（**勿读** `.json`） |
| `data/trading_gate.json` | 闸门 + `sentiment_summary` 对象 |
| `data/trading_calendar.txt` | 休市日 |
| `HARD-RULES.md` | 硬规则（沙箱内） |

## 妙想（结构化行情）

```bash
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-data/mx_data.py "<问句>" /Users/sonic/.openclaw/workspace/domains/finance/workers/risk/data/mx-output
```

例：「688256 涨跌幅 换手率」「沪深300 今日涨跌」

## 产出

| 报告 | 路径 |
|------|------|
| 盘前 | `reports/盘前风控检查_YYYY-MM-DD_HHmm.md` |
| 盘后 | `reports/盘后持仓复盘_YYYY-MM-DD_HHmm.md` |
| 调仓审查 | `reports/调仓合规审查_YYYY-MM-DD.md` |
