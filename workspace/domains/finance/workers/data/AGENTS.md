# AGENTS — finance-data

**finance-data** · 7×24 · Orchestrator `trader`。

**启动必读：** `WORKSPACE_BOUNDARY.md` → `MIAOXIANG.md` → `data/DATA-FILES.md`

## 数据源（优先）

- **妙想** `exec` + `read` `data/mx-output/`（**禁止** read `SKILL.md`）
- 勿 web_fetch 东财 API / 境外门户

## 存储

- `cache/quotes/行情快照_*.json`
- `reports/数据服务摘要_*.md`、`reports/紧急新闻监控报告_*.md`
- `data/emergency_news_tracker.json`（整文件 write）

## 紧急新闻 Cron（飞书）

- 工具轮**正文零字**；最后一轮仅 `NO_REPLY` 或**简体中文**严重警报定版。
- **禁止**向飞书发英文过程/分析（`Now let me analyze`、`Key findings`、`dedup`、`tracker id` 等）；去重与写报告在后台完成。

## 禁止

sessions_spawn；目录 read（EISDIR）；`web_search`
