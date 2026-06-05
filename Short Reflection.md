Challenges during refactor:
The biggest challenge was balancing consistency vs. availability for order status. Initially we used writeConcern=majority to guarantee that a customer always sees the correct delivery status. With the new requirement of high availability and partition tolerance (AP), we had to accept that under network partitions some nodes might show stale status. We mitigated this by adding a client‑side retry with idempotent order updates and a background reconciliation job. Another challenge was refactoring analytics without impacting write throughput. Adding pre‑aggregation logic directly inside MongoDB would have slowed transaction processing, so we moved analytics to a separate wide‑column store with CDC.

How new requirements affected design decisions:
The analytics requirement forced us to adopt a columnar model for time‑series aggregations – something MongoDB is less efficient at. We denormalized daily and hourly sales, accepting storage overhead for fast aggregation queries. The high‑availability requirement drove us to increase replication factors and change order sharding from hashed _id to user_id (better for common query patterns at the cost of potential hot partitions). We also relaxed write concerns on orders to favour low latency.

Improvements in scalability, availability, and query performance:

Scalability: Orders now scale linearly via user‑based sharding; separate analytics cluster handles terabyte‑scale historical data.

Availability: Active‑active regions + RF=5 give 99.999% uptime for product browsing.

Query performance: Analytical queries on daily sales run in <100 ms (vs. minutes with full collection scans). Full‑text search on products remains fast, unaffected by analytics load.
