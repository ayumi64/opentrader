# WORKSPACE_BOUNDARY — finance-risk

沙箱根：`/Users/sonic/.openclaw/workspace/domains/finance/workers/risk/`

## 必读（均在沙箱内）

1. `WORKSPACE_BOUNDARY.md`（本文件）
2. `data/DATA-FILES.md` — **精确文件名**
3. `HARD-RULES.md`、`A-SHARE-PLAYBOOK.md`
4. `MIAOXIANG.md` — 妙想仅 `exec`，禁止 read `SKILL.md`

## 禁止

- `read` `../../shared/`、`~/.openclaw/data/skills/`、任何 `SKILL.md`
- 猜测路径：`RISK-LIMITS.md`、`sentiment_summary.json`（见 `data/DATA-FILES.md`）
- 对目录 `read`（EISDIR）

## 舆情摘要读取顺序

1. `data/sentiment_summary.txt`
2. `data/trading_gate.json` 内 `sentiment_summary` 字段
3. `exec` `scripts/sync_context.sh` 后 `glob` `inbox/news/*.md`
