---
name: memv-files
description: This skill should be used when the user asks to 'upload a PDF to memv', 'ingest a document', 'add an image to memv', 'process audio with memv', or when calling client.upload.batch.create. Covers multimodal-first ingestion and when to use upload.batch.create vs memories.add. For video specifically, use memv-video-ingest instead.
---

# memv-files

## Required reading

1. `docs/memv/sdk/files.md` — upload API (`client.upload.batch.create`).
2. `docs/memv/sdk/error-handling.md` — upload-failure modes.
3. `docs/memv/sdk/videos.md` — video → use that skill instead (same `upload.batch.create` path, video skill has format guidance).

## SDK surface (verified against `docs/memv/sdk/files.md`)

- `client.upload.batch.create(space_id, files=[...], ...)` — upload PDF / doc / image / audio
- `client.upload.batch.get_status(batch_id)` — poll for processing done (sync wrapper) / TS: `getStatus`
- `client.files.list(space_id)` — enumerate files in space

## Hard rules

- Push raw files. No OCR / parse / chunk before upload — mem[v] handles extraction.
- `space_id` mandatory.
- `upload.batch.create` **async**. Returns `batch_id`. Poll `get_status(batch_id)` until done before assuming memories searchable.
- Parallelize via `asyncio.gather` with backoff per `sdk/error-handling.md`.

## Skeleton (Python)

```python
with open(file_path, "rb") as f:
    response = client.upload.batch.create(
        space_id=space_id,
        files=[f],
        metadata={"source": "user_upload", "filename": file_path.name},
    )
batch_id = response.batch_id

# poll until processing completes
while True:
    status = client.upload.batch.get_status(batch_id=batch_id)
    if status.state in ("completed", "failed"):
        break
```

## Choose right method

- Video → `client.upload.batch.create` (skill `memv-video-ingest` for format guidance)
- PDF, doc, image, audio → `client.upload.batch.create` (this skill)
- Plain text already in memory → `client.memories.add(content=...)` (skill `memv-add-memory`)

## Don't

- No `client.memories.add(content=open(pdf).read())` — stuffs raw bytes as text. Use `upload.batch.create`.
- No pre-OCR. mem[v] extracts on its side.
- No assuming write searchable immediately after `create()` returns. Poll `get_status` first.