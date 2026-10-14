# agentconnect-droid-daemon

AgentConnect daemon running Factory Droid (headless) as the coding agent, with the
Manifest LLM gateway (`https://app.manifest.build/v1`) as the model backend.

- Base: node:22-slim + git/build toolchain
- `@agentconnect.md/cli` v2.4.0 installed globally
- Droid v0.241.1 pre-seeded into AgentConnect's runtime store
  (`~/.agentconnect/runtimes/droid@0.241.1`) — npm 11 blocks install scripts,
  so the Dockerfile invokes the package's own `install.js` to fetch the
  linux-x64 binary
- `entrypoint.sh` renders `~/.factory/settings.json` (Manifest custom model)
  from env, then execs the daemon

## Required environment variables
| Var | Purpose |
|---|---|
| `AC_API_URL` | Control-plane WebSocket, e.g. `wss://agentconnect-cp-636509.zeabur.app/daemon/ws` |
| `AC_API_KEY` | Daemon API key minted in the AgentConnect UI |
| `MANIFEST_API_KEY` | Manifest gateway key (droid LLM backend) |
| `FACTORY_API_KEY` | Factory auth for droid |
# trigger
