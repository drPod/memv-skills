---
name: memv-graph
description: Use when querying or building features on top of the mem[v] knowledge graph — entity extraction, relationship traversal, or anything beyond plain semantic memory search
---

# memv-graph

## Required reading

1. `docs/memv/core-concepts/knowledge-graphs.md` — what mem[v] auto-extracts from memories (entities, relationships) and how the graph is built.
2. `docs/memv/sdk/graph.md` — programmatic query methods.
3. `docs/memv/core-concepts/search.md` — understand how search ALREADY uses the graph; you may not need explicit graph queries.

## When to use this vs plain search

- **Plain semantic search** (`client.memories.search`) is already graph-aware. It traverses entity neighbors automatically. Use it for "find memories about X."
- **Explicit graph queries** (`client.graph.*`) — use when you need:
  - All entities of a given type
  - All relationships between two entities
  - Walking the graph N hops
  - Building entity-centric UI (knowledge panels, profile pages)
  - Auditing what mem[v] auto-extracted from a corpus

If your need can be expressed as "find memories about X", you don't need this skill — use `memv-search` instead.

## Hard rules

- Graphs are per-space. No cross-space traversal.
- Don't try to write to the graph directly. Entities and relationships are derived from memories. To change the graph, change the underlying memories.

## Skeleton (Python)

```python
# fetch entities of a type
entities = client.graph.list_entities(space_id=space_id, entity_type="Person")

# fetch relationships involving an entity
edges = client.graph.list_relationships(space_id=space_id, entity_id=entity_id)
```

(Confirm exact method names against `docs/memv/sdk/graph.md` — they may differ.)

## Don't

- Don't model your own entity/relationship layer on top. Use what mem[v] extracted; if it's wrong, improve the memories.
- Don't traverse the graph in Python for what the SDK can do server-side.
