-- Question 4: Quarterly Revenue Trends
-- Calculates quarterly revenue, average order value (AOV), and total orders.
-- Uses window functions to identify Year-over-Year (YoY) revenue growth.

WITH QuarterlyData AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS order_year,
        EXTRACT(QUARTER FROM order_date) AS order_quarter,
        SUM(total_amount) AS total_revenue,
        AVG(total_amount) AS average_order_value,
        COUNT(DISTINCT order_id) AS total_orders
    FROM 
        orders
    WHERE 
        order_status != 'Cancelled'
    GROUP BY 
        EXTRACT(YEAR FROM order_date),
        EXTRACT(QUARTER FROM order_date)
)
SELECT 
    order_year,
    order_quarter,
    total_revenue,
    ROUND(average_order_value, 2) AS avg_order_value,
    total_orders,
    total_revenue - LAG(total_revenue) OVER (PARTITION BY order_quarter ORDER BY order_year) AS yoy_revenue_growth,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (PARTITION BY order_quarter ORDER BY order_year)) 
        / LAG(total_revenue) OVER (PARTITION BY order_quarter ORDER BY order_year) * 100, 
    2) AS yoy_growth_percentage

FROM 
    QuarterlyData
ORDER BY 
    order_year ASC, 
    order_quarter ASC;