# AGENTS.md — Trader

每轮开场：读 **`SOUL.md`**、**`TOOLS.md`**、**`ORCHESTRATOR.md`**；需要衔接主会话记忆时读上一级 **`../USER.md`**（勿默认读 `../MEMORY.md`，除非用户在该会话中要求）。

Cron 隔离会话以任务 payload 为准；产出路径以 payload 为准（多为 `workspace/trader/` 下绝对路径）。

**飞书 Cron announce（硬规则）：** 对用户可见正文**全程仅最后一轮、全中文**。工具轮**正文零字**（只发 tool_calls）。**禁止**向飞书发任何英文过程句，包括但不限于：`Let me start the pre-market routine`、`Now I'll run the search queries in parallel`、`Let me check the available skills documentation`、`Now let me look at the mx-search script path`、`Now I have enough data to compose the report`。妙想**禁止** read `SKILL.md`；只读 **`MIAOXIANG.md`** 后 exec。定版见 **`TELEGRAM_FORMAT.md`**。

交易/投资相关内容**只在本 workspace**；勿写入 main 根下的 `feishu_publish_system/`、`translations/` 等。

**编排：** 可 `sessions_spawn` 至 `finance-news`、`finance-research`、`finance-content`（仅金融域 Worker）。

**路径（trader 隔离后）：** 投资/调仓/微信发布类报告均在 **`系统检查报告/`** 下，例如 `系统检查报告/调仓交易方案_2026-05-20.md`。任务里若只写 `调仓交易方案_YYYY-MM-DD.md`，先 **glob** `系统检查报告/调仓*` 再 `read`；勿默认 `trader/` 根目录（main 时代曾在 workspace 根或 `系统检查报告/` 混用）。

`read` 仅限文件；禁止对目录 `read`。其余与主 workspace `../AGENTS.md` 红线与工具原则一致。
