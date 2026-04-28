# mem[v] docs — agent router

> Fat catalog of `docs/memv/`. Every entry: summary, when to consult, related files, key symbols.
> Read this **once** per task to pick which page(s) to actually `Read` in full.

**Snapshot:** synced from `https://docs.memv.ai/` on **2026-04-28**. Refresh: `./scripts/sync-memv-docs.sh`. See `CHANGELOG.md` for previous snapshot dates.

## Standing orders (always true on this project)

These rules apply to every line of code that touches mem[v]. Violations = bugs.

1. **Spaces are isolation boundaries.** Every `client.memories.add/update/delete` MUST pass `space_id`. There is no global write.
2. **MCP terminology mismatch:** the `mcp__memv__*` tools say `workspaceId`. The SDK says `space_id`. **Same concept.** When jumping between MCP and SDK, translate.
3. **Use SDK types directly.** `from memvai import Memv`. Do not invent wrapper types for Memory, Space, Entity, Relationship. If a shape isn't in the SDK, check `sdk/advanced.md` before inventing.
4. **No hand-rolled HTTP.** Always use the SDK. Escape hatches in `sdk/advanced.md`.
5. **Multimodal-first.** mem[v] handles text/files/video natively. Don't pre-process — push raw content via `client.memories.add` / `client.files.upload` / `client.videos.upload`.
6. **Follow SDK error patterns.** Read `sdk/error-handling.md` BEFORE wrapping any mem[v] call in try/except. Don't swallow.
7. **MCP is for dev-time inspection, NOT runtime.** See MCP-vs-SDK rules below.

## MCP vs SDK decision rules

The `mcp__memv__*` tools (4 total: `whoami`, `list_workspaces`, `add_memory`, `search_memory`) are an OAuth-authed live connection to the user's mem[v] account from the **agent's** context. The SDK is code that ships in the **app**.

**Use `mcp__memv__*` when:**
- Inspecting current state of user's live mem[v] account during dev (find a `workspaceId`, verify a write landed, sanity-check a search query)
- Quick scratch operations (add a test memory while debugging, run a one-off search)
- Verifying auth (`whoami`)
- Demo / natural-language exploration of the KG

