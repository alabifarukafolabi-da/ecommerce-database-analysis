# E-Commerce Database Analysis & Strategic Growth Optimization

## 📌 Project Overview
An end-to-end data sanitization and strategic analysis of a messy, real-world e-commerce database (TradeZone). This project transformed raw, inconsistent transactional data into actionable business intelligence, focusing on customer segmentation, seller efficiency, and Year-over-Year (YoY) revenue growth.

## 🎯 Business Problem
TradeZone required a comprehensive audit of their 2023-2024 transactional database to uncover hidden revenue gaps, rectify poor seller hygiene, and identify the highest-value customer segments for targeted 2025 marketing and retention strategies.

## 🛠️ Tools & Technologies Used
* **Relational Database:** PostgreSQL (pgAdmin 4)
* **Core SQL Concepts:** Common Table Expressions (CTEs), Window Functions (`LAG()`, `RANK()`, `ROW_NUMBER()`), Conditional Aggregation (`CASE WHEN`), Data Type Casting, and Table Joins.
* **Business Intelligence:** Data Validation, Financial Discrepancy Flagging, and Executive Reporting.

## 🔬 Methodology
1. **Data Cleaning & Integrity Protection:** * Safely isolated and resolved duplicate customer profiles using `ROW_NUMBER()` without breaking active foreign key constraints or deleting innocent accounts sharing emails.
   * Sanitized inconsistent text formatting, removed HTML artifacts (`&amp;`), and standardized product categories using `INITCAP` and `REPLACE`.
2. **Data Validation:** * Filtered out mathematically impossible data (e.g., negative prices, out-of-bound ratings).
   * Built boolean flags (`is_amount_flagged`) to identify checkout bugs where order line-item totals did not match the final invoice, preserving historical revenue metrics without deleting data.
3. **Exploratory Data Analysis:** * Leveraged complex CTEs to prevent Cartesian Fan-Outs when calculating seller ratings alongside revenue.
   * Used Window Functions to rank regional payment preferences and calculate exact YoY quarterly revenue growth.

## 📈 Key Insights & Business Impact
* **VIP Revenue Concentration:** Segmented the 2024 customer base and discovered that "High Spenders" (≥ ₦100,000) drive a massively disproportionate share of total revenue. *Recommendation: Shift 30% of generalized acquisition budget into a VIP retention and loyalty protocol.*
* **Unattributed Revenue ("Ghost Products"):** Uncovered thousands of Naira in sales attributed to completely blank (`NULL`) product entries, skewing catalog analytics. *Recommendation: Institute automated scripts to unlist missing metadata to improve search algorithms.*
* **Fulfillment Speed vs. Quality:** Identified a distinct disconnect between ultra-fast delivery times and customer satisfaction. The highest-earning, most reliable sellers were those maintaining a 4.0+ rating, not necessarily those with the fastest shipping.

## 📂 Repository Structure
* `Data_Cleaning_Script.sql`: The complete recipe for handling duplicates, formatting, and validation.
* `Exploratory_Analysis_Queries/`: Folder containing all advanced business logic queries (Customer Segmentation, YoY Growth, Seller Efficiency).
* `Analyst_Memo.pdf`: The final executive summary delivered to the Head of Growth and Operations.
