# 时序存储（Phase 2）

**当前**：行情/指标写入 `../cache/quotes/`、`../cache/fundamentals/`（JSON + 按日 md 摘要）。

**规划**：InfluxDB（或同类）落盘：

- measurement: `a_share_quote_l1`, `a_share_bar_1m`, `a_share_bar_1d`
- tags: `code`, `market`
- 由 `finance-data` Cron 增量写入（需本机部署 Influx 后启用 `DATA_STORE=influx`）

未部署前禁止 Cron 假设 Influx 可用。
