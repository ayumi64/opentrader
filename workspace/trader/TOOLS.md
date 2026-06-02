# TOOLS.md — Trader

本目录为 **trader** 子 workspace；产出路径均在本目录下（相对路径以 `workspace/trader/` 为根）。

## 妙想（miaoxiang）

- **用法文档（工作区内可读）：** [`MIAOXIANG.md`](MIAOXIANG.md)
- **禁止** `read` `~/.openclaw/data/skills/`（`workspaceOnly` 会报 Path escapes sandbox）。
- **exec 示例（勿 `cd &&` 链）：**
  - `python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-search/mx_search.py "<中文问句>" /Users/sonic/.openclaw/workspace/trader/data/mx-output`
  - `python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-data/mx_data.py "<问句>" /Users/sonic/.openclaw/workspace/trader/data/mx-output`
- 脚本产出用 `read` / `glob` 读 `data/mx-output/`。`MX_APIKEY` 由网关环境提供。

## 常用路径（相对本 workspace 根）

| 用途 | 路径 |
|------|------|
| 投资信息检查 | `系统检查报告/投资信息检查报告_*.md` |
| **调仓交易方案** | `系统检查报告/调仓交易方案_YYYY-MM-DD.md`（**勿**在 workspace 根 `trader/` 下裸文件名查找） |
| **调仓执行结果** | `系统检查报告/调仓交易执行结果_YYYY-MM-DD.md` |
| 微信公众号长文 | `wechat_publish_system/articles/` |
| 微信公众号发布通知 | `系统检查报告/微信公众号发布通知_YYYY-MM-DD.md` |
| 微信公众号发布提醒 | `系统检查报告/微信公众号发布提醒_*.md` |
| 紧急新闻 | `紧急新闻监控报告/`、`emergency_news_tracker.json` |
绝对路径前缀：`/Users/sonic/.openclaw/workspace/trader/`（**ChatGPT 每日三问** 在 main 根：`../ChatGPT每日三问/`）

## read 纪律

**禁止**对目录 `read`（EISDIR）；先 `list` / glob 再读具体文件。飞书/技术稿在 **main** 工作区：`../feishu_publish_system/articles/`。
