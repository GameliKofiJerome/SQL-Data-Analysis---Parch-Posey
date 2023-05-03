# DATA ANALYSIS USING SQL

## Introduction
Parch and Posey is a fictional e-commerce paper selling company that sells 3 different types of papers to companies, via different channels in different regions.
The database of the company was queried to derive insights on important metrics such as;
- Earliest orders for every sales account
- The number of sales reps in each region
- Number of times each sales channel was used
Etc...

## Project Analysis
In this project, I used the Parch and Posey database to explore different functional aspects of SQL from basic to advanced.

The database consists of different tables;
- accounts
- orders
- sales_reps
- region
- web_events

To create the database tables;
1. Download zip file to preferred location on local/personal computer.

2. Extract contents of zip file.

3. Install Microsoft SQL Server Management Studio (preferred RDBMS for this project).

4. Open application and click on the 'New Query' tab.

5. In the new query tab, enter this SQL statement/code to create the parch and posey database `CREATE DATABASE parch_and_posey`.

6. After completing step 5 above, run the parch_and_posey_tables.sql script in Microsoft SQL Server Management Studio to create the tables, found in the [Database folder](https://github.com/GameliKofiJerome/SQL-Data-Analysis---Parch-Posey/blob/main/Database%20File/parch_and_posey_tables.sql).
 
7. Run the sql scripts in Microsft SQL Server Management Studio to see the results and outputs. You can also edit the queries to see determine the various outputs as it is a great way to also learn.

## Suggestion
If you are new to SQL, I suggest running the sql scripts in this order to just a better grasp of the language.
1. SQL Basics
2. SQL Joins
3. SQL Data Cleaning
4. SQL Aggregations
5. SQL subqueries and Temp Tables (CTEs)
6. Advanced SQL Joins and Performance Tuning

- Numbers 2 and 3 can be run interchangeably depending on preference.

**NB:**
It's good to know that Transact-SQL was used for this project.

![Parch and Posey Schema](https://github.com/GameliKofiJerome/SQL-Data-Analysis---Parch-Posey/blob/main/parch_and_posey_ER_diagram.PNG).
