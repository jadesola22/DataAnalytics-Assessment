WITH transaction_counts AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_txn,
        (YEAR(CURDATE()) - YEAR(MIN(transaction_date))) AS years,
        (MONTH(CURDATE()) - MONTH(MIN(transaction_date))) AS months
    FROM savings_savingsaccount
    GROUP BY owner_id
),
monthly_avg AS (
    SELECT 
        owner_id,
        total_txn,
        GREATEST((years * 12 + months), 1) AS total_months,
        ROUND(total_txn / GREATEST((years * 12 + months), 1), 2) AS avg_txn_per_month
    FROM transaction_counts
),
categorized AS (
    SELECT 
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
    FROM monthly_avg
    GROUP BY frequency_category
)
SELECT * FROM categorized;