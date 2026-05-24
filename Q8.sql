---- Question 8: Top Seller Bonus Qualification
-- I Identified the top 10 sellers in 2024 based on revenue, minimum order count, and high ratings.

WITH SellerSales AS (
    SELECT 
        o.seller_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.line_total) AS total_revenue
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    WHERE 
        EXTRACT(YEAR FROM o.order_date) = 2024
        AND o.order_status != 'Cancelled'
    GROUP BY 
        o.seller_id
),
SellerRatings AS (
    SELECT 
        o.seller_id,
        AVG(r.rating) AS avg_rating
    FROM 
        orders o
    JOIN 
        reviews r ON o.order_id = r.order_id
    GROUP BY 
        o.seller_id
)
SELECT 
    s.seller_name,
    ss.total_orders,
    ROUND(sr.avg_rating, 2) AS average_rating,
    ss.total_revenue
FROM 
    sellers s
JOIN 
    SellerSales ss ON s.seller_id = ss.seller_id
JOIN 
    SellerRatings sr ON s.seller_id = sr.seller_id
WHERE 
    ss.total_orders >= 10       
    AND sr.avg_rating >= 4.0      
ORDER BY 
    ss.total_revenue DESC     
LIMIT 10;