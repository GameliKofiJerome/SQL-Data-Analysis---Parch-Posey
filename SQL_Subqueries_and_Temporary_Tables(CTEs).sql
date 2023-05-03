/*SUB-QUERIES*/

/*
Find the average number of events for each day for each channel.
*/

SELECT channel, AVG(num_events) AS avg_events
FROM
	(SELECT channel, FORMAT(occurred_at, 'yyyy-MM-dd') AS day, COUNT(*) AS num_events
	FROM parch_and_posey.dbo.web_events
	GROUP BY  channel, FORMAT(occurred_at, 'yyyy-MM-dd')) AS events_table
GROUP BY channel
ORDER BY avg_events DESC;


/*
Find only the orders that took place in the same month and year as the first order,
and then pull the average for each type of paper 'qty' in this month.
*/

SELECT AVG(standard_qty) AS avg_std,
	   AVG(poster_qty) AS avg_pos,
	   AVG(gloss_qty) AS avg_gls,
	   FORMAT(occurred_at, 'yyyy-MMMM') AS year_month
FROM parch_and_posey.dbo.orders
WHERE FORMAT(occurred_at, 'yyyy-MMMM') =
	(SELECT FORMAT(MIN(occurred_at), 'yyyy-MMMM') AS year_month
	FROM parch_and_posey.dbo.orders)
GROUP BY FORMAT(occurred_at, 'yyyy-MMMM');
-- The result shows that the first order occurred in Decemeber 2013, with standard_qty recording the highest average of 268


/*
What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/

SELECT AVG(total_spent) AS avg_top_ten_customer
FROM
	(SELECT TOP 10 a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
	FROM parch_and_posey.dbo.orders o
	INNER JOIN parch_and_posey.dbo.accounts a
	ON a.id = o.account_id
	GROUP BY a.name
	ORDER BY total_spent DESC) top_ten_customer;


/*
What is the lifetime average amount spent in terms of total_amt_usd, including
only the companies that spent more per order, on average, than the average of all orders.
*/

SELECT AVG(avg_amt) AS avg_amt
FROM
	(SELECT account_id, AVG(total_amt_usd) AS avg_amt
	FROM parch_and_posey.dbo.orders
	GROUP BY account_id
	HAVING AVG(total_amt_usd) >
		(SELECT AVG(total_amt_usd) AS avg_All
		FROM parch_and_posey.dbo.orders)
	) AS above_avg_amt;

-- The lifetime average amount spent is 4721.14, which is above the total_amt_usd average of all orders.


/*
Provide the name of the sales rep in each region with the largest amount of total_amt_usd sales.
*/

SELECT all_region_sales.sales_rep, all_region_sales.region, all_region_sales.total_amt
FROM
	(SELECT region, MAX(total_amt) AS max_amount
	FROM
		(SELECT s.name AS sales_rep, r.name AS region, SUM(o.total_amt_usd) AS total_amt
		FROM  parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON o.account_id = a.id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON a.sales_rep_id = s.id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY s.name, r.name) AS all_orders
	GROUP BY region) AS regions_sales
JOIN
	(SELECT s.name AS sales_rep, r.name AS region, SUM(o.total_amt_usd) AS total_amt
		FROM  parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON o.account_id = a.id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON a.sales_rep_id = s.id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY s.name, r.name) AS all_region_sales
ON regions_sales.region = all_region_sales.region AND regions_sales.max_amount = all_region_sales.total_amt;


/*
For the region with the largest sales total_amt_usd, how many total orders were placed?
*/

SELECT r.name AS region, COUNT(*) AS total_order_count
		FROM parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON a.id = o.account_id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON s.id = a.sales_rep_id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY r.name
HAVING SUM(o.total_amt_usd) =
	(SELECT MAX(total_amt) AS max_amt
	FROM
		(SELECT r.name AS region, SUM(o.total_amt_usd) AS total_amt
		FROM parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON a.id = o.account_id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON s.id = a.sales_rep_id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY r.name) AS region_sales);



