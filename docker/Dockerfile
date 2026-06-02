# OpenClaw Trader 私有化镜像
FROM node:22-bookworm-slim

ARG OPENCLAW_VERSION=latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl bash python3 python3-pip gettext-base \
    && pip3 install --no-cache-dir pyyaml \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@${OPENCLAW_VERSION}

WORKDIR /app

COPY bundle/workspace /app/workspace
COPY bundle/data/skills /app/data/skills
COPY bundle/cron/jobs.product.json /app/cron/jobs.json
COPY bundle/openclaw.json /app/openclaw.json
COPY bundle/openclaw.agents.json /app/openclaw.agents.json

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/healthcheck.sh /healthcheck.sh
COPY scripts/render-config.py /app/scripts/render-config.py
COPY config /app/config

RUN chmod +x /entrypoint.sh /healthcheck.sh \
    && mkdir -p /data/agents /data/cron /data/logs

ENV OPENCLAW_HOME=/data TZ=Asia/Shanghai NODE_ENV=production

VOLUME ["/data"]
EXPOSE 18789

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD /healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gateway"]
