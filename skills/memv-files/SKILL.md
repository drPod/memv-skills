---
name: memv-files
description: Use when ingesting files (PDF, docs, images, audio) into mem[v] — uploads create file-backed memories with auto-extraction; for video specifically use memv-video-ingest instead
---

# memv-files

## Required reading

1. `docs/memv/sdk/files.md` — upload API.
2. `docs/memv/sdk/error-handling.md` — upload-failure modes.
3. `docs/memv/sdk/videos.md` — for video specifically, use that skill instead.

## Hard rules

- Push raw files. Don't OCR / parse / chunk before upload — mem[v] handles extraction.
- `space_id` mandatory.
- One file per call. Batch via `asyncio.gather` if you need parallelism, with backoff per `sdk/error-handling.md`.

## Skeleton (Python)

```python
with open(file_path, "rb") as f:
    response = client.files.upload(
        space_id=space_id,
        file=f,
        metadata={"source": "user_upload", "filename": file_path.name},
    )
file_id = response.file_id
```

## Choose the right method

- Video → `client.videos.upload` (use skill `memv-video-ingest`)
- PDF, doc, image, audio → `client.files.upload` (this skill)
- Plain text already in memory → `client.memories.add(content=...)` (use skill `memv-add-memory`)

## Don't

- Don't `client.memories.add(content=open(pdf).read())` — that stuffs raw bytes as text. Use `files.upload`.
- Don't pre-OCR. mem[v] extracts on its side.
