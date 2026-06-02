# 金融域 · 路径契约

前缀：`/Users/sonic/.openclaw/workspace/domains/finance/workers/`

## finance-data（7×24）

| 用途 | 路径 |
|------|------|
| 行情缓存 | `data/cache/quotes/` |
| 基本面 | `data/cache/fundamentals/` |
| 舆情 | `data/cache/sentiment/` |
| 紧急 tracker | `data/data/emergency_news_tracker.json` |
| 时序（规划） | `data/timeseries/` → InfluxDB |

## finance-strategy

| 用途 | 路径 |
|------|------|
| 候选池 | `strategy/pool/YYYY-MM-DD_候选池.md` |
| 信号 | `strategy/signals/信号_YYYY-MM-DD_HHmm.json` |
| 盘中预警 | `strategy/signals/盘中预警_*.md` |
| 投研/调仓 | `strategy/reports/` |
| 三问 | `strategy/ChatGPT每日三问/` |

## finance-risk（7×24）

| 用途 | 路径 |
|------|------|
| gate | `risk/data/trading_gate.json` |
| 持仓/委托 | `risk/data/portfolio_snapshot.json`、`orders_pending.json` |
| 风控报告 | `risk/reports/` |

## finance-execution（交易日·模拟）

| 用途 | 路径 |
|------|------|
| gate / 信号（sync 后） | `execution/inbox/trading_gate.json`、`inbox/信号_*.json` |
| 风控上限 | `execution/data/RISK-LIMITS.json`（**勿** read `shared/RISK-LIMITS.json`） |
| 模拟订单 | `execution/orders/simulated_YYYY-MM-DD.json` |
| 留痕 | `execution/logs/`、`execution/reports/` |

## trader（总控）

| 用途 | 路径 |
|------|------|
| 调度日志 | `trader/logs/域调度_YYYY-MM-DD.md` |
| 周报 | `trader/reports/金融域周报_*.md` |

## finance-content

| 用途 | `content/wechat_publish_system/`、`content/reports/` |

妙想：各 Worker 内 `data/mx-output/`（**禁止** read `~/.openclaw/data/skills/`）；见 [`MIAOXIANG.md`](MIAOXIANG.md)
