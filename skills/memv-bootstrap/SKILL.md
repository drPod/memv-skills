---
name: memv-bootstrap
description: This skill should be used when the user asks to 'install memv', 'set up the memv SDK', 'memvai not found', 'fresh memv setup', or when 'import memvai' or 'from memvai import' fails. Handles language detection (Python pip / TypeScript npm), MEMV_API_KEY env var, and smoke-tests auth via the MCP connection.
---

# memv-bootstrap

First-touch setup for the `memvai` SDK. Run this BEFORE any other memv skill that writes code.

## Step 1 — Detect language

Check what's already in the repo:

```bash
ls pyproject.toml requirements.txt setup.py package.json 2>/dev/null
```

| Found | Language |
|-------|----------|
| `pyproject.toml` / `requirements.txt` / `setup.py` | Python |
| `package.json` | TypeScript / JavaScript |
| Both | Both — install both. |
| Neither | **Ask the user** which language before installing. Don't guess. |

## Step 2 — Install

### Python

```bash
# if no venv yet:
python3 -m venv .venv
source .venv/bin/activate
pip install memvai
pip freeze | grep memvai >> requirements.txt
```

If `pyproject.toml` exists (Poetry / uv / hatch), use the matching tool instead:
- Poetry: `poetry add memvai`
- uv: `uv add memvai`

### TypeScript

```bash
npm install memvai
# or pnpm add memvai / yarn add memvai / bun add memvai depending on lockfile present
```

## Step 3 — Environment variable

`memvai` reads `MEMV_API_KEY`. Verify it's set:

```bash
[ -n "$MEMV_API_KEY" ] && echo "set" || echo "MISSING"
```

If missing:
- Add to `.env` (project) — and `.env.example` with placeholder
- Ensure `.env` is in `.gitignore`
- For local dev shells, instruct user to `export MEMV_API_KEY=...` in their rc file or use a tool like `direnv`

API keys come from the user's mem[v] dashboard. Do NOT put one in source control. If the user doesn't have one, point them at `docs/memv/sdk/installation.md`.

## Step 4 — Smoke-test auth (no SDK needed)

The mem[v] MCP server uses OAuth (separate from the SDK's API key). If wired into your client, confirm it works:

```
mcp__memv__whoami()
```

If that returns a user → MCP path works (dev-time inspection available).
If the SDK env var also resolves → app code path works too.

These are independent — see skill `memv-mcp-vs-sdk`.

## Step 5 — Smoke-test the SDK

After install, sanity-check the import resolves:

```bash
# Python
python -c "from memvai import Memv; print(Memv.__module__)"

# TypeScript (if tsx installed)
npx tsx -e "import Memv from 'memvai'; console.log(typeof Memv)"
```

If that fails with ImportError / ModuleNotFoundError → Step 2 didn't take effect. Check venv activation, lockfile, working directory.

## Done

Once steps 1–5 pass:
- Skills `memv-add-memory`, `memv-search`, `memv-spaces`, `memv-files`, `memv-video-ingest`, `memv-graph` are safe to fire.
- Reference `docs/memv/sdk/installation.md` for any odd-platform details (proxies, custom CA, alternate Python versions).

## Don't

- Don't `pip install memvai` outside a venv on macOS/Linux — system Python install will refuse or break.
- Don't commit `.env` with a real key.
- Don't pre-install both languages without asking. Lockfile sprawl is harder to undo than to skip.