**Use SDK code (Python `memvai` / TS `memvai`) when:**
- The operation runs in production (the app's actual code)
- You need any operation MCP doesn't expose: file upload, video ingestion, space CRUD, knowledge-graph queries beyond text search, batch ops, transactions, advanced retrieval
- Anything version-controlled / shippable / repeatable

**Never:** call MCP tools from inside app code. They live in the agent harness, not the runtime.

## How to read this catalog

- **Hot path** = expect to open this file most days. Read it fully when starting feature work.
- **Reference** = open when the trigger fires. Skim, then targeted reads.
- **Optional** = drop these first when context is tight (per llms.txt convention).

For broad tasks, prefer `Read` of the whole layer over searching: `docs/memv/sdk/*.md` is ~58KB (~15K tokens), trivially cheaper than serial greps.

For one-shot fact-finding across all 35 pages, `Read docs/memv/llms-full.txt` (~160KB / ~40K tokens, single file).

---

## Layer 1 — Concepts (what mem[v] models)

> Read once at project start. Re-read when intuition about behavior feels off. ~22KB total.

### `core-concepts/how-it-works.md` (2.7KB · **read first**)
End-to-end pipeline: connect source → extract memories → build graph → retrieve. Anchor mental model for everything else.
**When:** first contact with mem[v], or when a teammate is confused about flow.
**Related:** all other core-concepts files.

### `core-concepts/spaces.md` (2.7KB · **hot path**)
Isolation primitive. Every memory belongs to exactly one space. Patterns for per-user / per-feature / per-environment partitioning.
**When:** designing tenancy, deciding space granularity, debugging "why doesn't this memory show up".
**Key:** `space_id` (mandatory on every write).
**Related:** `sdk/spaces.md` (CRUD), `sdk/memories.md` (write path).

### `core-concepts/memories.md` (3.5KB · **hot path**)
Atomic record. Lifecycle: create → enrich (auto entity/embed extract) → link (graph) → retrieve → decay.
**When:** designing what to store, debating granularity, understanding why retrieval returns what it returns.
**Key:** Memory shape, lifecycle stages.
**Related:** `sdk/memories.md`, `core-concepts/knowledge-graphs.md`, `core-concepts/search.md`.

### `core-concepts/knowledge-graphs.md` (6.0KB · reference)
Auto-extracted entity + relationship layer. Built from memories without explicit modeling.
**When:** querying entities/relationships, building graph-aware features, deciding whether to use direct memory search vs graph traversal.
**Related:** `sdk/graph.md` (programmatic queries), `core-concepts/search.md`.

### `core-concepts/search.md` (4.2KB · reference)
Graph-aware semantic retrieval. Explains WHY queries return what they return (vector + graph traversal).
**When:** implementing search, tuning retrieval, debugging "why isn't this memory matching".
**Related:** `sdk/memories.md` (search call), `core-concepts/knowledge-graphs.md`.

### `index.md` (3.7KB · skim)
High-level pitch + "video is the superset" framing. Skim only when confirming mem[v] fits the use case.

---

## Layer 2 — SDK (how code talks to mem[v])

> Open when writing or changing app code. **`sdk/memories.md` is the most-touched file in this project.** ~58KB total.

### `sdk/installation.md` (7.1KB)
Install + auth setup. Python (`pip install memvai`) and TypeScript.
**When:** before any import, fresh environment setup, CI configuration.
**Key:** `MEMV_API_KEY` env var, client construction.

### `sdk/overview.md` (5.1KB)
Top-level client shape. What's on `client.memories`, `client.spaces`, `client.files`, `client.videos`, `client.graph`.
**When:** orienting before touching a new SDK area.

### `sdk/memories.md` (11.7KB · **HOT PATH**)
The most-touched file. `add`, `search`, `update`, `delete`. Text + file + conversation + preference patterns.
**When:** writing or editing ANY code that creates/queries memories.
**Key APIs:** `client.memories.add`, `client.memories.search`, `client.memories.update`.
**Related:** `core-concepts/memories.md`, `sdk/error-handling.md`, `sdk/spaces.md`.

### `sdk/spaces.md` (8.6KB)
Space CRUD. Create, list, delete. Plus listing memories within a space.
**When:** managing tenancy, bootstrapping new users/features, cleaning up.
**Key APIs:** `client.spaces.create`, `client.spaces.list`, `client.spaces.delete`.

### `sdk/files.md` (6.0KB)
File-backed memories. Upload PDFs/docs/images, mem[v] extracts memories from them.
**When:** ingesting documents, building file-aware features.
**Key APIs:** `client.files.upload`.
**Related:** `sdk/videos.md` (sibling for video).

### `sdk/videos.md` (5.4KB · **likely hot path for this project**)
Video memories. mem[v]'s headline capability — multimodal extraction from video (audio, visual, text, temporal).
**When:** ingesting any video content, building video-search features.
**Key APIs:** `client.videos.upload`.
**Related:** `sdk/files.md`, `index.md` ("video is the superset").

### `sdk/graph.md` (4.4KB)
Programmatic knowledge-graph queries. Walk entities, traverse relationships.
**When:** building entity-centric features, auditing what mem[v] auto-extracted.
**Related:** `core-concepts/knowledge-graphs.md`.

### `sdk/error-handling.md` (7.4KB · **read before any try/except**)
Exception hierarchy, retryable vs terminal errors, rate-limit shape.
**When:** wrapping any mem[v] call in error-handling, debugging production issues.
**Key:** exception types to catch, what's safe to retry.

### `sdk/advanced.md` (6.6KB)
Escape hatches: raw HTTP, custom embeddings, advanced retrieval modes.
**When:** standard SDK doesn't cover the case. Read this BEFORE asking the user or fabricating.

---

## Layer 3 — Integrations & ops

### `mcp/overview.md` (2.8KB)
What the mem[v] hosted MCP server exposes. 4 tools: `whoami`, `list_workspaces`, `add_memory`, `search_memory`.
**When:** deciding MCP-vs-SDK (see standing orders), or building this app's own MCP-facing features.

### `mcp/setup.md` (3.2KB)
How to install the memv MCP in different clients (Claude Code, Claude Desktop, Cursor, ChatGPT, VS Code, Windsurf).
**When:** onboarding a new dev, or wiring our app's own MCP server (use as reference for endpoint conventions).

### `connectors/` (7 files, ~3KB total · **STUBS**)
All 7 (`box`, `custom-sources`, `gmail-connector`, `google-drive`, `notion`, `onedrive`, `s3`) are placeholder pages: "Updates to be released soon. This section is currently under development." **Do not consult for technical detail.** Check `changelog/` for status updates.

### `support/security.md` (7.4KB)
Security architecture, encryption, tenancy isolation, compliance.
**When:** prod deploy, auth design, multi-tenant questions, customer security review.

### `support/troubleshooting.md` (516B · stub)
Currently very thin. **First stop on runtime errors**, but expect to fall through to `sdk/error-handling.md` and `changelog/`.

### `quickstart.md` (6.5KB)
End-to-end "hello world" flow: install → space → add memory → search. Good for sanity-checking environment setup.
**When:** verifying a fresh install works, or showing someone the simplest possible flow.

---

## Layer 4 — Optional (drop first when context tight)

### `changelog/experiment-notes.md` (514B · stub)
Currently placeholder. Watch for breaking-change announcements.

### `changelog/product-updates.md` (877B · stub)
Currently placeholder. Same.

### `use-cases/` (6 files, ~55KB total)
Reference architectures: `education`, `enterprise`, `gaming`, `healthcare`, `robotics`, `wearables`. **Mine for patterns** matching our domain before designing from scratch — but skip when token-budget tight, none are required reading.

---

## Provenance

- `_llms.txt` — original Mintlify-generated index. Source of truth for what pages exist.
- `_urls.txt` — derived URL list used by sync script.
- `llms-full.txt` — single-blob mirror of all 35 pages concatenated, ~160KB. Use when one agent will do many sequential lookups.
- All other `*.md` files mirror `https://docs.memv.ai/<path>` 1:1 with: banner stripped, `Mem\[v]` unescaped, internal vendor URLs rewritten to local paths.

Refresh: `./scripts/sync-memv-docs.sh`
