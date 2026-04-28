---
name: memv-search
description: This skill should be used when the user asks to 'search memv memories', 'retrieve from the knowledge graph', 'find memories about X', 'implement semantic search on memv', or when calling client.memories.search. Covers graph-aware ranking, when retrieval will surprise you, and the difference from explicit graph traversal.
---

# memv-search

## Required reading

1. `docs/memv/core-concepts/search.md` — explains WHY queries return what they return (vector + graph traversal). Read BEFORE SDK page or API surprises.
2. `docs/memv/sdk/memories.md` (search section) — exact call shape.
3. `docs/memv/core-concepts/knowledge-graphs.md` — only if needing entity/relationship-aware queries beyond plain semantic.

## Hard rules

- Search is **graph-aware**, not pure vector. Returned memories may include neighbors of best embedding match. Feature, not bug.
- `space_id` scopes search. Omit only if intentionally cross-space.
- No post-filtering in Python when SDK does it server-side (`metadata` filters, `space_id`).

## Skeleton (Python)

```python
results = client.memories.search(
    space_id=space_id,
    query="<natural language query>",
    limit=10,
)
for memory in results:
    print(memory.content, memory.score)
```

## Choose right tool

- **Plain semantic search** → `client.memories.search` (this skill)
- **Entity / relationship traversal** → `client.graph.*` → skill `memv-graph` + `docs/memv/sdk/graph.md`
- **Quick dev-time exploratory search** → `mcp__memv__search_memory` (no SDK, no app code) → skill `memv-mcp-vs-sdk`

## Don't

- No expecting lexical match. mem[v] returns semantic neighbors; query terms may not appear verbatim.
- No tuning by inflating `limit` to "see more results" — re-frame query first.
