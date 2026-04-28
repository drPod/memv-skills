# MCP Overview

> Connect AI assistants to your mem[v] knowledge graph via the Model Context Protocol

The mem[v] MCP server lets AI assistants like Claude, ChatGPT, Cursor, and VS Code Copilot read and write to your knowledge graph directly.

## What is MCP?

The [Model Context Protocol](https://modelcontextprotocol.io) (MCP) is an open standard that lets AI assistants connect to external data sources and tools. Instead of copy-pasting context into your AI chat, MCP gives the assistant direct access to your mem[v] memories.

## Endpoint

```
https://mcp.memv.ai/mcp
```

## Authentication

The MCP server uses **OAuth authentication** via Clerk. When you connect a client for the first time, you'll be prompted to sign in with your mem[v] account. No API keys needed.

## Available Tools

The MCP server exposes three tools:

### `list_workspaces`

List your mem[v] workspaces. Returns each workspace with its ID and name.

### `add_memory`

Add one or more memories to a workspace's knowledge graph.

| Parameter     | Type   | Required | Description                                         |
| ------------- | ------ | -------- | --------------------------------------------------- |
| `workspaceId` | string | Yes      | The workspace ID (use `list_workspaces` to find it) |
| `memories`    | array  | Yes      | Array of `{ content, name? }` objects               |

### `search_memory`

Search memories in your knowledge graph.

| Parameter     | Type   | Required | Description                                            |
| ------------- | ------ | -------- | ------------------------------------------------------ |
| `query`       | string | Yes      | The search query                                       |
| `workspaceId` | string | No       | Limit to a specific workspace. Searches all if omitted |
| `maxResults`  | number | No       | Max results to return (default 10, max 50)             |

## Example Workflow

Once connected, you can interact with your memories naturally:

```
You: What do I know about the Q4 product roadmap?
AI:  [calls search_memory with query "Q4 product roadmap"]
     Based on your memories, the Q4 roadmap includes...

You: Remember that we decided to postpone the mobile app to Q1.
AI:  [calls add_memory with content "Mobile app postponed to Q1"]
     Done, I've added that to your knowledge graph.
```

<CardGroup cols={2}>
  <Card title="Setup Guide" icon="wrench" href="/mcp/setup">
    Connect your AI client to mem[v]
  </Card>

  <Card title="Quickstart" icon="bolt" href="/quickstart">
    New to mem[v]? Start here
  </Card>
</CardGroup>
