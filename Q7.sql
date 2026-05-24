-- Question 7: Review Ratings and Sales Performance
-- Segments products by average rating and calculates their revenue and price metrics.

WITH ProductRatings AS (
    SELECT 
        product_id, 
        AVG(rating) AS avg_rating
    FROM 
        reviews
    GROUP BY 
        product_id
),
ProductRevenue AS (
    SELECT 
        product_id, 
        SUM(line_total) AS total_revenue
    FROM 
        order_items
    GROUP BY 
        product_id
),
CategorizedProducts AS (
    SELECT 
        p.product_id,
        p.unit_price,
        pr.avg_rating,
        prev.total_revenue,
        CASE 
            WHEN pr.avg_rating >= 4.0 THEN 'High Rated'
            WHEN pr.avg_rating >= 3.0 THEN 'Mid Rated'
            WHEN pr.avg_rating < 3.0 THEN 'Low Rated'
        END AS rating_category
    FROM 
        products p
    JOIN 
        ProductRatings pr ON p.product_id = pr.product_id 
    LEFT JOIN 
        ProductRevenue prev ON p.product_id = prev.product_id
)
SELECT 
    rating_category,
    COUNT(product_id) AS product_count,
    COALESCE(SUM(total_revenue), 0) AS total_revenue,
    ROUND(AVG(unit_price), 2) AS average_unit_price
FROM 
    CategorizedProducts
GROUP BY 
    rating_category
ORDER BY 
    total_revenue DESC;