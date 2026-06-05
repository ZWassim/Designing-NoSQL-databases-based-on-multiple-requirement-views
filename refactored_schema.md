Strategy Summary
Separate analytical store – Add a wide‑column (Cassandra) or column‑oriented (BigQuery / ClickHouse) table for sales aggregates.

Denormalization – Pre‑aggregate daily product sales into a new collection/table.

Sharding – Explicitly define partition keys for both OLTP and OLAP workloads.

Replication – Increase replica factor to 5 across three AZs for partition tolerance (AP system for product views, CP for orders).

Refactored OLTP Schema (MongoDB – tuned for availability)
Products collection remains unchanged, but now replica factor = 5 (read preference nearest).

Orders collection is sharded by user_id (rather than hashed _id) to enable faster per‑user order history queries, accepting some hot‑partition risk (mitigated by application‑level user ID hashing).

Write concern reduced to {w: 1} for orders to improve write latency under high velocity; eventual consistency of delivery status is acceptable per new requirements.
