---
name: memv-graph
description: This skill should be used when the user asks to 'query the memv knowledge graph', 'inspect entities and relationships', 'get triplets for a memory', 'find connections between', or when calling client.graph.retrieve_triplets. Covers entity/relationship extraction, when to use explicit graph queries vs the graph-aware client.memories.search, and the per-memory triplet model.
---

# memv-graph

## Required reading

1. `docs/memv/core-concepts/knowledge-graphs.md` — what mem[v] auto-extracts (entities, relationships), how graph built.
2. `docs/memv/sdk/graph.md` — programmatic query method.
3. `docs/memv/core-concepts/search.md` — search ALREADY uses graph; may not need explicit graph queries.

## SDK surface (verified against `docs/memv/sdk/graph.md`)

**Only one method:** `client.graph.retrieve_triplets(memory_id, ...)` (TS: `retrieveTriplets`). Returns triplets `(entity, relationship, entity)` extracted from given memory.

**No `list_entities`, `list_relationships`, or graph-walk traversal API.** Need entities across whole space → query memories via `client.memories.search`, gather triplets from each result.

## When to use this vs plain search

- **Plain semantic search** (`client.memories.search`) graph-aware. Traverses entity neighbors automatically. Use for "find memories about X."
- **Explicit triplets** (`client.graph.retrieve_triplets`) — use when need:
  - Exact (entity, relationship, entity) structure mem[v] extracted from one memory
  - Audit what mem[v] auto-extracted (debugging or building UI)
  - Build entity-centric panels (per-memory → per-entity rollup in your code)

Need expressible as "find memories about X"? Skip this skill — use `memv-search` instead.

## Hard rules

- Triplets per-memory. Space-wide view → fan out: search memories → call `retrieve_triplets` on each.
- No writing to graph directly. Entities + relationships derived from memories. Change graph by changing memories.

## Skeleton (Python)

```python
# get triplets for a known memory
triplets = client.graph.retrieve_triplets(memory_id="mem_xyz789")
for t in triplets:
    print(t.source, "→", t.relation, "→", t.target)
```

## Don't

- No assuming `list_entities` / `list_relationships` / `walk` methods exist. They don't.
- No modeling own entity/relationship layer on top. Use what mem[v] extracted; if wrong, improve memories.
- No traversing graph in Python for what `client.memories.search` does server-side.