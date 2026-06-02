# data/ · finance-execution

| 文件 | 用途 |
|------|------|
| `RISK-LIMITS.json` | 风控上限（**禁止** read `../../shared/RISK-LIMITS.json`） |

开盘前 `exec` `scripts/sync_signals.sh` 会刷新 **`inbox/trading_gate.json`**、**`inbox/信号_*.json`**（来自 risk/strategy，勿跨 Worker read）。
