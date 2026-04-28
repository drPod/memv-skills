---
name: memv-add-memory
description: This skill should be used when the user asks to 'add a memory', 'write to mem[v]', 'store in the knowledge graph', 'update a memory', or when writing or modifying code that calls client.memories.add/update/delete. Covers required space_id, metadata patterns, multimodal payload routing, and the error-handling envelope every call needs.
---

# memv-add-memory

## Required reading (in order)

1. `docs/memv/sdk/memories.md` — full method signatures and patterns. **Hot path. Read in full.**
2. `docs/memv/core-concepts/memories.md` — lifecycle (create → enrich → link → retrieve → decay) and what counts as a single memory.
3. `docs/memv/core-concepts/spaces.md` — every write needs `space_id`. Confirm the calling code has one.
4. `docs/memv/sdk/error-handling.md` — exception types to catch.

## Hard rules

- `space_id` is **mandatory**. No global writes exist.
- Use SDK types (`memvai`) directly. Don't define your own wrapper `class Memory`.
- Push raw content. Don't pre-summarize text or pre-extract entities — mem[v] does that.
- For non-text (file, video) → use `client.files.upload` / `client.videos.upload`, NOT `client.memories.add` with stringified blob.
- Wrap in try/except per `sdk/error-handling.md`. Don't bare-except.

## Skeleton (Python)

```python
from memvai import Memv

client = Memv()  # reads MEMV_API_KEY env var

response = client.memories.add(
    space_id=space_id,                    # required
    content="<raw text>",
    metadata={"source": "...", "user_id": "..."},
)
memory_id = response.memory_id
```

## Verify after writing

If running interactively, sanity-check the write landed:

```
mcp__memv__search_memory(query="<excerpt>", workspaceId=space_id, maxResults=3)
```

(`workspaceId` in MCP == `space_id` in SDK — see skill `memv-mcp-vs-sdk`.)

## Don't

- Don't reuse the same `space_id` across logical tenants (per-user/feature/env separation — see `core-concepts/spaces.md`).
- Don't loop `add()` thousands of times without backoff. Check `sdk/advanced.md` for batch patterns.
- Don't store rendered HTML / markup. Push the raw source content.
