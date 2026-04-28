---
name: memv-mcp-setup
description: This skill should be used when the user asks to 'install memv MCP', 'wire memv to Claude Code/Cursor/ChatGPT/Claude Desktop', 'add MCP server', 'expose our app via MCP', or 'build an MCP server'. Covers per-client install commands, OAuth flow, endpoint conventions, and the limits of the 4-tool surface.
---

# memv-mcp-setup

## Two distinct things called "MCP" here

1. **mem[v]'s hosted MCP server** (https://mcp.memv.ai/mcp) — exposes 4 tools: `whoami`, `list_workspaces`, `add_memory`, `search_memory`. Skill `memv-mcp-vs-sdk` for agent-vs-app rules.
2. **Your app's own MCP server** — wire it yourself if exposing app data to AI clients.

This skill covers BOTH. Use right section.

## Required reading

1. `docs/memv/mcp/overview.md` — what mem[v]'s MCP exposes + example NL workflows.
2. `docs/memv/mcp/setup.md` — per-client install commands. REFERENCE when building own MCP for endpoint/auth conventions.

## Consuming mem[v]'s MCP from new client

```bash
# Claude Code
claude mcp add --transport http memv https://mcp.memv.ai/mcp

# VS Code Copilot
code --add-mcp '{"name":"memv","type":"http","url":"https://mcp.memv.ai/mcp"}'
```

OAuth prompt fires on first tool use. No API keys.

## Exposing your app's data via MCP

Follow mem[v]'s patterns from `mcp/setup.md`:
- `https://<your-domain>/mcp` over HTTP transport (not SSE — Cursor's `/sse` is exception)
- OAuth via user's existing auth provider, NOT API keys
- Tool surface mirrors their style: small high-leverage set, NL-friendly names, clear param descriptions

## Hard rules

- No `mcp__memv__*` calls inside app code. Agent-side. Use SDK.
- No shipping API keys to client; OAuth via Clerk (mem[v]'s pattern) or own auth provider.
- Verify connection with `mcp__memv__whoami` after install.
