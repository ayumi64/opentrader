# 妙想（mx-search / mx-data）· 工作区内用法

金融域各 Worker 与 **trader** 均启用 `tools.fs.workspaceOnly: true`。

## 禁止

- **`read` / `write` / `edit`** 访问 `~/.openclaw/data/skills/`、`~/.openclaw/data/output/miaoxiang/`（会报 `Path escapes sandbox root`）。
- 不要尝试 `read` 各 skill 目录下的 `SKILL.md`（finance-data/risk **已从 Agent skills 移除**）；用法以本文为准。
- **`web_search`**：本机未配置 SearXNG，金融域 Agent 已在 `openclaw.json` 禁用；勿调用。
- **`web_fetch`** `push2.eastmoney.com`、`quote.eastmoney.com` 等行情 JSON API（常 `fetch failed`）；指数/个股/板块**只用 mx-data**。

## 允许

- **`exec`** 调用妙想 Python 脚本（脚本在沙箱外，由网关执行）。
- **`read`** 本 Worker 工作区内的 **`data/mx-output/`** 下脚本产出（txt / json / xlsx / `*_description.txt`）。

## 输出目录（第三参数，必须落在本 Worker 工作区内）

| Agent | `exec` 第三参数（输出目录） |
|-------|---------------------------|
| finance-data | `/Users/sonic/.openclaw/workspace/domains/finance/workers/data/data/mx-output` |
| finance-strategy | `/Users/sonic/.openclaw/workspace/domains/finance/workers/strategy/data/mx-output` |
| finance-risk | `/Users/sonic/.openclaw/workspace/domains/finance/workers/risk/data/mx-output` |
| finance-content | `/Users/sonic/.openclaw/workspace/domains/finance/workers/content/data/mx-output` |
| finance-research / news | 各 worker 下 `data/mx-output`（已废弃 worker 同理） |
| **trader** | `/Users/sonic/.openclaw/workspace/trader/data/mx-output` |

目录不存在时脚本会自动创建。

## mx-search（资讯）

```bash
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-search/mx_search.py "<中文问句>" <上表输出目录>
```

- 鉴权：`MX_APIKEY`（`~/.openclaw/.env`，网关加载）。
- 产出：`mx_search_<问句>.txt`、`mx_search_<问句>.json`（在输出目录内）。
- **禁止** `cd &&`、管道、重定向；一次 `exec` 一条命令。
- 问句示例：「今日 A 股科技板块要闻」「北向资金最新解读」「贵州茅台最新研报」。

## mx-data（结构化行情/财务）

```bash
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-data/mx_data.py "<中文问句>" <上表输出目录>
```

- 产出：`mx_data_<问句>.xlsx`、`mx_data_<问句>_description.txt`（优先 `read` description 再按需读 xlsx 路径说明）。
- 问句示例：「上证指数最新收盘价 涨跌幅」「寒武纪 迈为股份 最新价 涨跌幅」。

## 工作流建议

1. `exec` 拉数（可多轮不同问句，工具轮正文零字）。
2. `glob` / `read` 本 worker `data/mx-output/` 下最新 `mx_*` 文件。
3. 归纳后 **`write`** 到 `reports/`、`pool/` 等本 worker 约定路径。

## 其它 mx-*（xuangu / zixuan / moni）

脚本路径均在 `/Users/sonic/.openclaw/data/skills/miaoxiang/<name>/`；调用方式同上加第三参数为**本 worker** `data/mx-output`。trader 编排任务见 `trader/TOOLS.md`。
