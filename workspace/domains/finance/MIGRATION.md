# 金融域迁移说明

## 2026-05 · Worker 化

| 旧路径（trader） | 新路径（Worker） |
|------------------|------------------|
| `trader/emergency_news_tracker.json` | `workers/news/data/emergency_news_tracker.json` |
| `trader/紧急新闻监控报告/` | `workers/news/reports/` |
| `trader/系统检查报告/投资信息检查报告_*` | `workers/research/reports/` |
| `trader/系统检查报告/调仓*` | `workers/research/reports/` |
| `trader/ChatGPT每日三问/` | `workers/research/ChatGPT每日三问/` |
| `trader/wechat_publish_system/` | `workers/content/wechat_publish_system/` |
| `trader/系统检查报告/微信公众号*` | `workers/content/reports/` |

**旧目录保留只读归档**，不自动删除。首次运行会从 `trader/emergency_news_tracker.json` 复制到 news worker（若新文件不存在）。
