---
name: memv-debug
description: Use when mem[v] returns errors, unexpected behavior, missing memories, failed writes, slow responses, or auth issues — covers the error hierarchy, common failure modes, and the dev-time MCP probes for sanity-checking
---

# memv-debug

## Required reading (in priority order)

1. `docs/memv/sdk/error-handling.md` — exception hierarchy, retryable vs terminal, rate-limit shape.
2. `docs/memv/support/troubleshooting.md` — first stop on runtime errors (currently thin, may fall through).
3. `docs/memv/changelog/` — check for recent breaking changes if behavior diverges from docs.
4. `docs/memv/sdk/advanced.md` — escape hatches if standard SDK fails inexplicably.

## Triage flow

1. **Auth error?** → Run `mcp__memv__whoami` to confirm the live account works. If yes but app fails → check `MEMV_API_KEY` env var in the app's runtime.
2. **Memory not appearing in search?** → Verify the write landed: `mcp__memv__search_memory(query=<excerpt>, workspaceId=space_id)`. If MCP sees it but app search doesn't → check `space_id` mismatch (MCP says `workspaceId`, SDK says `space_id`, same value).
3. **Slow / timing out?** → Check rate-limit response per `sdk/error-handling.md`. Don't add naïve retry loops; the SDK already handles backoff per its docs.
4. **Surprising search results?** → Re-read `docs/memv/core-concepts/search.md`. Search is graph-aware; neighbors of the embedding match are returned by design.
5. **Shape error / KeyError on response?** → Don't fabricate field names. Check `sdk/<area>.md` for the actual response shape. If absent → `sdk/advanced.md`. If still absent → flag to user, don't invent.

## Hard rules

- Don't bare-except. Catch the specific exception types from `sdk/error-handling.md`.
- Don't retry on terminal errors. The doc tells you which is which.
- Don't paper over with sleep+retry. Surface the error or fix the root cause.

## Common failure modes

| Symptom | Likely cause | Where to look |
|---------|--------------|---------------|
| 401/403 | API key missing or wrong | `sdk/installation.md`, env var |
| Memory not searchable | Wrong `space_id` or write failed silently | `core-concepts/spaces.md`, MCP sanity-check |
| Search returns nothing | Query semantically distant from stored memories | `core-concepts/search.md` |
| Search returns "wrong" memories | Graph traversal pulling neighbors | `core-concepts/search.md` (working as intended) |
| Upload timeout | Large file or rate-limit | `sdk/error-handling.md`, `sdk/files.md` / `videos.md` |
| Field missing on response | SDK version mismatch or wrong area | `sdk/<area>.md` first, then `sdk/advanced.md` |
