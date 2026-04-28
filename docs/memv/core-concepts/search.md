# Semantic search

> Graph-aware semantic search for AI agents

Mem[v] provides graph-aware semantic search that finds information by meaning and automatically includes connected entities and relationships.

## How it works

Semantic search uses:

* Embedding-based similarity for meaning
* Knowledge graph traversal for connected information
* Entity recognition for precise matches
* Metadata filtering for refined results

## Basic search

<CodeGroup>
  ```python Python theme={null}
  results = client.memories.search(
      space_id="space_123",
      query="What are the user's communication preferences?",
      limit=10
  )

  for memory in results.memories:
      print(f"Score: {memory.score}")
      print(f"Content: {memory.content}")
  ```

  ```typescript TypeScript theme={null}
  const results = await client.memories.search({
    space_id: 'space_123',
    query: 'What are the user\'s communication preferences?',
    limit: 10,
  });

  for (const memory of results.memories) {
    console.log(`Score: ${memory.score}`);
    console.log(`Content: ${memory.content}`);
  }
  ```
</CodeGroup>

## Search results

Each result includes:

* **Relevance score** (0-1): Semantic similarity to query
* **Content**: The extracted information
* **Metadata**: Context and tags
* **Entities**: Extracted people, places, technologies
* **Source**: Original file, timestamp, page number

## Query patterns

### Natural questions

```python theme={null}
"What does the user like for breakfast?"
"Who works in the engineering team?"
"How do I authenticate API requests?"
```

### Entity searches

```python theme={null}
"Sarah Chen"
"Acme Corp"
"Kubernetes deployment"
```

### Conceptual queries

```python theme={null}
"user preferences"
"team structure"
"authentication methods"
```

## Search with filters

Combine semantic search with metadata filters:

<CodeGroup>
  ```python Python theme={null}
  results = client.memories.search(
      space_id="space_123",
      query="bug reports",
      filters={
          "type": "bug_report",
          "severity": "high"
      },
      limit=20
  )
  ```

  ```typescript TypeScript theme={null}
  const results = await client.memories.search({
    space_id: 'space_123',
    query: 'bug reports',
    filters: {
      type: 'bug_report',
      severity: 'high',
    },
    limit: 20,
  });
  ```
</CodeGroup>

## Building AI context

Get relevant context for AI responses:

<CodeGroup>
  ```python Python theme={null}
  def get_context_for_query(user_query: str, space_id: str) -> str:
      results = client.memories.search(
          space_id=space_id,
          query=user_query,
          limit=5
      )
      return "\n\n".join([m.content for m in results.memories])

  # Use in AI prompt
  context = get_context_for_query("How should I configure the database?", "docs_space")
  prompt = f"Context: {context}\n\nQuestion: {user_query}"
  ```

  ```typescript TypeScript theme={null}
  async function getContextForQuery(userQuery: string, spaceId: string) {
    const results = await client.memories.search({
      space_id: spaceId,
      query: userQuery,
      limit: 5,
    });
    return results.memories.map(m => m.content).join('\n\n');
  }

  // Use in AI prompt
  const context = await getContextForQuery('How should I configure the database?', 'docs_space');
  const prompt = `Context: ${context}\n\nQuestion: ${userQuery}`;
  ```
</CodeGroup>

## Best practices

* **Be specific**: "What is the user's preferred auth method?" vs "auth"
* **Use natural language**: Ask complete questions
* **Adjust limit**: 5-10 for AI context, 20-50 for comprehensive search
* **Combine with filters**: Use metadata to narrow results
* **Check scores**: Filter by relevance threshold if needed

## Next steps

<CardGroup cols={2}>
  <Card title="Knowledge Graphs" icon="diagram-project" href="/core-concepts/knowledge-graphs">
    Discover connected information
  </Card>

  <Card title="SDK: Memories" icon="code" href="/sdk/memories">
    SDK search documentation
  </Card>
</CardGroup>
