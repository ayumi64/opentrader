# OpenBigA

**OpenClaw Trader** — A 股金融域 Orchestrator 私有化部署产品。

基于 [OpenClaw](https://github.com/openclaw/openclaw) Gateway + Trader 五层 Worker（Data / Strategy / Risk / Execution / Content），支持 Docker 一键安装、配置化飞书推送与持续升级。

## 快速开始

```bash
git clone https://github.com/ayumi64/openbigA.git
cd openbigA

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

- [README 完整说明](./README.md)（产品细节）
- [UPGRADE.md](./UPGRADE.md)（版本迭代）

## 维护者

从 OpenClaw monorepo 同步源码：

```bash
OPENCLAW_MONO=/path/to/.openclaw bash scripts/sync-source.sh
bash scripts/build-image.sh
```

## License

Private / 按你的发布策略填写。
