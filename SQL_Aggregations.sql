/* USING SQL AGGREGATION FUNCTIONS */


/* USING COUNT FUNCTION 
Count the number of rows in the orders table.
*/

SELECT COUNT (*) 
FROM parch_and_posey.dbo.orders;


/* USING SUM FUNCTION
Find the total amount of poster_qty paper ordered in the orders table.
*/

SELECT SUM(poster_qty) AS sum_poster_qty
FROM parch_and_posey.dbo.orders;


/*
Find the total amount of standard_qty paper ordered in the orders table.
*/

SELECT SUM(standard_qty) AS sum_standard_qty
FROM parch_and_posey.dbo.orders;


/*
Find the total dollar amount of sales using the total_amt_usd in the orders table.
*/

SELECT SUM(total_amt_usd) AS sum_total_amount_USD
FROM parch_and_posey.dbo.orders;


/*
Find the total amount for each individual order that was spent on standard and gloss papers in the orders table. 
This should give a dollar amount for each order in the order table.
*/

SELECT standard_amt_usd + gloss_amt_usd AS standard_gloss_total
FROM parch_and_posey.dbo.orders;


/*
Find the standard_amount_usd per unit standard quantity paper. Your solution should use both an aggregation and 
a mathematical operator.
*/

SELECT ROUND(SUM(standard_amt_usd)/SUM(standard_qty), 2) AS standard_amt_per_qty
FROM parch_and_posey.dbo.orders;



/* USING MIN/MAX FUNCTIONS */

/*
When was the earliest order ever placed? Only return the date.
*/

SELECT MIN(occurred_at) AS earliest_date
FROM parch_and_posey.dbo.orders;


/*
Try performing same query in the previous one without using an aggregation function.
*/

SELECT TOP 1 occurred_at AS earliest_date
FROM parch_and_posey.dbo.orders
ORDER BY occurred_at;


/*
When did the most recent/latest web-event occur?
*/

SELECT MAX(occurred_at) AS latest_date
FROM parch_and_posey.dbo.web_events;


/*
Try to perform the result of the previous query without using an aggregation function.
*/

SELECT TOP 1 occurred_at AS latest_date
FROM parch_and_posey.dbo.web_events
ORDER BY occurred_at DESC;



/* USING AVG FUNCTION*/

/* 
Find the mean (average) amount spent per order on each paper type , as well  as the mean amount of each 
paper type purchased per order. Your final answer should have 6 values - one for each paper type for the
average number of sales, as well as average amount.
*/

SELECT AVG([standard_qty]) AS avg_standasr_qty,
	   AVG([gloss_qty]) AS avg_gloss_qty,
	   AVG([poster_qty]) AS avg_poster_qty,
	   AVG([standard_amt_usd]) AS avg_standard_amt,
	   AVG([gloss_amt_usd]) AS avg_gloss_amt,
	   AVG([poster_amt_usd]) AS avg_poster_amt
FROM parch_and_posey.dbo.orders;



/*USING GROUP BY*/

/*
Which accounts (by name) placed the earliest order? Your solution should have the account name and the date of the order.
*/

SELECT TOP 1 a.name, o.occurred_at
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
ORDER BY occurred_at;




/*
Assuming we want to find the earliest order date for every account.
*/

SELECT a.name AS Account_name, MIN(o.occurred_at) AS Earliest_order_date
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY MIN(occurred_at);


/*
Find the total sales in USD for each account. You should include two columns: 
 the total sales for each company's orders in USD and the company name.
*/

SELECT a.name AS Account_name, SUM(o.total_amt_usd) AS total_sales
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
GROUP BY a.name;


/*
Via what channel did the most recent or latest web event occur? Which account was associated
with this event? Your query should return only three values - the date, channel and account name.
*/

SELECT TOP 1 a.name AS Account_name, w.channel, w.occurred_at
FROM parch_and_posey.dbo.accounts a 
INNER JOIN parch_and_posey.dbo.web_events w
ON a.id = w.account_id
ORDER BY occurred_at DESC;


/*
Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the numbber of times the channel was used.
*/

SELECT channel, COUNT(channel) AS Number_of_Times_Used
FROM parch_and_posey.dbo.web_events
GROUP BY channel;


