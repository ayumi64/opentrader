# Trader · 交易日程与 Cron

> 对照职业交易员 **标准每日时间轴**；下方 **OpenClaw 自动任务** 覆盖你指定的汇总/复盘节点。

## 一、人工时间轴（参考）

| 时段 | 事项 |
|------|------|
| 06:30–07:30 | 资讯扫读：宏观、公告、外盘、龙虎榜、风险点 |
| 07:30–08:30 | **交易计划**：复盘昨日、标的/止损/止盈/仓位、备选清单 |
| 08:30–09:15 | **集合竞价** 9:15–9:25 盯盘、微调计划 |
| 09:30–11:30 | 早盘执行，严格止损 |
| 11:30–13:00 | 午间休整、早盘复盘、下午策略 |
| 13:00–15:00 | 下午盘；14:30 后尾盘；是否隔夜 |
| 15:00–17:00 | 收盘复盘、逐笔核对、统计胜率 |
| 17:00–19:00 | 晚餐放松，不盯盘 |
| 19:00–22:00 | 深度复盘、学习、次日准备 |
| 22:00+ | 收尾、睡眠 |

## 二、OpenClaw 自动任务（`agentId: trader`）

**投递：飞书 Cron announce**（账号 **SonicTeamNo.1** / `sonicteam` → **SonicTeam 群** `oc_62e803c91b95d36b712e678e10c05465`，见 [`../FEISHU_GROUPS.md`](../FEISHU_GROUPS.md)）。定版排版见 [`TELEGRAM_FORMAT.md`](TELEGRAM_FORMAT.md)（与飞书共用）。完整长文同时写入 `reports/`。

**工作日**盘前/盘中/盘后/复盘：读 `data/trading_calendar.txt`，休市 → `NO_REPLY`。

| 时间 | Cron | 产出 | 定版 |
|------|------|------|------|
| **08:30** | 盘前重要消息汇总 | `reports/daily/盘前消息汇总_*.md` | 📋 |
| **11:00** | 盘中汇总 | `reports/daily/盘中汇总_*.md` | 📊 |
| **16:00** | 盘后汇总 | `reports/daily/盘后汇总_*.md` | 📈 |
| **18:00** | 每日复盘 + 风控告警 | `reports/daily/每日复盘_*.md` | 📝 |

| 周期 | 时间 | 产出 | 定版 |
|------|------|------|------|
| **每周日** | 20:00 | `reports/weekly/周末消息面汇总_*.md` | 📰 |
| **周一、周三** | 19:00 | `reports/weekly/财报解读_*.md` | 📑 |
| **每月 1 日** | 09:00 | `reports/monthly/月度趋势判断_*.md` | 📅 |

## 三、执行前（每条 Cron）

1. `exec` → `bash scripts/sync_worker_context.sh`（拉 gate、持仓、数据摘要到 `inbox/`）
2. `read` → `data/watchlist.json`
3. 妙想 `mx-search` / `mx-data` 覆盖**自选逐只**或板块问句

## 四、自选列表

维护 [`data/watchlist.json`](data/watchlist.json)。

## 五、与五层 Worker 关系

| 本任务 | Worker 分工 |
|--------|-------------|
| 08:30 消息 | trader 汇总；底层数据已由 `finance-data` 小时刷新 |
| 11/16 汇总 | trader 汇总；可参考 `inbox/` 内策略候选池 |
| 18:00 复盘 | trader 写复盘 + 读 `inbox/trading_gate.json` 写**风控告警**节 |
| 周日 20:00 周末消息面 | trader 汇总周末要闻；`mx-search` 多轮问句 |
| 周一三财报 | trader 深度解读；`mx-data` 财报问句 |
| 月初趋势 | trader 宏观+科技主线判断 |

重度流水线（候选池、模拟成交）仍由 `finance-strategy` / `finance-risk` / `finance-execution` Cron 执行，见 [`../domains/finance/shared/A-SHARE-PLAYBOOK.md`](../domains/finance/shared/A-SHARE-PLAYBOOK.md)。
