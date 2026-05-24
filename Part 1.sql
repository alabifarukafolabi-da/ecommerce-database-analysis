SELECT *
FROM customers 
;

SELECT DISTINCT account_status
FROM customers 
 ;

SELECT *
FROM customers 
LIMIT 100 ;

SELECT *
FROM customers 
WHERE EMAIL IS NULL
LIMIT 100 ;

SELECT *
FROM customers 
WHERE account_status = 'Inactive';


SELECT *
FROM order_items 
LIMIT 100 ;

SELECT *
FROM order_items 
;

SELECT *
FROM orders 
LIMIT 100 ;

SELECT DISTINCT order_status
FROM orders 
;

SELECT *
FROM orders 
WHERE delivery_date IS NULL
LIMIT 100 ;

SELECT *
FROM payments 
LIMIT 100 ;

SELECT *
FROM reviews 
LIMIT 100 ;

SELECT *
FROM sellers 
LIMIT 100 ;


/*
DATA CLEANING 
*/
---- CUSTOMERS TABLE 

SELECT email, COUNT(*)
FROM customers
GROUP BY  email
HAVING COUNT(*) > 1
;


SELECT email, MIN(ctid)
FROM customers
GROUP BY email
ORDER BY MIN(ctid)

SELECT *
FROM customers
WHERE email = 'tunde.oluwole733@gmail.com'

---- INCONSISTENT FORMATTING 
UPDATE customers
SET city = TRIM(
INITCAP( REPLACE (REPLACE(city, 'Lago s', 'Lagos'),'Port-Harcourt','Port Harcourt'))
)

UPDATE customers
SET city = 'Port Harcourt'
WHERE city ILIKE '%Portharcourt%';

UPDATE sellers
SET city = TRIM(
INITCAP( REPLACE (REPLACE (REPLACE(city, 'Lago s', 'Lagos'),'Port-Harcourt','Port Harcourt'), 'Portharcourt', 'Port Harcourt'))
);
----------
SELECT * 
FROM sellers 

SELECT DISTINCT product_category 
FROM sellers 


UPDATE sellers
SET product_category = TRIM(
INITCAP(product_category)
);

UPDATE sellers
SET product_category = REPLACE (REPLACE (REPLACE(product_category, 'Books', 'Books & Stationery'),'Electronis','Electronics'), 'Sports', 'Sports And Fitness')
;

UPDATE sellers
SET product_category = TRIM (
INITCAP ( REPLACE( product_category, 'And', '&'))
)
;

UPDATE sellers
SET product_category = 'Sports & Fitness'
WHERE product_category ILIKE '%Sport%';

UPDATE sellers
SET product_category = 'Books & Stationery'
WHERE product_category ILIKE '%Books%';

UPDATE sellers
SET product_category = 'Food & Beverages'
WHERE product_category ILIKE '%Food%';

UPDATE sellers
SET product_category = 'Fashion'
WHERE product_category ILIKE '%Fash%';

UPDATE sellers
SET product_category = 'Beauty & Personal Care'
WHERE product_category ILIKE '%Beauty%';

--------
SELECT * 
FROM products

SELECT DISTINCT category 
FROM products 


UPDATE products
SET category = TRIM(
INITCAP(category)
);

UPDATE products
SET category = TRIM (
INITCAP ( REPLACE( category, 'And', '&'))
)
;

UPDATE products
SET category = 'Sports & Fitness'
WHERE category ILIKE '%Sport%';

UPDATE products
SET category = 'Books & Stationery'
WHERE category ILIKE '%Books%';

UPDATE products
SET category = 'Food & Beverages'
WHERE category ILIKE '%Food%';

UPDATE products
SET category = 'Fashion'
WHERE category ILIKE '%Fash%';

UPDATE products
SET category = 'Beauty & Personal Care'
WHERE category ILIKE '%Beauty%';

UPDATE products
SET category = 'Electronics'
WHERE category ILIKE '%Electr%';


------ Rating Review
SELECT *
FROM reviews
WHERE rating > 5 OR rating < 1

DELETE FROM reviews 
WHERE rating > 5 OR rating < 1

------ Checking Negative Price 
 SELECT * 
 FROM payments
 WHERE amount < 0 --- No negative price 
 
SELECT * 
 FROM products
 WHERE unit_price < 0 

 SELECT * 
 FROM order_items
 WHERE unit_price < 0 

 SELECT * 
 FROM orders
 WHERE total_amount < 0 
 
------- Price Validation Flagged or Not Using BOOLEAN 

ALTER TABLE orders 
ADD COLUMN is_amount_flagged BOOLEAN DEFAULT FALSE;

-- Flagged TRUE if there is a discrepancy > ₦10.
UPDATE orders o
SET is_amount_flagged = TRUE
FROM (
    SELECT order_id, SUM(line_total) as calculated_total
    FROM order_items
    GROUP BY order_id
) oi
WHERE o.order_id = oi.order_id
AND ABS(o.total_amount - oi.calculated_total) > 10;

SELECT *
FROM orders
WHERE is_amount_flagged = 'TRUE'

-------Data Quality check
SELECT *
FROM products 
WHERE product_name IS NULL OR TRIM(product_name) = '';

SELECT * FROM products 
WHERE product_id IN (
    SELECT product_id 
    FROM order_items 
    GROUP BY product_id 
    HAVING SUM(line_total) = 334110
);

SELECT 
    p.product_id,         -- <--- ADD THIS LINE
    p.product_name,
    p.category,
    SUM(oi.line_total) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY 
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;


