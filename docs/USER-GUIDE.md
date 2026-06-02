# OpenTrader 用户帮助文档

> 产品：OpenClaw Trader 私有化部署  
> 仓库：[github.com/ayumi64/opentrader](https://github.com/ayumi64/opentrader)  
> 版本：见仓库根目录 `VERSION`

---

## 1. 产品是什么？

OpenTrader 是一套 **A 股金融域自动化系统**，安装在你自己的服务器或本机上，包含：

| 组件 | 作用 |
|------|------|
| **Trader（总控）** | 盘前 / 盘中 / 盘后汇总，飞书定版推送 |
| **finance-data** | 行情快照、舆情、紧急新闻 tracker |
| **finance-strategy** | 信号、候选池、盘中预警 |
| **finance-risk** | 风控检查、trading_gate 闸门 |
| **finance-execution** | **仅模拟盘**撮合记录 |
| **finance-content** | 内容/微信稿（可选） |

数据与报告默认保存在本机目录，不经过第三方 SaaS。

**重要声明**：本产品用于研究与自动化辅助，**不构成投资建议**；执行层默认**不接实盘**。

---

## 2. 环境要求

| 项目 | 要求 |
|------|------|
| 操作系统 | Linux、macOS、Windows 10/11 |
| Docker | 24.0+，含 Docker Compose v2 |
| 网络 | 能访问大模型 API、妙想 API；飞书需能访问 `open.feishu.cn` |
| 磁盘 | 建议 ≥ 2GB 可用空间 |

---

## 3. 安装

### 3.1 克隆仓库

```bash
git clone https://github.com/ayumi64/opentrader.git
cd opentrader
chmod +x install.sh scripts/*.sh docker/*.sh
```

### 3.2 方式 A：命令行（最快）

```bash
./install.sh \
  --api-key "你的DeepSeek_API_Key" \
  --sim-token "你的模拟盘Token"
```

安装过程中可选启用飞书，按提示输入 App ID、App Secret、群 chat_id（`oc_...`）。

### 3.3 方式 B：配置文件（推荐）

```bash
cp config/install.env.example config/install.env
# 编辑 config/install.env，填写 DEEPSEEK_API_KEY、SIM_TRADING_TOKEN 等

cp config/feishu.yaml.example config/feishu.yaml   # 需要飞书时
cp config/trader.yaml.example config/trader.yaml     # 可选
cp config/advanced.yaml.example config/advanced.yaml # 可选

./install.sh --config config/install.env
```

### 3.4 启动

```bash
cd ~/.openclaw-trader    # 或你在 install.env 里设置的 INSTALL_DIR
docker compose up -d
docker compose logs -f trader-gateway
```

浏览器可访问 Gateway（默认）：`http://127.0.0.1:18789`

### 3.5 Windows

```powershell
.\install.ps1 -ApiKey "sk-..." -SimToken "your-token"
cd $env:USERPROFILE\.openclaw-trader
docker compose up -d
```

镜像构建建议在 WSL2 或 Git Bash 中执行 `bash scripts/build-image.sh`。

---

## 4. 安装时需要准备什么？

### 4.1 必填

| 名称 | 环境变量 | 说明 |
|------|----------|------|
| **API Key** | `DEEPSEEK_API_KEY` | 大模型推理，Agent 写报告、分析用 |
| **模拟盘 Token** | `SIM_TRADING_TOKEN` | 写入 `execution/data/sim-trading.json`，供仿真对接 |

### 4.2 强烈建议单独配置

| 名称 | 环境变量 | 说明 |
|------|----------|------|
| 妙想 API Key | `MX_APIKEY` | 东方财富妙想，拉 A 股行情/资讯；可与 LLM Key 不同 |

未填 `MX_APIKEY` 时，安装脚本可能临时复用 API Key，**生产环境请分开填写**。

### 4.3 可选 · 飞书推送

| 名称 | 环境变量 / 文件 | 说明 |
|------|-----------------|------|
| 飞书 App ID | `FEISHU_APP_ID` | 开放平台应用 |
| 飞书 App Secret | `FEISHU_APP_SECRET` | 应用密钥 |
| 推送群 ID | `FEISHU_DELIVERY_GROUP_ID` 或 `feishu.yaml` | 形如 `oc_xxxxxxxx` |
| 是否启用 | `FEISHU_ENABLED=true` | 或 `feishu.yaml` 里 `enabled: true` |

不配置飞书时：Cron 仍运行，报告写入本地，**不会**向群聊发消息。

### 4.4 可选 · 其他

见 `config/advanced.yaml`：HTTP 代理、备用模型、Telegram 等。

---

## 5. 安装后的目录结构

默认安装路径：`~/.openclaw-trader`

```text
~/.openclaw-trader/
├── .env                 # 运行时环境变量（含密钥，勿泄露）
├── docker-compose.yml
├── config/              # 用户配置（可编辑）
│   ├── install.env
│   ├── feishu.yaml
│   ├── trader.yaml
│   └── advanced.yaml
└── data/                # 持久化数据（OPENCLAW_HOME）
    ├── openclaw.json    # Gateway 配置（由 render-config 生成）
    ├── cron/jobs.json     # 定时任务
    └── workspace/
        ├── trader/           # 总控：自选、报告、脚本
        └── domains/finance/  # 五层 Worker
```

### 常用报告路径

| 报告 | 路径 |
|------|------|
| 盘前 / 盘中 / 盘后 | `data/workspace/trader/reports/daily/` |
| 风控检查 | `data/workspace/domains/finance/workers/risk/reports/` |
| 数据摘要 | `data/workspace/domains/finance/workers/data/reports/` |
| 紧急新闻 | `data/workspace/domains/finance/workers/data/reports/紧急新闻监控报告_*.md` |

---

## 6. 定时任务（Cron）说明

时区默认：**Asia/Shanghai**。

| 时间（工作日） | 任务 | 飞书（若已配置） |
|----------------|------|------------------|
| 08:30 | 盘前消息汇总 | ✅ 定版推送 |
| 11:00 | 盘中汇总 | ✅ |
| 16:00 | 盘后汇总 | ✅ |
| 18:00 | 复盘与风控告警 | ✅ |
| 每小时 | 数据刷新、健康检查 | 通常静默 |

**休市日**：系统通过 `trading_calendar.txt` + `is_trading_day.sh` 判断，休市则 Trader 市场类任务 **NO_REPLY**（不推送）。

---

## 7. 配置修改

### 7.1 修改自选

编辑：

```text
data/workspace/trader/data/watchlist.json
```

保存后等待下一档 Cron，或重启 Gateway：

```bash
cd ~/.openclaw-trader && docker compose restart
```

### 7.2 修改休市日

权威文件：

```text
data/workspace/domains/finance/workers/risk/data/trading_calendar.txt
```

每行一个 **休市日** `YYYY-MM-DD`；**不在列表中的周一至周五 = 交易日**。

同步到 Trader：

```bash
# 容器内或宿主机若已安装 sync 脚本
bash data/workspace/trader/scripts/sync_worker_context.sh
```

### 7.3 开启 / 关闭飞书

1. 编辑 `config/feishu.yaml`：

```yaml
enabled: true
delivery:
  group_id: "oc_你的群ID"
```

2. 在 `.env` 中设置 `FEISHU_APP_ID`、`FEISHU_APP_SECRET`、`FEISHU_ENABLED=true`

3. 重新渲染并重启：

```bash
python3 /path/to/opentrader/scripts/render-config.py ~/.openclaw-trader ~/.openclaw-trader/config
cd ~/.openclaw-trader && docker compose restart
```

### 7.4 修改 Gateway 端口

在 `config/install.env` 或 `.env` 中设置 `GATEWAY_PORT=18789`，并同步 `docker-compose.yml` 端口映射。

---

## 8. 飞书定版长什么样？

Trader 飞书 Cron **全程只发一条消息**（最后一轮），示例骨架：

```text
📋 盘前消息 2026-06-02

宏观：…
外盘：…

▎自选要闻
• 600xxx 名称：一句话
…

▎今日板块
…

▎竞价前关注（9:15前）
1. …
2. …
```

不会出现 `Let me fetch...`、`Now I'll run...` 等过程句。

---

## 9. 常见问题（FAQ）

### Q1：安装失败，提示需要 Docker？

请先安装 [Docker Desktop](https://docs.docker.com/get-docker/) 或 Linux Docker Engine，并确认 `docker compose version` 可用。

### Q2：Gateway 启动后没有飞书消息？

按顺序检查：

1. `FEISHU_ENABLED=true` 且 AppId/Secret 正确  
2. 机器人已加入目标群，群 ID 正确（`oc_...`）  
3. 今天是否为交易日（休市日不推送）  
4. `docker compose logs trader-gateway` 是否有 Cron 报错  

### Q3：报告为空或数据很少？

1. 检查 `MX_APIKEY` 是否有效  
2. 查看 `data/workspace/trader/data/mx-output/` 是否有新文件  
3. 网络是否阻断妙想 API  

### Q4：能否实盘下单？

**默认不能。** `finance-execution` 仅写 `orders/simulated_*.json`。实盘需自行对接券商 API，并改风控规则，**不在 v1 产品支持范围内**。

### Q5：如何升级版本？

见仓库 [UPGRADE.md](../UPGRADE.md)。简要步骤：

```bash
# 备份
tar czf backup.tgz ~/.openclaw-trader/data ~/.openclaw-trader/.env

# 拉新代码 / 新镜像后
cd ~/.openclaw-trader && docker compose down
docker pull your-registry/openclaw-trader:新版本
# 更新 .env 中 TRADER_IMAGE
docker compose up -d
```

数据卷 `data/` 会保留历史报告与 tracker。

### Q6：密钥存在哪？安全吗？

密钥在 `~/.openclaw-trader/.env` 和 `config/`，**请勿提交到 Git** 或发到群里。生产环境建议限制目录权限：

```bash
chmod 600 ~/.openclaw-trader/.env
```

### Q7：如何完全卸载？

```bash
cd ~/.openclaw-trader
docker compose down -v   # 谨慎：-v 会删卷内数据
rm -rf ~/.openclaw-trader
docker rmi openclaw-trader:1.0.0   # 可选
```

---

## 10. 故障排查

| 现象 | 可能原因 | 处理 |
|------|----------|------|
| 容器反复重启 | 缺 API Key / Sim Token | 检查 `.env` 必填项 |
| Cron 不跑 | Gateway 未常驻 | `docker compose ps`，确认 Up |
| 英文过程句出现在飞书 | 旧版 payload / 模型越权 | 升级镜像，见 release note |
| `web_search` 失败 | 未配置 SearXNG | 正常，系统已禁用，用妙想 exec |
| 路径 EISDIR | Agent read 了目录 | 只 read 具体 `.md`/`.json` 文件 |

日志：

```bash
cd ~/.openclaw-trader
docker compose logs -f --tail=200 trader-gateway
```

---

## 11. 获取帮助

- **文档**：本文件、`config/README.md`、仓库 `README.md`
- **Issue**：[GitHub Issues](https://github.com/ayumi64/opentrader/issues)
- **配置示例**：`config/*.example`

提交 Issue 时请附带（**脱敏**）：

- 操作系统与 Docker 版本  
- `docker compose logs` 相关片段（去掉 API Key）  
- 是否启用飞书、是否交易日  

---

## 12. 术语表

| 术语 | 含义 |
|------|------|
| Gateway | OpenClaw 主进程，承载 Cron 与 Agent |
| Worker | 金融域子 Agent（data/strategy/risk/…） |
| trading_gate | 风控闸门 JSON，控制是否允许模拟开仓 |
| mx-search / mx-data | 妙想资讯/行情 Python 脚本 |
| NO_REPLY | Cron 成功但不向飞书发可见消息 |
| 定版 | 飞书只允许最后一轮一条中文正文 |

---

*文档随产品版本更新；以仓库内最新文件为准。*
