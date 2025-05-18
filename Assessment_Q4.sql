-- Step 1: Summarize transactions per customer
WITH txn_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,  -- Number of transactions
        SUM(confirmed_amount) / 100 AS total_amount  -- Total deposit amount in Naira (converted from kobo)
    FROM savings_savingsaccount
    GROUP BY owner_id
),

-- Step 2: Calculate customer tenure in months since account was enabled
tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, enabled_at, CURDATE()) AS tenure_months  -- Duration of user activity in months
    FROM users_customuser
),

-- Step 3: Estimate Customer Lifetime Value (CLV)
clv_calc AS (
    SELECT 
        t.customer_id,
        t.name,
        te.total_transactions,
        te.total_amount,
        t.tenure_months,

        -- Estimated CLV: annualized transaction rate × assumed revenue per transaction (₦1)
        ROUND((te.total_transactions / NULLIF(t.tenure_months, 0)) * 12 * 0.001, 2) AS estimated_clv
    FROM tenure t
    JOIN txn_summary te ON t.customer_id = te.owner_id
)

-- Final Output: Ranked list of customers by CLV
SELECT * FROM clv_calc
ORDER BY estimated_clv DESC;

