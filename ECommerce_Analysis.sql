--Q1
--Create a temporary table that joins the orders, order_products,and products tables 
-- to get information about each order, 
--including the products that were purchased and their department 
--and aisle information

select * from order_products limit 10;
select * from orders limit 10;
select * from products limit 10;

CREATE TEMPORARY TABLE order_info AS(
    SELECT o.order_id, o.order_number, o.order_dow, o.order_hour_of_day, o.days_since_prior_order,
           op.product_id, op.add_to_cart_order, op.reordered,
           p.product_name, p.aisle_id, p.department_id
    FROM orders AS o
    JOIN order_products AS op ON o.order_id = op.order_id
    JOIN products AS p ON op.product_id = p.product_id);

SELECT * from order_info limit 10

--Q2
--Create a temporary table that groups the orders by product
--and finds the total number of times each product was purchased, 
--the total number of times each product was reordered,
--and the average number of times each product was added to a cart.

CREATE TEMP TABLE order_summary as (
SELECT 
product_id,
product_name,
count(order_id) as total_orders,
count(CASE WHEN reordered=1 Then TRUE Else NULL END) as total_reorderd,
avg(add_to_cart_order) as total_card_order
From order_info 
GROUP BY product_id,product_name);

--Q3
--Create a temporary table that groups the orders by department 
--and finds the total number of products purchased, 
--the total number of unique products purchased, 
--the total number of products purchased on weekdays vs weekends, 
--and the average time of day that products in each department are ordered

SELECT * FROM departments limit 10

CREATE TEMPORARY TABLE department_order_summary AS (
    SELECT department_id, COUNT(*) AS total_products_purchased,
           COUNT(DISTINCT product_id) AS total_unique_products_purchased,
           COUNT(CASE WHEN order_dow < 6 THEN 1 ELSE NULL END) AS total_weekday_purchases,
           COUNT(CASE WHEN order_dow >= 6 THEN 1 ELSE NULL END) AS total_weekend_purchases,
           AVG(order_hour_of_day) AS avg_order_time
    FROM order_info
    GROUP BY department_id);
	
	
--Create a temporary table that groups the orders by aisle 
--and finds the top 10 most popular aisles, 
--including the total number of products purchased 
--and the total number of unique products purchased from each aisle

CREATE TEMPORARY TABLE aisle_order_summary AS
    SELECT aisle_id, COUNT(*) AS total_products_purchased,
           COUNT(DISTINCT product_id) AS total_unique_products_purchased
    FROM order_info
    GROUP BY aisle_id
    ORDER BY COUNT(*) DESC
    LIMIT 10
	
--Combine the information from the previous temporary tables into a final table 
--that shows the product ID, product name, department ID, department name, aisle ID,
--aisle name, total number of times purchased, total number of times reordered,
--average number of times added to cart, total number of products purchased, 
--total number of unique products purchased, total number of products purchased on weekdays,
--total number of products purchased on weekends, 
--and average time of day products are ordered in each department.	
	
CREATE TABLE product_behavior_analysis AS(
    SELECT pi.product_id, pi.product_name, pi.department_id, d.department, pi.aisle_id, a.aisle,
           pos.total_orders, pos.total_reorderd, pos.total_card_order,
           dos.total_products_purchased, dos.total_unique_products_purchased,
           dos.total_weekday_purchases, dos.total_weekend_purchases, dos.avg_order_time
    FROM order_summary AS pos
    JOIN products AS pi ON pos.product_id = pi.product_id
    JOIN departments AS d ON pi.department_id = d.department_id
    JOIN aisles AS a ON pi.aisle_id = a.aisle_id
    JOIN department_order_summary AS dos ON pi.department_id = dos.department_id);
	
	