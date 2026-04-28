# Installation

> Install and configure the Mem[v] SDK

The Mem[v] SDK provides convenient access to the Mem[v] REST API from Python and TypeScript/JavaScript applications.

## Installation

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

  ```bash bun theme={null}
  bun add memvai
  ```
</CodeGroup>

## Requirements

<Tabs>
  <Tab title="Python">
    * Python 3.9 or higher
    * Works with standard Python and async/await
  </Tab>

  <Tab title="TypeScript/JavaScript">
    * TypeScript 4.9+ (optional, but recommended)
    * Node.js 20 LTS or later
    * Also supports: Deno, Bun, Cloudflare Workers, Vercel Edge Runtime
  </Tab>
</Tabs>

## Authentication

Get your API key from the [Mem[v] Dashboard](https://app.memv.ai/).

### Set up your API key

<CodeGroup>
  ```bash Python theme={null}
  export MEMV_API_KEY="your-api-key-here"
  ```

  ```bash TypeScript theme={null}
  export MEMV_API_KEY="your-api-key-here"
  ```
</CodeGroup>

Or use a `.env` file:

```bash theme={null}
MEMV_API_KEY=your-api-key-here
```

<Warning>
  Never commit your API key to source control. Always use environment variables.
</Warning>

## Quick start

<CodeGroup>
  ```python Python theme={null}
  import os
  from memvai import Memv

  # Initialize the client
  client = Memv(
      api_key=os.environ.get("MEMV_API_KEY"),
  )

  # List all spaces
  response = client.spaces.list()
  for space in response.spaces:
      print(f"{space.name} ({space.id})")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  // Initialize the client
  const client = new Memv({
    apiKey: process.env.MEMV_API_KEY,
  });

  // List all spaces
  const response = await client.spaces.list();
  for (const space of response.spaces) {
    console.log(`${space.name} (${space.id})`);
  }
  ```

  ```javascript JavaScript (CommonJS) theme={null}
  const Memv = require('memvai');

  const client = new Memv({
    apiKey: process.env.MEMV_API_KEY,
  });

  async function main() {
    const response = await client.spaces.list();
    for (const space of response.spaces) {
      console.log(`${space.name} (${space.id})`);
    }
  }

  main();
  ```
</CodeGroup>

## Async usage

<CodeGroup>
  ```python Python theme={null}
  import os
  import asyncio
  from memvai import AsyncMemv

  client = AsyncMemv(
      api_key=os.environ.get("MEMV_API_KEY"),
  )

  async def main():
      response = await client.spaces.list()
      for space in response.spaces:
          print(f"{space.name} ({space.id})")

  asyncio.run(main())
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  // All methods are async by default
  const response = await client.spaces.list();
  console.log(response.spaces);
  ```
</CodeGroup>

## Type support

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv
  from memvai.types import SpaceListResponse

  client = Memv()

  # Full type hints with Pydantic models
  response: SpaceListResponse = client.spaces.list()
  ```

  ```typescript TypeScript theme={null}
  import Memv, { SpaceListResponse } from 'memvai';

  const client = new Memv();

  // Full TypeScript type definitions
  const response: SpaceListResponse = await client.spaces.list();
  ```
</CodeGroup>

## Configuration options

### Timeouts

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  # Set default timeout (20 seconds)
  client = Memv(timeout=20.0)

  # Override per-request
  client.with_options(timeout=5.0).spaces.list()
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  // Set default timeout (20 seconds)
  const client = new Memv({
    timeout: 20 * 1000, // milliseconds
  });

  // Override per-request
  await client.spaces.list({
    timeout: 5 * 1000,
  });
  ```
</CodeGroup>

Default timeout is 60 seconds.

### Retries

<CodeGroup>
  ```python Python theme={null}
  # Configure retries (default is 2)
  client = Memv(max_retries=5)

  # Disable retries
  client = Memv(max_retries=0)

  # Override per-request
  client.with_options(max_retries=3).spaces.list()
  ```

  ```typescript TypeScript theme={null}
  // Configure retries (default is 2)
  const client = new Memv({
    maxRetries: 5,
  });

  // Disable retries
  const client = new Memv({
    maxRetries: 0,
  });

  // Override per-request
  await client.spaces.list({
    maxRetries: 3,
  });
  ```
</CodeGroup>

Automatically retried errors:

* Connection errors
* 408 Request Timeout
* 409 Conflict
* 429 Rate Limit
* 500+ Server errors

### Logging

<CodeGroup>
  ```python Python theme={null}
  # Set via environment variable
  import os
  os.environ['MEMV_LOG'] = 'debug'  # or 'info'

  # Or via client option
  client = Memv(log_level='debug')
  ```

  ```typescript TypeScript theme={null}
  // Set via environment variable
  process.env.MEMV_LOG = 'debug';  // or 'info' | 'warn' | 'error' | 'off'

  // Or via client option
  const client = new Memv({
    logLevel: 'debug',
  });
  ```
</CodeGroup>

## Runtime-specific usage

### Deno

```typescript theme={null}
import Memv from 'npm:memvai';

const client = new Memv({
  apiKey: Deno.env.get('MEMV_API_KEY'),
});
```

### Bun

```typescript theme={null}
import Memv from 'memvai';

const client = new Memv({
  apiKey: process.env.MEMV_API_KEY,
});
```

### Cloudflare Workers

```typescript theme={null}
import Memv from 'memvai';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const client = new Memv({
      apiKey: env.MEMV_API_KEY,
    });

    const spaces = await client.spaces.list();
    return Response.json(spaces.spaces);
  },
};
```

## Working with response objects

<CodeGroup>
  ```python Python theme={null}
  # Extract the data you need
  response = client.spaces.create(name="My Space")
  space_id = response.space.id

  # Or unpack the object
  space = response.space
  print(space.id, space.name)
  ```

  ```typescript TypeScript theme={null}
  // Extract the data you need
  const response = await client.spaces.create({ name: 'My Space' });
  const spaceId = response.space.id;

  // Or destructure
  const { space } = await client.spaces.create({ name: 'My Space' });
  console.log(space.id, space.name);
  ```
</CodeGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Spaces" icon="folder" href="/sdk/spaces">
    Create and manage memory spaces
  </Card>

  <Card title="Memories" icon="brain" href="/sdk/memories">
    Add and search memories
  </Card>

  <Card title="Files" icon="file" href="/sdk/files">
    Upload and manage files
  </Card>

  <Card title="Error handling" icon="triangle-exclamation" href="/sdk/error-handling">
    Handle errors and exceptions
  </Card>
</CardGroup>
