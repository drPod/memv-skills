---
name: memv-spaces
description: This skill should be used when the user asks to 'create a memv space', 'list workspaces', 'delete a space', 'design memv tenancy', 'isolate memories per user', or when calling client.spaces.* methods. Covers per-user / per-feature / per-environment partitioning patterns and the no-global-write rule.
---

# memv-spaces

## Required reading

1. `docs/memv/core-concepts/spaces.md` — what space IS, isolation guarantees, partitioning patterns.
2. `docs/memv/sdk/spaces.md` — CRUD methods.

## Hard rules

- Space = ONLY isolation primitive. Memories never cross space boundaries.
- Each space own knowledge graph. Cross-space queries don't exist.
- Pick partitioning early. Migrating memories between spaces not documented op.

## Common partitioning patterns

From `core-concepts/spaces.md`:

- **Per user** — `space_id = user_alice_123`. Strongest isolation. Default for multi-tenant apps.
- **Per feature** — `space_id = chat_history`, `space_id = user_preferences`. Isolates feature data.
- **Per environment** — `space_id = prod_users`, `space_id = staging_users`. Prevents test pollution.

Pick ONE. No combining without reading doc — combinations multiply spaces fast.

## Skeleton (Python)

```python
# create
space = client.spaces.create(name="user_alice_123", metadata={"tier": "pro"})
space_id = space.space_id

# list
for s in client.spaces.list():
    print(s.space_id, s.name)

# delete (irreversible — drops all memories in space)
client.spaces.delete(space_id=space_id)
```

## Find existing space IDs (dev-time)

```
mcp__memv__list_workspaces()
```

(`workspaceId` MCP == `space_id` SDK.)

## Don't

- No "default" space all memories fall back to. Global-write antipattern.
- No `delete` without confirmation — irreversible.