USE mydb;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10),
    city VARCHAR(20),
    order_date DATE,
    amount INT
);

INSERT INTO orders VALUES
(1, 'C101', 'Pune',    '2026-01-05',  500),
(2, 'C102', 'Pune',    '2026-01-10',  800),
(3, 'C101', 'Pune',    '2026-01-15',  800),
(4, 'C103', 'Pune',    '2026-01-20', 1200),
(5, 'C104', 'Mumbai',  '2026-01-08',  400),
(6, 'C105', 'Mumbai',  '2026-01-12', 1500),
(7, 'C104', 'Mumbai',  '2026-01-18', 1500),
(8, 'C106', 'Delhi',   '2026-01-14',  900);

select * from orders;

SELECT order_id, city, amount,
       SUM(amount) OVER () AS grand_total,
       ROUND(100.0 * amount / SUM(amount) OVER (), 1) AS pct_of_grand_total
FROM orders;

SELECT order_id, city, amount,
       SUM(amount) OVER (PARTITION BY city) AS city_total,
       ROUND(100.0 * amount / SUM(amount) OVER (PARTITION BY city), 1) AS pct_of_city_total
FROM orders;

SELECT order_id, order_date, amount,
       SUM(amount) OVER (ORDER BY order_date) AS company_running_total,
       ROW_NUMBER() OVER (ORDER BY order_date) AS global_order_seq
FROM orders;


SELECT order_id, order_date, amount,city,
       SUM(amount) OVER (PARTITION BY city ORDER BY order_date) AS company_running_total
       -- ,
       -- ROW_NUMBER() OVER (ORDER BY order_date) AS global_order_seq
FROM orders;

SELECT order_id, city, order_date, amount,
       -- 1. Running Total that resets per city:
       SUM(amount) OVER (
           PARTITION BY city 
           ORDER BY order_date 
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS city_running_total,

       -- 2. Ranking by largest amount within city:
       ROW_NUMBER() OVER (PARTITION BY city ORDER BY amount DESC, order_id ASC) AS rn,
       RANK()       OVER (PARTITION BY city ORDER BY amount DESC) AS rnk,
       DENSE_RANK() OVER (PARTITION BY city ORDER BY amount DESC) AS drnk,

       -- 3. Comparing with the customer's previous order in that city:
       LAG(amount) OVER (PARTITION BY city ORDER BY order_date) AS prev_order_amt,
       amount - LAG(amount) OVER (PARTITION BY city ORDER BY order_date) AS diff_vs_prev
FROM orders;












