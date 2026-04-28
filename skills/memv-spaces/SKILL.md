---
name: memv-spaces
description: This skill should be used when the user asks to 'create a memv space', 'list workspaces', 'delete a space', 'design memv tenancy', 'isolate memories per user', or when calling client.spaces.* methods. Covers per-user / per-feature / per-environment partitioning patterns and the no-global-write rule.
---

# memv-spaces

## Required reading

1. `docs/memv/core-concepts/spaces.md` — what a space IS, isolation guarantees, common partitioning patterns.
2. `docs/memv/sdk/spaces.md` — CRUD methods.

## Hard rules

- A space is the ONLY isolation primitive. Memories never cross space boundaries.
- Each space has its own knowledge graph. Cross-space queries do not exist.
- Pick the partitioning early. Migrating memories between spaces is not a documented op.

## Common partitioning patterns

From `core-concepts/spaces.md`:

- **Per user** — `space_id = user_alice_123`. Strongest isolation. Default for multi-tenant apps.
- **Per feature** — `space_id = chat_history`, `space_id = user_preferences`. Isolates feature data.
- **Per environment** — `space_id = prod_users`, `space_id = staging_users`. Prevents test pollution.

Choose ONE. Don't combine without reading the doc — combinations multiply spaces fast.

## Skeleton (Python)

```python
# create
space = client.spaces.create(name="user_alice_123", metadata={"tier": "pro"})
space_id = space.space_id

# list
for s in client.spaces.list():
    print(s.space_id, s.name)

# delete (irreversible — drops all memories in the space)
client.spaces.delete(space_id=space_id)
```

## Find existing space IDs (dev-time)

```
mcp__memv__list_workspaces()
```

(`workspaceId` in MCP == `space_id` in SDK.)

## Don't

- Don't write a "default" space that all memories fall back to. That's the global-write antipattern.
- Don't `delete` without confirmation — irreversible.
