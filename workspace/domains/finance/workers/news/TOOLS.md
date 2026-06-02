# TOOLS.md — finance-news

工作区：`/Users/sonic/.openclaw/workspace/domains/finance/workers/news`（`workspaceOnly`）。

## 路径

| 用途 | 路径 |
|------|------|
| Tracker | `data/emergency_news_tracker.json` |
| 监控报告 | `reports/紧急新闻监控报告_YYYY-MM-DD_HHmm.md` |
| 去重脚本 | `/Users/sonic/.openclaw/workspace/scripts/emergency_news_dedup.py` |
| 妙想输出 | `data/mx-output/`（见 `../../shared/MIAOXIANG.md`） |

## 妙想

```bash
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-search/mx_search.py "<问句>" /Users/sonic/.openclaw/workspace/domains/finance/workers/news/data/mx-output
```

## 网络

- **禁止 web_fetch**：yahoo、bloomberg、reuters、cnbc、wsj、ft、investing 等（见 Cron payload）。
- **财联社**：禁止无数字 ID 的 `cls.cn/detail/` URL。

## 禁止工具

`sessions_spawn`、`message`/`send`（Cron 任务内）。
