# WORKSPACE_BOUNDARY — finance-data

沙箱根：`/Users/sonic/.openclaw/workspace/domains/finance/workers/data/`

## 妙想

- **仅** `exec` + `read` `data/mx-output/`、`cache/quotes/` 下具体文件
- **禁止** read `~/.openclaw/data/skills/`、`mx-search/SKILL.md`、`mx-data/SKILL.md`（已从 Agent skills 移除）
- 用法：`MIAOXIANG.md`

## 产出

| 路径 | 用途 |
|------|------|
| `cache/quotes/行情快照_*.json` | 行情缓存 |
| `reports/数据服务摘要_*.md` | 摘要（risk 经 sync 可读） |
| `reports/紧急新闻监控报告_*.md` | 紧急新闻 |
| `data/emergency_news_tracker.json` | 去重 tracker |

## 禁止

- `web_search`（未配置 SearXNG）
- `web_fetch` 东财 push/quote API
- 对目录 `read`
