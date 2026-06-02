# CRON.md — finance-news

| Job ID | 名称 | 调度 | agentId |
|--------|------|------|---------|
| `6fb7f43f-fbeb-4db1-b739-5179296d9d11` | 紧急新闻监控（修复版） | `30 */4 * * *` | `finance-news` |
| `b3522901-bb25-4ab8-875b-392e42b80a19` | 紧急新闻监控（旧） | every 30m | `finance-news`（**disabled**） |

## 产出

- Tracker：`data/emergency_news_tracker.json`（禁止 `edit` 碎片补丁）
- 报告：`reports/紧急新闻监控报告_YYYY-MM-DD_HHmm.md`
- 去重：`python3 /Users/sonic/.openclaw/workspace/scripts/emergency_news_dedup.py`

路径契约：[`../../shared/PATHS.md`](../../shared/PATHS.md)
