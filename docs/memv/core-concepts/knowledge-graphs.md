# Knowledge Graphs

> Automatic entity extraction and relationship discovery

Mem[v] automatically builds knowledge graphs from your content, connecting entities through relationships and enabling graph-aware semantic search for AI agents.

## What is a Knowledge Graph?

A knowledge graph is a network of entities and relationships automatically extracted from memories:

**From memories**:

* "Sarah Chen is the CTO at Acme Corp"
* "Acme Corp uses Kubernetes for deployments"

**Graph representation**:

```
Sarah Chen → role → CTO
Sarah Chen → works_at → Acme Corp
Acme Corp → uses → Kubernetes
```

## Triplet structure

Knowledge is stored as Subject → Predicate → Object:

```
User → prefers → Dark mode
Database → runs_on → PostgreSQL
API → authenticates_via → JWT tokens
Team → uses → GitHub Actions
```

## Automatic entity extraction

Mem[v] identifies and extracts:

* **People**: Names, roles, relationships
* **Organizations**: Companies, teams, departments
* **Technologies**: Tools, frameworks, platforms
* **Locations**: Cities, offices, regions
* **Topics**: Concepts, subjects, categories

## Graph-aware search

When you search, results include connected entities:

**Query**: "Sarah Chen"

**Returns**:

* Direct memories about Sarah
* Her role (CTO)
* Company (Acme Corp)
* Technologies she uses (Kubernetes)
* Teams she manages
* Projects she leads

## Common use cases

### Team knowledge

<CodeGroup>
  ```python Python theme={null}
  # Find who knows about a technology
  results = client.graph.query(
      space_id="company",
      entity="Kubernetes",
      relationship="expert_in"
  )

  for triplet in results.triplets:
      print(f"{triplet.subject} → {triplet.predicate} → {triplet.object}")
  ```

  ```typescript TypeScript theme={null}
  // Find who knows about a technology
  const results = await client.graph.query({
    space_id: 'company',
    entity: 'Kubernetes',
    relationship: 'expert_in',
  });

  for (const triplet of results.triplets) {
    console.log(`${triplet.subject} → ${triplet.predicate} → ${triplet.object}`);
  }
  ```
</CodeGroup>

### Product dependencies

Map system architecture:

```
Frontend App
├── depends_on → Backend API
│   ├── depends_on → PostgreSQL
│   └── depends_on → Redis
└── uses → React
    └── requires → Node.js
```

### Customer insights

Understand customer relationships:

```
Acme Corp
├── uses → Enterprise Plan
├── located_in → San Francisco
├── contact → Sarah Chen
│   └── role → VP Engineering
└── industry → Technology
```

## Automatic graph building

Graphs build automatically as you add memories:

<CodeGroup>
  ```python Python theme={null}
  client.memories.add(
      space_id="space_123",
      content="Sarah Chen is the CTO at Acme Corp and specializes in cloud architecture"
  )

  # Graph automatically contains:
  # Sarah Chen → works_at → Acme Corp
  # Sarah Chen → role → CTO
  # Sarah Chen → specializes_in → Cloud Architecture
  ```

  ```typescript TypeScript theme={null}
  await client.memories.add({
    space_id: 'space_123',
    content: 'Sarah Chen is the CTO at Acme Corp and specializes in cloud architecture',
  });

  // Graph automatically contains:
  // Sarah Chen → works_at → Acme Corp
  // Sarah Chen → role → CTO
  // Sarah Chen → specializes_in → Cloud Architecture
  ```
</CodeGroup>

## Query the graph

<CodeGroup>
  ```python Python theme={null}
  # Get all relationships for an entity
  results = client.graph.query(
      space_id="space_123",
      entity="Sarah Chen"
  )

  for triplet in results.triplets:
      print(f"{triplet.subject} {triplet.predicate} {triplet.object}")
  ```

  ```typescript TypeScript theme={null}
  // Get all relationships for an entity
  const results = await client.graph.query({
    space_id: 'space_123',
    entity: 'Sarah Chen',
  });

  for (const triplet of results.triplets) {
    console.log(`${triplet.subject} ${triplet.predicate} ${triplet.object}`);
  }
  ```
</CodeGroup>

## Cross-content graphs

Graphs connect information across all content types:

**Video**: "Sarah is leading the Kubernetes migration"
→ Sarah Chen → leads → Kubernetes Migration

**PDF**: "Kubernetes migration depends on new infrastructure"
→ Kubernetes Migration → depends\_on → New Infrastructure

**Chat**: "New infrastructure will use AWS EKS"
→ New Infrastructure → uses → AWS EKS

**Combined graph**:

```
Sarah Chen
└── leads → Kubernetes Migration
    └── depends_on → New Infrastructure
        └── uses → AWS EKS
```

## Relationship types

Automatically detected relationships:

* **Professional**: works\_at, reports\_to, manages, collaborates\_with
* **Technical**: uses, depends\_on, integrates\_with, built\_with
* **Conceptual**: related\_to, part\_of, category\_of, type\_of
* **Temporal**: preceded\_by, followed\_by, during, after
* **Preference**: prefers, likes, requires

## Best practices

* Include rich context in memories for better entity extraction
* Use consistent entity names across content
* Add structured metadata for clearer relationships
* Leverage graph queries to enrich AI context

## Privacy and isolation

Knowledge graphs respect Space boundaries:

* Each Space has an independent graph
* Entities never connect across spaces
* Ensures data privacy and separation

## Next steps

<CardGroup cols={2}>
  <Card title="Memories" icon="brain" href="/core-concepts/memories">
    Add memories to build graphs
  </Card>

  <Card title="Search" icon="magnifying-glass" href="/core-concepts/search">
    Graph-aware semantic search
  </Card>

  <Card title="SDK: Graph" icon="code" href="/sdk/graph">
    Query knowledge graphs
  </Card>
</CardGroup>
