# CRON — finance-risk

| Job ID | 名称 | 调度 |
|--------|------|------|
| `f1n4nc3-risk-pre-0001-000000000001` | A股·盘前风控 | `50 8 * * 1-5` |
| `f1n4nc3-risk-post-0001-000000000001` | A股·盘后复盘 | `35 15 * * 1-5` |
| `f1n4nc3-risk-plan-0001-000000000001` | A股·调仓合规审查 | `25 9 * * 1-5` |

均为 `sessionTarget: isolated`，`agentId: finance-risk`。
