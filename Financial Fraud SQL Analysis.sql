CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_age INT,
    customer_gender VARCHAR(10),
    income_group VARCHAR(20),
    bank_name VARCHAR(50),
    card_type VARCHAR(20),
    transaction_amount DECIMAL(12,2),
    transaction_type VARCHAR(30),
    transaction_time DATE,
    transaction_location VARCHAR(50),
    state VARCHAR(50),
    device_type VARCHAR(20),
    operating_system VARCHAR(20),
    merchant_category VARCHAR(50),
    previous_transactions_count INT,
    account_balance DECIMAL(15,2),
    international_transaction INT,
    failed_login_attempts INT,
    suspicious_ip_flag INT,
    new_device_login INT,
    risk_score INT,
    is_fraud INT
);

SELECT * FROM transactions;

-- 1. What is the total number of transactions in the dataset?
SELECT COUNT(*) AS total_rows
FROM transactions;

-- 2. How can we preview the first 10 rows of the dataset?
SELECT *
FROM transactions
LIMIT 10;

-- 3. How can we check null values in each column of the dataset?
SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS transaction_id_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE customer_age IS NULL) AS customer_age_nulls,
    COUNT(*) FILTER (WHERE customer_gender IS NULL) AS customer_gender_nulls,
    COUNT(*) FILTER (WHERE income_group IS NULL) AS income_group_nulls,
    COUNT(*) FILTER (WHERE bank_name IS NULL) AS bank_name_nulls,
    COUNT(*) FILTER (WHERE card_type IS NULL) AS card_type_nulls,
	COUNT(*) FILTER (WHERE transaction_amount IS NULL) AS transaction_amount_nulls,
    COUNT(*) FILTER (WHERE transaction_type IS NULL) AS transaction_type_nulls,
    COUNT(*) FILTER (WHERE transaction_time IS NULL) AS transaction_time_nulls,
    COUNT(*) FILTER (WHERE transaction_location IS NULL) AS transaction_location_nulls
FROM transactions;

-- or

SELECT 
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS state_Null_Count,
    SUM(CASE WHEN device_type IS NULL THEN 1 ELSE 0 END) AS device_type_Null_Count,
	SUM(CASE WHEN operating_system IS NULL THEN 1 ELSE 0 END) AS operating_system_Null_Count,
    SUM(CASE WHEN merchant_category IS NULL THEN 1 ELSE 0 END) AS merchant_category_Null_Count,
	SUM(CASE WHEN previous_transactions_count IS NULL THEN 1 ELSE 0 END) AS previous_transactions_count_Null_Count,
    SUM(CASE WHEN account_balance IS NULL THEN 1 ELSE 0 END) AS account_balance_Null_Count,
	SUM(CASE WHEN international_transaction IS NULL THEN 1 ELSE 0 END) AS international_transaction_Null_Count,
	SUM(CASE WHEN failed_login_attempts IS NULL THEN 1 ELSE 0 END) AS failed_login_attempts_Null_Count,
    SUM(CASE WHEN suspicious_ip_flag IS NULL THEN 1 ELSE 0 END) AS suspicious_ip_flag_Null_Count,
	SUM(CASE WHEN new_device_login IS NULL THEN 1 ELSE 0 END) AS new_device_login_Null_Count,
    SUM(CASE WHEN risk_score IS NULL THEN 1 ELSE 0 END) AS risk_score_Null_Count,
	SUM(CASE WHEN is_fraud IS NULL THEN 1 ELSE 0 END) AS is_fraud_Null_Count
FROM transactions;

-- 4. How can we identify duplicate rows and duplicate transaction IDs?
SELECT *,
       COUNT(*)
FROM transactions
GROUP BY
    transaction_id,
    customer_id,
    customer_age,
    customer_gender,
    income_group,
    bank_name,
    card_type,
    transaction_amount,
    transaction_type,
    transaction_time,
    transaction_location,
    state,
    device_type,
    operating_system,
    merchant_category,
    previous_transactions_count,
    account_balance,
    international_transaction,
    failed_login_attempts,
    suspicious_ip_flag,
    new_device_login,
    risk_score,
    is_fraud
HAVING COUNT(*) > 1;

-- or
SELECT transaction_id,
       COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- 5. What are the distinct bank names, transaction types, and device types available in the dataset?
SELECT DISTINCT bank_name
FROM transactions;

SELECT 
    DISTINCT bank_name,
    COUNT(bank_name) AS TotalCount
FROM transactions
GROUP BY bank_name;

-- Distinct Transaction Types.
SELECT DISTINCT transaction_type
FROM transactions;

-- Distinct Device Types
SELECT DISTINCT device_type
FROM transactions;

