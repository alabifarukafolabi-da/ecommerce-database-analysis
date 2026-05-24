-- Question 3: Seller Fulfilment Efficiency
-- I Find the top 20 fastest sellers (min 20 orders) and include their average rating.

SELECT 
    s.seller_name,
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    ROUND(AVG(o.delivery_date - o.order_date) * 24, 2) AS avg_delivery_hours,
    ROUND(AVG(r.rating), 2) AS average_rating
    
FROM 
    sellers s
JOIN 
    orders o ON s.seller_id = o.seller_id
LEFT JOIN 
    reviews r ON o.order_id = r.order_id
WHERE 
    o.delivery_date IS NOT NULL 
GROUP BY 
    s.seller_id, 
    s.seller_name
HAVING 
    COUNT(DISTINCT o.order_id) >= 20 
ORDER BY 
    avg_delivery_hours ASC        
LIMIT 20;