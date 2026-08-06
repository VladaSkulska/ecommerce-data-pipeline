-- =============================================================================
-- PROJECT: E-Commerce Data Pipeline
-- FILE: 01_data_cleaning.sql
-- PURPOSE: Data Cleansing, Type Casting, and Feature Engineering
-- AUTHOR: Vlada Skulska
-- =============================================================================
/* =============================================================================
   1. REGIONAL TIMESTAMP PARSING:
      - Issue: Raw `invoice_date` stored as US string format (MM/DD/YY HH24:MI).
      - Solution: Parsed into native PostgreSQL TIMESTAMP using TO_TIMESTAMP.

   2. TEXT NORMALIZATION & DEDUPLICATION:
      - Issue: Inconsistent text casing (e.g., '15056bl' vs '15056BL') and trailing spaces.
      - Solution: Applied UPPER(TRIM(...)) across `stock_code`, `description`, `invoice`, and `country`.

   3. FILTERING ANOMALIES & WAREHOUSE NOISE (WHERE Clause):
      - `customer_id IS NOT NULL`: Removed ~25% anonymous records to enable accurate 
        cohort analysis, LTV, and RFM metrics.
      - `price > 0`: Excluded warehouse inventory errors ('damages', 'lost', '?'), 
        zero-price marketing samples, and bad debt adjustments (-11062.06).

   4. TRANSACTION CLASSIFICATION & CALCULATED METRICS:
      - Flagged cancellations via `CASE WHEN quantity < 0 OR invoice LIKE 'C%' THEN 'Return'`.
      - Derived line-item revenue: `ROUND(quantity * price, 2) AS total_amount`.
   ============================================================================= */

-- Step 1: Re-create clean analytical table
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	TRIM(invoice) as invoice,
	UPPER(TRIM(stock_code)) as stock_code,
	UPPER(TRIM(description)) as description,
	quantity,
	TO_TIMESTAMP(invoice_date, 'MM/DD/YY HH24:MI') as invoice_date,
	price,
	customer_id,
	TRIM(country) as country,

	ROUND((quantity * price)::numeric, 2) as total_amount, 
	CASE
		WHEN quantity < 0 OR invoice LIKE 'C%' THEN 'Return'
		ELSE 'Sale'
	END AS transaction_type
FROM raw_sales
WHERE customer_id IS NOT NULL AND price > 0;

-- Step 2: Creating indexes
CREATE INDEX idx_clean_sales_customer ON clean_sales(customer_id);
CREATE INDEX idx_clean_sales_date ON clean_sales(invoice_date);

-- Step 3: Sanity Check
SELECT
	transaction_type,
	COUNT(*) as total_records,
	ROUND(SUM(total_amount), 2) as total_revenue
FROM clean_sales
GROUP BY transaction_type
