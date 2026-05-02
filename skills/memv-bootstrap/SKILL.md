---
name: memv-bootstrap
description: This skill should be used when the user asks to 'install memv', 'set up the memv SDK', 'memvai not found', 'fresh memv setup', or when 'import memvai' or 'from memvai import' fails. Handles language detection (Python pip / TypeScript npm), MEMV_API_KEY env var, and smoke-tests auth via the MCP connection.
---

# memv-bootstrap

First-touch SDK setup. Run BEFORE any other memv skill that writes code.

## Step 1 — Detect language

Check repo:

```bash
ls pyproject.toml requirements.txt setup.py package.json 2>/dev/null
```

| Found | Language |
|-------|----------|
| `pyproject.toml` / `requirements.txt` / `setup.py` | Python |
| `package.json` | TypeScript / JavaScript |
| Both | Both — install both. |
| Neither | **Ask user** before installing. Don't guess. |

## Step 2 — Install

### Python

```bash
# no venv yet:
python3 -m venv .venv
source .venv/bin/activate
pip install memvai
pip freeze | grep memvai >> requirements.txt
```

`pyproject.toml` present → use matching tool:
- Poetry: `poetry add memvai`
- uv: `uv add memvai`

### TypeScript

```bash
npm install memvai
# pnpm add memvai / yarn add memvai / bun add memvai per lockfile
```

## Step 3 — Env var

`memvai` reads `MEMV_API_KEY`. Verify:

```bash
[ -n "$MEMV_API_KEY" ] && echo "set" || echo "MISSING"
```

Missing:
- Add to `.env` + `.env.example` placeholder
- `.env` in `.gitignore`
- Local dev shells: `export MEMV_API_KEY=...` in rc file, or use `direnv`

Keys from user's mem[v] dashboard. NEVER commit. No key → point user at `docs/memv/sdk/installation.md`.

## Step 4 — Smoke-test auth (no SDK needed)

mem[v] MCP server uses OAuth (separate from SDK API key). If wired into client:

```
mcp__memv__whoami()
```

Returns user → MCP path works.
SDK env var resolves → app code path works.

Independent paths — see skill `memv-mcp-vs-sdk`.

## Step 5 — Smoke-test SDK

Post-install, check import:

```bash
# Python
python -c "from memvai import Memv; print(Memv.__module__)"

# TypeScript (tsx)
npx tsx -e "import Memv from 'memvai'; console.log(typeof Memv)"
```

ImportError / ModuleNotFoundError → Step 2 failed. Check venv activation, lockfile, cwd.

## Done

After 1–5:
- Skills `memv-add-memory`, `memv-search`, `memv-spaces`, `memv-files`, `memv-video-ingest`, `memv-graph` safe to fire.
- Odd-platform details (proxies, custom CA, alt Python): `docs/memv/sdk/installation.md`.

## Don't

- No `pip install memvai` outside venv on macOS/Linux — system Python refuses or breaks.
- No `.env` commit with real key.
- No pre-install both languages without ask. Lockfile sprawl harder to undo than skip.