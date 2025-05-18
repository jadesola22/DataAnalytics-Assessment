WITH last_txn AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
)
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    l.last_transaction_date,
    DATEDIFF(CURDATE(), l.last_transaction_date) AS inactivity_days
FROM plans_plan p
JOIN last_txn l ON p.id = l.plan_id
WHERE DATEDIFF(CURDATE(), l.last_transaction_date) > 365
  AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND (p.is_deleted = 0 OR p.is_deleted IS NULL);