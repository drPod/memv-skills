# Design rationale

This document explains the structural choices behind `memv-skills` and the research that drove each. It exists so the next maintainer (or a forking user) doesn't have to re-derive the trade-offs.

## Goals

1. Let many parallel Claude Code agents reference mem[v] docs/APIs cheaply and accurately while building on the platform.
2. Encode the mem[v]-specific footguns (mandatory `space_id`, MCP-vs-SDK boundary, `workspaceId`/`space_id` terminology mismatch) so agents can't drift.
3. Stay version-pinned and offline-capable — no surprise API drift mid-build.
4. Be drop-in: any project building on mem[v] can install the plugin and inherit good defaults without project-specific tuning.

## Big choices and why

### 1. Bundle the docs mirror instead of WebFetching on demand

Bundled mem[v] docs (`docs/memv/`, ~165KB across 35 markdown pages + `llms-full.txt` for slurp mode).

**Why:**
- **Token economics.** A targeted `Read docs/memv/sdk/error-handling.md` (~6KB / ~1.5K tokens) costs less than a `WebFetch` round-trip plus the lossy LLM-summarization step Claude Code's `WebFetch` tool applies. For an agent that hits docs 20+ times during a build, the difference compounds.
- **Determinism / version pinning.** The mirror snapshots the docs at the date in `CHANGELOG.md`. Vendor doc updates can't break a build mid-session; refresh is explicit (`./scripts/sync-memv-docs.sh`).
- **Offline / air-gapped.** No network dependency at agent runtime.
- **Lossless.** Original markdown, not a summarized fetch.

**Trade-off:** repo carries ~165KB of vendor content. Acceptable; refreshable via the sync script.

**Source:** Mintlify auto-publishes both `/llms.txt` (index) and `/llms-full.txt` (concatenated). See https://www.mintlify.com/docs/ai/llmstxt for the publishing pattern.

### 2. Hand-curated `docs/memv/README.md` router (instead of relying on `llms.txt` alone)

The vendor's `llms.txt` is alphabetical with one-line descriptions. Useful but flat. `README.md` adds: per-file size, hot-path flags, when-to-consult triggers, related-file pointers, key API symbols, and a layered grouping (Concepts / SDK / Integrations & ops / Optional).

