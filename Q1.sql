----- Question 1: Customer Acquisition & 30-Day Conversion
-- The top 5 states by new customer sign-ups in 2024 and the 30-day conversion rate.

SELECT 
    c.state,
    COUNT(DISTINCT c.customer_id) AS total_new_customers,
    
    COUNT(DISTINCT CASE 
        WHEN o.order_date <= c.signup_date + INTERVAL '30 days' 
        THEN c.customer_id 
    END) AS total_customers_within_30_days_with_purchase,
    
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN o.order_date <= c.signup_date + INTERVAL '30 days' 
            THEN c.customer_id 
        END) * 100.0 / COUNT(DISTINCT c.customer_id), 
    2) AS purchase_customers_percent
    
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM c.signup_date) = 2024
GROUP BY c.state
ORDER BY total_new_customers DESC
LIMIT 5;