

CREATE TABLE cardholders (
    customer_id VARCHAR(20) PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    income_band VARCHAR(30),
    card_type VARCHAR(20),
    credit_limit DECIMAL(12,2),
    join_date DATE,
    account_status VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cardholders.csv'
INTO TABLE cardholders
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE transactions (
    transaction_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20),
    transaction_date DATE,
    category VARCHAR(50),
    amount DECIMAL(12,2),
    reward_points INT,
    cashback_amount DECIMAL(12,2),

    FOREIGN KEY (customer_id)
    REFERENCES cardholders(customer_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transaction.csv'
INTO TABLE transactions
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE billing (
    billing_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20),

    card_type VARCHAR(20),

    month DATE,

    total_spend DECIMAL(12,2),
    minimum_due DECIMAL(12,2),
    amount_paid DECIMAL(12,2),

    interest_income DECIMAL(12,2),
    annual_fee DECIMAL(12,2),
    late_fee DECIMAL(12,2),
    emi_fee DECIMAL(12,2),

    fee_waiver DECIMAL(12,2),

    interchange_revenue DECIMAL(12,2),

    cashback_cost DECIMAL(12,2),

    profit DECIMAL(12,2),

    reward_cost DECIMAL(12,2),

    outstanding_balance DECIMAL(12,2),

    FOREIGN KEY (customer_id)
    REFERENCES cardholders(customer_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/billing.csv'
INTO TABLE billing
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
billing_id,
customer_id,
card_type,
@month,
total_spend,
minimum_due,
amount_paid,
interest_income,
annual_fee,
late_fee,
emi_fee,
fee_waiver,
interchange_revenue,
cashback_cost,
profit,
reward_cost,
outstanding_balance
)
SET month = STR_TO_DATE(@month,'%d-%m-%Y');

CREATE TABLE delinquency (
    customer_id VARCHAR(20),
    month DATE,

    days_past_due INT,
    delinquency_bucket VARCHAR(20),

    utilization_rate DECIMAL(5,2),
    portfolio_health VARCHAR(20),

    PRIMARY KEY (customer_id, month),

    FOREIGN KEY (customer_id)
    REFERENCES cardholders(customer_id)
);

describe delinquency;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delinquency_new.csv'
INTO TABLE delinquency
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
customer_id,
@month,
delinquency_bucket,
days_past_due,
portfolio_health,
utilization_rate
)
SET month = STR_TO_DATE(@month,'%Y-%m-%d');

select count(*) from transactions;
-- update 
SELECT
COUNT(*) AS late_fee_records
FROM billing
WHERE late_fee > 0;

UPDATE billing b
JOIN delinquency d
ON b.customer_id = d.customer_id
AND b.month = d.month
SET b.late_fee =
CASE
    WHEN d.days_past_due = 0 THEN 0
    WHEN d.days_past_due BETWEEN 1 AND 30 THEN 100
    WHEN d.days_past_due BETWEEN 31 AND 60 THEN 300
    WHEN d.days_past_due BETWEEN 61 AND 90 THEN 500
    ELSE 750
END;

SELECT
late_fee,
COUNT(*) AS records
FROM billing
GROUP BY late_fee
ORDER BY late_fee;

UPDATE billing
SET profit =
(
    interest_income
    + annual_fee
    + late_fee
    + emi_fee
    + interchange_revenue
)
-
(
    reward_cost
    + cashback_cost
    + fee_waiver
);

SELECT
month,
SUM(interest_income) AS interest_income,
SUM(annual_fee) AS annual_fee,
SUM(late_fee) AS late_fee,
SUM(emi_fee) AS emi_fee,
SUM(interchange_revenue) AS interchange_revenue
FROM billing
GROUP BY month
ORDER BY month;

/* 01. Portfolio Profitability Overview
Q1. Total Portfolio Profit */
SELECT ROUND(SUM(profit),2) AS total_profit
FROM billing;
-- Q2. Total Portfolio Revenue
SELECT ROUND(
SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS total_revenue
FROM billing;
-- Q3. Total Portfolio Cost
SELECT ROUND(
SUM(
cashback_cost +
reward_cost +
fee_waiver
),2) AS total_cost
FROM billing;
-- Q4. Portfolio Profit Margin
SELECT ROUND(
SUM(profit) * 100 /
SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS profit_margin
FROM billing;
-- Q5. Monthly Profit Trend
SELECT
month,
ROUND(SUM(profit),2) AS total_profit
FROM billing
GROUP BY month
ORDER BY month;
-- Q6. Monthly Revenue Trend
SELECT
month,
ROUND(SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS total_revenue
FROM billing
GROUP BY month
ORDER BY month;
-- Q7. Monthly Cost Trend
SELECT
month,
ROUND(SUM(
cashback_cost +
reward_cost +
fee_waiver
),2) AS total_cost
FROM billing
GROUP BY month
ORDER BY month;
-- Q8. Revenue Source Contribution
SELECT 'Interest Income' AS revenue_source,
ROUND(SUM(interest_income),2) AS revenue
FROM billing

UNION ALL

SELECT 'Annual Fee',
ROUND(SUM(annual_fee),2)
FROM billing

UNION ALL

SELECT 'Late Fee',
ROUND(SUM(late_fee),2)
FROM billing

UNION ALL

SELECT 'EMI Fee',
ROUND(SUM(emi_fee),2)
FROM billing

UNION ALL

SELECT 'Interchange Revenue',
ROUND(SUM(interchange_revenue),2)
FROM billing;
-- Q9. Cost Source Contribution
SELECT 'Cashback Cost' AS cost_source,
ROUND(SUM(cashback_cost),2)
FROM billing

UNION ALL

SELECT 'Reward Cost',
ROUND(SUM(reward_cost),2)
FROM billing

UNION ALL

SELECT 'Fee Waiver',
ROUND(SUM(fee_waiver),2)
FROM billing;
-- Q10. Rewards & Cashback Consumption %
SELECT ROUND(
SUM(cashback_cost + reward_cost) * 100 /
SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS reward_cashback_percentage
FROM billing;
-- 02. Card Type Profitability Analysis
-- Profit by Card Type
SELECT
card_type,
ROUND(SUM(profit),2) AS total_profit
FROM billing
GROUP BY card_type;
-- Revenue by Card Type
SELECT
card_type,
ROUND(SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS total_revenue
FROM billing
GROUP BY card_type;
-- Cost by Card Type
SELECT
card_type,
ROUND(SUM(
cashback_cost +
reward_cost +
fee_waiver
),2) AS total_cost
FROM billing
GROUP BY card_type;

--- Profit Margin by Card Type
SELECT
card_type,
ROUND(
SUM(profit) * 100 /
SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS profit_margin
FROM billing
GROUP BY card_type;


# 03. Customer Segment Profitability Analysis
### Profit by Income Band
SELECT
c.income_band,
ROUND(SUM(b.profit),2) AS total_profit
FROM billing b
JOIN cardholders c
ON b.customer_id = c.customer_id
GROUP BY c.income_band;
### Revenue by Income Band

SELECT
c.income_band,
ROUND(SUM(
b.interest_income +
b.annual_fee +
b.late_fee +
b.emi_fee +
b.interchange_revenue
),2) AS total_revenue
FROM billing b
JOIN cardholders c
ON b.customer_id = c.customer_id
GROUP BY c.income_band;

### Cost by Income Band
SELECT
c.income_band,
ROUND(SUM(
b.cashback_cost +
b.reward_cost +
b.fee_waiver
),2) AS total_cost
FROM billing b
JOIN cardholders c
ON b.customer_id = c.customer_id
GROUP BY c.income_band;

### Profit Margin by Income Band
SELECT
c.income_band,
ROUND(
SUM(b.profit) * 100 /
SUM(
b.interest_income +
b.annual_fee +
b.late_fee +
b.emi_fee +
b.interchange_revenue
),2) AS profit_margin
FROM billing b
JOIN cardholders c
ON b.customer_id = c.customer_id
GROUP BY c.income_band;

# 04. Revenue Leakage Analysis
### Cashback by Card Type
SELECT
card_type,
ROUND(SUM(cashback_cost),2) AS cashback_payouts
FROM billing
GROUP BY card_type;

### Reward Cost by Card Type

SELECT
card_type,
ROUND(SUM(reward_cost),2) AS total_reward_cost
FROM billing
GROUP BY card_type;

### Fee Waiver by Card Type

SELECT
card_type,
ROUND(SUM(fee_waiver),2) AS total_fee_waiver
FROM billing
GROUP BY card_type;

### Leakage % by Card Type

SELECT
card_type,
ROUND(
SUM(cashback_cost + reward_cost + fee_waiver) * 100 /
SUM(
interest_income +
annual_fee +
late_fee +
emi_fee +
interchange_revenue
),2) AS leakage_pct
FROM billing
GROUP BY card_type;

# 05. Top Customer Analysis

### Top 10 Profitable Customers

SELECT
customer_id,
ROUND(SUM(profit),2) AS total_profit
FROM billing
GROUP BY customer_id
ORDER BY total_profit DESC
LIMIT 10;

### Top 20 Contribution
SELECT ROUND(SUM(total_profit),2)
FROM
(
SELECT
customer_id,
SUM(profit) AS total_profit
FROM billing
GROUP BY customer_id
ORDER BY total_profit DESC
LIMIT 20
) t;

### Customer Segmentation

SELECT
CASE
WHEN total_profit >= 8000 THEN 'VIP'
WHEN total_profit >= 4000 THEN 'High Value'
ELSE 'Regular'
END AS customer_segment,
COUNT(*) AS customer_count
FROM
(
SELECT
customer_id,
SUM(profit) AS total_profit
FROM billing
GROUP BY customer_id
) t
GROUP BY customer_segment;

# 06. Delinquency Analysis
### Bucket Distribution
SELECT
delinquency_bucket,
COUNT(DISTINCT customer_id) AS customer_count
FROM delinquency
GROUP BY delinquency_bucket;

### Delinquency by Card Type
SELECT
c.card_type,
d.delinquency_bucket,
COUNT(DISTINCT d.customer_id) AS customers
FROM delinquency d
JOIN cardholders c
ON d.customer_id = c.customer_id
GROUP BY c.card_type,d.delinquency_bucket;

### Delinquency by Income Band
SELECT
c.income_band,
d.delinquency_bucket,
COUNT(DISTINCT d.customer_id) AS customers
FROM delinquency d
JOIN cardholders c
ON d.customer_id = c.customer_id
GROUP BY c.income_band,d.delinquency_bucket;
### Profit Exposure

SELECT
d.delinquency_bucket,
ROUND(SUM(b.profit),2) AS total_profit
FROM delinquency d
JOIN billing b
ON d.customer_id=b.customer_id
AND d.month=b.month
GROUP BY d.delinquency_bucket;

### Outstanding Balance Exposure

SELECT
d.delinquency_bucket,
ROUND(SUM(b.outstanding_balance),2)
AS total_outstanding_balance
FROM delinquency d
JOIN billing b
ON d.customer_id=b.customer_id
AND d.month=b.month
GROUP BY d.delinquency_bucket;

# 07. Portfolio Health Analysis

### Health Distribution
SELECT
portfolio_health,
COUNT(DISTINCT customer_id)
AS customer_count
FROM delinquency
GROUP BY portfolio_health;

### Utilization by Health

SELECT
portfolio_health,
ROUND(AVG(utilization_rate),2)
AS avg_utilization
FROM delinquency
GROUP BY portfolio_health;

### Health by Card Type

SELECT
c.card_type,
d.portfolio_health,
COUNT(DISTINCT d.customer_id)
AS customer_count
FROM delinquency d
JOIN cardholders c
ON d.customer_id=c.customer_id
GROUP BY c.card_type,d.portfolio_health;
### Health by Income Band

SELECT
c.income_band,
d.portfolio_health,
COUNT(DISTINCT d.customer_id)
AS customer_count
FROM delinquency d
JOIN cardholders c
ON d.customer_id=c.customer_id
GROUP BY c.income_band,d.portfolio_health;

# 08. Credit Utilization vs Profitability
### Customer Count

SELECT
CASE
WHEN utilization_rate < 0.30 THEN 'Low Utilization'
WHEN utilization_rate < 0.70 THEN 'Medium Utilization'
ELSE 'High Utilization'
END AS utilization_band,
COUNT(DISTINCT customer_id)
AS customer_count
FROM delinquency
GROUP BY utilization_band;

### Profit by Utilization
SELECT
CASE
WHEN d.utilization_rate < 0.30 THEN 'Low Utilization'
WHEN d.utilization_rate < 0.70 THEN 'Medium Utilization'
ELSE 'High Utilization'
END AS utilization_band,
ROUND(SUM(b.profit),2) AS total_profit
FROM delinquency d
JOIN billing b
ON d.customer_id=b.customer_id
AND d.month=b.month
GROUP BY utilization_band;

### Revenue by Utilization

SELECT
CASE
WHEN d.utilization_rate < 0.30 THEN 'Low Utilization'
WHEN d.utilization_rate < 0.70 THEN 'Medium Utilization'
ELSE 'High Utilization'
END AS utilization_band,
ROUND(SUM(
b.interest_income +
b.annual_fee +
b.late_fee +
b.emi_fee +
b.interchange_revenue
),2) AS total_revenue
FROM delinquency d
JOIN billing b
ON d.customer_id=b.customer_id
AND d.month=b.month
GROUP BY utilization_band;

# 09. City-wise Profitability Analysis

### Profit by City

SELECT
c.city,
ROUND(SUM(b.profit),2)
AS total_profit
FROM billing b
JOIN cardholders c
ON b.customer_id=c.customer_id
GROUP BY c.city
ORDER BY total_profit DESC;

