# data/ 子目录（finance-data）

| 文件 | 用途 |
|------|------|
| `emergency_news_tracker.json` | 紧急新闻去重（整文件 write，禁止 edit 碎片） |
| `mx-output/` | 妙想脚本输出（glob 后 read 具体 `mx_*` 文件） |

妙想 exec 第三参数必须指向：`…/data/data/mx-output`
