# Credit-Card-Portfolio-Profitability-Revenue-Leakage-Analysis

## Project Overview

This project analyzes the financial performance of a simulated credit card portfolio to identify the key drivers of profitability, revenue leakage, customer behavior, and credit risk.

Using SQL, Power BI, Python, and Excel, the analysis evaluates how different card products, customer segments, spending patterns, and delinquency levels impact overall portfolio performance. The project provides data-driven recommendations to improve profitability while reducing operational and credit risk.

## Business Problem

A retail bank has experienced steady growth in credit card customers and transaction volume, but overall profitability has not improved at the same pace. Rising cashback expenses, reward costs, fee waivers, and customer delinquency are reducing portfolio returns.

Management wants to answer the following questions:

* Which card products generate the highest profitability?
* Which revenue sources contribute the most?
* Where is revenue leaking?
* Which customer segments are most profitable?
* How does delinquency affect profitability?
* Which customers should be retained, upgraded, or monitored?
## Project Objectives
* Analyze overall portfolio profitability.
* Identify major revenue and cost drivers.
* Measure revenue leakage from cashback, rewards, and fee waivers.
* Evaluate profitability across customer segments and card products.
* Assess portfolio health and delinquency risk.
* Build an interactive executive dashboard for business decision-making.
* Recommend strategies to improve profitability and reduce risk.
## Dataset Overview
Metric	Value
* Customers	10,000
* Analysis Period	12 Months
* Transactions	150,000+
* Tables	4
* Dashboard Pages	5
### Data Model
* Cardholders
* Transactions
* Billing
* Delinquency
## Tools & Technologies
* SQL (MySQL) – Data extraction and business analysis
* Power BI – Interactive dashboard development
* Excel – Data validation and exploratory analysis
* GitHub – Version control and project documentation
*  ## Analytical Approach
The analysis was completed across five business areas:
* 1. Portfolio Profitability
* Revenue
* Cost
* Net Profit
* Profit Margin
* Monthly Performance
* 2. Product Profitability
* Card Type Performance
* Income Segment Analysis
* Customer Profitability
* City-wise Profitability
* 3. Revenue Leakage
* Cashback Cost
* Reward Cost
* Fee Waivers
* Leakage Ratio
* 4. Portfolio Risk
* Delinquency Analysis
* Outstanding Balance Exposure
* Credit Utilization
* Portfolio Health
* 5. Customer Spending Behaviour
* Spending Categories
* Transaction Analysis
* Customer Value
* Category-wise Spend
## Dashboard Pages
* Page 1 — Executive Portfolio Overview - 
Provides an executive summary of portfolio performance including revenue, profit, profit margin, revenue composition, product profitability, and delinquency KPIs.

* Page 2 — Product Profitability & Revenue Leakage - 

Analyzes profitability across Classic, Gold, and Platinum cards while identifying major revenue leakage from cashback, rewards, and fee waivers.

 * Page 3 — Risk & Delinquency - 

Evaluates delinquency movement across DPD buckets, outstanding balance exposure, and customer risk concentration.

*  Page 4 — Portfolio Health - 

Analyzes portfolio health distribution, watchlist customers, high-risk accounts, and credit utilization.

* Page 5 — Customer & Spend Behaviour - 

Explores customer profitability, spending categories, city-wise performance, and spending patterns.

## Key Business Findings
* Portfolio generated ₹50.38M in total revenue and ₹17.63M in net profit, achieving a 34.99% profit margin across 10,000 customers over 12 months.
* Interchange revenue contributed ₹17.75M (35.23% of total revenue), making it the largest individual revenue source and highlighting the importance of customer spending behaviour.
* Cashback cost reached ₹19.78M, making it the largest cost component and the primary driver of portfolio revenue leakage.
* Platinum cards achieved the highest profit margin (47.78%), while Classic cards generated the highest revenue (₹21.46M) but the lowest profit margin (25.47%), indicating lower cost efficiency.
* The portfolio recorded a 15.23% delinquency rate, with 571 customers in the 90+ DPD bucket representing the highest credit risk segment requiring immediate attention.
* Travel accounted for ₹638M (approximately 55% of total portfolio spend), making it the highest spending category, while city-wise profitability remained relatively consistent across all locations.
## Business Recommendations
* 1. Optimize Classic Card Cashback Strategy - Reduce cashback on low-margin categories while maintaining attractive rewards on high-value spending categories to reduce revenue leakage.
* Expected Impact: Improve profitability by reducing unnecessary cashback costs.

* 2. Upgrade High-Value Classic Customers - Identify high-spending Classic cardholders and promote Gold cards to improve long-term portfolio profitability through a more efficient reward structure.

* 3. Launch Early Delinquency Intervention - Implement automated payment reminders, EMI restructuring, and proactive customer outreach for Watchlist customers before they migrate into higher DPD buckets.

* 4. Review Platinum Fee Waiver Policy - Restrict fee waivers to eligible customer scenarios to reduce unnecessary revenue leakage without impacting customer retention.

* 5. Focus Customer Acquisition on Spending Behaviour - Prioritize acquisition campaigns targeting profitable spending patterns rather than geographic location to improve overall portfolio quality.

## Skills Demonstrated
* SQL (Joins, CTEs, Window Functions, Aggregations, Subqueries)
* Data Cleaning & Validation
* Business KPI Development
* Financial & Portfolio Analysis
* Customer Segmentation
* Revenue Leakage Analysis
* Risk & Delinquency Analysis
* Power BI Dashboard Development
* Data Storytelling
* Business Recommendation Framework
