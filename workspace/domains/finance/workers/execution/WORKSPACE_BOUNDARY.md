# WORKSPACE_BOUNDARY — finance-execution

沙箱根：`/Users/sonic/.openclaw/workspace/domains/finance/workers/execution/`

## 允许

| 路径 | 说明 |
|------|------|
| `inbox/trading_gate.json` | sync 后 read（**勿** read `../risk/…`） |
| `inbox/信号_*.json` | sync 后 read 最新信号 |
| `data/RISK-LIMITS.json` | 本目录副本（**勿** read `domains/finance/shared/`） |
| `orders/`、`logs/`、`reports/` | 产出 |

## 禁止

- `read` `../../shared/`、`../risk/`、`../strategy/`、`~/.openclaw/data/skills/`
- 对目录 `read`（EISDIR）

## 流程

1. **exec** `scripts/sync_signals.sh`（单条）
2. **read** `inbox/trading_gate.json`；可选 **read** `data/RISK-LIMITS.json`
3. **glob** `inbox/信号_*.json` → read 最新
4. **write** `orders/simulated_YYYY-MM-DD.json`、`logs/` 或 `reports/`
