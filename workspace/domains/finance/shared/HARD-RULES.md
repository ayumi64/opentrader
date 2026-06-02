# 风控硬规则（finance-risk · 7×24）

违反任一条 → `trading_gate.json` 置 `allow_open_new: false` 或 `force_reduce: true`；**finance-execution 禁止模拟开仓**。

## 硬规则清单

| ID | 规则 | 动作 |
|----|------|------|
| R1 | 单票仓位 > `RISK-LIMITS.max_single_stock_pct` | 禁止新开/加仓该票 |
| R2 | 板块集中度 > `max_sector_pct` | 禁止板块内新开 |
| R3 | 现金 < `min_cash_buffer_pct` | 禁止新开 |
| R4 | 标的距涨停 < `warn_near_limit_up_pct` 拟买入 | 禁止追涨开仓 |
| R5 | 未成交委托数 > `max_pending_orders` | 提醒撤单/清理后再开 |
| R6 | `finance-data` 舆情「严重」+ 持仓相关 | `force_reduce` 预案 |
| R7 | 当日已触发止损清单内标的 | 禁止加仓 |
| R8 | 非交易日 | 仅维护 gate，不生成开仓信号 |

## gate 文件

`/Users/sonic/.openclaw/workspace/domains/finance/workers/risk/data/trading_gate.json`

execution 下单前 **必须 read**；`allow_open_new === false` 时只写日志不开仓。
