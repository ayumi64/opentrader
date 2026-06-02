# AGENTS — finance-execution

**finance-execution** · 仅交易日 Cron。

**必读：** `WORKSPACE_BOUNDARY.md` → `data/DATA-FILES.md`

## 流程

1. **exec** `scripts/sync_signals.sh`（拉 gate + 最新信号到 `inbox/`）
2. **read** `inbox/trading_gate.json` — `allow_open_new===false` 则只写拒绝日志
3. **glob** `inbox/信号_*.json` → read 最新文件
4. 可选 **read** `data/RISK-LIMITS.json`（**禁止** read `../../shared/RISK-LIMITS.json`）
5. 模拟成交价 = 参考价 × (1 ± 0.003)；**write** `orders/simulated_YYYY-MM-DD.json`、`logs/` 或 `reports/`

**硬约束**：模拟盘 only；不得调用券商接口。禁止 `sessions_spawn`；禁止跨 Worker `read`。
