#!/bin/sh
set -e

# Render droid's custom-LLM config (Manifest gateway) from env at boot
mkdir -p /root/.factory
cat > /root/.factory/settings.json <<JSON
{
  "customModels": [
    {
      "model": "custom:Manifest-Auto-0",
      "displayName": "Manifest Auto",
      "baseUrl": "https://app.manifest.build/v1",
      "apiKey": "${MANIFEST_API_KEY}",
      "provider": "generic-chat-completion-api"
    }
  ]
}
JSON

echo "[entrypoint] droid runtime check:"
node /root/.agentconnect/runtimes/droid@0.241.1/node_modules/droid/bin/droid --version || true
echo "[entrypoint] starting agentconnect daemon (agents: /root/.agentconnect/agents)"

exec agentconnect run \
  --api-url "${AC_API_URL}" \
  --api-key "${AC_API_KEY}" \
  --agents-dir /root/.agentconnect/agents
