# Memories

> Add and search memories

Memories are structured pieces of information extracted from your content. Mem[v] automatically processes text, files, videos, and other content to create searchable memories.

## Add a memory

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  client = Memv()

  # Add a simple memory
  response = client.memories.add(
      space_id="space_abc123",
      content="The user prefers dark mode and uses Python for development",
      metadata={
          "source": "preferences",
          "user_id": "user_123"
      }
  )

  print(f"Memory ID: {response.memory_id}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  // Add a simple memory
  const response = await client.memories.add({
    space_id: 'space_abc123',
    content: 'The user prefers dark mode and uses TypeScript for development',
    metadata: {
      source: 'preferences',
      user_id: 'user_123',
    },
  });

  console.log(`Memory ID: ${response.memory_id}`);
  ```
</CodeGroup>

### Add conversation memories

<CodeGroup>
  ```python Python theme={null}
  # Add conversation memory
  response = client.memories.add(
      space_id="space_abc123",
      content="User asked about implementing authentication in FastAPI. Prefers JWT tokens.",
      metadata={
          "type": "conversation",
          "topic": "authentication",
          "timestamp": "2026-02-14T10:30:00Z"
      }
  )
  ```

  ```typescript TypeScript theme={null}
  // Add conversation memory
  const response = await client.memories.add({
    space_id: 'space_abc123',
    content: 'User asked about implementing authentication in Next.js. Prefers NextAuth.js.',
    metadata: {
      type: 'conversation',
      topic: 'authentication',
      timestamp: new Date().toISOString(),
    },
  });
  ```
</CodeGroup>

### Add structured data

<CodeGroup>
  ```python Python theme={null}
  # Add structured memory with entities
  client.memories.add(
      space_id="space_abc123",
      content="Sarah Chen is the VP of Engineering at Acme Corp. She uses React and TypeScript.",
      metadata={
          "entities": ["Sarah Chen", "Acme Corp", "React", "TypeScript"],
          "type": "profile"
      }
  )
  ```

  ```typescript TypeScript theme={null}
  // Add structured memory with entities
  await client.memories.add({
    space_id: 'space_abc123',
    content: 'Sarah Chen is the VP of Engineering at Acme Corp. She uses React and TypeScript.',
    metadata: {
      entities: ['Sarah Chen', 'Acme Corp', 'React', 'TypeScript'],
      type: 'profile',
    },
  });
  ```
</CodeGroup>

## Search memories

<CodeGroup>
  ```python Python theme={null}
  # Search for memories
  results = client.memories.search(
      space_id="space_abc123",
      query="What programming languages does the user prefer?",
      limit=10
  )

  # Process results
  for memory in results.memories:
      print(f"Score: {memory.score}")
      print(f"Content: {memory.content}")
      print(f"Metadata: {memory.metadata}")
      print("---")
  ```

  ```typescript TypeScript theme={null}
  // Search for memories
  const results = await client.memories.search({
    space_id: 'space_abc123',
    query: 'What technologies does the user prefer?',
    limit: 10,
  });

  // Process results
  for (const memory of results.memories) {
    console.log(`Score: ${memory.score}`);
    console.log(`Content: ${memory.content}`);
    console.log(`Metadata:`, memory.metadata);
    console.log('---');
  }
  ```
</CodeGroup>

### Search with filters

<CodeGroup>
  ```python Python theme={null}
  # Search with metadata filters
  results = client.memories.search(
      space_id="space_abc123",
      query="authentication",
      filters={
          "type": "conversation",
          "topic": "authentication"
      },
      limit=5
  )
  ```

  ```typescript TypeScript theme={null}
  // Search with metadata filters
  const results = await client.memories.search({
    space_id: 'space_abc123',
    query: 'authentication',
    filters: {
      type: 'conversation',
      topic: 'authentication',
    },
    limit: 5,
  });
  ```
</CodeGroup>

## Semantic search

Mem[v] uses semantic search to find relevant memories even when exact keywords don't match:

<CodeGroup>
  ```python Python theme={null}
  # Query: "How does the user like their UI?"
  # Will match: "The user prefers dark mode"
  results = client.memories.search(
      space_id="space_abc123",
      query="How does the user like their UI?"
  )

  for memory in results.memories:
      print(memory.content)
      # Output: "The user prefers dark mode and uses Python for development"
  ```

  ```typescript TypeScript theme={null}
  // Query: "How does the user like their UI?"
  // Will match: "The user prefers dark mode"
  const results = await client.memories.search({
    space_id: 'space_abc123',
    query: 'How does the user like their UI?',
  });

  for (const memory of results.memories) {
    console.log(memory.content);
    // Output: "The user prefers dark mode and uses TypeScript for development"
  }
  ```
</CodeGroup>

## Common patterns

### Store user preferences

<CodeGroup>
  ```python Python theme={null}
  def save_user_preference(user_id: str, preference: str):
      return client.memories.add(
          space_id=f"user_{user_id}_prefs",
          content=preference,
          metadata={
              "user_id": user_id,
              "type": "preference",
              "timestamp": datetime.now().isoformat()
          }
      )

  # Usage
  save_user_preference("user_123", "Prefers concise responses")
  ```

  ```typescript TypeScript theme={null}
  async function saveUserPreference(
    userId: string,
    preference: string
  ): Promise<void> {
    await client.memories.add({
      space_id: `user_${userId}_prefs`,
      content: preference,
      metadata: {
        user_id: userId,
        type: 'preference',
        timestamp: new Date().toISOString(),
      },
    });
  }

  // Usage
  await saveUserPreference('user_123', 'Prefers concise responses');
  ```
</CodeGroup>

### Build conversation history

<CodeGroup>
  ```python Python theme={null}
  def add_conversation_turn(space_id: str, role: str, message: str):
      return client.memories.add(
          space_id=space_id,
          content=f"{role}: {message}",
          metadata={
              "role": role,
              "timestamp": datetime.now().isoformat()
          }
      )

  # Usage
  add_conversation_turn("conv_123", "user", "How do I deploy a FastAPI app?")
  add_conversation_turn("conv_123", "assistant", "You can deploy FastAPI using...")
  ```

  ```typescript TypeScript theme={null}
  async function addConversationTurn(
    spaceId: string,
    role: 'user' | 'assistant',
    message: string
  ): Promise<void> {
    await client.memories.add({
      space_id: spaceId,
      content: `${role}: ${message}`,
      metadata: {
        role,
        timestamp: new Date().toISOString(),
      },
    });
  }

  // Usage
  await addConversationTurn('conv_123', 'user', 'How do I deploy a Next.js app?');
  await addConversationTurn('conv_123', 'assistant', 'You can deploy Next.js using...');
  ```
</CodeGroup>

### Get relevant context for AI

<CodeGroup>
  ```python Python theme={null}
  def get_relevant_context(space_id: str, query: str, limit: int = 5) -> str:
      """Get relevant memories as context string."""
      results = client.memories.search(
          space_id=space_id,
          query=query,
          limit=limit
      )

      return "\n\n".join([m.content for m in results.memories])

  # Usage in a chatbot
  user_query = "What are the user's preferences?"
  context = get_relevant_context("user_space", user_query)

  # Pass context to your LLM
  response = llm.generate(
      prompt=f"Context: {context}\n\nUser: {user_query}"
  )
  ```

  ```typescript TypeScript theme={null}
  async function getRelevantContext(
    spaceId: string,
    query: string,
    limit: number = 5
  ): Promise<string> {
    const results = await client.memories.search({
      space_id: spaceId,
      query,
      limit,
    });

    return results.memories
      .map(m => m.content)
      .join('\n\n');
  }

  // Usage in a chatbot
  const userQuery = "What are the user's preferences?";
  const context = await getRelevantContext('user_space', userQuery);

  // Pass context to your LLM
  const response = await llm.generate({
    prompt: `Context: ${context}\n\nUser: ${userQuery}`,
  });
  ```
</CodeGroup>

## Best practices

<AccordionGroup>
  <Accordion title="Add context with metadata">
    Include relevant metadata to make memories more searchable:

    <CodeGroup>
      ```python Python theme={null}
      client.memories.add(
          space_id="space_abc123",
          content="User reported bug in login flow",
          metadata={
              "type": "bug_report",
              "severity": "high",
              "feature": "authentication",
              "reported_by": "user_123",
              "timestamp": datetime.now().isoformat()
          }
      )
      ```

      ```typescript TypeScript theme={null}
      await client.memories.add({
        space_id: 'space_abc123',
        content: 'User reported bug in login flow',
        metadata: {
          type: 'bug_report',
          severity: 'high',
          feature: 'authentication',
          reported_by: 'user_123',
          timestamp: new Date().toISOString(),
        },
      });
      ```
    </CodeGroup>
  </Accordion>

  <Accordion title="Use clear, descriptive content">
    Write memory content that is self-contained and easy to understand.

    **Good:** `"User prefers email notifications for important updates only"`

    **Less good:** `"email - important only"`
  </Accordion>

  <Accordion title="Search with specific queries">
    More specific queries return more relevant results.

    **Specific:** `"What is the user's preferred framework for backend development?"`

    **Vague:** `"framework"`
  </Accordion>
</AccordionGroup>

## Error handling

<CodeGroup>
  ```python Python theme={null}
  import memvai

  try:
      response = client.memories.add(
          space_id="space_abc123",
          content="Important user preference"
      )
      print(f"Created memory: {response.memory_id}")
  except memvai.NotFoundError:
      print("Space not found")
  except memvai.UnprocessableEntityError as e:
      print(f"Invalid content: {e.message}")
  except memvai.APIError as e:
      print(f"API error: {e}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  try {
    const response = await client.memories.add({
      space_id: 'space_abc123',
      content: 'Important user preference',
    });
    console.log(`Created memory: ${response.memory_id}`);
  } catch (error) {
    if (error instanceof Memv.NotFoundError) {
      console.error('Space not found');
    } else if (error instanceof Memv.UnprocessableEntityError) {
      console.error('Invalid content:', error.message);
    } else if (error instanceof Memv.APIError) {
      console.error('API error:', error.status, error.message);
    }
  }
  ```
</CodeGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Files" icon="file" href="/sdk/files">
    Upload files to extract memories
  </Card>

  <Card title="Knowledge graphs" icon="diagram-project" href="/sdk/graph">
    Build knowledge graphs from memories
  </Card>
</CardGroup>
