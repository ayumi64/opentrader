# 妙想（trader · workspaceOnly）

## 禁止

- `read` `~/.openclaw/data/skills/`、`~/.openclaw/data/output/miaoxiang/`（报 Path escapes sandbox）。
- `web_search`（未配置 SearXNG，工具层已 deny）。
- `web_fetch` `push2.eastmoney.com` / `quote.eastmoney.com` 行情 API；用 mx-data 问句代替。

## 输出目录

`/Users/sonic/.openclaw/workspace/trader/data/mx-output`

## exec

```bash
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-search/mx_search.py "<问句>" /Users/sonic/.openclaw/workspace/trader/data/mx-output
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-data/mx_data.py "<问句>" /Users/sonic/.openclaw/workspace/trader/data/mx-output
```

**指数/午后行情问句示例（mx-data）：**「上证指数 深证成指 创业板指 科创50 最新点位 涨跌幅」「全市场成交额和量能数据」。

**要闻（mx-search）：**「A股 2026年6月1日 午后 大盘」「科创50 市场动态」「GTC 利好出尽 股市」。

拉数后 `glob` / `read` `data/mx-output/` 下 `mx_*` 文件，再 `write` 到 `reports/` 等。禁止 `cd &&`、管道、重定向。
