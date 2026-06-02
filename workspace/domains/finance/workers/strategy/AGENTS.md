# AGENTS — finance-strategy

**finance-strategy** · 交易日为主 · `trader` 编排。

**启动必读（均在沙箱内）：** `WORKSPACE_BOUNDARY.md` → `STRATEGY-RULES.md` → `TOOLS.md` / `MIAOXIANG.md`

## 产出

- `pool/YYYY-MM-DD_候选池.md`
- `signals/信号_*.json`、`signals/盘中预警_*.md`
- `reports/投资信息检查报告_*.md`、`reports/调仓交易方案_*.md`
- `ChatGPT每日三问/`（交易话题）

## 流程

1. `read` `inbox/trading_gate.json`（或 `exec` `scripts/sync_risk_gate.sh` 后 read）
2. 妙想：`exec` + `read` `data/mx-output/` 或 `signals/mx_*` 具体文件（**禁止** read `~/.openclaw/data/skills/`）
3. 按 `STRATEGY-RULES.md` 写候选池/信号

禁止 `sessions_spawn`；禁止 `read` 目录；禁止 `~/coding/` 路径
