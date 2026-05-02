---
name: memv-mcp-vs-sdk
description: This skill should be used when the user is deciding between mcp__memv__* tools and SDK code, asks 'should I use MCP or SDK', mixes mcp__memv__ calls with memvai imports in app code, or hits the workspaceId/space_id terminology mismatch. Covers the agent-vs-app boundary and the 4-tool MCP surface limits.
---

# memv-mcp-vs-sdk

mem[v] reachable two ways. NOT interchangeable.

## Two surfaces

| Surface | Lives in | Auth | Surface size |
|---------|----------|------|--------------|
| `mcp__memv__*` tools | Agent harness | OAuth (live user) | 4 tools |
| `memvai` SDK | App code | API key | Full platform |

## 4 MCP tools (everything else needs SDK)

- `mcp__memv__whoami` — verify auth
- `mcp__memv__list_workspaces` — get `workspaceId`s
- `mcp__memv__add_memory(workspaceId, memories[])` — text only, no metadata
- `mcp__memv__search_memory(query, workspaceId?, maxResults?)` — text search

## SDK surface (verified against `docs/memv/sdk/`)

- `client.memories.add` / `.search` (no `update`, no `delete`)
- `client.spaces.create` / `.list` / `.retrieve` / `.update` / `.delete`
- `client.upload.batch.create` / `.get_status` (files + video, async)
- `client.files.list` / `client.videos.list`
- `client.graph.retrieve_triplets`
- Escape hatches in `docs/memv/sdk/advanced.md`

## Decision rules

**Use `mcp__memv__*` (agent inspecting live data) when:**
- Find real `workspaceId` to wire into config or seed
- Verify write landed after running app
- Quick scratch search ("anything about X already?")
- Sanity-check auth (`whoami`)
- One-off NL query against KG during dev

**Use SDK when:**
- Op runs in production / ships in app
- Needs ANYTHING beyond 4 MCP tools: file/video upload (`upload.batch.create`), space CRUD, graph triplets, advanced retrieval, batch, custom embeddings, raw HTTP
- Needs metadata / structured payloads beyond `{content, name?}`
- Needs error handling for retryable vs terminal failures

**Never:** import `mcp__memv__*` from app code. Lives in harness, not runtime.

## Terminology — translate

- MCP: `workspaceId` (string)
- SDK: `space_id` (string)
- **Same concept.** Same value. Doc refs in `docs/memv/core-concepts/spaces.md` and `docs/memv/sdk/spaces.md` use SDK term.

## Steps

1. Classify task: dev-time inspection vs app code path.
2. MCP-eligible AND 4 tools cover it → `mcp__memv__<tool>`.
3. Else → SDK. `docs/memv/sdk/overview.md` for method, then specific page.
4. Unsure → default SDK. Always works; MCP convenience only.

## See also

- `docs/memv/mcp/overview.md` — exact MCP tool semantics
- `docs/memv/sdk/overview.md` — full SDK surface
- `AGENTS.md` standing rule #7