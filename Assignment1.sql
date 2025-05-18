SELECT 
    u.id AS owner_id,
CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) AS investment_count,
    SUM(s.confirmed_amount) / 100 AS total_deposits
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
JOIN users_customuser u ON s.owner_id = u.id
WHERE s.confirmed_amount > 0 AND (p.is_deleted = 0 OR p.is_deleted IS NULL)
GROUP BY u.id, u.name
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;