**Why:** routing-via-manifest beats both blind reads and grep at this corpus size. The Mindstudio "agents waste 80% of tokens finding things" study and the Frontmatter-First piece (https://medium.com/@michael.hannecke/frontmatter-first-is-not-optional-context-window-survival-for-local-llms-in-opencode-15809b207977) measured ~85–95% token reduction from index-then-targeted-read vs naïve scans.

**Why a fat router instead of YAML frontmatter on each file:** the sync script overwrites every file on refresh, which would also overwrite per-file frontmatter. Centralizing routing metadata in `README.md` keeps source files clean and refresh-safe.

### 3. Skills as procedural recipes; docs as reference

Skills (`skills/memv-*/SKILL.md`) are short procedural playbooks (~30–100 lines each) that auto-fire on description match and route the agent to the right doc files. Skills don't restate doc content — they tell the agent which docs to read and which rules apply.

**Why this division:**
- Skills load **on demand**; ~100 chars of description per skill stay in every prompt, but the body only loads when triggered.
- Docs are the source of truth and update via the sync script independently of skill text.
- Combines best of both: persistent routing (skills) + lossless content (docs).

**Source:** Anthropic Claude Code best-practices say to keep `CLAUDE.md`/`AGENTS.md` lean and use `@imports` or skill auto-discovery for everything else. https://code.claude.com/docs/en/best-practices and https://code.claude.com/docs/en/memory.

### 4. Why 10 skills (not fewer, not more)

Surveyed published official plugins:
- Vercel: 25 skills. Cloudflare: ~20. AWS Dev Toolkit: 34. CockroachDB: 32.

10 is **on the low side** for a single-domain platform plugin. Anthropic's docs (https://code.claude.com/docs/en/skills) state 100+ skills work fine because metadata is preloaded in ~30–50 tokens per skill; the bottleneck is description discrimination, not count.

The single consolidation a researcher recommended was merging `memv-mcp-vs-sdk` + `memv-mcp-setup` → one `memv-mcp` skill. Deferred: the two answer different mental moments ("which surface should I use?" vs "how do I install it?") and current descriptions discriminate well enough. Re-evaluate if activation rates suffer.

The ingest-trio (`memv-add-memory`, `memv-files`, `memv-video-ingest`) was kept split because multimodal-first is a core mem[v] principle and each warrants distinct procedural guidance. Description front-loads the discriminating word (memories / files / video) to avoid keyword cannibalization.

**Source:** Activation-rate study at https://medium.com/@ivan.seleznov1/why-claude-code-skills-dont-activate-and-how-to-fix-it-86f679409af1 found description wording has ~20× impact on activation. Also https://buildtolaunch.substack.com/p/claude-skills-not-working-fix.

### 5. Third-person skill descriptions with explicit trigger phrases

Every `description:` field uses the form `This skill should be used when the user asks to '<trigger>', '<trigger>', or when <scenario>. Covers <scope>.`

**Why:** Anthropic's `plugin-dev:skill-development` skill mandates this pattern. Third-person + concrete user phrases produces measurably higher activation rates than vague second-person ("Use when working with ...") forms.

Initial release used second-person; corrected to third-person in 0.1.0 before publishing.

### 6. AGENTS.md, not CLAUDE.md, as the primary

`AGENTS.md.template` (not `CLAUDE.md.template`) is the published surface. Claude Code falls back to `AGENTS.md` when no `CLAUDE.md` exists, and `AGENTS.md` is now the cross-tool standard (Cursor, Aider, Cline, Continue, Codex CLI, Copilot CLI, Gemini CLI, Windsurf, Zed, Warp all read it).

**Why:** one file works across all tools instead of duplicating content. https://agents.md/ + https://hivetrail.com/blog/agents-md-vs-claude-md-cross-tool-standard.

Recommended downstream pattern: `ln -s AGENTS.md CLAUDE.md` to satisfy any Claude-only tooling that expects the legacy filename.

### 7. Sync-script post-processing (banner strip, unescape, URL rewrite)

The sync script doesn't just mirror — it transforms each fetched markdown file:
- **Strips the 3-line "Documentation Index" banner** Mintlify auto-injects at the top of every page (4KB total saved across 35 files; pure waste in a local mirror).
- **Unescapes `Mem\[v]`** → `Mem[v]` (MDX escape artifacts that don't render in raw markdown).
- **Rewrites `https://docs.memv.ai/<path>`** → `docs/memv/<path>.md` so agents `Read` locally instead of accidentally `WebFetch`-ing.

**Why URL rewriting matters:** agents follow links literally. A live URL triggers `WebFetch` (slow, billable, lossy); a relative path triggers `Read` (cheap, deterministic). Same rationale as bundling the docs in the first place.

## Choices considered and rejected

### Per-file YAML frontmatter on every doc

Rejected because the sync script overwrites every file on refresh, which would clobber the frontmatter every time. Centralized routing metadata in `docs/memv/README.md` is refresh-safe.

### Compression of doc text (LLMLingua-2, sqz, caveman-style)

Rejected. These tools (https://github.com/ojuschugh1/sqz, https://github.com/microsoft/LLMLingua) shine on 500KB+ corpora or RAG pipelines. At 165KB the savings don't justify lossy transformation of code samples and API shapes.

### Auto-fetch docs on plugin install via lifecycle hook

Rejected. Claude Code plugins have **no install-time hook** (per https://code.claude.com/docs/en/plugins-reference). The closest substitute is a `SessionStart` hook that diffs a manifest. That adds session latency and network failure modes for marginal benefit; ship snapshotted docs and refresh on release cadence instead.

### Bundling a Vercel-style auto-hosted MCP server

Rejected. mem[v] already publishes its own hosted MCP server at `https://mcp.memv.ai/mcp`. Bundling would double-register tools.

### LICENSE file

Initially skipped per maintainer preference. Public plugins without a license are legally ambiguous in corporate settings, which can suppress adoption. To be revisited in 0.2.0.

### CI workflow (GitHub Actions for skill validation)

Deferred to 0.2.0. Pattern from trailofbits/skills-curated and gupsammy/Claudest is to validate `plugin.json`, `marketplace.json`, and every `SKILL.md` frontmatter on PR. Worth adding once the plugin sees external contributions.

## Sources cited above

- mem[v] docs site (Mintlify-hosted): https://docs.memv.ai/
- Mintlify llms.txt feature: https://www.mintlify.com/docs/ai/llmstxt
- llms.txt spec: https://llmstxt.org/
- AGENTS.md spec: https://agents.md/
- Anthropic Claude Code best practices: https://code.claude.com/docs/en/best-practices
- Anthropic Claude Code memory docs: https://code.claude.com/docs/en/memory
- Anthropic Claude Code skills: https://code.claude.com/docs/en/skills
- Anthropic plugin reference: https://code.claude.com/docs/en/plugins-reference
- Anthropic plugin marketplace docs: https://code.claude.com/docs/en/plugin-marketplaces
- Skill activation-rate study: https://medium.com/@ivan.seleznov1/why-claude-code-skills-dont-activate-and-how-to-fix-it-86f679409af1
- Skill bloat post-mortem: https://buildtolaunch.substack.com/p/claude-skills-not-working-fix
- Skills controllability problem: https://paddo.dev/blog/claude-skills-controllability-problem/
- Frontmatter-first context survival: https://medium.com/@michael.hannecke/frontmatter-first-is-not-optional-context-window-survival-for-local-llms-in-opencode-15809b207977
- Knowledge-base index file pattern: https://www.mindstudio.ai/blog/llm-knowledge-base-index-file-no-vector-search
- AGENTS.md vs CLAUDE.md analysis: https://hivetrail.com/blog/agents-md-vs-claude-md-cross-tool-standard
- ETH Zurich context-bloat study (Feb 2026): https://www.termdock.com/blog/skill-md-vs-claude-md-vs-agents-md
- Reference plugin: anthropics/claude-plugins-official
- Reference plugin: obra/superpowers-marketplace
- Reference plugin: trailofbits/skills-curated
- Reference plugin: cloudflare/skills
- Reference plugin: vercel-labs (Vercel official)
