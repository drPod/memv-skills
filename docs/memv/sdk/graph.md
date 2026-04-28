# Knowledge graphs

> Build and query knowledge graphs from memories

Knowledge graphs connect related entities, facts, and concepts. Mem[v] automatically builds semantic graphs showing how people, topics, and events relate.

## What are knowledge graphs?

Knowledge graphs represent information as interconnected triplets:

**Subject → Predicate → Object**

Examples:

* `Sarah Chen` → `works_at` → `Acme Corp`
* `User` → `prefers` → `Dark mode`
* `FastAPI` → `is_used_for` → `Building APIs`

## Retrieve triplets

<CodeGroup>
  ```python Python theme={null}
  from memvai import Memv

  client = Memv()

  # Retrieve triplets for a memory
  triplets = client.graph.retrieve_triplets(
      type="memory",
      id="mem_xyz789"
  )

  # Print relationships
  for triplet in triplets:
      print(f"{triplet['subject']} → {triplet['predicate']} → {triplet['object']}")
  ```

  ```typescript TypeScript theme={null}
  import Memv from 'memvai';

  const client = new Memv();

  // Retrieve triplets for a memory
  const triplets = await client.graph.retrieveTriplets('mem_xyz789', {
    type: 'memory',
  });

  // Print relationships
  for (const triplet of triplets) {
    console.log(`${triplet.subject} → ${triplet.predicate} → ${triplet.object}`);
  }
  ```
</CodeGroup>

## Building knowledge graphs

Knowledge graphs are automatically built from your memories:

<CodeGroup>
  ```python Python theme={null}
  # Add memories with entities
  client.memories.add(
      space_id="space_abc123",
      content="Alice Johnson is the CTO at TechCorp. She specializes in distributed systems."
  )

  client.memories.add(
      space_id="space_abc123",
      content="Alice Johnson uses Kubernetes for container orchestration."
  )

  # Mem[v] automatically creates triplets:
  # - Alice Johnson → works_at → TechCorp
  # - Alice Johnson → role → CTO
  # - Alice Johnson → specializes_in → distributed systems
  # - Alice Johnson → uses → Kubernetes
  ```

  ```typescript TypeScript theme={null}
  // Add memories with entities
  await client.memories.add({
    space_id: 'space_abc123',
    content: 'Alice Johnson is the CTO at TechCorp. She specializes in distributed systems.',
  });

  await client.memories.add({
    space_id: 'space_abc123',
    content: 'Alice Johnson uses Kubernetes for container orchestration.',
  });

  // Mem[v] automatically creates triplets:
  // - Alice Johnson → works_at → TechCorp
  // - Alice Johnson → role → CTO
  // - Alice Johnson → specializes_in → distributed systems
  // - Alice Johnson → uses → Kubernetes
  ```
</CodeGroup>

## Use cases

<AccordionGroup>
  <Accordion title="Build user profiles">
    Create comprehensive user profiles from their interactions and preferences.
  </Accordion>

  <Accordion title="Map organizational knowledge">
    Build company knowledge graphs with people, teams, and technologies.
  </Accordion>

  <Accordion title="Connect research findings">
    Link research papers, concepts, and discoveries.
  </Accordion>

  <Accordion title="Track product features">
    Map product requirements, dependencies, and technologies.
  </Accordion>
</AccordionGroup>

## Best practices

<AccordionGroup>
  <Accordion title="Use clear, factual statements">
    Write memories as clear subject-predicate-object statements.

    **Good:** `"Sarah Chen is the VP of Engineering at Acme Corp"`

    **Less good:** `"Sarah is pretty high up in engineering I think"`
  </Accordion>

  <Accordion title="Be specific with relationships">
    Use precise language for relationships.

    **Good:** `"The API uses PostgreSQL for data storage"`

    **Less good:** `"We have PostgreSQL"`
  </Accordion>

  <Accordion title="Avoid ambiguity">
    Use full names and clear references.

    **Good:** `"John Smith manages the DevOps team"`

    **Less good:** `"John manages it"` (ambiguous)
  </Accordion>
</AccordionGroup>

## Next steps

<CardGroup cols={2}>
  <Card title="Memories" icon="brain" href="/sdk/memories">
    Add more memories to build graphs
  </Card>

  <Card title="Advanced usage" icon="code" href="/sdk/advanced">
    Advanced SDK features
  </Card>
</CardGroup>
