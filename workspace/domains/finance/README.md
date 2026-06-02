# 金融域 · A 股五层量化架构

| 层级 | Agent | 运行 |
|------|-------|------|
| **总控** | [`trader`](../../trader/) | 7×24 |
| **数据** | `finance-data` | 7×24 |
| **策略** | `finance-strategy` | 交易日+盘后 |
| **风控** | `finance-risk` | 7×24 |
| **执行** | `finance-execution` | 交易日（**仅模拟**） |
| 内容 | `finance-content` | Cron |

手册：[`shared/A-SHARE-PLAYBOOK.md`](shared/A-SHARE-PLAYBOOK.md) · 策略：[`STRATEGY-RULES.md`](shared/STRATEGY-RULES.md) · 硬规则：[`HARD-RULES.md`](shared/HARD-RULES.md)

**已废弃**：`finance-news` → `finance-data`；`finance-research` → `finance-strategy`。
