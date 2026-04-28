---
name: memv-mcp-setup
description: Use when wiring this app to expose its own MCP server, or when configuring a client (Claude Code, Claude Desktop, Cursor, ChatGPT, VS Code, Windsurf) to consume mem[v]'s MCP — covers OAuth flow, endpoint conventions, and the limits of the 4-tool surface
---

# memv-mcp-setup

## Two distinct things called "MCP" here

1. **mem[v]'s hosted MCP server** (https://mcp.memv.ai/mcp) — exposes 4 tools: `whoami`, `list_workspaces`, `add_memory`, `search_memory`. See skill `memv-mcp-vs-sdk` for the agent-vs-app rules.
2. **Your app's own MCP server** — if you expose your app's data to AI clients via MCP, you wire it yourself.

This skill covers BOTH. Use the right section.

## Required reading

1. `docs/memv/mcp/overview.md` — what mem[v]'s MCP exposes and example NL workflows.
2. `docs/memv/mcp/setup.md` — per-client install commands. Use as REFERENCE when building our own MCP for endpoint/auth conventions.

## Consuming mem[v]'s MCP from a new client

```bash
# Claude Code
claude mcp add --transport http memv https://mcp.memv.ai/mcp

# VS Code Copilot
code --add-mcp '{"name":"memv","type":"http","url":"https://mcp.memv.ai/mcp"}'
```

OAuth prompt fires on first tool use. No API keys.

## If exposing your app's data via MCP

Follow mem[v]'s patterns from `mcp/setup.md`:
- `https://<your-domain>/mcp` over HTTP transport (not SSE — Cursor's `/sse` is the exception)
- OAuth via the user's existing auth provider, NOT API keys
- Tool surface should mirror their style: small set of high-leverage tools, NL-friendly names, clear param descriptions

## Hard rules

- Don't put `mcp__memv__*` calls inside app code. They're agent-side. Use the SDK.
- Don't ship API keys to the client; OAuth via Clerk (mem[v]'s pattern) or our own auth provider.
- Verify connection with `mcp__memv__whoami` after install.
