# 升级与迭代

## 版本规范

- 产品版本见 `VERSION`（如 `1.0.0`）
- 镜像标签与版本一致：`openclaw-trader:1.0.1`
- `manifest.yaml` 记录组件与 agent 列表，供发布说明使用

## 发布新版本（维护方）

1. 在开发环境完成 Trader / Finance Worker / `cron/jobs.json` 修改
2. 递增 `products/openclaw-trader/VERSION`
3. 打 bundle 并构建镜像：

```bash
bash products/openclaw-trader/scripts/bundle.sh
bash products/openclaw-trader/scripts/build-image.sh
docker push <registry>/openclaw-trader:<新版本>
```

4. 编写变更说明（Breaking changes：Cron 路径、必填 env、openclaw.json 结构）

## 客户侧升级（保留数据）

```bash
cd ~/.openclaw-trader

# 1. 备份
tar czf openclaw-trader-backup-$(date +%Y%m%d).tgz data .env

# 2. 拉新镜像
export TRADER_IMAGE=registry.example.com/openclaw-trader:1.0.1
docker pull "${TRADER_IMAGE}"

# 3. 更新 .env 中 TRADER_IMAGE（若使用 compose 变量）
# 4. 滚动重启
docker compose down
docker compose up -d

# 5. 若 Cron 结构大变：对比 bundle/cron/jobs.product.json 手动合并 data/cron/jobs.json
```

**数据卷** `/data` 保留：自选、交易日历、tracker、历史报告不会随镜像更新丢失。

## 仅更新业务逻辑（不重装）

若只改 `workspace/trader` 或 `domains/finance` 文档/脚本：

- 方案 A：发布新镜像（推荐，可回滚）
- 方案 B：将补丁 rsync 到 `~/.openclaw-trader/data/workspace/` 后 `docker compose restart`

## 回滚

```bash
docker compose down
export TRADER_IMAGE=registry.example.com/openclaw-trader:1.0.0
docker compose up -d
```
