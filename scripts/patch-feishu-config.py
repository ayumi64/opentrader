#!/usr/bin/env python3
"""无 PyYAML 依赖时也可写 feishu.yaml 最小字段。"""
import sys
from pathlib import Path

def main() -> int:
    path = Path(sys.argv[1])
    enabled = sys.argv[2].lower() in ("true", "1", "yes")
    group = sys.argv[3]
    app_id = sys.argv[4] if len(sys.argv) > 4 else ""
    app_secret = sys.argv[5] if len(sys.argv) > 5 else ""

    text = f"""enabled: {'true' if enabled else 'false'}

account:
  id: sonicteam
  name: TraderBot
  app_id_env: FEISHU_APP_ID
  app_secret_env: FEISHU_APP_SECRET

delivery:
  channel: feishu
  account_id: sonicteam
  group_id: "{group}"
  require_mention: false
"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
