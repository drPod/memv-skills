---
name: memv-search
description: This skill should be used when the user asks to 'search memv memories', 'retrieve from the knowledge graph', 'find memories about X', 'implement semantic search on memv', or when calling client.memories.search. Covers graph-aware ranking, when retrieval will surprise you, and the difference from explicit graph traversal.
---

# memv-search

## Required reading

1. `docs/memv/core-concepts/search.md` — explains WHY queries return what they return (vector + graph traversal). Read this BEFORE the SDK page or the API will surprise you.
2. `docs/memv/sdk/memories.md` (search section) — exact call shape.
3. `docs/memv/core-concepts/knowledge-graphs.md` — only if you need entity/relationship-aware queries beyond plain semantic search.

## Hard rules

- Search is **graph-aware**, not pure vector. Returned memories may include neighbors of the best embedding match. This is a feature.
- `space_id` scopes the search. Omit only if intentionally cross-space.
- Don't post-filter results in Python when the SDK can do it server-side (`metadata` filters, `space_id`, etc.).

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

## Choose the right tool

- **Plain semantic search** → `client.memories.search` (this skill)
- **Entity / relationship traversal** → `client.graph.*` → see skill `memv-graph` and `docs/memv/sdk/graph.md`
- **Quick dev-time exploratory search** → `mcp__memv__search_memory` (no SDK, no app code) → see skill `memv-mcp-vs-sdk`

## Don't

- Don't expect lexical match. mem[v] returns what's semantically close, which may not contain the query terms verbatim.
- Don't tune by inflating `limit` to "see more results" — re-frame the query first.