/*
Who was the primary contact associated with the earliest web event?
*/

SELECT TOP 1 a.primary_poc, w.occurred_at
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.web_events w
ON a.id = w.account_id
ORDER BY occurred_at;


/*
What was the smallest order placed by each account in terms of the total usd. Provide only two columns -
the account name and the total usd. Order from the smallest dollar amount to the largest.
*/

SELECT a.name AS Account_name, MIN(o.total_amt_usd) AS min_total_usd
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY MIN(o.total_amt_usd);


/*
Find the number of sales_reps in each region. Your final table should have two columns - the region and 
the number of sales reps. Order from fewest reps to most reps.
*/

SELECT r.name AS Region, COUNT(*) AS sales_rep_count
FROM parch_and_posey.dbo.region r
inner join parch_and_posey.dbo.sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY COUNT(*);



/*USING GROUP BY ON MULTIPLE COLUMNS*/

/*
Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final 
table should have three columns - the name of the sales rep, the channel and the number of occurences. 
Order your table with the highest number of occurences first.
*/

SELECT s.name AS sales_reps, w.channel AS channel, COUNT(*) AS number_of_occurences
FROM parch_and_posey.dbo.web_events w
INNER JOIN parch_and_posey.dbo.accounts a
	ON a.id = w.account_id
INNER JOIN parch_and_posey.dbo.sales_reps s
	ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY number_of_occurences DESC;


/*
Determine the number of times a particular channel was used in the web_events table for each region.
Your final table should have three columns - the region name, the channel and the number of occurences. 
Order your table with the highest number of occurences first.
*/

SELECT r.name AS region, w.channel AS channel, COUNT(*) AS number_of_occurences
FROM parch_and_posey.dbo.web_events w
INNER JOIN parch_and_posey.dbo.accounts a
	ON w.account_id = a.id
INNER JOIN parch_and_posey.dbo.sales_reps s
	ON a.sales_rep_id = s.id
INNER JOIN parch_and_posey.dbo.region r
	ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY number_of_occurences DESC;



/*USING DISTINCT*/

/*
Use DISTINCT to test if there are any accounts associated with more than one region
*/

SELECT a.name AS Account_name, r.name AS region, COUNT(*) AS Number_of_Occurences
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.sales_reps s
	ON a.sales_rep_id = s.id
INNER JOIN parch_and_posey.dbo.region r
	ON s.region_id = r.id
GROUP BY a.name, r.name
ORDER BY Number_of_Occurences DESC;

--OR

SELECT DISTINCT a.name AS Account_name, r.name AS region
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.sales_reps s
	ON a.sales_rep_id = s.id
INNER JOIN parch_and_posey.dbo.region r
	ON s.region_id = r.id;
-- There are no accounts that are associated with more than one region.


/*
Has any sales_rep worked on more than one account?
*/

SELECT s.name AS sales_rep, COUNT(*) AS Number_of_Accounts
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name
ORDER BY Number_of_Accounts DESC;
--- Yes, all the sales_rep has worked on more than one account.



/*USING HAVING CLAUSE*/

/*
How many of the sales_reps have more than five accounts that they manage?
*/

SELECT s.name AS sales_reps, COUNT(*) AS Number_of_Accounts
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(*) > 5
ORDER BY Number_of_Accounts DESC;
-- 34 sales_reps have more than 5 accounts

/*
How many accounts have more than 20 orders?
*/

SELECT a.name AS Account_name, COUNT(*) AS num_of_orders
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(*) > 20;
-- 120 accounts have more than 20 orders


/*
Which account has the most orders?
*/

SELECT TOP 1 a.name AS Account_name, COUNT(*) AS num_of_orders
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(*) > 20
ORDER BY num_of_orders DESC;
-- Leucadia National has the most orders(71 total orders).


/*
Which accounts spent more than 30,000 USD total across all orders?
*/

SELECT a.name AS Account_name, SUM(o.total_amt_usd) AS Total_Amount_Spent
FROM parch_and_posey.dbo.orders o
INNER JOIN parch_and_posey.dbo.accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY SUM(o.total_amt_usd) DESC;


/*
Which account has spent the most with the the company?
*/