/*Common Table Expressions (CTEs)*/

/*
Find the average number of events for each day for each channel.
*/

WITH all_events AS (
	SELECT channel, FORMAT(occurred_at, 'yyyy-MM-dd') AS day, COUNT(*) AS num_events
	FROM parch_and_posey.dbo.web_events
	GROUP BY  channel, FORMAT(occurred_at, 'yyyy-MM-dd'))
SELECT channel, AVG(num_events) AS avg_events
FROM all_events
GROUP BY channel
ORDER BY avg_events DESC;


/*
Find only the orders that took place in the same month and year as the first order,
and then pull the average for each type of paper 'qty' in this month.
*/

WITH min_month AS (
	SELECT FORMAT(MIN(occurred_at), 'yyyy-MMMM') AS year_month
	FROM parch_and_posey.dbo.orders)
SELECT AVG(standard_qty) AS avg_std,
	   AVG(poster_qty) AS avg_pos,
	   AVG(gloss_qty) AS avg_gls,
	   FORMAT(occurred_at, 'yyyy-MMMM') AS order_year_month
FROM parch_and_posey.dbo.orders
WHERE FORMAT(occurred_at, 'yyyy-MMMM') = (SELECT * FROM min_month)
GROUP BY FORMAT(occurred_at, 'yyyy-MMMM');


/*
What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/

WITH top_ten_customer AS (
	SELECT TOP 10 a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
	FROM parch_and_posey.dbo.orders o
	INNER JOIN parch_and_posey.dbo.accounts a
	ON a.id = o.account_id
	GROUP BY a.name
	ORDER BY total_spent DESC)
SELECT AVG(total_spent) AS avg_top_ten_custmer
FROM top_ten_customer;


/*
What is the lifetime average amount spent in terms of total_amt_usd, including only the
companies that spent more per order, on average, than the average of all orders.
*/

WITH above_avg_amt AS (
	SELECT account_id, AVG(total_amt_usd) AS avg_amt
	FROM parch_and_posey.dbo.orders
	GROUP BY account_id
	HAVING AVG(total_amt_usd) >
		(SELECT AVG(total_amt_usd) AS avg_All
		FROM parch_and_posey.dbo.orders))
SELECT AVG(avg_amt) AS avg_amt
FROM above_avg_amt;


/*
Provide the name of the sales rep in each region with the largest amount of total_amt_usd sales.
*/

WITH all_region_sales AS (
SELECT s.name AS sales_rep, r.name AS region, SUM(o.total_amt_usd) AS total_amt
		FROM  parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON o.account_id = a.id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON a.sales_rep_id = s.id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY s.name, r.name),
region_sales AS (
SELECT region, MAX(total_amt) AS max_amt
	FROM all_region_sales
	GROUP BY region)
SELECT ars.sales_rep, ars.region, ars.total_amt 
	FROM all_region_sales ars
	JOIN region_sales rs
	ON rs.region = ars.region AND rs.max_amt = ars.total_amt;


/*
For the region with the largest sales total_amt_usd, how many total orders were placed?
*/

WITH region_sales AS (
SELECT r.name AS region, SUM(o.total_amt_usd) AS total_amt
		FROM parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON a.id = o.account_id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON s.id = a.sales_rep_id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY r.name),
max_amt AS (
SELECT MAX(total_amt) AS max_amt
	FROM region_sales)
SELECT r.name AS region, COUNT(*) AS order_count
		FROM parch_and_posey.dbo.orders o
		INNER JOIN parch_and_posey.dbo.accounts a
		ON a.id = o.account_id
		INNER JOIN parch_and_posey.dbo.sales_reps s
		ON s.id = a.sales_rep_id
		INNER JOIN parch_and_posey.dbo.region r
		ON r.id = s.region_id
		GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM max_amt);

