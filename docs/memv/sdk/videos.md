# Videos

> Work with video files and extract multimodal memories

Videos are a core focus of Mem[v]. Upload video files to extract memories from spoken dialogue, visual content, on-screen text, and temporal context.

## Why videos matter

Video is the superset of all multimedia:

* **Audio/Transcripts**: Spoken language and dialogue
* **Visual Information**: Scenes, objects, actions, people
* **Text**: Captions, subtitles, on-screen text
* **Temporal Dynamics**: How information unfolds over time

## Upload videos

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  client = Memv()

  # Upload a video file
  with open("meeting_recording.mp4", "rb") as video:
      response = client.upload.batch.create(
          space_id="space_abc123",
          files=[video]
      )

  print(f"Batch ID: {response.batch_id}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';
  import fs from 'fs';

  const client = new Memv();

  // Upload a video file
  const video = fs.createReadStream('meeting_recording.mp4');

  const response = await client.upload.batch.create({
    space_id: 'space_abc123',
    files: [video],
  });

  console.log(`Batch ID: ${response.batch_id}`);
  ```
</CodeGroup>

## Monitor processing

<CodeGroup>
  ```python Python theme={null}
  import time

  # Upload video
  with open("lecture.mp4", "rb") as video:
      response = client.upload.batch.create(
          space_id="space_abc123",
          files=[video]
      )

  batch_id = response.batch_id

  # Poll for completion
  while True:
      status = client.upload.batch.get_status(batch_id=batch_id)

      if status.status == "completed":
          print("Video processing complete!")
          break

      time.sleep(10)  # Check every 10 seconds
  ```

  ```typescript TypeScript theme={null}
  // Upload video
  const video = fs.createReadStream('lecture.mp4');
  const { batch_id } = await client.upload.batch.create({
    space_id: 'space_abc123',
    files: [video],
  });

  // Poll for completion
  while (true) {
    const status = await client.upload.batch.getStatus(batch_id);

    if (status.status === 'completed') {
      console.log('Video processing complete!');
      break;
    }

    await new Promise(r => setTimeout(r, 10000)); // Check every 10 seconds
  }
  ```
</CodeGroup>

## List videos

<CodeGroup>
  ```python Python theme={null}
  # List all videos
  response = client.videos.list(space_id="space_abc123")

  for video in response.videos:
      print(f"{video.name}")
      print(f"  Duration: {video.duration_seconds}s")
      print(f"  Size: {video.size_bytes / 1024 / 1024:.2f} MB")
  ```

  ```typescript TypeScript theme={null}
  // List all videos
  const response = await client.videos.list({
    space_id: 'space_abc123',
  });

  for (const video of response.videos) {
    console.log(`${video.name}`);
    console.log(`  Duration: ${video.duration_seconds}s`);
    console.log(`  Size: ${(video.size_bytes / 1024 / 1024).toFixed(2)} MB`);
  }
  ```
</CodeGroup>

## Search video memories

<CodeGroup>
  ```python Python theme={null}
  # Search for content in videos
  results = client.memories.search(
      space_id="space_abc123",
      query="What did they say about the product roadmap?"
  )

  for memory in results.memories:
      print(f"Content: {memory.content}")
      print(f"Timestamp: {memory.metadata.get('timestamp')}")
  ```

  ```typescript TypeScript theme={null}
  // Search for content in videos
  const results = await client.memories.search({
    space_id: 'space_abc123',
    query: 'What did they say about the product roadmap?',
  });

  for (const memory of results.memories) {
    console.log(`Content: ${memory.content}`);
    console.log(`Timestamp: ${memory.metadata?.timestamp}`);
  }
  ```
</CodeGroup>

## Delete videos

<CodeGroup>
  ```python Python theme={null}
  # Delete a video
  response = client.videos.delete(
      video_id="video_xyz789",
      space_id="space_abc123"
  )

  if response.success:
      print("Video deleted successfully")
  ```

  ```typescript TypeScript theme={null}
  // Delete a video
  const response = await client.videos.delete({
    video_id: 'video_xyz789',
    space_id: 'space_abc123',
  });

  if (response.success) {
    console.log('Video deleted successfully');
  }
  ```
</CodeGroup>

<Warning>
  Deleting a video also removes all memories extracted from it.
</Warning>

## Use cases

<AccordionGroup>
  <Accordion title="Meeting recordings">
    Extract action items, decisions, and key discussions from team meetings.
  </Accordion>

  <Accordion title="Educational content">
    Extract knowledge from lectures and tutorials for searchable learning materials.
  </Accordion>

  <Accordion title="Customer support">
    Analyze support interactions to identify common issues and solutions.
  </Accordion>

  <Accordion title="Video tutorials">
    Build searchable knowledge bases from how-to videos.
  </Accordion>
</AccordionGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Memories" icon="brain" href="/sdk/memories">
    Search video memories
  </Card>

  <Card title="Knowledge graphs" icon="diagram-project" href="/sdk/graph">
    Build graphs from video content
  </Card>
</CardGroup>
