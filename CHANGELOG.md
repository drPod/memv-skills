# Changelog

All notable changes to `memv-skills` are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning follows [SemVer](https://semver.org/).

## [0.1.0] — 2026-04-28

### Added
- Initial public release
- 10 skills covering the mem[v] platform surface:
  - `memv-bootstrap` — first-touch SDK install + auth setup
  - `memv-mcp-vs-sdk` — when to use MCP tools vs SDK code
  - `memv-add-memory` — create/update/delete memories
  - `memv-search` — semantic + graph-aware retrieval
  - `memv-spaces` — tenancy, isolation, CRUD
  - `memv-files` — file (PDF/doc/image/audio) ingestion
  - `memv-video-ingest` — video ingestion (mem[v]'s headline path)
  - `memv-graph` — knowledge graph queries
  - `memv-mcp-setup` — install MCP clients / build your own
  - `memv-debug` — error triage + sanity probes
- Mirrored mem[v] docs (35 markdown pages, ~165KB content) at `docs/memv/`, **synced from docs.memv.ai on 2026-04-28**
- `docs/memv/llms-full.txt` single-blob fallback (160KB, served directly by Mintlify)
- Hand-curated `docs/memv/README.md` router with per-file summary, when-to-consult trigger, related files, and key API symbols
- `scripts/sync-memv-docs.sh` — idempotent refresh script (fetch + strip-banner + unescape + URL-rewrite)
- `AGENTS.md.template` — paste-in routing block for downstream projects
- `.claude-plugin/marketplace.json` — enables `/plugin install` flow
- `DESIGN.md` — design rationale and research citations

### Doc snapshot
- Source: `https://docs.memv.ai/`
- Date: 2026-04-28
- Pages: 35 (+ `llms.txt` index + `llms-full.txt` blob)
- Post-processing: 3-line "Documentation Index" banner stripped, `Mem\[v]` unescaped, vendor URLs rewritten to local `docs/memv/` paths
