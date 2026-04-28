# Quickstart

> Get started with Mem[v] in minutes

Add long-term memory to your AI agents in three simple steps.

## Get your API key

Sign up and get your API key from the [Mem[v] Dashboard](https://app.memv.ai/).

```bash theme={null}
export MEMV_API_KEY="your-api-key-here"
```

## Install the SDK

<CodeGroup>
  ```bash Python theme={null}
  pip install memvai
  ```

  ```bash npm theme={null}
  npm install memvai
  ```

  ```bash pnpm theme={null}
  pnpm add memvai
  ```

  ```bash yarn theme={null}
  yarn add memvai
  ```
</CodeGroup>

## Build your first memory-enabled app

<Steps>
  <Step title="Create a space">
    Spaces organize memories for different contexts or users.

    <CodeGroup>
      ```python Python theme={null}
      from memvai import Memv

      client = Memv()

      # Create a space
      response = client.spaces.create(
          name="My AI Assistant",
          description="Personal assistant memories"
      )
      space_id = response.space.id

      print(f"Created space: {space_id}")
      ```

      ```typescript TypeScript theme={null}
      import Memv from 'memvai';

      const client = new Memv();

      // Create a space
      const response = await client.spaces.create({
        name: 'My AI Assistant',
        description: 'Personal assistant memories',
      });
      const spaceId = response.space.id;

      console.log(`Created space: ${spaceId}`);
      ```
    </CodeGroup>
  </Step>

  <Step title="Add memories">
    Add text, upload files, or import from connectors.

    <CodeGroup>
      ```python Python theme={null}
      # Add a text memory
      memory = client.memories.add(
          space_id=space_id,
          content="User prefers concise responses without small talk"
      )

      # Upload a file
      with open("meeting_notes.pdf", "rb") as file:
          batch = client.upload.batch.create(
              space_id=space_id,
              files=[file]
          )
      ```

      ```typescript TypeScript theme={null}
      // Add a text memory
      await client.memories.add({
        space_id: spaceId,
        content: 'User prefers concise responses without small talk',
      });

      // Upload a file (Node.js)
      import fs from 'fs';

      const file = fs.createReadStream('meeting_notes.pdf');
      await client.upload.batch.create({
        space_id: spaceId,
        files: [file],
      });
      ```
    </CodeGroup>
  </Step>

  <Step title="Search memories">
    Query memories using natural language.

    <CodeGroup>
      ```python Python theme={null}
      # Search for relevant memories
      results = client.memories.search(
          space_id=space_id,
          query="What are the user's communication preferences?"
      )

      for memory in results.memories:
          print(f"- {memory.content}")
      ```

      ```typescript TypeScript theme={null}
      // Search for relevant memories
      const results = await client.memories.search({
        space_id: spaceId,
        query: "What are the user's communication preferences?",
      });

      for (const memory of results.memories) {
        console.log(`- ${memory.content}`);
      }
      ```
    </CodeGroup>
  </Step>
</Steps>

## Complete example

Here's a complete example of a memory-enabled chatbot:

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  # Initialize client
  client = Memv()

  # Create or get space
  response = client.spaces.create(name="Chatbot Memory")
  space_id = response.space.id

  def chat_with_memory(user_message: str) -> str:
      """Process user message with memory context."""

      # 1. Search for relevant memories
      memories = client.memories.search(
          space_id=space_id,
          query=user_message,
          limit=5
      )

      # 2. Build context from memories
      context = "\n".join([m.content for m in memories.memories])

      # 3. Generate response (using your LLM of choice)
      # response = your_llm.generate(
      #     prompt=f"Context: {context}\n\nUser: {user_message}",
      # )

      # 4. Store the conversation as a new memory
      client.memories.add(
          space_id=space_id,
          content=f"User: {user_message}\nAssistant: {response}"
      )

      return response

  # Use it
  response = chat_with_memory("What features should we prioritize?")
  print(response)
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  // Initialize client
  const client = new Memv();

  // Create or get space
  const response = await client.spaces.create({ name: 'Chatbot Memory' });
  const spaceId = response.space.id;

  async function chatWithMemory(userMessage: string): Promise<string> {
    // 1. Search for relevant memories
    const memories = await client.memories.search({
      space_id: spaceId,
      query: userMessage,
      limit: 5,
    });

    // 2. Build context from memories
    const context = memories.memories
      .map(m => m.content)
      .join('\n');

    // 3. Generate response (using your LLM of choice)
    // const response = await yourLLM.generate({
    //   prompt: `Context: ${context}\n\nUser: ${userMessage}`,
    // });

    // 4. Store the conversation as a new memory
    await client.memories.add({
      space_id: spaceId,
      content: `User: ${userMessage}\nAssistant: ${response}`,
    });

    return response;
  }

  // Use it
  const response = await chatWithMemory('What features should we prioritize?');
  console.log(response);
  ```
</CodeGroup>

## What's next?

<CardGroup cols={2}>
  <Card title="SDK Documentation" icon="code" href="/sdk/installation">
    Explore all SDK features
  </Card>

  <Card title="Core Concepts" icon="lightbulb" href="/core-concepts/how-it-works">
    Understand how Mem[v] works under the hood
  </Card>

  <Card title="Use Cases" icon="sparkles" href="/use-cases/healthcare">
    Explore real-world applications
  </Card>

  <Card title="Connectors" icon="plug" href="/connectors/gmail-connector">
    Connect your data sources
  </Card>
</CardGroup>

## Need help?

<CardGroup cols={2}>
  <Card title="Join Discord" icon="discord" href="https://discord.gg/memv">
    Chat with the community
  </Card>

  <Card title="GitHub" icon="github" href="https://github.com/mem-v">
    View source code and examples
  </Card>
</CardGroup>
