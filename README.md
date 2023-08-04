# DATA EXPLORATION AND ANALYSIS USING SQL

## Introduction
Parch and Posey is a fictional e-commerce paper selling company that sells 3 types of papers to companies, via different channels in different regions.
The database of the company was queried to derive insights on essential metrics such as;
- Earliest orders for every sales account
- The number of sales reps in each region
- Number of times each sales channel was used
Etc...

## Project Analysis
In this project, I used the Parch and Posey database to explore different functional aspects of SQL from basic to advanced answering questions about the data.

The database consists of different tables;
- accounts
- orders
- sales_reps
- region
- web_events

To create the database tables;
1. Download the zip file to a preferred location on your local/personal computer.

2. Extract the contents of the zip file.

3. Install Microsoft SQL Server Management Studio (preferred RDBMS for this project).

4. Open the application and click the New Query tab.

5. In the new query tab, enter this SQL statement/code to create the parch and posey database `CREATE DATABASE parch_and_posey`.

6. After completing step 5 above, run the parch_and_posey_tables.sql script in Microsoft SQL Server Management Studio to create the tables, found in the [Database folder](https://github.com/GameliKofiJerome/SQL-Data-Analysis---Parch-Posey/blob/main/Database%20File/parch_and_posey_tables.sql).
 
7. Run the SQL scripts in Microsft SQL Server Management Studio to see the results and outputs.
  
8. You can also edit the queries to determine the various outputs. This is a way of learning.

## Suggestion
If you are new to SQL, I suggest running the SQL scripts in this order to just a better grasp of the language.
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
