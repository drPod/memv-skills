---
name: memv-add-memory
description: This skill should be used when the user asks to 'add a memory', 'write to mem[v]', 'store in the knowledge graph', or when writing or modifying code that calls client.memories.add. Covers required space_id, metadata patterns, multimodal payload routing (text vs file vs video), and the error-handling envelope every call needs.
---

# memv-add-memory

## Required reading (in order)

1. `docs/memv/sdk/memories.md` — full method signatures + patterns. **Hot path. Read in full.**
2. `docs/memv/core-concepts/memories.md` — lifecycle (create → enrich → link → retrieve → decay), what counts as one memory.
3. `docs/memv/core-concepts/spaces.md` — every write needs `space_id`. Confirm caller has one.
4. `docs/memv/sdk/error-handling.md` — exception types to catch.

## Hard rules

- `space_id` **mandatory**. No global writes exist.
- Use SDK types (`memvai`) directly. Don't define wrapper `class Memory`.
- Push raw content. Don't pre-summarize text or pre-extract entities — mem[v] does that.
- Non-text (PDF, image, audio, video) → `client.upload.batch.create(...)` (skill `memv-files` / `memv-video-ingest`), NOT `client.memories.add` with stringified blob.
- Wrap try/except per `sdk/error-handling.md`. No bare-except.

## SDK surface (verified against `docs/memv/sdk/memories.md`)

- `client.memories.add(space_id, content, metadata?)` — write text memory
- `client.memories.search(space_id, query, limit?)` — retrieve

**No `update_memory` / `delete_memory` exist in the SDK.** To change a memory, add a new one and let mem[v]'s graph reconcile, OR use `client.spaces.delete(space_id=...)` to drop a whole space.

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

Interactive sanity-check write landed:

```
mcp__memv__search_memory(query="<excerpt>", workspaceId=space_id, maxResults=3)
```

(`workspaceId` MCP == `space_id` SDK — see skill `memv-mcp-vs-sdk`.)

## Don't

- No reusing `space_id` across logical tenants (per-user/feature/env separation — `core-concepts/spaces.md`).
- No looping `add()` thousands of times without backoff. Batch patterns in `sdk/advanced.md`.
- No storing rendered HTML / markup. Push raw source.
- No assuming `update`/`delete` exist on `client.memories`. They don't.
