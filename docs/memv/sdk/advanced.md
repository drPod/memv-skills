# Advanced usage

> Advanced features and patterns

Explore advanced features of the Mem[v] SDK including custom HTTP clients, raw responses, proxies, and more.

## Raw response access

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  client = Memv()

  # Get raw response with headers
  response = client.spaces.with_raw_response().list()

  # Access headers
  print(response.headers.get('X-Request-ID'))
  print(response.headers.get('X-RateLimit-Remaining'))

  # Parse the response
  spaces = response.parse()
  print(spaces.spaces)
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  // Get raw response
  const response = await client.spaces.list().asResponse();
  console.log(response.headers.get('X-Request-ID'));

  // Get both parsed data and raw response
  const { data, response: raw } = await client.spaces.list().withResponse();
  console.log(raw.headers.get('X-RateLimit-Remaining'));
  console.log(data.spaces);
  ```
</CodeGroup>

## Custom HTTP client

<Tabs>
  <Tab title="Python">
    ```python theme={null}
    import httpx
    from memvai import Memv, DefaultHttpxClient

    # Custom HTTP client with proxy
    client = Memv(
        http_client=DefaultHttpxClient(
            proxy="http://proxy.example.com:8080"
        )
    )
    ```
  </Tab>

  <Tab title="TypeScript">
    ```typescript theme={null}
    import Memv from 'memvai';
    import fetch from 'node-fetch';

    const client = new Memv({
      fetch: fetch as any,
    });
    ```
  </Tab>
</Tabs>

## Configure proxies

<Tabs>
  <Tab title="Python">
    ```python theme={null}
    import httpx
    from memvai import Memv, DefaultHttpxClient

    client = Memv(
        http_client=DefaultHttpxClient(
            proxy="http://localhost:8888"
        )
    )
    ```
  </Tab>

  <Tab title="Node.js">
    ```typescript theme={null}
    import Memv from 'memvai';
    import * as undici from 'undici';

    const proxyAgent = new undici.ProxyAgent('http://localhost:8888');

    const client = new Memv({
      fetchOptions: {
        dispatcher: proxyAgent,
      },
    });
    ```
  </Tab>

  <Tab title="Bun">
    ```typescript theme={null}
    import Memv from 'memvai';

    const client = new Memv({
      fetchOptions: {
        proxy: 'http://localhost:8888',
      },
    });
    ```
  </Tab>

  <Tab title="Deno">
    ```typescript theme={null}
    import Memv from 'npm:memvai';

    const httpClient = Deno.createHttpClient({
      proxy: { url: 'http://localhost:8888' },
    });

    const client = new Memv({
      fetchOptions: {
        client: httpClient,
      },
    });
    ```
  </Tab>
</Tabs>

## Concurrent operations

### Parallel requests

<CodeGroup>
  ```python Python theme={null}
  import asyncio
  from memvai import AsyncMemv

  async def main():
      client = AsyncMemv()

      # Execute multiple requests in parallel
      spaces_task = client.spaces.list()
      stats_task = client.spaces.get_stats()

      spaces, stats = await asyncio.gather(spaces_task, stats_task)

      print(f"Spaces: {len(spaces.spaces)}")
      print(f"Total memories: {stats.total_memories}")

  asyncio.run(main())
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  // Execute multiple requests in parallel
  const [spaces, stats] = await Promise.all([
    client.spaces.list(),
    client.spaces.getStats(),
  ]);

  console.log(`Spaces: ${spaces.spaces.length}`);
  console.log(`Total memories: ${stats.total_memories}`);
  ```
</CodeGroup>

### Batch uploads

<CodeGroup>
  ```python Python theme={null}
  async def upload_files_parallel(space_id: str, file_paths: list[str]):
      """Upload multiple files concurrently."""
      client = AsyncMemv()

      async def upload_file(file_path: str):
          with open(file_path, 'rb') as f:
              return await client.upload.batch.create(
                  space_id=space_id,
                  files=[f]
              )

      # Upload all files concurrently
      tasks = [upload_file(path) for path in file_paths]
      results = await asyncio.gather(*tasks)

      return [r.batch_id for r in results]

  # Usage
  files = ["doc1.pdf", "doc2.pdf", "doc3.pdf"]
  batch_ids = asyncio.run(upload_files_parallel("space_abc123", files))
  ```

  ```typescript TypeScript theme={null}
  async function uploadFilesParallel(
    spaceId: string,
    filePaths: string[]
  ): Promise<string[]> {
    const uploadPromises = filePaths.map(async filePath => {
      const file = fs.createReadStream(filePath);
      const response = await client.upload.batch.create({
        space_id: spaceId,
        files: [file],
      });
      return response.batch_id;
    });

    return await Promise.all(uploadPromises);
  }

  // Usage
  const files = ['doc1.pdf', 'doc2.pdf', 'doc3.pdf'];
  const batchIds = await uploadFilesParallel('space_abc123', files);
  ```
</CodeGroup>

## Custom logging

<CodeGroup>
  ```python Python theme={null}
  import logging
  from memvai import Memv

  # Configure logging
  logging.basicConfig(level=logging.INFO)
  logger = logging.getLogger(__name__)

  client = Memv()

  # Logging is automatic with MEMV_LOG environment variable
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';
  import pino from 'pino';

  const logger = pino();

  const client = new Memv({
    logger: logger.child({ name: 'Memv' }),
    logLevel: 'debug',
  });
  ```
</CodeGroup>

## Best practices

<AccordionGroup>
  <Accordion title="Reuse client instances">
    Create one client instance and reuse it throughout your application.
  </Accordion>

  <Accordion title="Use async for I/O-bound operations">
    Async is more efficient for multiple concurrent requests.
  </Accordion>

  <Accordion title="Monitor rate limits">
    Track rate limit headers to avoid throttling.
  </Accordion>

  <Accordion title="Implement proper error handling">
    Always handle potential errors gracefully.
  </Accordion>
</AccordionGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Error handling" icon="triangle-exclamation" href="/sdk/error-handling">
    Comprehensive error handling
  </Card>

  <Card title="API Reference" icon="code" href="https://github.com/mem-v/memv-python/blob/main/api.md">
    Complete API documentation
  </Card>
</CardGroup>
