# 配置说明

## 1. install.env（环境变量）

复制 `install.env.example` → `install.env`。

**必填**

- `DEEPSEEK_API_KEY` — 大模型
- `SIM_TRADING_TOKEN` — 模拟盘

**可选**

- `MX_APIKEY` — 妙想行情（默认同 API Key，建议分开填）
- `FEISHU_*` — 飞书（也可用 feishu.yaml）
- `GATEWAY_PORT` / `TRADER_IMAGE` / 代理变量

## 2. feishu.yaml

复制 `feishu.yaml.example` → `feishu.yaml`。

```yaml
enabled: true
delivery:
  group_id: "oc_你的群ID"
```

对应环境变量：`FEISHU_APP_ID`、`FEISHU_APP_SECRET`。

安装时 `./install.sh --feishu --feishu-app-id ... --feishu-group oc_...` 会自动写入。

## 3. trader.yaml

- Gateway 端口、模型 provider
- 模拟盘滑点、报告路径
- 是否尊重交易日历

## 4. advanced.yaml

- HTTP/HTTPS 代理
- 备用模型 `DOUBAO_API_KEY`
- Telegram（默认关闭）
- 工具 deny 列表

修改配置后：

```bash
cd ~/.openclaw-trader
python3 /path/to/openbigA/scripts/render-config.py . config/
docker compose restart
```
