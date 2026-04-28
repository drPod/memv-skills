# Files

> Upload and manage files

Upload documents, images, videos, audio, and other content to Mem[v] for automatic memory extraction.

## Upload files

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  client = Memv()

  # Upload a file
  with open("document.pdf", "rb") as file:
      response = client.upload.batch.create(
          space_id="space_abc123",
          files=[file]
      )

  print(f"Batch ID: {response.batch_id}")
  ```

  ```typescript TypeScript (Node.js) theme={null}
  import Memv from 'memvai';
  import fs from 'fs';

  const client = new Memv();

  // Upload a file
  const file = fs.createReadStream('document.pdf');

  const response = await client.upload.batch.create({
    space_id: 'space_abc123',
    files: [file],
  });

  console.log(`Batch ID: ${response.batch_id}`);
  ```
</CodeGroup>

## Upload multiple files

<CodeGroup>
  ```python Python theme={null}
  # Upload multiple files
  file_paths = ["doc1.pdf", "doc2.txt", "image.png"]

  files = [open(path, "rb") for path in file_paths]

  try:
      response = client.upload.batch.create(
          space_id="space_abc123",
          files=files
      )
      print(f"Uploaded {len(files)} files - Batch ID: {response.batch_id}")
  finally:
      for file in files:
          file.close()
  ```

  ```typescript TypeScript theme={null}
  // Upload multiple files
  const files = [
    fs.createReadStream('doc1.pdf'),
    fs.createReadStream('doc2.txt'),
    fs.createReadStream('image.png'),
  ];

  const response = await client.upload.batch.create({
    space_id: 'space_abc123',
    files,
  });

  console.log(`Uploaded ${files.length} files - Batch ID: ${response.batch_id}`);
  ```
</CodeGroup>

## Supported file types

<AccordionGroup>
  <Accordion title="Documents">
    PDF, Word, Text, Markdown, Rich Text
  </Accordion>

  <Accordion title="Spreadsheets">
    Excel, CSV, Google Sheets
  </Accordion>

  <Accordion title="Presentations">
    PowerPoint, Google Slides
  </Accordion>

  <Accordion title="Images">
    JPEG, PNG, GIF, WebP
  </Accordion>

  <Accordion title="Videos">
    MP4, WebM, MOV, AVI
  </Accordion>

  <Accordion title="Audio">
    MP3, WAV, OGG, M4A
  </Accordion>
</AccordionGroup>

## Monitor upload progress

<CodeGroup>
  ```python Python theme={null}
  import time

  # Upload file
  with open("large_video.mp4", "rb") as file:
      response = client.upload.batch.create(
          space_id="space_abc123",
          files=[file]
      )

  batch_id = response.batch_id

  # Poll for completion
  while True:
      status = client.upload.batch.get_status(batch_id=batch_id)

      print(f"Status: {status.status}")
      print(f"Progress: {status.processed_files}/{status.total_files}")

      if status.status == "completed":
          print("Processing complete!")
          break
      elif status.status == "failed":
          print("Processing failed")
          break

      time.sleep(2)  # Check every 2 seconds
  ```

  ```typescript TypeScript theme={null}
  // Upload file
  const file = fs.createReadStream('large_video.mp4');
  const { batch_id } = await client.upload.batch.create({
    space_id: 'space_abc123',
    files: [file],
  });

  // Poll for completion
  while (true) {
    const status = await client.upload.batch.getStatus(batch_id);

    console.log(`Status: ${status.status}`);
    console.log(`Progress: ${status.processed_files}/${status.total_files}`);

    if (status.status === 'completed') {
      console.log('Processing complete!');
      break;
    } else if (status.status === 'failed') {
      throw new Error('Processing failed');
    }

    await new Promise(r => setTimeout(r, 2000)); // Check every 2 seconds
  }
  ```
</CodeGroup>

## List files

<CodeGroup>
  ```python Python theme={null}
  # List all files in a space
  response = client.files.list(space_id="space_abc123")

  for file in response.files:
      print(f"{file.name} - {file.size} bytes")
      print(f"  Type: {file.mime_type}")
      print(f"  Status: {file.processing_status}")
  ```

  ```typescript TypeScript theme={null}
  // List all files in a space
  const response = await client.files.list({
    space_id: 'space_abc123',
  });

  for (const file of response.files) {
    console.log(`${file.name} - ${file.size} bytes`);
    console.log(`  Type: ${file.mime_type}`);
    console.log(`  Status: ${file.processing_status}`);
  }
  ```
</CodeGroup>

## Download files

<CodeGroup>
  ```python Python theme={null}
  # Download a file
  response = client.files.download(
      file_id="file_xyz789",
      space_id="space_abc123"
  )

  # Save to disk
  with open("downloaded_file.pdf", "wb") as f:
      f.write(response.content)
  ```

  ```typescript TypeScript (Node.js) theme={null}
  // Download a file
  const response = await client.files.download('file_xyz789', {
    space_id: 'space_abc123',
  });

  // Save to disk
  import fs from 'fs/promises';
  await fs.writeFile('downloaded_file.pdf', response.content);
  ```
</CodeGroup>

## Delete files

<CodeGroup>
  ```python Python theme={null}
  # Delete a file
  response = client.files.delete(
      file_id="file_xyz789",
      space_id="space_abc123"
  )

  if response.success:
      print("File deleted successfully")
  ```

  ```typescript TypeScript theme={null}
  // Delete a file
  const response = await client.files.delete({
    file_id: 'file_xyz789',
    space_id: 'space_abc123',
  });

  if (response.success) {
    console.log('File deleted successfully');
  }
  ```
</CodeGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Videos" icon="video" href="/sdk/videos">
    Work with video files
  </Card>

  <Card title="Memories" icon="brain" href="/sdk/memories">
    Search extracted memories
  </Card>
</CardGroup>
