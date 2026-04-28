---
name: memv-video-ingest
description: This skill should be used when the user asks to 'upload a video to memv', 'ingest video', 'extract memories from video', 'process a video file', or when calling client.upload.batch.create with a video file. Covers multimodal extraction (audio + visual + on-screen text + temporal dynamics), upload size considerations, and why pre-transcribing loses information.
---

# memv-video-ingest

## Why this matters

mem[v] = "memory + video". Pitch (`docs/memv/index.md`): "If you solve memory for video, you've solved it for everything else." Video subsumes text, audio, image, temporal context.

## Required reading

1. `docs/memv/sdk/videos.md` — upload + processing API (`client.upload.batch.create` for video).
2. `docs/memv/index.md` — "video is superset of all multimedia" framing.
3. `docs/memv/sdk/files.md` — sibling for non-video files; same `upload.batch.create` path.
4. `docs/memv/sdk/error-handling.md` — uploads = most common failure surface.

## SDK surface (verified against `docs/memv/sdk/videos.md`)

- `client.upload.batch.create(space_id, files=[...])` — upload video file(s)
- `client.upload.batch.get_status(batch_id)` — poll until done
- `client.videos.list(space_id)` — enumerate videos in space

Same `upload.batch.create` path as files. mem[v] detects MIME and routes internally.

## Hard rules

- Push raw video. NO pre-extracting audio, transcribing, or sampling frames before upload — mem[v] does it better than ad-hoc pipelines.
- `space_id` mandatory.
- Video uploads slow / large. Wrap with explicit timeout + retry per `sdk/error-handling.md`.
- `upload.batch.create` is **async**. Poll `get_status(batch_id)` until done before assuming memories are searchable.
- Big or batch uploads → check `sdk/advanced.md` before rolling own queue.

## Skeleton (Python)

```python
with open(video_path, "rb") as f:
    response = client.upload.batch.create(
        space_id=space_id,
        files=[f],
        metadata={"source": "user_upload", "user_id": user_id},
    )
batch_id = response.batch_id

# poll until processing completes
while True:
    status = client.upload.batch.get_status(batch_id=batch_id)
    if status.state in ("completed", "failed"):
        break
```

## What mem[v] extracts from video

- Spoken language (audio transcripts)
- Visual info (scenes, motion, recognized entities)
- On-screen text (captions, slides)
- Temporal dynamics (how info unfolds)

All become searchable memories in same space.

## Don't

- No pushing pre-transcribed text instead of video. Loses visual + temporal info.
- No sharding video file before upload. Send whole asset.
- No assuming write is searchable immediately after `create()` returns. Poll `get_status` first.
