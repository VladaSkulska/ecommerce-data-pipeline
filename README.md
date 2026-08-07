# ecommerce-data-pipeline
End-to-end e-commerce data pipeline: SQL (PostgreSQL) ETL, data cleansing, financial metrics analysis, Excel reporting, and interactive Tableau dashboard.

---

## Tech Stack & Tools
* **SQL (PostgreSQL):** Data extraction, ETL, CTEs, Window Functions, filtering out incomplete records.
* **Google Sheets / Excel:** Data enrichment (XLOOKUP), financial formulas (ROUND, SUM), matrix modeling (Pivot Tables), Heatmaps.
* **Data Analysis:** AI-Assisted Executive Reporting & Data Validation.
* **Tableau:** Interactive dashboards, global geographical maps, regional/country drill-down analysis, and financial visual storytelling.
---

## Data Pipeline Workflow

### Phase 1: Data Extraction & Cleansing (SQL)
* Queried raw transaction logs to separate actual sales from returns/refunds.
* Filtered out canceled orders and null customer IDs to maintain data integrity.
* Aggregated monthly sales metrics, total order volumes, and financial figures at the country level.

### Phase 2: Data Enrichment & Modeling (Excel / Google Sheets)
* **Regional Mapping:** Created a custom mapping dictionary and utilized `=XLOOKUP()` to categorize individual countries into broader economic regions (e.g., Europe, APAC, Americas).
* **KPI Dashboard:** Built a concise summary block calculating Total Net Revenue and Top Sales Country, as well as Average Order Value (AOV) using financial rounding: `=ROUND(SUM(monthly_sales_by_country!E:E) / SUM(monthly_sales_by_country!D:D), 2)`.
* **Matrix Modeling:** Constructed a multi-level Pivot Table hierarchy (`Region` -> `Country` -> `Year-Month`).
* Applied **Conditional Formatting (Color Scales)** to create an automated Heatmap, instantly highlighting seasonal sales peaks.

### Phase 3: AI-Assisted Business Insights
* Processed the aggregated regional and seasonal data matrices through an LLM to identify hidden trends.
* Generated structured executive insights detailing Q4 seasonality, regional return rate anomalies, and APAC B2B purchasing behavior.

### Phase 4: Data Visualization (Tableau)
* Developed an interactive Tableau dashboard providing dual-level analytics:
  * **Macro-Regional Overview:** High-level executive views comparing revenue contribution, AOV, and return rates across key economic regions (Domestic, Europe, APAC, Americas).
  * **Country Drill-Down Analysis:** Granular geographical map and bar charts tracking performance and return rate anomalies at the individual country level (e.g., UK dominance, Netherlands efficiency vs. Spain/US return spikes).
  * **Seasonal Dynamic Trends:** Integrated time-series visual filters for monthly revenue and return surges.

---

## 📊 Key Business Insights

### 1. The Q4 Surge & Post-Holiday Return Backlash
* **Trend:** Sales peak dramatically in Q4, hitting a high of **$1,161,817** in November, followed by strong October and September numbers.
* **Risk:** December and January show massive spikes in return volume (over **$175k** in December alone, representing ~33% of gross sales).
* **Recommendation:** Optimize reverse logistics and increase customer service staffing during the Dec-Jan window to efficiently handle the predictable post-holiday return influx.

### 2. APAC B2B Potential vs. Domestic Dominance
* **Volume:** The UK dominates overall volume, generating **$7.3M** (82% of net revenue).
* **Efficiency:** The APAC region processes significantly fewer orders but boasts an extraordinary Average Order Value (AOV) of **$2,376** per order, indicating strong B2B or wholesale activity compared to the $439 Domestic AOV.
* **Recommendation:** Develop targeted marketing strategies and tiered pricing to capture more high-value wholesale clients in the APAC market.

### 3. Return Rate Anomalies by Region
* **High Performers:** The Netherlands drives high international revenue ($285k) with an exceptionally low return rate of just **0.27%**.
* **Friction Points:** Spain (11.05% returns) and the Americas region (22.04% returns) suffer from abnormally high return rates.
* **Recommendation:** Conduct a localized audit of product descriptions, sizing charts, and fulfillment partners in Spain and the Americas to identify friction points and reduce the return rate.

---

## Repository Structure
* `sql/` - Contains the PostgreSQL queries used for data extraction and aggregation.
* `data/` - Contains the cleaned and aggregated dataset.
* `images/` - Screenshots of the Excel modeling (Heatmaps, KPI formulas).
