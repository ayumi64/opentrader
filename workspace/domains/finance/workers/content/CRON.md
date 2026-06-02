# CRON.md — finance-content

| Job ID | 名称 | 调度 | agentId |
|--------|------|------|---------|
| `993aa9aa-cfee-4ad7-b947-1cad141fe503` | 微信公众号文章生成 | `0 8 * * *` | `finance-content` |
| `8b366651-2ca4-4a89-b7f4-3a01e0bdabf0` | 微信公众号发布提醒 | `0 9 * * *` | `finance-content` |
| `91807345-6295-4106-8658-1820bd43a6ac` | 每周投资内容创作提醒 | `0 10 * * 1` | `finance-content` |

## 产出

- 长稿：`wechat_publish_system/articles/YYYY-MM-DD_投资主题.md`
- 发布通知：`reports/微信公众号发布通知_YYYY-MM-DD.md`
- 发布提醒：`reports/微信公众号发布提醒_YYYY-MM-DD.md`
- 周计划：`reports/每周投资创作规划_YYYY-MM-DD.md`
