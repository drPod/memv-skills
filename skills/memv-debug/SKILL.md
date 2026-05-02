---
name: memv-debug
description: This skill should be used when the user reports a mem[v] error, mentions 'memv 401', 'memory not found', 'search returns nothing', 'add_memory failed', 'rate limited', or when troubleshooting unexpected mem[v] behavior. Covers the SDK exception hierarchy, common failure modes, and the dev-time MCP probes for sanity-checking writes and auth.
---

# memv-debug

## Required reading (priority order)

1. `docs/memv/sdk/error-handling.md` — exception hierarchy, retryable vs terminal, rate-limit shape.
2. `docs/memv/support/troubleshooting.md` — first stop on runtime errors (thin now, may fall through).
3. `docs/memv/changelog/` — recent breaking changes if behavior diverges from docs.
4. `docs/memv/sdk/advanced.md` — escape hatches when standard SDK fails inexplicably.

## Triage flow

1. **Auth error?** → `mcp__memv__whoami` confirm live account works. Yes but app fails → check `MEMV_API_KEY` env var in app runtime.
2. **Memory not appearing in search?** → Verify write landed: `mcp__memv__search_memory(query=<excerpt>, workspaceId=space_id)`. MCP sees it but app search doesn't → check `space_id` mismatch (MCP `workspaceId`, SDK `space_id`, same value).
3. **Slow / timing out?** → Check rate-limit response per `sdk/error-handling.md`. No naïve retry loops; SDK handles backoff per docs.
4. **Surprising search results?** → Re-read `docs/memv/core-concepts/search.md`. Search graph-aware; neighbors of embedding match returned by design.
5. **Shape error / KeyError on response?** → No fabricating field names. Check `sdk/<area>.md` for actual response shape. Absent → `sdk/advanced.md`. Still absent → flag to user, don't invent.

## Hard rules

- No bare-except. Catch specific exception types from `sdk/error-handling.md`.
- No retrying terminal errors. Doc tells which is which.
- No papering over with sleep+retry. Surface error or fix root cause.

## Common failure modes

| Symptom | Likely cause | Where to look |
|---------|--------------|---------------|
| 401/403 | API key missing or wrong | `sdk/installation.md`, env var |
| Memory not searchable | Wrong `space_id` or write failed silently | `core-concepts/spaces.md`, MCP sanity-check |
| Search returns nothing | Query semantically distant from stored memories | `core-concepts/search.md` |
| Search returns "wrong" memories | Graph traversal pulling neighbors | `core-concepts/search.md` (working as intended) |
| Upload timeout | Big file or rate-limit | `sdk/error-handling.md`, `sdk/files.md` / `videos.md` |
| Field missing on response | SDK version mismatch or wrong area | `sdk/<area>.md` first, then `sdk/advanced.md` |