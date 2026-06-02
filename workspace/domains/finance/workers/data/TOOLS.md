# TOOLS — finance-data

工作区：`/Users/sonic/.openclaw/workspace/domains/finance/workers/data`（`workspaceOnly`）。见 **`WORKSPACE_BOUNDARY.md`**。

## 妙想

**必读** [`MIAOXIANG.md`](MIAOXIANG.md)（**禁止** `read` `~/.openclaw/data/skills/` 与 **任何** `SKILL.md`）。

输出目录：`data/mx-output/`

```bash
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-search/mx_search.py "<问句>" /Users/sonic/.openclaw/workspace/domains/finance/workers/data/data/mx-output
python3 /Users/sonic/.openclaw/data/skills/miaoxiang/mx-data/mx_data.py "<问句>" /Users/sonic/.openclaw/workspace/domains/finance/workers/data/data/mx-output
```

产出见 `reports/数据服务摘要_YYYY-MM-DD_HHmm.md`（可选）
