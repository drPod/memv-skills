#!/usr/bin/env bash
# Mirror docs.memv.ai → docs/memv/, then post-process for agent consumption.
# Usage: ./scripts/sync-memv-docs.sh
#
# Fetches:
#   1. llms.txt          — original Mintlify index (provenance)
#   2. llms-full.txt     — single-blob all-docs (slurp-mode access)
#   3. all .md pages     — individual files (targeted reads)
#
# Post-processes each .md:
#   - strips the 3-line "Documentation Index" banner Mintlify auto-injects
#   - unescapes `Mem\[v]` → `Mem[v]`
#   - rewrites `https://docs.memv.ai/<path>` → `docs/memv/<path>.md`
#     (so agents Read locally instead of accidentally WebFetch)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$ROOT/docs/memv"
BASE="https://docs.memv.ai"

mkdir -p "$DEST"
cd "$DEST"

echo "==> [1/4] fetching index"
curl -fsSL "$BASE/llms.txt" -o _llms.txt
curl -fsSL "$BASE/llms-full.txt" -o llms-full.txt
echo "    llms.txt: $(wc -c < _llms.txt) bytes"
echo "    llms-full.txt: $(wc -c < llms-full.txt) bytes"

echo "==> [2/4] parsing URLs"
grep -oE 'https://docs\.memv\.ai/[^ )]+\.md' _llms.txt | sort -u > _urls.txt
total=$(wc -l < _urls.txt | tr -d ' ')
echo "    $total pages"

echo "==> [3/4] downloading pages"
fail=0
while read -r url; do
  path="${url#$BASE/}"
  mkdir -p "$(dirname "$path")"
  if ! curl -fsSL "$url" -o "$path"; then
    echo "    FAIL $path"
    fail=$((fail + 1))
  fi
done < _urls.txt
[ "$fail" -eq 0 ] || { echo "==> $fail page(s) failed"; exit 1; }

echo "==> [4/4] post-processing"
processed=0
find . -type f -name "*.md" \
  -not -name "_*" \
  -not -name "README.md" \
  -print0 | while IFS= read -r -d '' f; do
  # strip 3-line "Documentation Index" banner if present (banner + trailing blank line = 4 lines)
  if head -1 "$f" | grep -q "Documentation Index"; then
    tail -n +5 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  fi
  # unescape Mem\[v] / mem\[v]
  sed -i '' -E 's/Mem\\\[v\\?\]/Mem[v]/g; s/mem\\\[v\\?\]/mem[v]/g' "$f"
  # rewrite vendor URLs to local paths (two passes: with .md, then add .md)
  sed -i '' -E "s|https://docs\\.memv\\.ai/([A-Za-z0-9_/-]+)\\.md|docs/memv/\\1.md|g" "$f"
  sed -i '' -E "s|https://docs\\.memv\\.ai/([A-Za-z0-9_/-]+)([\")  ])|docs/memv/\\1.md\\2|g" "$f"
  processed=$((processed + 1))
done

echo "==> done. $total pages → $DEST"
du -sh "$DEST"
