-- This query retrieves users who actively use both savings and investment plans.
-- It returns their ID, full name, counts of each plan type, and total confirmed deposits (in Naira)
SELECT 
    u.id AS owner_id,
  
  -- Combine first and last names to create a readable full name
  
CONCAT(u.first_name, ' ', u.last_name) AS full_name,
  - Count distinct savings plans where the plan is flagged as a regular savings plan
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) AS savings_count,

   Count distinct investment plans where the plan is flagged as an investment fund
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) AS investment_count,
  
   -- Sum confirmed deposits for each user and convert the result from kobo to Naira
    SUM(s.confirmed_amount) / 100 AS total_deposits
  
FROM savings_savingsaccount s
  
  -- Join to retrieve plan detail
JOIN plans_plan p ON s.plan_id = p.id
  
   -- Join to retrieve user details
JOIN users_customuser u ON s.owner_id = u.id
  
  -- Only include records with a positive confirmed deposit
WHERE s.confirmed_amount > 0 
  
  -- Exclude deleted plans
  AND (p.is_deleted = 0 OR p.is_deleted IS NULL)

  
GROUP BY u.id, u.name

   -- Include only users who have both a savings and an investment plan
HAVING savings_count > 0 AND investment_count > 0

  -- Sort users in descending order of total deposits
ORDER BY total_deposits DESC;


