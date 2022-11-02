use my_guitar_shop;
SELECT category_name, 
COUNT(product_id) AS number_of_products, 
MIN(list_price) AS least_expensive_product
FROM categories c JOIN products p
ON c.category_id = p.category_id
GROUP BY category_name
ORDER BY number_of_products DESC;

SELECT 
    c.email_address,
    COUNT(o.order_id) AS count,
    SUM(o.item_price - o.discount_amount) * COUNT(o.order_id) AS total_amount
FROM customers  c
JOIN orders ord 
ON c.customer_id = ord.customer_id
JOIN order_items o 
ON o.order_id = ord.order_id
GROUP BY c.customer_id
HAVING count > 1
ORDER BY total_amount DESC;



SELECT c.email_address, 
COUNT(oi.order_id) AS count_,
SUM(oi.item_price - oi.discount_amount) * COUNT(oi.order_id) AS total_amount
FROM customers c 
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY c.customer_id
HAVING count > 1
ORDER BY total_amount DESC;

use my_guitar_shop;
SELECT product_name, SUM(list_price - discount_percent * quantity) AS total_amount
FROM products p JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY product_name
WITH ROLLUP;



SELECT category_name
FROM categories
WHERE category_id IN 
(SELECT DISTINCT category_id FROM products)
ORDER BY category_name;


SELECT 
    product_name, list_price
FROM products
WHERE
    list_price > (SELECT AVG(list_price)
        FROM products)
ORDER BY list_price DESC;

SELECT category_name
FROM categories c
WHERE
    NOT EXISTS( SELECT *
        FROM products p
        WHERE p.category_id = c.category_id);
        
SELECT 
    email_address,
    SUM(oi.item_price) * COUNT(oi.item_id) AS first_sum_by_count,
    SUM(oi.discount_amount) * COUNT(oi.item_id) AS second_sum_by_count
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN
    order_items oi 
    ON oi.order_id = o.order_id
GROUP BY c.customer_id
ORDER BY SUM(oi.item_price) DESC;

SELECT c.email_address, 
SUM(oi.item_price - oi.discount_amount) * COUNT(oi.order_id) AS total_amount
FROM customers c 
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
WHERE oi.item_price > 100
GROUP BY c.customer_id
HAVING count_ > 2
ORDER BY total_amount DESC;


SELECT product_name, SUM(list_price - discount_percent * quantity) AS total_amount
FROM products p JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY product_name
WITH ROLLUP;

use my_guitar_shop;
SELECT category_name,
COUNT(product_id) AS number_of_products,
MIN(list_price) AS least_expensive_product
FROM categories c JOIN products p
ON c.category_id = p.category_id
GROUP BY category_name
ORDER BY number_of_products DESC;

SELECT c.email_address,SUM(oi.item_price) * COUNT(oi.item_id) AS first_sum_by_count,
SUM(oi.discount_amount) * COUNT(oi.item_id) AS second_sum_by_count
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON oi.order_id = o.order_id
GROUP BY c.customer_id
ORDER BY SUM(oi.item_price) DESC;


SELECT 
    email_address,
    SUM(oi.item_price) * COUNT(oi.item_id) AS first_sum_by_count,
    SUM(oi.discount_amount) * COUNT(oi.item_id) AS second_sum_by_count
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id
ORDER BY SUM(oi.item_price) DESC;