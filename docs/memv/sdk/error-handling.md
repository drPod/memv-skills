# Error handling

> Handle errors and exceptions

The Mem[v] SDK provides comprehensive error handling with specific exception types for different error scenarios.

## Exception types

<Tabs>
  <Tab title="Python">
    ```python theme={null}
    import memvai

    # Base exception
    memvai.APIError

    # Connection errors
    memvai.APIConnectionError
    memvai.APITimeoutError

    # Status code errors
    memvai.BadRequestError        # 400
    memvai.AuthenticationError    # 401
    memvai.PermissionDeniedError  # 403
    memvai.NotFoundError          # 404
    memvai.UnprocessableEntityError  # 422
    memvai.RateLimitError         # 429
    memvai.InternalServerError    # 500+
    ```
  </Tab>

  <Tab title="TypeScript">
    ```typescript theme={null}
    import Memv from 'memvai';

    // Base exception
    Memv.APIError

    // Connection errors
    Memv.APIConnectionError
    Memv.APIConnectionTimeoutError

    // Status code errors
    Memv.BadRequestError        // 400
    Memv.AuthenticationError    // 401
    Memv.PermissionDeniedError  // 403
    Memv.NotFoundError          // 404
    Memv.UnprocessableEntityError  // 422
    Memv.RateLimitError         // 429
    Memv.InternalServerError    // 500+
    ```
  </Tab>
</Tabs>

## Basic error handling

<CodeGroup>
  ```python Python theme={null}
  import memvai
  from memvai import Memv

  client = Memv()

  try:
      spaces = client.spaces.list()
  except memvai.APIError as e:
      print(f"API Error: {e.message}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  try {
    const spaces = await client.spaces.list();
  } catch (error) {
    if (error instanceof Memv.APIError) {
      console.error(`API Error: ${error.message}`);
    }
  }
  ```
</CodeGroup>

## Handle specific errors

### Authentication errors

<CodeGroup>
  ```python Python theme={null}
  try:
      client = Memv(api_key="invalid_key")
      spaces = client.spaces.list()
  except memvai.AuthenticationError:
      print("Invalid API key - check your credentials")
  ```

  ```typescript TypeScript theme={null}
  try {
    const client = new Memv({ apiKey: 'invalid_key' });
    const spaces = await client.spaces.list();
  } catch (error) {
    if (error instanceof Memv.AuthenticationError) {
      console.error('Invalid API key - check your credentials');
    }
  }
  ```
</CodeGroup>

### Not found errors

<CodeGroup>
  ```python Python theme={null}
  try:
      space = client.spaces.retrieve(space_id="non_existent")
  except memvai.NotFoundError:
      print("Space not found")
      # Create the space or handle missing resource
  ```

  ```typescript TypeScript theme={null}
  try {
    const space = await client.spaces.retrieve('non_existent');
  } catch (error) {
    if (error instanceof Memv.NotFoundError) {
      console.error('Space not found');
      // Create the space or handle missing resource
    }
  }
  ```
</CodeGroup>

### Rate limiting

<CodeGroup>
  ```python Python theme={null}
  import time

  try:
      for i in range(1000):
          client.memories.add(
              space_id="space_abc123",
              content=f"Memory {i}"
          )
  except memvai.RateLimitError as e:
      print("Rate limit exceeded")
      retry_after = e.response.headers.get('Retry-After', 60)
      print(f"Waiting {retry_after} seconds...")
      time.sleep(int(retry_after))
  ```

  ```typescript TypeScript theme={null}
  try {
    for (let i = 0; i < 1000; i++) {
      await client.memories.add({
        space_id: 'space_abc123',
        content: `Memory ${i}`,
      });
    }
  } catch (error) {
    if (error instanceof Memv.RateLimitError) {
      console.error('Rate limit exceeded');
      const retryAfter = error.headers?.['retry-after'] || 60;
      console.log(`Waiting ${retryAfter} seconds...`);
      await new Promise(r => setTimeout(r, retryAfter * 1000));
    }
  }
  ```
</CodeGroup>

## Access error details

<CodeGroup>
  ```python Python theme={null}
  try:
      client.spaces.create(name="")
  except memvai.APIStatusError as e:
      print(f"Status: {e.status_code}")
      print(f"Message: {e.message}")
      print(f"Headers: {e.response.headers}")
  ```

  ```typescript TypeScript theme={null}
  try {
    await client.spaces.create({ name: '' });
  } catch (error) {
    if (error instanceof Memv.APIError) {
      console.error(`Status: ${error.status}`);
      console.error(`Message: ${error.message}`);
      console.error(`Headers:`, error.headers);
    }
  }
  ```
</CodeGroup>

## Retry logic

### Custom retry with backoff

<CodeGroup>
  ```python Python theme={null}
  import time

  def retry_with_backoff(func, max_attempts=3, base_delay=1):
      """Retry with exponential backoff."""
      for attempt in range(max_attempts):
          try:
              return func()
          except memvai.RateLimitError:
              if attempt == max_attempts - 1:
                  raise
              delay = base_delay * (2 ** attempt)
              print(f"Rate limited. Retrying in {delay}s...")
              time.sleep(delay)
          except memvai.APIError as e:
              if attempt == max_attempts - 1:
                  raise
              print(f"Error: {e}. Retrying...")
              time.sleep(base_delay)

  # Usage
  result = retry_with_backoff(lambda: client.spaces.list())
  ```

  ```typescript TypeScript theme={null}
  async function retryWithBackoff<T>(
    fn: () => Promise<T>,
    maxAttempts: number = 3,
    baseDelay: number = 1000
  ): Promise<T> {
    for (let attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        return await fn();
      } catch (error) {
        if (error instanceof Memv.RateLimitError) {
          if (attempt === maxAttempts - 1) throw error;
          const delay = baseDelay * Math.pow(2, attempt);
          console.log(`Rate limited. Retrying in ${delay}ms...`);
          await new Promise(r => setTimeout(r, delay));
        } else if (error instanceof Memv.APIError) {
          if (attempt === maxAttempts - 1) throw error;
          console.log(`Error: ${error.message}. Retrying...`);
          await new Promise(r => setTimeout(r, baseDelay));
        } else {
          throw error;
        }
      }
    }
    throw new Error('Max retries exceeded');
  }

  // Usage
  const result = await retryWithBackoff(() => client.spaces.list());
  ```
</CodeGroup>

## Best practices

<AccordionGroup>
  <Accordion title="Always handle exceptions">
    Never let exceptions propagate unchecked.
  </Accordion>

  <Accordion title="Be specific with exception handling">
    Catch specific exceptions before general ones.
  </Accordion>

  <Accordion title="Log errors with context">
    Always log errors with relevant context for debugging.
  </Accordion>

  <Accordion title="Implement retry logic for transient errors">
    Retry operations that might fail temporarily.
  </Accordion>
</AccordionGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Advanced usage" icon="code" href="/sdk/advanced">
    Advanced SDK features
  </Card>

  <Card title="Installation" icon="download" href="/sdk/installation">
    SDK installation and setup
  </Card>
</CardGroup>
