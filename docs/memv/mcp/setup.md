# Client Setup

> Connect your AI assistant to mem[v] via MCP

Choose your AI client below and follow the setup steps. All clients use the same MCP endpoint and OAuth authentication, no API keys required.

<Info>
  You'll need a mem[v] account. [Sign up at chat.memv.ai](https://chat.memv.ai) if you haven't already.
</Info>

## Claude Code

Run this command in your terminal:

```bash theme={null}
claude mcp add --transport http memv https://mcp.memv.ai/mcp
```

Claude Code will prompt you to authenticate via OAuth when you first use a mem[v] tool.

## Claude Desktop

<Steps>
  <Step title="Open Connectors">
    Go to **Settings** → **Connectors**.
  </Step>

  <Step title="Add the MCP server">
    Click **Add** and enter the endpoint URL:

    ```
    https://mcp.memv.ai/mcp
    ```
  </Step>

  <Step title="Authenticate">
    Follow the OAuth prompt to sign in to your mem[v] account.
  </Step>
</Steps>

<Warning>
  Remote MCP servers must be added via **Settings → Connectors**. Claude Desktop does not connect to remote servers configured directly in `claude_desktop_config.json`.
</Warning>

## ChatGPT

<Steps>
  <Step title="Open Settings">
    Click your profile icon → **Settings** → **Apps & Connectors**.
  </Step>

  <Step title="Add MCP server">
    Click **Add** and enter the endpoint URL:

    ```
    https://mcp.memv.ai/mcp
    ```
  </Step>

  <Step title="Authenticate">
    Follow the OAuth prompt to sign in to your mem[v] account.
  </Step>
</Steps>

<Warning>
  Requires a ChatGPT Plus, Pro, Team, Enterprise, or Edu plan.
</Warning>

## Cursor

<Steps>
  <Step title="Open MCP settings">
    Go to **Cursor Settings** → **Features** → **MCP** → **Add new MCP Server**.
  </Step>

  <Step title="Add the server">
    Select **SSE** as the type and enter the endpoint URL:

    ```
    https://mcp.memv.ai/sse
    ```
  </Step>

  <Step title="Authenticate">
    Cursor will prompt you to sign in via OAuth on first use.
  </Step>
</Steps>

<Warning>
  Requires a Cursor Pro plan or higher. MCP servers only work in Agent mode, which is not available on the free tier.
</Warning>

## VS Code (Copilot)

Run this command in your terminal:

```bash theme={null}
code --add-mcp '{"name":"memv","type":"http","url":"https://mcp.memv.ai/mcp"}'
```

Or add it manually to `.vscode/mcp.json` in your workspace:

```json theme={null}
{
  "servers": {
    "memv": {
      "type": "http",
      "url": "https://mcp.memv.ai/mcp"
    }
  }
}
```

## Windsurf

Add the following to `~/.codeium/windsurf/mcp_config.json`:

```json theme={null}
{
  "mcpServers": {
    "memv": {
      "serverUrl": "https://mcp.memv.ai/mcp"
    }
  }
}
```

Restart Windsurf to load the new configuration. You'll be prompted to sign in via OAuth on first use.

## Verify the Connection

After setup, ask your AI assistant:

```
List my mem[v] workspaces.
```

You should see your workspaces returned, confirming the connection is working.

<Tip>
  Try `search_memory` next to search your knowledge graph directly from your AI assistant.
</Tip>
