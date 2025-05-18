WITH txn_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) / 100 AS total_amount
    FROM savings_savingsaccount
    GROUP BY owner_id
),
tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, enabled_at, CURDATE()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        t.customer_id,
        t.name,
        te.total_transactions,
        te.total_amount,
        t.tenure_months,
        ROUND((te.total_transactions / NULLIF(t.tenure_months, 0)) * 12 * 0.001, 2) AS estimated_clv
    FROM tenure t
    JOIN txn_summary te ON t.customer_id = te.owner_id
)
SELECT * FROM clv_calc
ORDER BY estimated_clv DESC;