# A 股量化域 · 五层架构手册

> 对齐个人量化台：**Orchestrator → Data → Strategy → Risk → Execution**（+ 对外 Content）

## 1. 五层 + 编排

| 层级 | Agent | 运行 | 职责 |
|------|-------|------|------|
| **总控** | `trader` | **7×24** | 调度、时间触发、异常兜底、域日志汇总；Gateway 常驻，断线由 OpenClaw 重连 |
| **数据** | `finance-data` | **7×24** | 行情 L1/日线/分钟摘要、基本面、舆情（财联社/公告）；`cache/` + 规划 InfluxDB |
| **策略** | `finance-strategy` | **交易日+盘后** | 科技强势+回调+二波；候选池、盘中预警、买卖信号 |
| **风控** | `finance-risk` | **7×24** | 仓位/止损/集中度/黑天鹅；**硬规则** → `trading_gate.json` |
| **执行** | `finance-execution` | **交易日** | **仅模拟盘**；滑点 ±0.3%；信号/订单留痕 |
| 内容 | `finance-content` | Cron | 微信公众号（免责） |

**已合并**：`finance-news` → `finance-data`；`finance-research` → `finance-strategy`。

## 2. 交易日时间线（CST）

| 时间 | Agent | 产出 |
|------|-------|------|
| 7×24 每小时 | `finance-data` | 行情/舆情缓存 |
| 7×24 每 4h | `finance-data` | 紧急舆情（严重→Telegram） |
| 7×24 每 2h | `finance-risk` | 更新 `trading_gate.json` |
| 08:50 | `finance-risk` | 盘前风控 |
| 09:00 | `finance-strategy` | 投资信息检查 |
| 09:25 | `finance-risk` | 调仓合规 |
| 09:26 | `finance-execution` | 开盘模拟撮合 |
| 09:30–15:00 每30min | `finance-strategy` | 盘中预警 |
| 15:00 | `finance-strategy` | 盘后投研 |
| 15:05 | `finance-execution` | 收盘执行小结 |
| 15:35 | `finance-risk` | 盘后复盘 |
| 16:30 | `finance-strategy` | 盘后候选池 |
| 16:05 | `finance-strategy` | ChatGPT 交易三问 |
| 每小时 | `trader` | 域调度健康日志 |

休市：读 `workers/risk/data/trading_calendar.txt` → 交易类 Cron `NO_REPLY`。

## 3. 流水线（硬顺序）

```text
finance-data    → 缓存 + 舆情
finance-strategy → 候选池 / 信号
finance-risk    → gate（可否开仓）
finance-execution → 模拟订单（仅当 gate 允许）
```

Orchestrator ad-hoc「跑一遍盘前」：

```text
trader → spawn data（摘要）→ risk（盘前）→ strategy（候选）→ execution（仅读 gate，不开新单除非用户要求）
```

## 4. 策略规则

[`STRATEGY-RULES.md`](STRATEGY-RULES.md)

## 5. 风控硬规则

[`HARD-RULES.md`](HARD-RULES.md) · 参数 [`workers/risk/data/RISK-LIMITS.json`](../workers/risk/data/RISK-LIMITS.json)

## 6. 执行约束

- **禁止** 本系统自动实盘下单
- 模拟成交价：参考价 × (1 ± 0.003)
- 每笔写入 `workers/execution/log/`、`orders/simulated_*.json`

## 7. 数据契约

见 [`PATHS.md`](PATHS.md)。
