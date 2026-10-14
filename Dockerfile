FROM node:22-slim

# Tooling a coding agent needs (git required by droid; build-essential + python3 for task builds)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git openssh-client python3 make g++ ripgrep jq \
    && rm -rf /var/lib/apt/lists/*

# AgentConnect CLI
RUN npm install -g @agentconnect.md/cli@2.4.0 --registry=https://registry.npmjs.org

# Runtime store for the audited `factory-droid` runtime, in the layout
# AgentConnect's store installer expects: runtimes/droid@<version>/node_modules/droid
# NOTE: must use the official npm registry (mirrors often lack the @factory
# platform packages) and --ignore-scripts is fine: the linux-x64 ELF installs
# as an optionalDependency and the JS shim resolves it at launch.
RUN mkdir -p /root/.agentconnect/runtimes/droid@0.241.1 \
    && cd /root/.agentconnect/runtimes/droid@0.241.1 \
    && echo '{"name":"droid-store","version":"1.0.0","private":true}' > package.json \
    && npm install droid@0.241.1 --ignore-scripts --no-audit --no-fund \
         --registry=https://registry.npmjs.org \
    && node node_modules/droid/bin/droid --version

# Agent definition (validated against the v2.4.0 schema)
COPY agents /root/.agentconnect/agents

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV HOME=/root OTEL_SDK_DISABLED=true
ENTRYPOINT ["/entrypoint.sh"]
