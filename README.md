# memv-skills

Drop-in [Claude Code](https://docs.claude.com/claude-code) skills + mirrored docs for building on [mem[v]](https://memv.ai).

10 skills auto-fire on relevant tasks. The mirrored docs sit on disk so agents can `Read` them lossless instead of fetching over the network. Refresh script keeps the mirror current.

For the design rationale and research citations behind every choice, see [DESIGN.md](./DESIGN.md). For the version history and bundled-doc snapshot dates, see [CHANGELOG.md](./CHANGELOG.md).

## What you get

```
.claude-plugin/plugin.json     plugin manifest
skills/                        10 skills, each <100 lines
  memv-bootstrap/              first-time SDK install + auth setup
  memv-mcp-vs-sdk/             when to use MCP tools vs SDK code
  memv-add-memory/             create/update/delete memories
  memv-search/                 semantic + graph-aware retrieval
  memv-spaces/                 tenancy, isolation, CRUD
  memv-files/                  file (PDF/doc/image/audio) ingestion
  memv-video-ingest/           video ingestion (mem[v]'s headline path)
  memv-graph/                  knowledge graph queries
  memv-mcp-setup/              install MCP clients / build your own
  memv-debug/                  error triage + sanity probes
docs/memv/                     mirrored docs.memv.ai (~420KB)
  README.md                    fat router — agents read this first
  llms-full.txt                single-blob, all docs concatenated
  llms.txt + _urls.txt         provenance
  core-concepts/, sdk/, mcp/, connectors/, support/, use-cases/, changelog/
scripts/sync-memv-docs.sh      refresh script (idempotent)
AGENTS.md.template             paste-in routing block for downstream projects
```

## Install

### Option A — Claude Code plugin (recommended)

In any Claude Code session:

```
/plugin marketplace add drPod/memv-skills
/plugin install memv-skills@memv-skills
```

Skills auto-discover. The 10 `memv-*` skills will fire on relevant tasks. The bundled docs sit in the plugin cache and are referenced from skill bodies.

### Option B — Manual copy

```bash
git clone https://github.com/drPod/memv-skills.git
cd your-project
cp -R ../memv-skills/skills .claude/skills
cp -R ../memv-skills/docs/memv docs/memv
cp ../memv-skills/scripts/sync-memv-docs.sh scripts/sync-memv-docs.sh
chmod +x scripts/sync-memv-docs.sh
```

Then add the contents of `AGENTS.md.template` to your project's `AGENTS.md` (or `CLAUDE.md`).

## Why this exists

mem[v] is small enough that agents could fetch docs ad-hoc, but every fetch costs a round-trip and an LLM-summarization pass that loses precision. A local mirror plus a hand-curated routing index (`docs/memv/README.md`) lets agents:

- `Read` lossless instead of `WebFetch` lossy
- Pick the right page by skimming a 6KB router instead of grepping
- Stay offline / version-pinned during a build session

The skills add a layer above that: procedural recipes that auto-fire when the agent hits a relevant task ("user wants to add a memory" → `memv-add-memory` skill loads → tells agent which docs to read + the `space_id` rule + the error-handling envelope).

## Refreshing the docs mirror

mem[v] ships updates. Re-fetch + post-process:

```bash
./scripts/sync-memv-docs.sh
```

The script:
1. Pulls `https://docs.memv.ai/llms.txt` (index)
2. Pulls `https://docs.memv.ai/llms-full.txt` (all docs in one blob, ~160KB)
3. Pulls each individual `.md` page (35 files)
4. Strips the duplicated 3-line "Documentation Index" banner Mintlify auto-injects
5. Unescapes `Mem\[v]` → `Mem[v]`
6. Rewrites `https://docs.memv.ai/<path>` → `docs/memv/<path>.md` so agents `Read` locally instead of `WebFetch`-ing

## Standing rules baked into skills

These hold across all 10 skills:

1. **Spaces are isolation boundaries.** Every write needs `space_id`. No global writes exist.
2. **MCP says `workspaceId`. SDK says `space_id`.** Same concept, different name. Translate when bridging.
3. **Use SDK types directly.** Don't invent wrappers.
4. **No hand-rolled HTTP** for mem[v]. SDK only.
5. **Multimodal-first.** Push raw text/files/video. Don't pre-process.
6. **Read `sdk/error-handling.md` before any try/except.**
7. **MCP `mcp__memv__*` tools are dev-time inspection only — never from app code.**
8. **Never guess SDK shapes.** If docs don't show it, flag — don't invent.

## Token economics

- Naive (read all docs every task): ~165KB / ~40K tokens
- With `memv-skills` (skill + targeted Read): ~10–25KB / ~3–6K tokens
- ~6–10× cheaper per task, no info loss

## Contributing

Issues + PRs welcome at https://github.com/drPod/memv-skills.

If mem[v] ships a docs change that breaks a skill, run `./scripts/sync-memv-docs.sh` and submit a PR with the updated mirror + any skill text adjustments.