SELECT 
	customer_gender, 
	COUNT(customer_gender) AS TotalCount,
    ROUND (COUNT(customer_gender) * 100.0 / (SELECT COUNT(*) FROM transactions), 2) AS Percentage
FROM transactions
GROUP BY customer_gender;

-- 6. What is the minimum, maximum, and average transaction amount?
SELECT
    MIN(transaction_amount) AS minimum_amount,
    MAX(transaction_amount) AS maximum_amount,
    AVG(transaction_amount) AS average_amount
FROM transactions;

-- 7. How many fraud and non-fraud transactions are there?
SELECT
    is_fraud,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY is_fraud;

-- 8. What is the fraud percentage in the dataset?
SELECT
    ROUND( 100.0 * SUM(is_fraud) / COUNT(*), 2) AS fraud_percentage
FROM transactions;

-- 9. Which transaction type has the highest number of transactions?
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    ROUND(AVG(transaction_amount),2) AS avg_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- 10. Which transaction type has the highest fraud cases?
SELECT
    transaction_type,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY transaction_type
ORDER BY fraud_cases DESC;

-- 11. Which bank has the highest fraud percentage?
SELECT
    bank_name,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY bank_name
ORDER BY fraud_cases DESC;

-- 12. Which locations have the highest fraud transactions?
SELECT
    transaction_location,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY transaction_location
ORDER BY fraud_cases DESC
LIMIT 10;

-- 13. Which device type is mostly used for fraudulent transactions?
SELECT
    device_type,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY device_type
ORDER BY fraud_cases DESC;

-- 14. Which transactions are classified as high-risk based on risk score?
SELECT
    transaction_id,
    transaction_amount,
    risk_score
FROM transactions
WHERE risk_score >= 40
ORDER BY risk_score DESC;

-- 15. How are failed login attempts distributed across transactions?
SELECT
    failed_login_attempts,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY failed_login_attempts
ORDER BY failed_login_attempts;

-- 16. Are international transactions more likely to be fraudulent?
SELECT
    international_transaction,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY international_transaction;

-- 17. What is the monthly fraud trend in the dataset?
SELECT
    EXTRACT(MONTH FROM transaction_time) AS month,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY month
ORDER BY month;

-----------------------------------------------------------------------
-- 18. What is the fraud rate percentage by bank?
SELECT
    bank_name,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*),
        2
    ) AS fraud_percentage
FROM transactions
GROUP BY bank_name
ORDER BY fraud_percentage DESC;


-- 19. Who are the top 10 high-risk customers based on fraud activity and risk score?
SELECT
    customer_id,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    MAX(risk_score) AS max_risk_score
FROM transactions
GROUP BY customer_id
ORDER BY fraud_cases DESC, max_risk_score DESC
LIMIT 10;


-- 20. What is the average transaction amount for fraud vs non-fraud transactions?
SELECT
    is_fraud,
    ROUND(AVG(transaction_amount),2) AS avg_transaction_amount
FROM transactions
GROUP BY is_fraud;


-- 21. How does fraud trend vary month-wise?
SELECT
    TO_CHAR(transaction_time, 'Month') AS month_name,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY month_name
ORDER BY fraud_cases DESC;


-- 22. Which device type has the highest fraud rate?
SELECT
    device_type,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY device_type
ORDER BY fraud_rate DESC;


-- 23. Which merchant category has the highest fraud risk and average transaction amount?
SELECT
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        AVG(transaction_amount),
        2
    ) AS avg_amount
FROM transactions
GROUP BY merchant_category
ORDER BY fraud_cases DESC;


-- 24. What is the fraud rate for international vs domestic transactions?
SELECT
    international_transaction,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY international_transaction;


-- 25. How do failed login attempts impact fraud cases?
SELECT
    failed_login_attempts,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases
FROM transactions
GROUP BY failed_login_attempts
ORDER BY failed_login_attempts DESC;


-- 26. Does logging in from a new device increase fraud risk?
SELECT
    new_device_login,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
GROUP BY new_device_login;


-- 27. How can transactions be segmented into low, medium, and high-risk categories using risk score?
SELECT
    CASE
        WHEN risk_score < 20 THEN 'Low Risk'
        WHEN risk_score BETWEEN 20 AND 40 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_category,

    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases

FROM transactions
GROUP BY risk_category
ORDER BY fraud_cases DESC;


-- 28. Which transaction locations have the highest fraud cases?
SELECT
    transaction_location,
    COUNT(*) AS fraud_cases
FROM transactions
WHERE is_fraud = 1
GROUP BY transaction_location
ORDER BY fraud_cases DESC
LIMIT 10;