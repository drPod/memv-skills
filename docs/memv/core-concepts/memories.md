# Memories

> Understanding memories and their lifecycle

Memories are structured pieces of information extracted from content. They feed into knowledge graphs and enable semantic retrieval for AI agents.

## What is a Memory?

A memory contains:

* Content: the extracted information
* Metadata: additional context and tags
* Entities: extracted people, places, technologies
* Embeddings: semantic representations for search

## Creating memories

### From text

<CodeGroup>
  ```python Python theme={null}
  client.memories.add(
      space_id="space_123",
      content="User prefers dark mode and concise responses"
  )
  ```

  ```typescript TypeScript theme={null}
  await client.memories.add({
    space_id: 'space_123',
    content: 'User prefers dark mode and concise responses',
  });
  ```
</CodeGroup>

### From files

<CodeGroup>
  ```python Python theme={null}
  with open("meeting_notes.pdf", "rb") as file:
      client.upload.batch.create(
          space_id="space_123",
          files=[file]
      )
  ```

  ```typescript TypeScript theme={null}
  const file = fs.createReadStream('meeting_notes.pdf');
  await client.upload.batch.create({
    space_id: 'space_123',
    files: [file],
  });
  ```
</CodeGroup>

### From videos

<CodeGroup>
  ```python Python theme={null}
  with open("team_meeting.mp4", "rb") as video:
      client.upload.batch.create(
          space_id="space_123",
          files=[video]
      )
  ```

  ```typescript TypeScript theme={null}
  const video = fs.createReadStream('team_meeting.mp4');
  await client.upload.batch.create({
    space_id: 'space_123',
    files: [video],
  });
  ```
</CodeGroup>

Extracts:

* Spoken dialogue (transcription)
* Visual context (on-screen content)
* Text (slides, captions)
* Temporal information

## Memory lifecycle

1. **Creation**: Add via API or upload files
2. **Indexing**: Entities extracted, graph built, embeddings created
3. **Retrieval**: Search by semantic meaning and graph connections
4. **Updates**: New content extends the knowledge graph
5. **Deletion**: Remove when no longer needed

## Use cases

### User preferences

```python theme={null}
client.memories.add(
    space_id=f"user_{user_id}",
    content="User prefers technical explanations",
    metadata={"type": "preference"}
)
```

### Conversation history

```python theme={null}
client.memories.add(
    space_id="conversation_123",
    content=f"User: {user_message}\nAssistant: {assistant_response}"
)
```

### Knowledge bases

```python theme={null}
# Upload documentation
with open("api_docs.pdf", "rb") as file:
    client.upload.batch.create(space_id="docs", files=[file])

# Search later
results = client.memories.search(
    space_id="docs",
    query="How do I authenticate API requests?"
)
```

## Best practices

* Add rich metadata for better filtering
* Use clear, self-contained content
* Organize related memories in the same space
* Include entity relationships in content
* Update when information changes

## Next steps

<CardGroup cols={2}>
  <Card title="Search" icon="magnifying-glass" href="/core-concepts/search">
    Search memories semantically
  </Card>

  <Card title="Knowledge Graphs" icon="diagram-project" href="/core-concepts/knowledge-graphs">
    Understand entity connections
  </Card>

  <Card title="SDK: Memories" icon="code" href="/sdk/memories">
    SDK documentation
  </Card>
</CardGroup>
