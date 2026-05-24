-- Question 2: Product Performance
-- I Identifies the top 10 products by total revenue in 2024.

SELECT 
    p.product_name,
    p.category,
    SUM(oi.line_total) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM 
    products p
JOIN 
    order_items oi ON p.product_id = oi.product_id
JOIN 
    orders o ON oi.order_id = o.order_id
WHERE 
    EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY 
    p.product_id,
    p.product_name,
    p.category
ORDER BY 
    total_revenue DESC
LIMIT 10;