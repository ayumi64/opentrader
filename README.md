# OpenTrader

**OpenClaw Trader** — A 股金融域 Orchestrator 私有化部署产品。

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

基于 [OpenClaw](https://github.com/openclaw/openclaw) Gateway + Trader 五层 Worker（Data / Strategy / Risk / Execution / Content），支持 Docker 一键安装、配置化飞书推送与持续升级。

仓库：[github.com/ayumi64/opentrader](https://github.com/ayumi64/opentrader)

## 快速开始

```bash
git clone https://github.com/ayumi64/opentrader.git
cd opentrader

# 必填：API Key + 模拟盘 Token
./install.sh --api-key "sk-..." --sim-token "your-sim-token"

# 或使用配置文件（推荐）
cp config/install.env.example config/install.env
# 编辑 config/install.env 后：
./install.sh --config config/install.env

cd ~/.openclaw-trader && docker compose up -d
```

## 安装输入

| 必填 | 说明 |
|------|------|
| **API Key** | DeepSeek 大模型 (`DEEPSEEK_API_KEY`) |
| **模拟盘 Token** | 仿真柜台凭证 (`SIM_TRADING_TOKEN`) |

## 配置目录

安装后 `~/.openclaw-trader/config/`：

| 文件 | 说明 |
|------|------|
| `install.env` | 环境变量总入口 |
| `feishu.yaml` | 飞书 AppId/Secret/推送群 |
| `trader.yaml` | Gateway 端口、模型、路径 |
| `advanced.yaml` | 代理、备用模型、Telegram 等 |

详见 [config/README.md](./config/README.md)。

## 文档

| 文档 | 读者 |
|------|------|
| [用户帮助文档](./docs/USER-GUIDE.md) | 安装、配置、FAQ、排障 |
| [配置说明](./config/README.md) | install.env / feishu.yaml 等 |
| [UPGRADE.md](./UPGRADE.md) | 版本升级 |

## 维护者

从 OpenClaw monorepo 同步源码：

```bash
OPENCLAW_MONO=/path/to/.openclaw bash scripts/sync-source.sh
bash scripts/build-image.sh
```

## License

Private / 按你的发布策略填写。
