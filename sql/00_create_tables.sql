-- =============================================================================
-- PROJECT: E-Commerce Data Pipeline
-- FILE: 00_create_tables.sql
-- PURPOSE: Database setup, raw table creation, and data ingestion
-- AUTHOR: Vlada Skulska
-- DATE: August 2026
-- =============================================================================

-- Step 1: Create Database (Execute separately in postgres database)
-- CREATE DATABASE pwc_ecommerce_analytics;

-- Connect to pwc_ecommerce_analytics database before executing steps below

-- Step 2: Drop table if it exists to ensure idempotency
DROP TABLE IF EXISTS raw_sales;

-- Step 3: Create schema for raw (uncleaned) data
CREATE TABLE raw_sales (
    invoice VARCHAR(20),
    stock_code VARCHAR(20),
    description TEXT,
    quantity INT,
    invoice_date TEXT, -- NOTE in the end
    price NUMERIC(10, 2),
    customer_id INT,
    country VARCHAR(50)
);

-- Step 4: Bulk Ingest Data from CSV
COPY raw_sales(invoice, stock_code, description, quantity, invoice_date, price, customer_id, country)
FROM 'C:/path_to_my_dataset/online_retail.csv'
WITH (
    FORMAT CSV, 
    HEADER true, 
    DELIMITER ',', 
    ENCODING 'UTF8'
);

/* =============================================================================
- Issue: Raw dataset uses US date format (MM/DD/YY HH24:MI), e.g., "12/13/10" for Dec 13, 2010.
- Conflict: Default PostgreSQL DateStyle expects European format (DD/MM/YY), causing ingestion 
  failure (13 parsed as an invalid month number).
- Engineering Solution: Ingested `invoice_date` as raw TEXT to decouple database import from server settings, 
  then deterministically parsed it in SQL using TO_TIMESTAMP(invoice_date, 'MM/DD/YY HH24:MI').
============================================================================= */
