---
name: memv-mcp-vs-sdk
description: This skill should be used when the user is deciding between mcp__memv__* tools and SDK code, asks 'should I use MCP or SDK', mixes mcp__memv__ calls with memvai imports in app code, or hits the workspaceId/space_id terminology mismatch. Covers the agent-vs-app boundary and the 4-tool MCP surface limits.
---

# memv-mcp-vs-sdk

mem[v] is reachable two ways. Pick the right one — they are NOT interchangeable.

## The two surfaces

| Surface | Lives in | Auth | Surface size |
|---------|----------|------|--------------|
| `mcp__memv__*` tools | The **agent's** harness | OAuth (live user) | 4 tools |
| `memvai` SDK | The **app's** code | API key | Full platform |

## The 4 MCP tools (everything else needs SDK)

- `mcp__memv__whoami` — verify auth
- `mcp__memv__list_workspaces` — get `workspaceId`s
- `mcp__memv__add_memory(workspaceId, memories[])` — text only, no metadata
- `mcp__memv__search_memory(query, workspaceId?, maxResults?)` — text search

## Decision rules

**Use `mcp__memv__*` (agent inspecting live data) when:**
- Finding a real `workspaceId` to wire into config or a seed
- Verifying a write actually landed after running the app
- Quick scratch search ("is there anything about X already?")
- Sanity-checking auth setup (`whoami`)
- Any one-off NL query against the user's KG during dev

**Use SDK code when:**
- The operation runs in production / ships in the app
- It needs ANYTHING beyond the 4 MCP tools: file upload, video ingestion, space CRUD, graph traversal, advanced retrieval, batch ops, transactions, custom embeddings, raw HTTP fallback
- It needs metadata, structured payloads, or anything beyond `{content, name?}`
- It needs `update_memory` / `delete_memory` (not in MCP)
- It needs error handling for retryable vs terminal failures

**Never:** import `mcp__memv__*` from app code. They live in the harness, not the runtime.

## Terminology mismatch — translate

- MCP says `workspaceId` (string)
- SDK says `space_id` (string)
- **Same concept.** Pass the same value either way. Doc references in `docs/memv/core-concepts/spaces.md` and `docs/memv/sdk/spaces.md` use the SDK term.

## Steps

1. Classify the task: dev-time inspection vs app code path.
2. If MCP-eligible AND the 4 tools cover it → call `mcp__memv__<tool>`.
3. Otherwise → SDK. Read `docs/memv/sdk/overview.md` to find the right method, then the specific page.
4. If unsure, default to SDK — it always works; MCP is a convenience.

## See also

- `docs/memv/mcp/overview.md` — exact MCP tool semantics
- `docs/memv/sdk/overview.md` — full SDK surface
- `AGENTS.md` standing rule #7
