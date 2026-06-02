#!/usr/bin/env python3
"""根据 install.env + yaml 配置渲染 openclaw.json 与 cron delivery。"""
from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None


def load_env_file(path: Path) -> dict[str, str]:
    out: dict[str, str] = {}
    if not path.is_file():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, _, v = line.partition("=")
        out[k.strip()] = v.strip().strip('"').strip("'")
    return out


def load_yaml(path: Path) -> dict:
    if not path.is_file() or yaml is None:
        return {}
    return yaml.safe_load(path.read_text(encoding="utf-8")) or {}


def expand_home(s: str) -> str:
    return os.path.expanduser(s)


def truthy(v: str | bool | None) -> bool:
    if isinstance(v, bool):
        return v
    return str(v or "").lower() in ("1", "true", "yes", "on")


def main() -> int:
    if len(sys.argv) < 3:
        print("usage: render-config.py <install_dir> <product_config_dir>", file=sys.stderr)
        return 1

    install_dir = Path(expand_home(sys.argv[1]))
    cfg_dir = Path(sys.argv[2])
    data_dir = install_dir / "data"
    openclaw_home = os.environ.get("OPENCLAW_HOME", str(data_dir))

    env = load_env_file(install_dir / ".env")
    env.update(load_env_file(cfg_dir / "install.env"))
    feishu = load_yaml(cfg_dir / "feishu.yaml")
    trader = load_yaml(cfg_dir / "trader.yaml")
    advanced = load_yaml(cfg_dir / "advanced.yaml")

    feishu_enabled = truthy(env.get("FEISHU_ENABLED")) or truthy(feishu.get("enabled"))
    group_id = env.get("FEISHU_DELIVERY_GROUP_ID") or (
        feishu.get("delivery") or {}
    ).get("group_id", "")

    template = json.loads(
        (cfg_dir.parent / "config" / "openclaw.product.json.template").read_text(encoding="utf-8")
    )
    # 若从 install 目录调用，template 在 product 根
    tpl_path = Path(__file__).resolve().parent.parent / "config" / "openclaw.product.json.template"
    if tpl_path.is_file():
        template = json.loads(tpl_path.read_text(encoding="utf-8"))

    oc = json.loads(json.dumps(template))
    oc["gateway"]["port"] = int(env.get("GATEWAY_PORT", trader.get("gateway", {}).get("port", 18789)))
    oc["gateway"]["bind"] = trader.get("gateway", {}).get("bind", "0.0.0.0")
    oc["gateway"]["auth"]["token"] = env.get("OPENCLAW_GATEWAY_TOKEN", "${OPENCLAW_GATEWAY_TOKEN}")

    # agents.list 从 bundle 或已有文件合并
    bundle_agents = data_dir / "openclaw.agents.json"
    if bundle_agents.is_file():
        oc["agents"]["list"] = json.loads(bundle_agents.read_text())["list"]
    elif (data_dir / "openclaw.json").is_file():
        oc = json.loads((data_dir / "openclaw.json").read_text(encoding="utf-8"))

    for key in ("skills", "agents"):
        oc_str = json.dumps(oc)
        oc_str = oc_str.replace("${OPENCLAW_HOME}", openclaw_home)
        oc = json.loads(oc_str)

    if feishu_enabled and env.get("FEISHU_APP_ID") and env.get("FEISHU_APP_SECRET"):
        acc_id = env.get("FEISHU_ACCOUNT_ID") or feishu.get("account", {}).get("id", "sonicteam")
        oc.setdefault("channels", {})["feishu"] = {
            "enabled": True,
            "defaultAccount": acc_id,
            "streaming": False,
            "accounts": {
                acc_id: {
                    "name": feishu.get("account", {}).get("name", "TraderBot"),
                    "appId": env["FEISHU_APP_ID"],
                    "appSecret": env["FEISHU_APP_SECRET"],
                    "groupPolicy": "allowlist",
                    "groupAllowFrom": [group_id] if group_id else [],
                    "groups": {
                        group_id: {
                            "requireMention": truthy(
                                env.get("FEISHU_REQUIRE_MENTION")
                                or feishu.get("delivery", {}).get("require_mention")
                            ),
                            "allowFrom": ["*"],
                        }
                    }
                    if group_id
                    else {},
                }
            },
        }
        oc.setdefault("plugins", {}).setdefault("entries", {})["feishu"] = {"enabled": True}
    else:
        oc.setdefault("channels", {})["feishu"] = {"enabled": False}
        oc.setdefault("plugins", {}).setdefault("entries", {})["feishu"] = {"enabled": False}

    proxy = advanced.get("proxy") or {}
    if proxy.get("http") or proxy.get("https"):
        oc["env"] = {
            "HTTP_PROXY": proxy.get("http", ""),
            "HTTPS_PROXY": proxy.get("https", ""),
            "NO_PROXY": proxy.get(
                "no_proxy",
                "localhost,127.0.0.1,open.feishu.cn,.feishu.cn,.larksuite.com,.feishu.net",
            ),
        }

    data_dir.mkdir(parents=True, exist_ok=True)
    (data_dir / "openclaw.json").write_text(
        json.dumps(oc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    cron_src = data_dir / "cron" / "jobs.json"
    if cron_src.is_file() and group_id and feishu_enabled:
        jobs = json.loads(cron_src.read_text(encoding="utf-8"))
        acc = env.get("FEISHU_ACCOUNT_ID", "sonicteam")
        for job in jobs.get("jobs", []):
            d = job.get("delivery") or {}
            if d.get("mode") == "announce" and d.get("channel") == "feishu":
                d["accountId"] = acc
                d["to"] = f"group:{group_id}"
                job["delivery"] = d
        cron_src.write_text(json.dumps(jobs, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(f"[render-config] openclaw.json → {data_dir / 'openclaw.json'}")
    print(f"[render-config] feishu={'on' if feishu_enabled else 'off'} group={group_id or '-'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
