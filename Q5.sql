-- Question 5: Customer Spend Segmentation
-- Groups 2024 customers into High, Medium, and Low spenders and calculates group metrics.

WITH CustomerSpends AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spend
    FROM 
        orders
    WHERE 
        EXTRACT(YEAR FROM order_date) = 2024
        AND order_status != 'Cancelled'
    GROUP BY 
        customer_id
),
CustomerSegments AS (
    SELECT 
        customer_id,
        total_spend,
        CASE 
            WHEN total_spend >= 100000 THEN 'High Spenders'
            WHEN total_spend >= 50000 THEN 'Medium Spenders'
            ELSE 'Low Spenders'
        END AS spend_group
    FROM 
        CustomerSpends
)
SELECT 
    spend_group,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(total_spend), 2) AS average_spend_per_customer,
    SUM(total_spend) AS total_revenue_contribution
FROM 
    CustomerSegments
GROUP BY 
    spend_group
ORDER BY 
    total_revenue_contribution DESC;