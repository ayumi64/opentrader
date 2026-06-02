# CRON.md — finance-research

| Job ID | 名称 | 调度 | agentId |
|--------|------|------|---------|
| `32d25a46-3f7f-4b99-b1e9-6a4aa4bfc25b` | 每日投资信息检查 | `0 9,15 * * *` | `finance-research` |
| `9a1b2c3d-4e5f-6789-a012-3456789abc01` | 交易话题 ChatGPT 三问 | `5 16 * * *` | `finance-research` |

## 产出

- 投资检查：`reports/投资信息检查报告_YYYY-MM-DD_HHmm.md`
- 调仓：`reports/调仓交易方案_YYYY-MM-DD.md`、`reports/调仓交易执行结果_YYYY-MM-DD.md`
- 三问：`ChatGPT每日三问/YYYY-MM-DD_交易话题.md`（模板见 `ChatGPT每日三问/templates/`）
