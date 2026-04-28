# Spaces

> Organize and isolate memories with Spaces

Spaces are isolated containers for organizing memories. Each space maintains its own knowledge graph, ensuring complete data separation.

## What is a Space?

A Space provides:

* Complete isolation: memories never cross space boundaries
* Independent knowledge graphs per space
* Flexible organization for any use case

## Organization patterns

### By user

```
Space: user_alice_123
├── Preferences and settings
├── Conversation history
└── Personal knowledge

Space: user_bob_456
├── Preferences and settings
├── Conversation history
└── Personal knowledge
```

### By feature

```
Space: chat_history
└── All conversation turns

Space: user_preferences
└── Settings and configurations

Space: knowledge_base
└── Product documentation
```

### By environment

```
Space: prod_app
└── Production data

Space: dev_testing
└── Test data

Space: staging
└── Staging data
```

## Create and manage spaces

<CodeGroup>
  ```python Python theme={null}
  # Create
  response = client.spaces.create(
      name="My Application",
      description="Main memory space"
  )
  space_id = response.space.id

  # List
  response = client.spaces.list()
  for space in response.spaces:
      print(f"{space.name}: {space.id}")

  # Delete
  client.spaces.delete(space_id=space_id)
  ```

  ```typescript TypeScript theme={null}
  // Create
  const response = await client.spaces.create({
    name: 'My Application',
    description: 'Main memory space',
  });
  const spaceId = response.space.id;

  // List
  const response = await client.spaces.list();
  for (const space of response.spaces) {
    console.log(`${space.name}: ${space.id}`);
  }

  // Delete
  await client.spaces.delete({ space_id: spaceId });
  ```
</CodeGroup>

<Warning>
  Deleting a space permanently removes all memories, files, and knowledge graphs. This cannot be undone.
</Warning>

## Best practices

* Use descriptive names
* Plan your isolation strategy early
* One space per user for privacy
* Don't over-partition (avoid one space per conversation)
* Clean up unused spaces regularly

## Next steps

<CardGroup cols={2}>
  <Card title="Memories" icon="brain" href="/core-concepts/memories">
    Add and manage memories
  </Card>

  <Card title="Knowledge Graphs" icon="diagram-project" href="/core-concepts/knowledge-graphs">
    Build connected knowledge
  </Card>

  <Card title="SDK: Spaces" icon="code" href="/sdk/spaces">
    SDK documentation
  </Card>
</CardGroup>
