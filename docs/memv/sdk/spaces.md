# Spaces

> Create and manage memory spaces

Spaces are isolated containers for organizing memories. Each space has its own set of memories, files, and configuration.

## Create a space

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  client = Memv()

  # Create a new space
  response = client.spaces.create(
      name="Personal Assistant",
      description="Memories for my AI assistant"
  )

  space = response.space
  print(f"Created space: {space.id}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  // Create a new space
  const response = await client.spaces.create({
    name: 'Personal Assistant',
    description: 'Memories for my AI assistant',
  });

  const { space } = response;
  console.log(`Created space: ${space.id}`);
  ```
</CodeGroup>

### Response structure

The response contains a `space` object with the following fields:

* `id` - Unique space identifier
* `name` - Space name
* `description` - Space description
* `created_at` - Creation timestamp
* `updated_at` - Last update timestamp

## List spaces

<CodeGroup>
  ```python Python theme={null}
  # List all spaces
  response = client.spaces.list()

  for space in response.spaces:
      print(f"{space.name} ({space.id})")
  ```

  ```typescript TypeScript theme={null}
  // List all spaces
  const response = await client.spaces.list();

  for (const space of response.spaces) {
    console.log(`${space.name} (${space.id})`);
  }
  ```
</CodeGroup>

## Retrieve a space

<CodeGroup>
  ```python Python theme={null}
  # Get space by ID
  response = client.spaces.retrieve(space_id="space_abc123")

  space = response.space
  print(f"Name: {space.name}")
  print(f"Description: {space.description}")
  ```

  ```typescript TypeScript theme={null}
  // Get space by ID
  const response = await client.spaces.retrieve('space_abc123');

  const { space } = response;
  console.log(`Name: ${space.name}`);
  console.log(`Description: ${space.description}`);
  ```
</CodeGroup>

## Update a space

<CodeGroup>
  ```python Python theme={null}
  # Update space details
  response = client.spaces.update(
      space_id="space_abc123",
      name="Updated Name",
      description="Updated description"
  )

  space = response.space
  print(f"Updated: {space.name}")
  ```

  ```typescript TypeScript theme={null}
  // Update space details
  const response = await client.spaces.update({
    space_id: 'space_abc123',
    name: 'Updated Name',
    description: 'Updated description',
  });

  console.log(`Updated: ${response.space.name}`);
  ```
</CodeGroup>

## Delete a space

<CodeGroup>
  ```python Python theme={null}
  # Delete a space
  response = client.spaces.delete(space_id="space_abc123")

  if response.success:
      print("Space deleted successfully")
  ```

  ```typescript TypeScript theme={null}
  // Delete a space
  const response = await client.spaces.delete({
    space_id: 'space_abc123',
  });

  if (response.success) {
    console.log('Space deleted successfully');
  }
  ```
</CodeGroup>

<Warning>
  Deleting a space permanently removes all memories, files, and data associated with it. This action cannot be undone.
</Warning>

## Get space statistics

<CodeGroup>
  ```python Python theme={null}
  # Get space stats
  stats = client.spaces.get_stats()

  print(f"Total memories: {stats.total_memories}")
  print(f"Total files: {stats.total_files}")
  print(f"Storage used: {stats.storage_bytes} bytes")
  ```

  ```typescript TypeScript theme={null}
  // Get space stats
  const stats = await client.spaces.getStats();

  console.log(`Total memories: ${stats.total_memories}`);
  console.log(`Total files: ${stats.total_files}`);
  console.log(`Storage used: ${stats.storage_bytes} bytes`);
  ```
</CodeGroup>

## Common patterns

### Create space if not exists

<CodeGroup>
  ```python Python theme={null}
  def get_or_create_space(client: Memv, name: str) -> str:
      """Get existing space by name or create new one."""
      # List existing spaces
      response = client.spaces.list()

      # Find by name
      for space in response.spaces:
          if space.name == name:
              return space.id

      # Create new space
      response = client.spaces.create(name=name)
      return response.space.id

  # Usage
  space_id = get_or_create_space(client, "My App")
  ```

  ```typescript TypeScript theme={null}
  async function getOrCreateSpace(
    client: Memv,
    name: string
  ): Promise<string> {
    // List existing spaces
    const { spaces } = await client.spaces.list();

    // Find by name
    const existing = spaces.find(s => s.name === name);
    if (existing) {
      return existing.id;
    }

    // Create new space
    const { space } = await client.spaces.create({ name });
    return space.id;
  }

  // Usage
  const spaceId = await getOrCreateSpace(client, 'My App');
  ```
</CodeGroup>

### Batch operations

<CodeGroup>
  ```python Python theme={null}
  def create_multiple_spaces(names: list[str]) -> list[str]:
      """Create multiple spaces."""
      space_ids = []

      for name in names:
          response = client.spaces.create(name=name)
          space_ids.append(response.space.id)

      return space_ids

  # Usage
  space_ids = create_multiple_spaces([
      "User Preferences",
      "Chat History",
      "Knowledge Base"
  ])
  ```

  ```typescript TypeScript theme={null}
  async function createMultipleSpaces(
    names: string[]
  ): Promise<string[]> {
    const promises = names.map(name =>
      client.spaces.create({ name })
    );

    const responses = await Promise.all(promises);
    return responses.map(r => r.space.id);
  }

  // Usage
  const spaceIds = await createMultipleSpaces([
    'User Preferences',
    'Chat History',
    'Knowledge Base',
  ]);
  ```
</CodeGroup>

## Best practices

<AccordionGroup>
  <Accordion title="Organize by use case">
    Create separate spaces for different use cases or users:

    <CodeGroup>
      ```python Python theme={null}
      # User-specific spaces
      user_space = client.spaces.create(
          name=f"User {user_id} - Preferences",
          description="User preferences and settings"
      )

      # Feature-specific spaces
      chat_space = client.spaces.create(
          name="Chat History",
          description="Conversation memories"
      )
      ```

      ```typescript TypeScript theme={null}
      // User-specific spaces
      const userSpace = await client.spaces.create({
        name: `User ${userId} - Preferences`,
        description: 'User preferences and settings',
      });

      // Feature-specific spaces
      const chatSpace = await client.spaces.create({
        name: 'Chat History',
        description: 'Conversation memories',
      });
      ```
    </CodeGroup>
  </Accordion>

  <Accordion title="Use descriptive names">
    Give spaces clear, descriptive names that indicate their purpose.
  </Accordion>

  <Accordion title="Clean up unused spaces">
    Regularly delete spaces that are no longer needed to manage costs.
  </Accordion>
</AccordionGroup>

## Error handling

<CodeGroup>
  ```python Python theme={null}
  import memvai
  from memvai import Memv

  client = Memv()

  try:
      response = client.spaces.create(name="My Space")
      space_id = response.space.id
      print(f"Created: {space_id}")
  except memvai.AuthenticationError:
      print("Invalid API key")
  except memvai.BadRequestError as e:
      print(f"Invalid request: {e.message}")
  except memvai.APIError as e:
      print(f"API error: {e}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  try {
    const response = await client.spaces.create({
      name: 'My Space',
    });
    console.log(`Created: ${response.space.id}`);
  } catch (error) {
    if (error instanceof Memv.AuthenticationError) {
      console.error('Invalid API key');
    } else if (error instanceof Memv.BadRequestError) {
      console.error('Invalid request:', error.message);
    } else if (error instanceof Memv.APIError) {
      console.error('API error:', error.status, error.message);
    }
  }
  ```
</CodeGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Memories" icon="brain" href="/sdk/memories">
    Add memories to your space
  </Card>

  <Card title="Files" icon="file" href="/sdk/files">
    Upload files to your space
  </Card>
</CardGroup>
