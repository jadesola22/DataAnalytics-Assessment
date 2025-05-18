-- Step 1: Calculate total number of transactions and how long each user has been active
WITH transaction_counts AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_txn,  -- Total transactions per user
        (YEAR(CURDATE()) - YEAR(MIN(transaction_date))) AS years,  -- Years since first transaction
        (MONTH(CURDATE()) - MONTH(MIN(transaction_date))) AS months  -- Months since first transaction
    FROM savings_savingsaccount
    GROUP BY owner_id
),

-- Step 2: Convert the duration into total months and calculate average transactions per month
monthly_avg AS (
    SELECT 
        owner_id,
        total_txn,
        -- Ensure at least 1 month to avoid division by zero
        GREATEST((years * 12 + months), 1) AS total_months,
        ROUND(total_txn / GREATEST((years * 12 + months), 1), 2) AS avg_txn_per_month
    FROM transaction_counts
),

-- Step 3: Categorize users based on their monthly transaction frequency
categorized AS (
    SELECT 
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,  -- Number of users in each category
        ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
    FROM monthly_avg
    GROUP BY frequency_category
)

-- Final output: customer distribution by frequency category
SELECT * FROM categorized;

