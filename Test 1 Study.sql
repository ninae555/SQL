use ap;
SELECT vendor_name, vendor_contact_last_name, vendor_contact_first_name
FROM vendors
ORDER BY vendor_contact_last_name, vendor_contact_first_name;

SELECT CONCAT(vendor_contact_last_name, ', ', vendor_contact_first_name) AS full_name
FROM vendors
WHERE vendor_contact_last_name < 'D' OR vendor_contact_last_name LIKE 'E%'
ORDER BY vendor_contact_last_name;

SELECT invoice_due_date AS 'due date', invoice_total AS 'Invoice Total', invoice_total * .10 AS '10%', invoice_total * 1.1 AS "Plus 10%"
FROM invoices
WHERE invoice_total >= 500 AND invoice_total <= 1000
ORDER BY invoice_due_date DESC;

SELECT invoice_number, invoice_total, payment_total + credit_total AS 'payment_credit_total', invoice_total - payment_total - credit_total AS 'balance_due'
FROM invoices
WHERE invoice_total - payment_total - credit_total > 50
ORDER BY balance_due DESC
LIMIT 5;

SELECT invoice_number, invoice_date, invoice_total - payment_total - credit_total AS 'balance_due', payment_date
FROM invoices
WHERE payment_date IS NULL;

SELECT DATE_FORMAT(CURRENT_DATE, '%m-%d-%Y') AS 'current_date';

SELECT 50000 AS 'starting_[rincipal', 50000 * .065 AS 'interest', 50000 + (50000 *.05);

SELECT *
FROM vendors v JOIN invoices i
ON v.vendor_id = i.vendor_id;

SELECT vendor_name, invoice_number, invoice_date, invoice_total - payment_total - credit_total 
FROM vendors v JOIN invoices i
ON v.vendor_id = i.vendor_id
WHERE invoice_total - payment_total - credit_total <> 0
ORDER BY vendor_name;

SELECT vendor_name, default_account_number AS 'default_account', account_description
FROM vendors v JOIN. general_ledger_accounts g
ON v.default_account_number = g.account_number
ORDER BY account_description, vendor_name;

SELECT vendor_name, invoice_date, invoice_number, invoice_sequence AS 'li_sequence', line_item_amount AS'li_amount'
FROM vendors v JOIN invoices i 
ON v.vendor_id = i.vendor_id
JOIN invoice_line_items il
ON i.invoice_id = il.invoice_id
ORDER BY vendor_name, invoice_date, invoice_number, invoice_sequence;

SELECT vendor_id, vendor_name, CONCAT(vendor_contact_first_name, ' ', vendor_contact_last_name) AS contact_name
FROM vendors v1 JOIN vendors v2
ON v1.vendor_id <> v2.venor_id AND v1.vendor_contact_last_name
ORDER BY v1.vendor_contact_last_name;

SELECT gl.account_number, account_description, invoice_id
FROM general_ledger_accounts gl LEFT JOIN invoice_line_items li
  ON gl.account_number = li.account_number
WHERE li.invoice_id IS NULL
ORDER BY gl.account_number;


SELECT vendor_name, vendor_state
  FROM vendors
  WHERE vendor_state = 'CA'
UNION
  SELECT vendor_name, 'Outside CA'
  FROM vendors
  WHERE vendor_state <> 'CA'
ORDER BY vendor_name;

SELECT  vendor_id, SUM(invoice_total) AS invoice_total_sum
FROM invoices
GROUP BY vendor_id;

SELECT vendor_name, SUM(payment_total) AS payment_total_sum
FROM invoices i JOIN vendors v
ON i.vendor_id = v.vendor_id
GROUP BY vendor_name
ORDER BY payment_total_sum DESC;

SELECT vendor_name, COUNT(*) AS invoice_count, SUM(invoice_total) AS invoice_total_sum
FROM vendors v JOIN invoices i 
ON v.vendor_id = i.vendor_id
GROUP BY vendor_name
ORDER BY invoice_count DESC;

SELECT account_description, COUNT(*) AS invoice_line_items_count, SUM(line_item_amount) AS line_item_amount_sum
FROM general_ledger_accounts gl JOIN invoice_line_items il
ON gl.account_number = il.account_number
GROUP BY account_description
HAVING invoice_line_items_count >1
ORDER BY line_item_amount_sum DESC;

SELECT account_description, COUNT(*) AS invoice_line_items_count, SUM(line_item_amount) AS line_item_amount_sum
FROM general_ledger_accounts gl JOIN invoice_line_items il
ON gl.account_number = il.account_number
JOIN invoices i 
ON il.invoice_id = i.invoice_id
WHERE invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
GROUP BY account_description
HAVING invoice_line_items_count > 1
ORDER BY line_item_amount_sum DESC;

SELECT account_number, SUM(line_item_amount) AS line_item_amount_sum
FROM invoice_line_items
GROUP BY account_number WITH ROLLUP;


SELECT vendor_name
FROM vendors
WHERE vendor_id IN
     (SELECT DISTINCT vendor_id FROM invoices)
ORDER BY vendor_name;

SELECT invoice_id, invoice_total
FROM invoices
WHERE payment_total >
(SELECT AVG(payment_total) FROM invoices WHERE payment_total > 0)
ORDER BY invoice_total;

SELECT account_number, account_description
FROM general_ledger_accounts gl
WHERE NOT EXISTS 
(SELECT *
FROM invoice_line_items 
WHERE account_number=gl.account_number)
ORDER BY account_number;
use ap;

