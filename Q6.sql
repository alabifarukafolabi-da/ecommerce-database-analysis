-- Question 6: Payment Method Preferences by State
-- I Analyze transaction counts and totals by payment method and state, identifying the most popular per state.

WITH StatePayments AS (
    SELECT 
        c.state,
        p.payment_method,
        COUNT(p.payment_id) AS transaction_count,
        SUM(p.amount) AS total_amount
    FROM 
        customers c
    JOIN 
        orders o ON c.customer_id = o.customer_id
    JOIN 
        payments p ON o.order_id = p.order_id
    GROUP BY 
        c.state, 
        p.payment_method
),
RankedPayments AS (
    SELECT 
        state,
        payment_method,
        transaction_count,
        total_amount,
        RANK() OVER (PARTITION BY state ORDER BY transaction_count DESC) AS popularity_rank
    FROM 
        StatePayments
)
SELECT 
    state,
    payment_method,
    transaction_count,
    total_amount,
    CASE 
        WHEN popularity_rank = 1 THEN 'Most Popular' 
        ELSE '' 
    END AS state_preference_status
FROM 
    RankedPayments
ORDER BY 
    state ASC, 
    transaction_count DESC;