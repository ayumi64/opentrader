# A 股交易日历（维护说明）

**权威文件：**

`/Users/sonic/.openclaw/workspace/domains/finance/workers/risk/data/trading_calendar.txt`

副本（trader 读取）：`workspace/trader/data/trading_calendar.txt`（由 sync 或手工与 risk 同步）

## 格式（重要）

- 每行一个 **休市日** `YYYY-MM-DD`（法定节假日、交易所休市）
- `#` 开头为注释
- **不在文件中的周一至周五 = 交易日**
- **切勿**把本文件当成「交易日白名单」——**列表里是休市，不是开市**

## 判断（推荐）

```bash
bash …/risk/scripts/is_trading_day.sh [trading_calendar.txt]
# 输出 TRADING | HOLIDAY | WEEKEND
```

- `TRADING` → 正常跑盘前/盘中/盘后 Cron
- `HOLIDAY` / `WEEKEND` → 交易类 Cron 最后一轮仅 `NO_REPLY`（勿向飞书解释）

## 示例休市日

```text
# 2026 春节
2026-02-16
2026-02-17
```

维护：每年初从交易所公告更新。