SELECT vendor_name, invoice_id, invoice_squence, line_item_amount
FROM vendors v JOIN invoices i 
ON v.vendor_id = i.vendor_id
JOIN invoice_line_iems il
ON i.invoice_id = il.invoice_id
WHERE i.invoice_id IN
(SELECT DISTINCT invoice_id
FROM invoice_line_items 
WHERE invoice_sequence > 1)
ORDER BY vendor_name, i.invoice_id, invoice_sequence;

use my_guitar_shop;
SELECT category_name, COUNT(product_id) AS products_count, 
MIN(list_price) AS least_expensive
FROM categories c JOIN products p
ON c.category_id = p.category_id
GROUP BY category_name 
ORDER BY products_count DESC;

SELECT email_address, SUM(item_price * quantity) as price_sum, 
SUM(discount_amount * quantity) AS discount
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY email_address
ORDER BY price_sum DESC;

SELECT email_address, COUNT(o.order_id) AS total_orders, 
SUM((item_price - discount_amount) * quantity) AS total_amount
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY email_address
HAVING total_orders > 1
ORDER BY total_amount DESC;

SELECT email_address, COUNT(o.order_id) AS total_orders, 
SUM((item_price - discount_amount) * quantity) AS total_amount
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE item_price > 100
GROUP BY email_address
HAVING total_orders > 2
ORDER BY total_amount DESC;

SELECT product_name,  
SUM((item_price - discount_amount) * quantity) AS total_amount
FROM order_items oi JOIN products p
ON oi.product_id = p.product_id
GROUP BY product_name
WITH ROLLUP;

SELECT DISTINCT category_name

FROM categories c JOIN products p

  ON c.category_id = p.category_id

ORDER BY category_name;

SELECT category_name
FROM categories 
WHERE category_id IN
(SELECT distinct category_id
FROM products)
ORDER BY category_name;

SELECT product_name, list_price
FROM products
WHERE list_price > (SELECT AVG(list_price)
FROM products)
ORDER BY list_price DESC;

	
SELECT product_name, discount_percent
FROM products
WHERE
    discount_percent NOT IN (SELECT discount_percent
        FROM products
        GROUP BY discount_percent
        HAVING COUNT(discount_percent) > 1)
ORDER BY product_name;


use ap;
SELECT invoice_total, FORMAT(invoice_total, 1), 
CONVERT(invoice_total, SIGNED) AS invoice_total_int, CAST(invoice_total AS SIGNED) AS invoice_total_int_cast
FROM invoices;

SELECT invoice_date
FROM invoices;

SELECT invoice_date,
CAST(invoice_date AS DATETIME), CAST(invoice_date AS CHAR(7))
FROM invoices;
SELECT invoice_total
FROM invoices;


SELECT invoice_total,
ROUND(invoice_total, 1) AS rounded_total, 
ROUND(invoice_total, 0) AS rounded_total_no_decimal,
TRUNCATE(invoice_total,0) AS trunacate
FROM invoices;

use ex;
SELECT start_date,
DATE_FORMAT(start_date, '%m/%d/%y') AS DATE_M_D_YY,
DATE_FORMAT(start_date, '%c/%e/%y') AS DATE_no_leading_zeros,
DATE_FORMAT(start_date, '%I:%i/%p') AS DATE_hours,
DATE_FORMAT(start_date, '%c/%e/%y %l:%i %p') AS format3 
FROM date_sample;

use ap;

SELECT invoice_number, invoice_date, 
DATE_ADD(invoice_date, INTERVAL 30 DAY) AS added_30_days, 
payment_date,
DATEDIFF(payment_date, invoice_date) AS number_of_days, 
MONTH(invoice_date) AS 'month',
YEAR(invoice_date) AS 'year'
FROM invoices
WHERE invoice_date > '2018-05-01' AND invoice_date < '2018-06-01';

/* Chapter 1 Assignment Practice */

use my_guitar_shop;
SELECT product_name, list_price, date_added
FROM products
WHERE list_price > 500 AND list_price < 2000
ORDER BY date_added DESC;

SELECT item_id, item_price, discount_amount, 
quantity, item_price * quantity AS price_total, 
discount_amount * quantity AS discount_total, 
(item_price - discount_amount) * quantity AS item_total
FROM order_items
WHERE (item_price - discount_amount) * quantity > 500
ORDER BY item_total DESC;

SELECT CURRENT_DATE, DATE_FORMAT(CURRENT_DATE, '%e-%b-%Y');
SELECT 100 AS price, .07 AS tax_rate, 100 * .07 AS tax_amount, 100 + (100 *.07) AS total;

SELECT first_name, last_name, line1, city, state, zip_code
FROM customers c JOIN addresses a
ON c.customer_id = a.customer_id;

SELECT category_name, product_id
FROM categories c LEFT JOIN products p 
ON c.category_id = p.category_id
WHERE product_id IS NULL;

SELECT 'shipped' AS ship_status, order_id, order_date
FROM orders 
WHERE ship_date > 0
UNION
SELECT 'not shipped' AS ship_status, order_id, order_date
FROM orders
WHERE ship_date IS NULL
ORDER BY order_date;

INSERT INTO products VALUES
(DEFAULT, 4, 'dgx_640', 'Yamaha DGX 640 88-Key Digital Plano', 'Long descriptions to come', 799.99, 0, CURRENT_DATE);

UPDATE products
SET discount_percent = .35 
WHERE discount_percent = 0;