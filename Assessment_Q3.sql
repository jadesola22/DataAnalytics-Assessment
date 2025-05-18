
-- Step 1: Identify the most recent transaction date per plan
WITH last_txn AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date  -- Latest transaction for each plan
    FROM savings_savingsaccount
    GROUP BY plan_id
)

-- Step 2: Select plans that have been inactive for over a year
SELECT 
    p.id AS plan_id,
    p.owner_id,

    -- Classify plan type for readability
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    l.last_transaction_date,
    
    -- Calculate how many days have passed since the last transaction
    DATEDIFF(CURDATE(), l.last_transaction_date) AS inactivity_days

FROM plans_plan p
JOIN last_txn l ON p.id = l.plan_id

-- Filter for plans with over 365 days of inactivity and are not deleted
WHERE 
    DATEDIFF(CURDATE(), l.last_transaction_date) > 365
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND (p.is_deleted = 0 OR p.is_deleted IS NULL);
