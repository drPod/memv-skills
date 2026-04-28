---
name: memv-video-ingest
description: This skill should be used when the user asks to 'upload a video to memv', 'ingest video', 'extract memories from video', 'process a video file', or when calling client.videos.upload. Covers multimodal extraction (audio + visual + on-screen text + temporal dynamics), upload size considerations, and why pre-transcribing loses information.
---

# memv-video-ingest

## Why this matters

mem[v] = "memory + video". The pitch (`docs/memv/index.md`): "If you solve memory for video, you've solved it for everything else." Video subsumes text, audio, image, and temporal context.

## Required reading

1. `docs/memv/sdk/videos.md` — upload + processing API.
2. `docs/memv/index.md` — "video is the superset of all multimedia" framing.
3. `docs/memv/sdk/files.md` — sibling for non-video files; same auth/space pattern.
4. `docs/memv/sdk/error-handling.md` — uploads are the most common failure surface.

## Hard rules

- Push raw video. Do NOT pre-extract audio, transcribe, or sample frames before upload — mem[v] does that better than ad-hoc pipelines.
- `space_id` mandatory.
- Video uploads can be slow / large. Wrap with explicit timeout + retry per `sdk/error-handling.md`.
- For very large or batch uploads, check `sdk/advanced.md` before rolling your own queue.

## Skeleton (Python)

```python
with open(video_path, "rb") as f:
    response = client.videos.upload(
        space_id=space_id,
        file=f,
        metadata={"source": "user_upload", "user_id": user_id},
    )
video_id = response.video_id
```

## What mem[v] extracts from video

- Spoken language (audio transcripts)
- Visual information (scenes, motion, recognized entities)
- On-screen text (captions, slides)
- Temporal dynamics (how info unfolds)

All become searchable memories in the same space.

## Don't

- Don't push pre-transcribed text instead of the video. You lose visual + temporal info.
- Don't shard a video file before upload. Send the whole asset.
