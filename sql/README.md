# E-Commerce Revenue & Customer Behavior Pipeline

## Business Context & Goals
The online store faced a classic growth challenge: top-line revenue looked promising, but net profitability was under pressure. Management lacked clear visibility into real performance due to noise and raw transactional anomalies in the accounting database.

**Core Business Questions:**
1. What is our actual Gross vs. Net Revenue, and how much is lost to returns?
2. Who drives our bottom line — one-time buyers or our core Repeat Customers?
3. Which specific products are "profit killers" due to high return rates or defects?
4. Which geographic markets yield the highest financial returns for targeted marketing?

---

## Data Pipeline & Cleaning Strategy
The raw dataset contained duplicates, missing values, and system-level noise. Before computing business metrics, a complete data transformation was executed in PostgreSQL (`01_clean_data.sql`):

* **Deduplication:** Identified and removed full row duplicates.
* **Data Hygiene:** Filtered out records with `price <= 0` and missing `customer_id` attributes.
* **Transaction Segmentation:** Categorized canceled/returned orders (invoices starting with `C`) as `Return` and valid purchases as `Sale`.
* **System Noise Removal:** Excluded non-product administrative codes (`M` — Manual, `POST` — Postage, `D` — Discount, `BANK CHARGES`) from product-level analysis.
* **Anomaly Handling:** Resolved time-lag mismatches where returns exceeded sales within the report boundary.

---

## 📈 Key Findings & Executive Insights

### 1. Overall Financial Performance ($8.3M Net Revenue)
* **Gross Revenue:** **$8,911,425.90**
* **Returned Revenue:** **$611,342.09** (**6.86%** leakage of potential revenue)
* **Net Revenue:** **$8,300,083.81**

### 2. Customer Retention & LTV Dynamics (Pareto Principle)
* **Repeat Customers (2+ orders):** Represent **65.5%** of the customer base (2,845 accounts) but generate **93.08% of total Net Revenue** ($8.29M).
* **LTV Contrast:** The average revenue per repeat customer (**$2,915.68**) is **7x higher** than that of a one-time buyer (**$412.80**).

### 3. Product Quality & High-Loss Items
* **PAPER CRAFT , LITTLE BIRDIE (Stock Code: 23843):** Top driver of financial loss — 80,995 units sold with a **100% return rate**. Direct loss: **$168,469.60**.
* **MEDIUM CERAMIC TOP STORAGE JAR (Stock Code: 23166):** Experienced a **95.61% return rate** (74,494 returned units), costing **$77,479.64**.
* **Manual Adjustments (`M` - Manual):** Manual override transactions resulted in a net negative impact of **$112,165.39**, highlighting a gap in manual discount governance.

### 4. Geographic Performance
* **United Kingdom (Domestic Market):** Accounts for **81.54%** of total revenue ($6.76M) and 3,949 active customers.
* **B2B Potential (Netherlands & EIRE):** Netherlands generated **$284,661.54** with only 9 distinct customer accounts (average revenue > $31k per client), signaling a high-value B2B segment.

---

## Recommendations on how to Act

1. **Shift Marketing Focus (Retention over Acquisition):**
   Reallocate budget from cold customer acquisition toward retention workflows. Implement automated email triggers and second-purchase incentives within 14 days — converting a buyer into a `Repeat Customer` yields a 7x LTV boost.
2. **Supply Chain & Packaging Audits:**
   * **PAPER CRAFT:** Investigate the root cause of the 100% batch cancellation ($168k loss) to determine if it stems from vendor defect or data entry error.
   * **Ceramic Storage Jars:** A 95% return rate on ceramics indicates transit breakage. Require reinforced protective packaging (bubble wrap/kraft boxes) or evaluate logistics handling.
3. **Financial Controls on Manual Overrides (`M`):**
   Establish strict limits and dual-authorization rules for manual ledger entries (`M` code) to eliminate unaccounted manual leakage ($112k).
4. **Scale EU B2B Operations:**
   Build dedicated corporate account management and tiered volume pricing for high-value international markets like the Netherlands and EIRE.

---

## Tech Stack
* **Database:** PostgreSQL
* **Tooling:** pgAdmin 4
* **SQL Concepts:** Common Table Expressions (CTEs), Window Functions (`OVER()`), Aggregations, Data Casting, Conditional Filtering (`CASE WHEN`, `HAVING`).
