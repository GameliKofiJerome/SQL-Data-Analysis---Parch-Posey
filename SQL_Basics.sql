/* WE WILL BEGIN BY WORKING WITH BASIC SQL STATEMENTS */

/* SELECT ALL ROWS AND COLUMNS FROM THE 'orders' TABLE */

SELECT *
FROM parch_and_posey.dbo.orders;
-- Outputs a total of 6,912 rows and 11 columns in the order table



/* SELECT ALL ROWS AND COLUMNS FROM THE 'accounts' TABLE */

SELECT *
FROM parch_and_posey.dbo.accounts;
-- Outputs a total of 351 rows and 7 columns in the accounts table



/* SELECT ALL ROWS AND COLUMNS FROM THE 'region' TABLE */

SELECT *
FROM parch_and_posey.dbo.region;
-- Outputs a total of 4 rows and 2 columns in the region table



/* SELECT ALL ROWS AND COLUMNS FROM THE 'sales_reps' TABLE */

SELECT *
FROM parch_and_posey.dbo.sales_reps;
-- Outputs a total of 50 rows and 3 columns in the sales_reps table



/* SELECT ALL ROWS AND COLUMNS FROM THE 'web_events' TABLE */

SELECT *
FROM parch_and_posey.dbo.web_events;
-- Outputs a total of 9,073 rows and 4 columns in the web_events table




/* USING SQL's TOP statement
NOTE: Not all database systems support the 'SELECT TOP' statements. 
	  MySQL and Postgre support the 'LIMIT' clause to select a minimum number of records
	  Oracle uses the 'FETCH FIRST n ROWS ONLY' and 'ROWNUM'
*/

/*
Q1. Write a query that selects and displays only the first 10 rows of data in the occurred_at, account_id, and channel 
columns of web_events table.
*/

SELECT TOP 10 occurred_at, account_id, channel
FROM parch_and_posey.dbo.web_events;




/* USING DISTINCT STATEMENT*/

/*
Q2. Write a query to return all the distinct channels in the web_events table
*/

SELECT DISTINCT web_events.channel
FROM parch_and_posey.dbo.web_events;
-- Outputs 6 distinct channels from the web events table




/* USING the ORDER BY clause */

/*
Q3. Write a query to return the top 10 earliest orders in the orders table. Must include the id, occurred_at, and total_amt_usd. 
Order output using the 'occurred_at' column.
*/

SELECT TOP 10 id, occurred_at, total_amt_usd
FROM parch_and_posey.dbo.orders
ORDER BY occurred_at;


/*
Q4. Write a query to return the top 5 orders in terms of the largest total_amt_usd. Must include the id, account_id, and total_amt_usd.
*/

SELECT TOP 5 id, account_id, total_amt_usd
FROM parch_and_posey.dbo.orders
ORDER BY total_amt_usd DESC;


/*
Q5. Write a query to return the lowest 20 orders with respect to smallest total_amt_usd. Include the id, account-id, and total_amt_usd.
*/

SELECT TOP 20 id, account_id, total_amt_usd
FROM parch_and_posey.dbo.orders
ORDER BY total_amt_usd;


/*
Q6. Write a query that displays the order_id, account_id, and total dollar amount for all the orders, sorted
first by the account_id (in ascending order), and then by the total dollar amount (in descending order).
*/

SELECT id, account_id, total_amt_usd
FROM parch_and_posey.dbo.orders
ORDER BY account_id, total_amt_usd DESC;


/*
Q7. Write a query that displays the order_id, account_id, and total dollar amount for each order, but this time 
sorted first by the total dollar amount (in descending order), and then by the account_id (in ascending order).
*/

SELECT id, account_id, total_amt_usd
FROM parch_and_posey.dbo.orders
ORDER BY total_amt_usd DESC, account_id;




/* USING the WHERE clause */

/*
Q8. Write a query that returns the first 5 rows and all columns from the orders 
table that have a gloss_amt_usd greater than or equal to 1000.
*/

SELECT TOP 5 *
FROM parch_and_posey.dbo.orders
WHERE gloss_amt_usd >= 1000;


/*
Q9. Write a query that returns the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
*/

SELECT TOP 10 *
FROM parch_and_posey.dbo.orders
WHERE total_amt_usd < 500;


/*
Q10. Filter the accounts table to include the company name, website, and the primary point 
of contact (primary_poc) just for the 'EOG Resources' Company in the accounts table.
*/

SELECT name, website, primary_poc 
FROM parch_and_posey.dbo.accounts
WHERE name = 'EOG Resources';




/* USING ARITHMETIC OPERATORS */

