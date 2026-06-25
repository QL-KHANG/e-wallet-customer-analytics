# E-Wallet Customer Analytics

End-to-end SQL analytics project covering transaction performance, customer behavior, promotion effectiveness, retention analysis, and RFM segmentation using SQL Server.

---

## Project Objectives

The project aims to:

- Evaluate transaction performance and payment success rates
- Analyze customer purchasing behavior
- Measure promotion effectiveness
- Track customer retention using cohort analysis
- Segment customers using RFM analysis
- Build dynamic reporting structures for business monitoring

---

## Project Highlights

- Analyzed 360,744 e-wallet transactions across 12,771 customers and 220 products
- Built 9 business-focused SQL analysis modules
- Applied CTEs, Window Functions, Dynamic SQL, and Pivot techniques
- Performed customer segmentation using RFM Analysis
- Developed retention analysis using Cohort methodology
- Created dynamic reporting structures for business monitoring

---

## Data Sources

Tables used:

- payment_history_17
- payment_history_18
- product
- table_message

Period Covered:

- January 2017 – December 2018

Data Volume:

- 360,744 transactions
- 12,771 customers
- 220 products

---

## SQL Analysis Tasks

### Task 1 – Data Exploration

- Data quality check
- Duplicate detection
- Transaction distribution
- Revenue overview
- Category performance

### Task 2 – Payment Performance Analysis

- Payment success rate
- Success rate by category
- Failure reason analysis
- Top failure reasons

### Task 3 – Customer Analysis

- Customer activity metrics
- Customer segmentation
- Purchase behavior analysis

### Task 4 – Promotion Analysis

- Promotion usage
- Promotion contribution
- Promotion effectiveness

### Task 5 – Revenue Trend Analysis

- Monthly revenue trends
- Revenue growth analysis
- Seasonal patterns

### Task 6 – Retention Cohort Analysis

- Customer retention matrix
- Cohort performance tracking

### Task 7 – Promotion Cost Distribution

- Promotion cost allocation
- Customer activity percentile analysis

### Task 8 – Dynamic Pivot Revenue Report

- Dynamic SQL Pivot
- Monthly revenue by category

### Task 9 – RFM Analysis

- Recency
- Frequency
- Monetary
- Customer segmentation

---

## Key Insights

### Customer Value Concentration

- Champions account for approximately 11% of customers.
- Champions generate over 65% of total revenue.
- Champions and Loyal Customers contribute more than 88% of revenue.

### Promotion Strategy

- Promotion costs are heavily concentrated among highly active customers.
- Frequent users receive the majority of promotional investment.

### Retention

- Customer retention declines steadily over time.
- Early retention periods are critical for customer engagement.

### Revenue

- Revenue is diversified across multiple product categories.
- Billing and Telco are among the strongest revenue contributors.

---

## Tools Used

- Microsoft SQL Server
- T-SQL
- Window Functions
- CTEs
- Dynamic SQL
- Pivot Tables

---

## Repository Structure

```text
01_Data Exploration.sql
02_Payment Performance Analysis.sql
03_Customer Analysis.sql
04_Promotion Analysis.sql
05_Revenue Trend Analysis.sql
06_Retention-Cohort Analysis.sql
07_Promotion Cost Distribution by Customer Activity Level.sql
08_Dynamic Pivot Revenue Report.sql
09_RFM Analysis.sql
```

## Author

Khang Quang

Aspiring Data Analyst transitioning from Finance and Accounting into Data Analytics.

Skills:
- Microsoft SQL Server
- T-SQL
- Data Analysis
- Business Intelligence
- Customer Analytics
- Cohort Analysis
- RFM Segmentation

GitHub:
https://github.com/QL-KHANG

Project Repository:
https://github.com/QL-KHANG/e-wallet-customer-analytics
