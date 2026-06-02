# WORKSPACE_BOUNDARY — finance-strategy

`tools.fs.workspaceOnly: true` · 沙箱根目录**仅此一处**：

```
/Users/sonic/.openclaw/workspace/domains/finance/workers/strategy/
```

## 允许（相对沙箱根）

| 用途 | 路径 |
|------|------|
| 信号 / 盘中预警 | `signals/`（**不是** `~/coding/strategy/signals`） |
| 妙想产出 | `data/mx-output/`、`signals/mx_*`（脚本写入后 `read` 具体文件） |
| 候选池 | `pool/` |
| 报告 | `reports/` |
| 风控 gate | `inbox/trading_gate.json` 或根下 `trading_gate` |
| 规则 | `STRATEGY-RULES.md`、`MIAOXIANG.md`、`TOOLS.md` |

## 禁止 `read` / `write` / `edit`

- 任何以 `~` 开头的路径（含 `~/.openclaw/data/skills/.../SKILL.md`）
- `~/coding/`、`../`、其它 Agent 工作区
- 对**目录**直接 `read`（EISDIR）→ 先 `glob` 再读文件

## 妙想

- **不要** `read` skill 的 `SKILL.md`；只用 **`exec`** + 本目录 `MIAOXIANG.md`
- 脚本第三参数输出目录：`…/strategy/data/mx-output` 或任务指定的 `signals/`（须在本沙箱内）

## 用户或上下文出现「coding/strategy」时

一律映射到本沙箱 `signals/`、`pool/`、`reports/`，**不要**尝试 `~/coding/strategy/…`。