SELECT TOP 1 a.name AS Acoount_name, SUM(o.total_amt_usd) AS Amount_spent
FROM parch_and_posey.dbo.orders o
INNER JOIN parch_and_posey.dbo.accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC;
-- EOG Resources spent the most with the company, a total of 382,873.30 USD


/*
Which accounts used Facebook as a channel to contact customers more than 6 times?
*/

SELECT a.name AS Accounts_name, COUNT(w.channel) AS Facebook_channel_count
FROM parch_and_posey.dbo.web_events w
INNER JOIN parch_and_posey.dbo.accounts a
ON w.account_id = a.id
WHERE w.channel = 'Facebook'
GROUP BY a.name
HAVING COUNT(w.channel) > 6
ORDER BY COUNT(w.channel) DESC;
-- 46 companys used Facebook as a channel to contact customers more than 6 times.


/*DATE FUNCTIONS
Let's look at some date functions
*/

/* Get the curent date
*/

SELECT GETDATE() AS cur_date;


/*
Get the date in UTC timezone
*/

SELECT GETUTCDATE() AS cur_date;


/*
Extract the month names from the occurred_at column in the orders table.
*/

SELECT DATENAME(MONTH, occurred_at) AS Date_Month, occurred_at
FROM parch_and_posey.dbo.orders;


/*
Extract both the month numbers and the month names from the occurred_at column in the orders table.
*/

SELECT DATEPART(MONTH, occurred_at) AS month_no, DATENAME(MONTH, occurred_at) AS date_month, occurred_at
FROM parch_and_posey.dbo.orders;


-- Alternatively you can also use the 'MONTH' function to return same thing as 'DATEPART'

SELECT MONTH(occurred_at) AS Month_number, DATEPART(MONTH, occurred_at) AS month_no, DATENAME(MONTH, occurred_at) AS date_month, occurred_at
FROM parch_and_posey.dbo.orders;
-- From the output we can see that the 'MONTH' function and the 'DATEPART' function produces the same results. Both returns integer values


/* Now Answering some questions regarding date functions */

/*
Find the total sales in dollars for all orders in each year, ordered from greatest to least.
*/


SELECT YEAR(occurred_at) as Year, SUM(total_amt_usd) AS orders_amount
FROM parch_and_posey.dbo.orders
GROUP BY YEAR(occurred_at)
ORDER BY SUM(total_amt_usd) DESC;
-- The greatest sales was recorded in the year 2016 ($12,864,917.92), with 2017 recording the least ($78,151.43)


/*
In which month did Parch and Posey record the greatest sales in terms of total dollars?
Are all months evenly represented by the dataset?
*/

SELECT MONTH(occurred_at) AS month_no, DATENAME(MONTH, occurred_at) AS date_month, SUM(total_amt_usd) AS orders_amount
FROM parch_and_posey.dbo.orders
GROUP BY MONTH(occurred_at), DATENAME(MONTH, occurred_at)
ORDER BY orders_amount DESC;
-- The month of December recorded the greatest sales ($3,129,411.98) and might be attributed to it been a festive period


/*
Assuming you want to return only the names of the months
*/

SELECT DATENAME(MONTH, occurred_at) AS month_name, SUM(total_amt_usd) AS orders_amount
FROM parch_and_posey.dbo.orders
GROUP BY DATENAME(MONTH, occurred_at)
ORDER BY orders_amount DESC;


/*
In which year did Parch and Posey record the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?
*/

SELECT YEAR(occurred_at) AS Year, COUNT(*) AS orders_count
FROM parch_and_posey.dbo.orders
GROUP BY YEAR(occurred_at)
ORDER BY orders_count DESC;
-- the result shows that we have incomplete data as 2013 and 2017 has less amount of orders


-- to confirm that there are incomplete data in 2013 and 2017, we run the scrits below
SELECT DISTINCT MONTH(occurred_at) AS month_date
FROM parch_and_posey.dbo.orders 
WHERE YEAR(occurred_at) = 2013; 
-- we see that 2013 only has the month of December recorded in it

SELECT DISTINCT MONTH(occurred_at) AS month_date
FROM parch_and_posey.dbo.orders 
WHERE YEAR(occurred_at) = 2017; 
-- we see that 2017 only has the month  of January recorded in it


