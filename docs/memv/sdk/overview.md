# SDK Overview

> Official SDKs for integrating Mem[v] into your applications

Mem[v] provides official SDKs for Python and TypeScript/JavaScript to integrate long-term memory capabilities into your AI applications.

## Available SDKs

<CardGroup cols={2}>
  <Card title="Python SDK" icon="python" href="/sdk/installation">
    Official Python SDK (v0.4.1) - Production ready
  </Card>

  <Card title="TypeScript/JavaScript SDK" icon="js" color="#3178c6" href="/sdk/installation">
    Official TypeScript/JS SDK (v0.4.0) - Production ready
  </Card>

  <Card title="Go" icon="golang" color="#00add8">
    Coming soon - Join the waitlist
  </Card>

  <Card title="Rust" icon="rust" color="#ce422b">
    Planned - Request early access
  </Card>
</CardGroup>

## Why use an SDK?

<AccordionGroup>
  <Accordion title="Type-safe development">
    Get full type definitions and IDE autocomplete for all API methods, parameters, and responses.
  </Accordion>

  <Accordion title="Built-in error handling">
    Comprehensive exception types for different error scenarios with automatic retries for transient failures.
  </Accordion>

  <Accordion title="Async support">
    Native async/await support for efficient concurrent operations in both Python and TypeScript.
  </Accordion>

  <Accordion title="Simplified authentication">
    Easy API key management with environment variable support.
  </Accordion>

  <Accordion title="Advanced features">
    Streaming responses, custom HTTP clients, middleware support, and more.
  </Accordion>
</AccordionGroup>

## Quick examples

<Tabs>
  <Tab title="Python">
    ```python theme={null}
    from memvai import Memv

    client = Memv()

    # Create a space
    response = client.spaces.create(name="AI Assistant")
    space_id = response.space.id

    # Add a memory
    client.memories.add(
        space_id=space_id,
        content="User prefers technical explanations"
    )

    # Search memories
    results = client.memories.search(
        space_id=space_id,
        query="How does the user like explanations?"
    )

    for memory in results.memories:
        print(memory.content)
    ```
  </Tab>

  <Tab title="TypeScript">
    ```typescript theme={null}
    import Memv from 'memvai';

    const client = new Memv();

    // Create a space
    const response = await client.spaces.create({ name: 'AI Assistant' });
    const spaceId = response.space.id;

    // Add a memory
    await client.memories.add({
      space_id: spaceId,
      content: 'User prefers technical explanations',
    });

    // Search memories
    const results = await client.memories.search({
      space_id: spaceId,
      query: 'How does the user like explanations?',
    });

    for (const memory of results.memories) {
      console.log(memory.content);
    }
    ```
  </Tab>
</Tabs>

## Key features

* **Python 3.9+** and **TypeScript 4.9+** support
* **Multiple runtimes**: Node.js, Deno, Bun, Cloudflare Workers, Vercel Edge
* **Full type safety**: Type annotations with Pydantic (Python) and TypeScript
* **Async support**: Async/await in both languages
* **Automatic retries**: Built-in retry logic with exponential backoff
* **Error handling**: Comprehensive exception types
* **File uploads**: Support for all file types

<Card title="View SDK documentation" icon="arrow-right" href="/sdk/installation">
  Complete SDK documentation with language tabs
</Card>

## REST API

Prefer to use the REST API directly? View the API reference:

<Card title="REST API Reference" icon="code" href="/api-reference/introduction">
  Complete REST API documentation with OpenAPI spec
</Card>

## Community SDKs

Building an SDK for Mem[v]? Let us know! We'd love to feature community-built SDKs here.

## SDK Support

<CardGroup cols={2}>
  <Card title="GitHub (Python)" icon="github" href="https://github.com/mem-v/memv-python">
    Python SDK repository
  </Card>

  <Card title="GitHub (TypeScript)" icon="github" href="https://github.com/mem-v/memv-typescript">
    TypeScript SDK repository
  </Card>

  <Card title="Discord Community" icon="discord" href="https://discord.gg/memv">
    Get help from the community
  </Card>

  <Card title="Email Support" icon="envelope" href="mailto:support@memv.ai">
    Contact the support team
  </Card>
</CardGroup>

## Contributing

Want to contribute to the SDKs? We welcome contributions!

* [Python SDK Contributing Guide](https://github.com/mem-v/memv-python/blob/main/CONTRIBUTING.md)
* [TypeScript SDK Contributing Guide](https://github.com/mem-v/memv-typescript/blob/main/CONTRIBUTING.md)

## Next steps

<CardGroup cols={3}>
  <Card title="Quickstart" icon="rocket" href="/quickstart">
    Get started in minutes
  </Card>

  <Card title="Installation" icon="download" href="/sdk/installation">
    Install the SDK
  </Card>

  <Card title="Core Concepts" icon="lightbulb" href="/core-concepts/how-it-works">
    Learn how Mem[v] works
  </Card>
</CardGroup>