/*
Q11. Create a column that divides the gloss_amount_usd by the gloss_quantity to find the unit price for the standard paper
for each order. Limit the results to the first 10 orders, and include the id and the account_id field.
*/

SELECT TOP 10 id,
           account_id,
		   (gloss_amt_usd/gloss_qty) AS unit_price
FROM parch_and_posey.dbo.orders;


/*
Q12. Write a query to find the percentage of revenue that comes from each poster paper sales. You will need to use only the
columns that ends with _usd. (Try to do this without using the total column). Display the id and the account_id_fields also.
*/

SELECT TOP 10 id, 
		   account_id, 
		   (poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd)) * 100 AS percent_rev_poster
FROM parch_and_posey.dbo.orders;




/* USING the LIKE operator */

/*
Q13. Write a query that returns all companies name that start with 'C'.
*/

SELECT name
FROM parch_and_posey.dbo.accounts
WHERE name LIKE 'C%';
-- Outputed 37 companies that have their names starting with C


/*
Q14. Write a query that returns all companies whose names contain the string 'one' somewhere in the name.
*/

SELECT name
FROM parch_and_posey.dbo.accounts
WHERE name LIKE '%one%';
-- Outputs 6 companies that have the string 'one' somewhere in their names 


/*
Q15. Write a query that returns all companies whose names end with 's'.
*/

SELECT name
FROM parch_and_posey.dbo.accounts
WHERE name LIKE '%s';
-- Outputs 81 companies having their names ending with 's'




/* USING THE IN operator */

/*
Q16. Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
*/

SELECT name, primary_poc, sales_rep_id
FROM parch_and_posey.dbo.accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom')


/*
Q17. Use the web-events table to find all information regarding all individuals who were contacted via organic or adwords channel
*/

SELECT *
FROM parch_and_posey.dbo.web_events
WHERE channel IN ('organic','adwords')
-- 1,858 inviduals werecontacted via organic or adwords




/* USING NOT operator */

/*
Q18. Use the web-events table to find all information regarding all individuals who were
contacted via any method except using organic or adwords methods.
*/

SELECT *
FROM parch_and_posey.dbo.web_events
WHERE channel NOT IN ('organic', 'adwords')
-- 7,215 inviduals were contacted via other methods except organic or adwords


/* 
Q19. Use the accounts table to find:
i. all the companies whose names do not start with 'c'. */
SELECT name
FROM parch_and_posey.dbo.accounts
WHERE name NOT LIKE 'C%';
-- 314 companies have their names not starting with C


/* ii. all the companies whose names do not contain the string 'one'. */
SELECT name
FROM parch_and_posey.dbo.accounts
WHERE name NOT LIKE '%one%';
-- 346 companies do not have the string 'one' in their names




/* USING AND and BETWEEN operators */

/*
Q20. Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
*/

SELECT  *
FROM parch_and_posey.dbo.orders 
WHERE standard_qty > 1000
	AND poster_qty = 0
	AND gloss_qty = 0;


/*
Q21. Using the accounts table, find all the companies whose names do not start with 'c' and end with 's'.
*/

SELECT name
FROM parch_and_posey.dbo.accounts
WHERE name NOT LIKE 'C%'
	AND name LIKE '%s';


/*
Q22. Write a query that displays the order date and gloss_qty data for all orders where gloss_qty data is between 24 and 29.
*/

SELECT occurred_at, gloss_qty
FROM parch_and_posey.dbo.orders 
WHERE gloss_qty BETWEEN 24 AND 29;


/*
Q23. Use the web_events table to find all the information regarding all individuals who were contacted via the organic
or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
*/

SELECT *
FROM parch_and_posey.dbo.web_events
WHERE channel IN ('organic', 'adwords')
AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;




/* USING the OR operator */

/*
Q24. Find the list of order_ids where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table.
*/

SELECT id, gloss_qty, poster_qty
FROM parch_and_posey.dbo.orders
WHERE gloss_qty > 4000 
	OR poster_qty > 4000;


/*
Q25. Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
*/

SELECT id, standard_qty, gloss_qty, poster_qty
FROM parch_and_posey.dbo.orders
WHERE standard_qty = 0
	AND (gloss_qty > 1000
	OR poster_qty > 1000);


/*
Q26. Write a query to find all company names that start with a 'C' or 'W', and the primary contact contains 'ana, or 'Ana', 
but it doesn't contain 'eana'.
*/
SELECT name, primary_poc
FROM parch_and_posey.dbo.accounts 
WHERE (name LIKE 'C%' OR name LIKE 'W%')
	AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
	AND (primary_poc NOT LIKE '%eana%');
