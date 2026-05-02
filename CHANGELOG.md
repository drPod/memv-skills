# Changelog

All notable changes to `memv-skills` are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning follows [SemVer](https://semver.org/).

## [0.1.2] — 2026-05-02

### Fixed
- **Caveman audit reverts.** Re-ran `/caveman:compress` on all 10 skill bodies, then audited diffs change-by-change. Reverted 15 grammar mutations (subject-verb breaks like `mem[v] do`/`SDK fail`/`Doc tell`/`MCP see…app search don't`/`Lose visual`, floating participles like `agent inspect`/`after run app`, ambiguous drops like `wire yourself`) and 1 semantic loss (`Plain text in memory` → restored `Plain text already in memory` to disambiguate from RAM). Kept ~30 clean caveman edits (article drops, gerund-to-imperative bullets, predicate-adjective drops, synonym swaps).
- Affected skills: `memv-add-memory`, `memv-debug`, `memv-files`, `memv-mcp-setup`, `memv-mcp-vs-sdk`, `memv-video-ingest`.

## [0.1.1] — 2026-04-28

### Fixed
- **Phantom SDK methods removed.** Skills + docs previously referenced `client.files.upload`, `client.videos.upload`, `client.memories.update`, `client.memories.delete`, `client.graph.list_entities`, `client.graph.list_relationships` — none of which exist in the real `memvai` SDK. Replaced with verified canonical methods:
  - File / video upload → `client.upload.batch.create(space_id, files=[...])` + `client.upload.batch.get_status(batch_id)` (async batch pattern)
  - Graph queries → `client.graph.retrieve_triplets(memory_id)` (per-memory triplets, no list/walk API)
  - Memory mutation: SDK exposes only `client.memories.add` and `client.memories.search` — to "change" a memory, add a new one and let the graph reconcile, or use `client.spaces.delete` to drop everything in a space.
- Affected skills: `memv-add-memory`, `memv-files`, `memv-video-ingest`, `memv-graph`, `memv-mcp-vs-sdk`.
- Affected docs: README.md (this file), CHANGELOG.md (this file).

### Changed
- Skill bodies rewritten in caveman style (drop articles / filler / hedging, fragments OK, code blocks unchanged, descriptions unchanged). Tighter, same technical content.
- Each skill now has a "SDK surface (verified against `docs/memv/sdk/<x>.md`)" section explicitly listing real method signatures so future audits can check against canonical.

### Note for installers of 0.1.0
If you installed 0.1.0 and started writing code from the skill skeletons, your code will fail on import — the methods don't exist. Bump to 0.1.1 (`/plugin update memv-skills@memv-skills`) and re-read affected skill files.

## [0.1.0] — 2026-04-28

### Added
- Initial public release
- 10 skills covering the mem[v] platform surface:
  - `memv-bootstrap` — first-touch SDK install + auth setup
  - `memv-mcp-vs-sdk` — when to use MCP tools vs SDK code
  - `memv-add-memory` — write memories via `client.memories.add` (SDK has no update/delete)
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
