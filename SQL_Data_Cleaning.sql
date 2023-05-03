/* CLEANING DATA USING SQL*/

/*USING THE LEFT AND RIGHT FUNCTIONS*/

/*
Q1. In the accounts table, there is a column that holds the website of each company. The last three characters specify what type 
of web address they are using. Pull these extenstions and provide how many of each website type exist in the accounts table.
*/

SELECT RIGHT(website, 3) AS extension, COUNT(*) AS site_num_occurences
FROM parch_and_posey.dbo.accounts
GROUP BY RIGHT(website, 3)
ORDER BY site_num_occurences DESC;




/*
Q2. Using the accounts table, pull the first letter of each company name to see the distribution of company names that 
begin with each letter or (number).
*/

SELECT LEFT(name, 1) AS company_name, COUNT(*) AS comp_num_occurences
FROM parch_and_posey.dbo.accounts
GROUP BY LEFT(name, 1)
ORDER BY comp_num_occurences DESC;




/*
Q3. Using the accounts table and a CASE statement, create two groups: one group of company names that begin with a number 
and a second group of those company that begin with a letter. What proprtion of company names start with a letter?
*/

SELECT SUM(number) AS number, SUM(letter) AS letter
FROM
	(SELECT CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
				   THEN 1
				   ELSE 0
				   END AS number,
		   CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
				   THEN 0
				   ELSE 1
				   END AS letter
FROM parch_and_posey.dbo.accounts) letter_num;

-- OR / ALTERNATIVE

SELECT SUM (CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
				   THEN 1
				   ELSE 0
				   END) AS num,
	   SUM (CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
				   THEN 0
				   ELSE 1
				   END) AS letter
FROM parch_and_posey.dbo.accounts;
-- you then do the math to ascertain the proportion of companies that start with a letter i.e 350/351 = percent/100





/*CHARINDEX() FUNCTION*/

/*
Q4. Using the accounts table, create the first and last name columns to hold the first and last names for the primary_poc.
*/

SELECT LEFT(primary_poc, CHARINDEX(' ', primary_poc) - 1) AS first_name,
	   RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)) AS last_name
FROM parch_and_posey.dbo.accounts;

-- OR / ALTERNATIVE USING SUBSTRING() FUNCTION

SELECT SUBSTRING(primary_poc, 1, CHARINDEX(' ', primary_poc) - 1) AS first_name,
       SUBSTRING(primary_poc, CHARINDEX(' ', primary_poc) + 1, LEN(primary_poc)) AS last_name
FROM parch_and_posey.dbo.accounts;




/*
Q5. Now see if you can do the exact thing for every rep name in the sales_rep table. Again provide first and last name columns.
*/

SELECT LEFT(name, CHARINDEX(' ', name) - 1) AS first_name,
	   RIGHT(name, LEN(name) - CHARINDEX(' ', name)) AS last_name
FROM parch_and_posey.dbo.sales_reps;

-- OR / ALTERNATIVE USING SUBSTRING() FUNCTION

SELECT SUBSTRING(name, 1, CHARINDEX(' ', name) - 1) AS first_name,
       SUBSTRING(name, CHARINDEX(' ', name) + 1, LEN(name)) AS last_name
from parch_and_posey.dbo.sales_reps;




/*CONCAT FUNCTION*/

/*
Each company in the accounts table want to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc.the last name of the primary poc @ company name.com
*/

WITH email_table AS (
	SELECT name,
		   LEFT(primary_poc, CHARINDEX(' ', primary_poc) -1) AS first_name,
		   RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)) AS last_name
	FROM parch_and_posey.dbo.accounts)

SELECT CONCAT(first_name, '.', last_name, '@', name, '.com') AS primary_poc_email
FROM email_table;

-- OR /ALTERNATIVE USING THE SUBSTRING() FUNCTION

WITH email_table AS(
	SELECT name,
		SUBSTRING(primary_poc, 1, CHARINDEX(' ', primary_poc) -1) AS first_name,
		SUBSTRING(primary_poc, CHARINDEX(' ', primary_poc) + 1, LEN(primary_poc)) AS last_name
	FROM parch_and_posey.dbo.accounts)

SELECT CONCAT(first_name, '.', last_name, '@', name, '.com') AS primary_poc_email
FROM email_table;




/*
You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work 
in an email address. See if you can create an email address that will work by removing all of the spaces in the account name.
*/

WITH email_table AS (
	SELECT name,
		   LEFT(primary_poc, CHARINDEX(' ', primary_poc) -1) AS first_name,
		   RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)) AS last_name
	FROM parch_and_posey.dbo.accounts)

SELECT CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com') AS email
FROM email_table;

-- OR /ALTERNATIVE SOLUTION USING SUBSTRING() FUNCTION

WITH email_table AS(
	SELECT name,
		SUBSTRING(primary_poc, 1, CHARINDEX(' ', primary_poc) -1) AS first_name,
		SUBSTRING(primary_poc, CHARINDEX(' ', primary_poc) + 1, len(primary_poc)) AS last_name
    FROM parch_and_posey.dbo.accounts)

SELECT CONCAT(first_name,'.',last_name,'@',REPLACE(name,' ',''),'.com') AS email_address
FROM email_table;


/*
We would also like to create an initial password, which they will change after their first log in. The first password
will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name(lowercase),
the first letter of their last name(lowercase), then the last letter of the last name(lowercase), the number of letters in
their first name, the number of letters in their last name, and then the name of the company they are working with, all
capitalized with no spaces.
*/

WITH pwd_table AS (
	SELECT name,
		   LEFT(primary_poc, CHARINDEX(' ', primary_poc) -1) AS first_name,
		   RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)) AS last_name
FROM parch_and_posey.dbo.accounts)

SELECT CONCAT(LEFT(LOWER(first_name),1), RIGHT(LOWER(first_name), 1),
	         LEFT(LOWER(last_name),1), RIGHT(LOWER(last_name), 1),
		     LEN(first_name), LEN(last_name),
		     REPLACE(UPPER(name), ' ', '')) AS password
FROM pwd_table;

-- OR / ALTERNATIVE USING SUBSTRING() FUNCTION

WITH pwd_table AS (
	SELECT name,
		SUBSTRING(primary_poc, 1, CHARINDEX(' ', primary_poc) - 1) AS first_name,
		SUBSTRING(primary_poc, CHARINDEX(' ', primary_poc) + 1, LEN(primary_poc)) AS last_name
	FROM parch_and_posey.dbo.accounts)

SELECT CONCAT(LEFT(LOWER(first_name),1), RIGHT(LOWER(first_name),1),
			  LEFT(LOWER(last_name),1), RIGHT(LOWER(last_name),1),
			  LEN(first_name),LEN(last_name),
			  REPLACE(UPPER(name), ' ',''))
FROM pwd_table;