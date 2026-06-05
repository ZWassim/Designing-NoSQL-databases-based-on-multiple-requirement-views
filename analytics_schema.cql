-- Keyspace for high availability (NetworkTopologyStrategy, RF=3 per DC)
CREATE KEYSPACE ecommerce_analytics
WITH replication = {'class': 'NetworkTopologyStrategy', 'dc1': 3, 'dc2': 3};

-- Daily product sales aggregation table
CREATE TABLE daily_product_sales (
    product_id UUID,
    sale_date DATE,
    category TEXT,
    total_quantity INT,
    total_revenue DECIMAL,
    avg_price DECIMAL,
    PRIMARY KEY ((product_id), sale_date)
) WITH CLUSTERING ORDER BY (sale_date DESC);

-- Hourly sales for high‑velocity trend analysis
CREATE TABLE hourly_sales_rollup (
    category TEXT,
    hour TIMESTAMP,
    product_id UUID,
    sales_count INT,
    revenue DECIMAL,
    PRIMARY KEY ((category), hour, product_id)
) WITH CLUSTERING ORDER BY (hour DESC);

-- Materialized view for category‑level analytics
CREATE MATERIALIZED VIEW category_sales AS
SELECT category, sale_date, total_revenue, total_quantity
FROM daily_product_sales
WHERE category IS NOT NULL AND sale_date IS NOT NULL
PRIMARY KEY ((category), sale_date, product_id);
