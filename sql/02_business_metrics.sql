/* =============================================================================
   BUSINESS METRICS & KPI ANALYSIS
   =============================================================================
   This script extracts key business performance indicators, customer retention 
   metrics, product quality insights, and geographic breakdowns.
   ============================================================================= */

/* -----------------------------------------------------------------------------
   1. OVERALL FINANCIAL PERFORMANCE
   Business Question: How much revenue is generated, and how much is lost to returns?
   ----------------------------------------------------------------------------- */
SELECT 
    SUM(CASE WHEN transaction_type = 'Sale' THEN total_amount ELSE 0 END) AS gross_revenue,
    ABS(SUM(CASE WHEN transaction_type = 'Return' THEN total_amount ELSE 0 END)) AS returned_revenue,
    SUM(total_amount) AS net_revenue
FROM clean_sales;

/* -----------------------------------------------------------------------------
   2. CUSTOMER RETENTION & LTV SEGMENTATION
   Business Question: What is the revenue share of one-time vs repeat customers?
   ----------------------------------------------------------------------------- */
WITH customer_summary AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders,
        SUM(total_amount) AS customer_LTV
    FROM clean_sales
    WHERE transaction_type = 'Sale'
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_orders = 1 THEN 'One-time Customer (1 order)'
        ELSE 'Repeat Customer (2+ orders)'
    END AS customer_segment,
    COUNT(customer_id) AS total_customers,
    ROUND(SUM(customer_LTV), 2) AS total_revenue,
    
    -- Using window function OVER() to calculate % share of total revenue
    ROUND(SUM(customer_LTV) * 100.0 / SUM(SUM(customer_LTV)) OVER(), 2) AS revenue_share_pct,
    ROUND(AVG(customer_LTV), 2) AS avg_revenue_per_customer
FROM customer_summary
GROUP BY 1;

/* -----------------------------------------------------------------------------
   3. PRODUCT QUALITY & RETURN RATE ANALYSIS
   Business Question: Which physical products have the highest return rate and cause
                      the largest financial losses?
   ----------------------------------------------------------------------------- */
SELECT
    stock_code,
    description,

    SUM(CASE WHEN transaction_type = 'Sale' THEN quantity ELSE 0 END) AS total_sold_qty,
    ABS(SUM(CASE WHEN transaction_type = 'Return' THEN quantity ELSE 0 END)) AS total_returned_qty,
    ABS(SUM(CASE WHEN transaction_type = 'Return' THEN total_amount ELSE 0 END)) AS money_lost,

    ROUND(
        ABS(SUM(CASE WHEN transaction_type = 'Return' THEN quantity ELSE 0 END)) * 100.0 /
        SUM(CASE WHEN transaction_type = 'Sale' THEN quantity ELSE 0 END),
        2
    ) AS return_rate_pct

FROM clean_sales
WHERE stock_code NOT IN ('M', 'POST', 'D', 'BANK CHARGES', 'PADS', 'DOT')
GROUP BY stock_code, description
HAVING SUM(CASE WHEN transaction_type = 'Sale' THEN quantity ELSE 0 END) > 100
   AND ABS(SUM(CASE WHEN transaction_type = 'Return' THEN quantity ELSE 0 END)) <= SUM(CASE WHEN transaction_type = 'Sale' THEN quantity ELSE 0 END)
ORDER BY return_rate_pct DESC
LIMIT 10;

/* -----------------------------------------------------------------------------
   4. GEOGRAPHIC PERFORMANCE
   Business Question: Which top 5 countries generate the most net revenue?
   ----------------------------------------------------------------------------- */
SELECT 
    country,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(total_amount), 2) AS net_revenue,
    ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER(), 2) AS revenue_share_pct
FROM clean_sales
GROUP BY country
ORDER BY net_revenue DESC
LIMIT 5;
