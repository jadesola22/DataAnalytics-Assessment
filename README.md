Introduction

This project contains my responses to a business-focused SQL assessment. The goal was to explore a structured dataset of users, plans, and transactions, and extract insights through precise SQL queries.

Before diving into each SQL file, I want to highlight some key experiences and challenges faced during this task.
Setup Hurdles
1.Getting the Data**
   - Downloading and extracting the dataset took a lot of time due to its large size.
   - The provided README was helpful, but understanding how the tables relate to one another took careful inspection — especially identifying how `users`, `plans`, `savings`, and `withdrawals` were linked.
2.Understanding the Schema
   - Important relationships like `owner_id` linking users to savings accounts, and `plan_id` connecting savings to plans, were initially not obvious.
   - Flags like `is_regular_savings` and `is_a_fund` were critical in filtering savings vs investment products, and understanding them was essential before attempting any query.
 Query-by-Query Breakdown
Assessment_Q1 — Customers with Both Savings and Investment Plans
Purpose:  
Find customers who have at least one savings** and one investment plan, and calculate their total confirmed deposits.
Key Logic:
- JOIN statements were used to combine savings with plans and users.
- Used `CASE WHEN` inside `COUNT(DISTINCT ...)` to separate savings from investments.
- Used `HAVING` to filter only users with both types of products.
- Converted `confirmed_amount` from **kobo to naira** by dividing by 100.
Challenge: 
Ensuring that the user has both product types required a `HAVING` clause instead of a `WHERE`, since the filtering was based on grouped values.
Assessment_Q2.sql — Estimating Customer Lifetime Value (CLV)
Purpose:
Estimate a simple version of Customer Lifetime Value by using transaction volume and user tenure.
Key Logic:
- Counted transactions and calculated total confirmed amount per user.
- Calculated `tenure` as number of months since the account was enabled.
- Estimated CLV with the formula:  
  `(transactions per month) × 12 × ₦1` (using 0.001 multiplier as a proxy).
Challenge: 
Avoiding divide-by-zero errors when tenure was 0 months. I handled this using `NULLIF()` and ensured safe calculations using SQL rounding.

Assessment_Q3 — Categorizing Users by Monthly Transaction Frequency
Purpose:  
Categorize customers as High,Medium, or Low frequency users based on their average monthly transaction volume.
Key Logic:
- Used `Max(transaction_date)` to determine how long each user has been transacting.
- Converted that into total months using current date.
- Calculated average transactions per month and categorized them:
  - High: ≥10
  - Medium: ≥3 and <10
  - Low: <3
Challenge: 
Ensuring total months was never 0 by wrapping the logic in GREATEST(..., 1). Also, breaking down the logic into Common Table Expressions (CTEs) improved clarity.

Assessment_Q4.sql` — Detecting Dormant Plans
Purpose: 
Find plans (either savings or investment) that haven’t had any transaction in over a year.

Key Logic:
- Found the **most recent transaction date** per plan.
- Calculated inactivity as the number of days since the last transaction.
- Filtered out deleted plans and only included those inactive for over 365 days.

Challenge:  
Plans that are soft-deleted (`is_deleted = 1`) needed to be excluded, and inactive duration required precise use of `DATEDIFF()`. 
i tried Date_trunc and discovered by research that my sql workbench dont use it but prefered extract or format to format data.

in Conclusion i approached each question by trying to understand what table we are to join to each table and why, what is common 
This assessment tested not only my SQL skills, but also my ability to think like an analyst — understanding business requirements, 
connecting data relationships, and writing optimized queries