/* 
In which month did Parch and Posey record the greatest sales in terms of total number of orders? 
Are all month evenly represented by the dataset?
*/

SELECT DATENAME(MONTH,occurred_at) AS Month_of_Year,COUNT(*) AS Total_orders_count, SUM(total_amt_usd) AS total_orders_amount
FROM parch_and_posey.dbo.orders
GROUP BY DATENAME(MONTH, occurred_at)
ORDER BY total_orders_amount DESC;
-- Parch and Posey recorded the greatest sales in December($3,129,411.98)


/*
In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/

SELECT FORMAT(o.occurred_at, 'MMMM-yyyy') AS year_month, SUM(o.gloss_amt_usd) AS total_gloss_amt_usd
FROM parch_and_posey.dbo.orders o
INNER JOIN parch_and_posey.dbo.accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY FORMAT(o.occurred_at, 'MMMM-yyyy')
ORDER BY total_gloss_amt_usd DESC;

-- Walmart spent the most ($9,257.64) on gloss paper in the month of May in the year 2016.


-- OR We use the 'DATENAME()' and 'YEAR()' to extract the month and year into separate columns

SELECT DATENAME(MONTH, o.occurred_at) AS Month_of_Year, YEAR(o.occurred_at) AS Year,SUM(o.gloss_amt_usd) AS total_gloss_amt_usd
FROM parch_and_posey.dbo.orders o
INNER JOIN parch_and_posey.dbo.accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY DATENAME(MONTH, o.occurred_at), YEAR(o.occurred_at)
ORDER BY total_gloss_amt_usd DESC;


/*CASE STATEMENTS*/

/*
Write a query to display for each order, the account ID, account name, total amount of the orders, and the level of the order -
'Large' or 'Small' - depending on if the order is $3000 or more, or less than $3000.
*/

SELECT a.id AS account_id, a.name AS account_name,
		SUM(o.total_amt_usd) AS total_order_amount,
		CASE WHEN SUM(o.total_amt_usd) >= 3000 THEN 'Large'
		ELSE 'Small'
		END AS sales_level
FROM parch_and_posey.dbo.orders o
INNER JOIN parch_and_posey.dbo.accounts a 
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_order_amount DESC;


/*
Write a query to display the number of orders in each of three categories, based on the total number of items in each order
The three categories are: 'At Least 2000', 'Between 1000 and 2000', and 'Less than 1000'.
*/

SELECT CASE WHEN total > 2000 THEN 'at least 2000'
			WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
			ELSE 'Less than 1000'
			END AS orders_category,
			COUNT(*) AS order_count
FROM parch_and_posey.dbo.orders
GROUP BY  CASE WHEN total > 2000 THEN 'at least 2000'
			WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
			ELSE 'Less than 1000'
			END
ORDER BY COUNT(*) DESC;


/* 
We would like to understand 3 different branches of customers based on the amount associated with their purchases. 
The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 USD. 
The second branch is between 200,000 and 100,000 USD. The lowest branch is anyone under 100,000 USD.
Provide a table that includes the level associated with  each account. You should provide the account name,
the total sales of all orders for the customer, and the level.
Order with the top spending customers listed first.
*/

SELECT a.name AS acount_name,
	   SUM(o.total_amt_usd) AS total_order_amount,
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'High_spenders'
			WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Medium_spenders'
			ELSE 'Low_spenders'
	   END AS customers_group
FROM parch_and_posey.dbo.accounts a
INNER JOIN parch_and_posey.dbo.orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC;


/*
We would like to identify top performing sales reps, which are sales reps asscoiated with more than 200 orders.
Create a table with the sales rep name, the total number of orders, and a column with top or not depending on
if they have more than 200 orders. Place the top sales people first in your final table.
*/

SELECT s.name AS sales_rep,
	   COUNT(*) AS order_count,
	   CASE WHEN COUNT(*) > 200 THEN 'Top_seller'
	        ELSE 'Low_seller'
		END AS sales_rep_group
FROM parch_and_posey.dbo.orders o
INNER JOIN parch_and_posey.dbo.accounts a
ON a.id = o.account_id
INNER JOIN parch_and_posey.dbo.sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY order_count DESC;
