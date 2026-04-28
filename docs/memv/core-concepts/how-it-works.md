# How it works

> Understanding Mem[v]'s core concepts and workflow

Mem[v] provides graph-based memory infrastructure for AI agents, automatically extracting entities, building knowledge graphs, and enabling semantic retrieval across all content types.

## The workflow

<Steps>
  <Step title="Connect your content">
    Upload files or send data through the API:

    * Documents (PDFs, Word, text)
    * Videos (MP4, MOV, WebM)
    * Audio (MP3, WAV)
    * Images and screenshots
    * Conversations
  </Step>

  <Step title="Automatic extraction">
    Mem[v] processes content and extracts:

    * Entities (people, companies, technologies, topics)
    * Relationships between entities
    * Semantic embeddings for search
    * Temporal context and metadata
  </Step>

  <Step title="Graph construction">
    Information is organized into knowledge graphs:

    * Entities become nodes
    * Relationships become edges
    * Triplets form: Subject → Predicate → Object
    * Isolated within Spaces for privacy
  </Step>

  <Step title="Semantic retrieval">
    Query by meaning to retrieve relevant context:

    * Graph-aware search returns connected information
    * Results ranked by relevance
    * Include entity relationships and metadata
  </Step>
</Steps>

## Key concepts

### Spaces

Isolated containers for memories and knowledge graphs. Each space has complete data separation, enabling per-user, per-feature, or per-tenant organization.

### Memories

Structured information extracted from your content. Each memory contains content, metadata, and extracted entities that feed into the knowledge graph.

### Knowledge graphs

Automatically built networks connecting entities through relationships. Enable discovery of indirect connections and richer context for AI agents.

### Semantic search

Graph-aware retrieval that finds information by meaning and returns connected entities and relationships.

## Data flow

```
Content → Processing → Memories → Knowledge Graph
                          ↓
AI Agent ← Semantic Search ← Query
```

## Next steps

<CardGroup cols={2}>
  <Card title="Quickstart" icon="rocket" href="/quickstart">
    Build your first memory-enabled app
  </Card>

  <Card title="Spaces" icon="folder" href="/core-concepts/spaces">
    Organize memories with Spaces
  </Card>

  <Card title="Knowledge Graphs" icon="diagram-project" href="/core-concepts/knowledge-graphs">
    Understand graph-based memory
  </Card>

  <Card title="SDK Documentation" icon="code" href="/sdk/installation">
    Explore the SDKs
  </Card>
</CardGroup>
