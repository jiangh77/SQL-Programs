select * from customer;

select * from product;

select * from sales;

-- IN Section
select * from customer where city in ('Philadelphia', 'Seattle');
-- same as
select * from customer where city = 'Philadelphia' or city = 'Seattle';

-- BETWEEN Section
select * from customer where age between 20 and 30;
-- age of 20 and 30 are included

-- same as
select * from customer where age >= 20 and age <= 30;

select * from customer where age not between 20 and 30;

select * from sales where ship_date between '2015-04-01' and '2016-04-01';

/*
LIKE Section
Wildcard - Explanation
% - Allows you to match any string of any length (including zero length)
_ - Allows you to match on a single character

A% means starts with A like ABC or ABCE
%A means anything that ends with A
A%B means starts with A but ends with B
AB is also included, because % can represent 0 length

AB_C means string starts with AB, then there is one character, then there is C at the end
*/

select * from customer where customer_name like 'J%';

select * from customer where customer_name like '%Nelson%';

-- finds customer name that has exactly 4 characters for first name
select * from customer where customer_name like '____ %';

select city from customer where city not like 'S%';
-- only select one per occurrence
select distinct city from customer where city not like 'S%';

-- if wants % to be considered as a character then use \
select * from customer where customer_name like 'G\%';

select * from customer;
select * from sales;
select * from product;

/*
Assignment 6
1. In the database Supermart_DB, find the following
a. Get the list of all cities where the region is South or east without any
duplicates using IN statement
b. Get the list of all orders where the ‘sales’ value is between 100 and
500 using the BETWEEN operator
c. Get the list of customers whose last name contains only 4 characters
using LIKE
*/

select city from customer where region in ('North', 'East');

-- Answer 1
select distinct city from customer where region in ('North', 'East');

-- Answer 2
select * from sales where sales between 100 and 500;

-- Answer 3
select * from customer where customer_name like '% ____';

-- How to comment

/*
Multiple line comments
*/

-- Single line comment

/* ORDER BY Commands */
select * from customer where state = 'California' order by customer_name;

-- same as
select * from customer where state = 'California' order by customer_name asc;

select * from customer where state = 'California' order by customer_name desc;

select * from customer order by city asc, customer_name desc;

select * from customer where state = 'California' order by city asc, customer_name desc;

/* column 2 is customer_name, the number 2 represents the customer_name column
table starts with column 1 which is customer_id */

-- if nothing is specified, it is sorted by Ascending Order
select * from customer order by 2 asc;

select * from customer order by age desc;

-- LIMIT Command, limit the number of rows returned
select * from customer where age > 25 order by age desc limit 8;

select * from customer where age > 25 order by age asc limit 10;

/*
Assignment 7
1. Retrieve all orders where ‘discount’ value is greater than zero ordered
in descending order basis ‘discount’ value
2. Limit the number of results in above query to top 10
*/

select * from sales;

select * from sales where discount > 0 order by discount desc;

select * from sales where discount > 0 order by discount desc limit 10;

-- Alias (AS), display a different column name than the original column name
select customer_id as "Serial Number", customer_name as name, age as Customer_age from customer;
-- Serial Number is in " " because there is a space in between
-- Alias will be important in JOINs

/* Aggregate Commands
COUNT SUM AVERAGE MIN MAX
*/

-- COUNT
select * from sales;
select count(*) from sales;
select count(*) as "Number of Sales" from sales;

select count (order_line) as "Number of Products Ordered", count (distinct order_id) as "Number of Orders"
from sales where customer_id = 'CG-12520';

-- SUM
select sum (Profit) as "Total Profit" from sales;

select sum (quantity) as "Total Quantity" from sales where product_id = 'FUR-TA-10000577';

-- AVERAGE
-- Syntax SELECT avg (aggregate_expression) from tables [WHERE conditions]
select avg (age) as "Average Customer age" from customer;

select avg (sales * 0.1) as "Average Commission value" from sales;
-- same as 0.1 can also expressed as .1
select avg (sales * .1) as "Average Commission value" from sales;

-- MIN & MAX
select min (sales) as "Minimum sales value June 15"
from sales
where order_date between '2015-06-01' and '2015-06-30';

select sales
from sales
where order_date between '2015-06-01' and '2015-06-30' order by sales asc;

select max (sales) as "Maximum sales value June 15"
from sales
where order_date between '2015-06-01' and '2015-06-30';

select sales
from sales
where order_date between '2015-06-01' and '2015-06-30' order by sales desc;

/*
Assignment 8
1. Find the sum of all ‘sales’ values.
2. Find count of the number of customers in north region with age
between 20 and 30
3. Find the average age of East region customers
4. Find the Minimum and Maximum aged customer from Philadelphia
*/

select * from sales;
select * from customer;

select sum (sales) from sales;

select count(*) from customer where region = 'North' and age between 20 and 30;
select count(*) from customer where age between 20 and 30;

select avg (age) from customer where region = 'East';

select min (age) from customer where city = 'Philadelphia';
select max (age) from customer where city = 'Philadelphia';
select min (age) as min_age, max (age) as max_age from customer where city = 'Philadelphia';

-- GROUP BY
select * from customer;

select region, count (customer_id) as customer_count from customer group by region;

-- use aggregate function with GROUP BY, if select age alone, it will cause an error, must be used in GROUP BY or as an aggregate function
select region, age, count (customer_id) as customer_count from customer group by region; -- error

select region, age, count (customer_id) as customer_count from customer group by region, age;

select region, avg (age) as age, count (customer_id) as customer_count from customer group by region; 

-- create all possible combination of region and state
select region, state, avg (age) as age, count (customer_id) as customer_count from customer group by region, state;

-- once an Alias is defined it can be used anywhere in the same query
select product_id, sum (quantity) as quantity_sold from sales group by product_id order by quantity_sold desc;

select customer_id, min (sales) as min_sales, max (sales) as max_sales,
avg (sales) as Average_sales, sum (sales) as Total_sales from sales
group by customer_id order by total_sales desc limit 5;

/* HAVING
HAVING clause is used in combination with the GROUP BY clause to restrict the groups of returned rows
to only those whose the condition is TRUE
HAVING clause is used to specify conditions on aggregate functions
WHERE clause is used to specify conditions on non-aggregate functions
WHERE is used before GROUP BY, HAVING is used after GROUP BY
*/

select region, count (customer_id) as customer_count from customer group by region having count (customer_id) > 200;

select region, count (customer_id) as customer_count from customer where customer_name like 'A%' group by region;

select region, count (customer_id) as customer_count from customer where customer_name like 'A%' group by region
having count (customer_id) > 15;

select * from sales;

/* 
Assignment 9
1. Make a dashboard showing the following figures for each product ID
a) Total sales (in $) order by this column in descending
b) Total sales quantity
c) Number of orders
d) Max Sales value
e) Min Sales value
f) Average sales value
2. Get the list of product ID’s where the quantity of product sold is greater than 10
*/

select product_id, sum (sales) as total_sales, sum (quantity) as total_quantity, count (order_id) as total_order,
min (sales) as min_sales, max (sales) as max_sales, avg (sales) as avg_sales from sales group by product_id order by total_sales desc;

select product_id, sum (quantity) as total_quantity from sales group by product_id having sum (quantity) > 10;

-- CASE WHEN
select *, case
	when age < 30 then 'Young'
	when age > 60 then 'Senior Citizen'
	else 'Middle Aged'
	end as Age_category
from customer;

--JOINs

/*Creating sales table of year 2015*/

Create table sales_2015 as select * from sales where ship_date between '2015-01-01' and '2015-12-31';
select count(*) from sales_2015; --2131
select count(distinct customer_id) from sales_2015;--578

/* Customers with age between 20 and 60 */
create table customer_20_60 as select * from customer where age between 20 and 60;
select count (*) from customer_20_60;--597

-- INNER JOIN
select customer_id from sales_2015 order by customer_id;
select customer_id from customer_20_60 order by customer_id;

-- see all tables
select * from customer;
select * from sales;
select * from product;
select * from customer_20_60;
select * from sales_2015;
select * from year_values;
select * from month_values;

/*
sales table has customer_id and product_id
customer table has customer_id, product table has product_id
customer_id is the primary key for customer table
product_id is the primary key for product table
order_line is the primary key for sales table
*/

-- INNER JOIN sales and product

select
	a.order_line,
	a.order_id,
	a.order_date,
	b.category,
	b.product_name
from sales AS a
INNER JOIN product AS b
ON a.product_id = b.product_id
ORDER BY a.product_id;

-- INNER JOIN customer and sales

select
	a.customer_id,
	a.customer_name,
	a.age,
	b.order_line,
	b.order_id,
	b.sales
from customer AS a
INNER JOIN sales AS b
ON a.customer_id = b.customer_id
ORDER BY b.customer_id;

-- INNER JOIN customer, sales and product
/*
Example from w3school sql inner join
SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName
FROM ((Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID);
*/

select
	a.customer_id,
	a.customer_name,
	a.age,
	b.order_line,
	b.order_id,
	b.sales
from customer AS a
INNER JOIN sales AS b
ON a.customer_id = b.customer_id;

select
	customer.customer_id,
	customer.customer_name,
	customer.age,
	sales.order_line,
	sales.order_id,
	sales.sales,
	product.product_id,
	product.category,
	product.product_name
from ((customer
INNER JOIN sales
ON customer.customer_id = sales.customer_id)
INNER JOIN product
ON sales.product_id = product.product_id)
ORDER BY sales.product_id;

select
	a.customer_id,
	a.customer_name,
	a.age,
	b.order_line,
	b.order_id,
	b.sales,
	c.product_id,
	c.category,
	c.product_name
from ((customer AS a
INNER JOIN sales AS b
ON a.customer_id = b.customer_id)
INNER JOIN product AS c
ON b.product_id = c.product_id)
ORDER BY a.customer_id;

select
	a.customer_id,
	a.customer_name,
	a.age,
	b.order_line,
	b.order_id,
	b.sales,
	c.product_id,
	c.category,
	c.product_name
from ((customer AS a
LEFT JOIN sales AS b
ON a.customer_id = b.customer_id)
LEFT JOIN product AS c
ON b.product_id = c.product_id)
ORDER BY a.customer_id;

select
	a.customer_id,
	a.customer_name,
	a.age,
	b.order_line,
	b.order_id,
	b.sales,
	c.product_id,
	c.category,
	c.product_name
from ((customer AS a
RIGHT JOIN sales AS b
ON a.customer_id = b.customer_id)
RIGHT JOIN product AS c
ON b.product_id = c.product_id)
ORDER BY a.customer_id;

select
	a.customer_id,
	a.customer_name,
	a.age,
	b.order_line,
	b.order_id,
	b.sales,
	c.product_id,
	c.category,
	c.product_name
from ((customer AS a
FULL JOIN sales AS b
ON a.customer_id = b.customer_id)
FULL JOIN product AS c
ON b.product_id = c.product_id)
ORDER BY a.customer_id;

/* INNER JOIN */

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
INNER JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;

/* LEFT JOIN */

select customer_id from sales_2015 order by customer_id;
select customer_id from customer_20_60 order by customer_id;

/* 	AA-10315 not present in customer_20_60 table
	AA-10375 present in both
	AA-10480 not present in sales_2015 table */

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
LEFT JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;

/* RIGHT JOIN */

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
RIGHT JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;
-- AA-10480 not present because query uses a.cutomer_id

SELECT
	a.order_line,
	a.product_id,
	b.customer_id,
	a.sales,
	b.customer_name,
	b.age
FROM sales_2015 AS a
RIGHT JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY customer_id;
-- AA-10480 present because query uses b.cutomer_id

/* FULL JOIN */

select * from sales_2015 order by customer_id;
select * from customer_20_60 order by customer_id;

SELECT
	a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age,
	b.customer_id
FROM sales_2015 AS a
FULL JOIN customer_20_60 AS b
ON a.customer_id = b.customer_id
ORDER BY a.customer_id , b.customer_id;

/* CROSS JOIN
Syntax does not contain the word JOIN
The Cross Join creates a cartesian product between two sets of data. */

create table month_values (MM integer);
create table year_values (YYYY integer);

insert into month_values values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);
insert into year_values values (2011), (2012), (2013), (2014), (2015), (2016), (2017), (2018), (2019);

select * from month_values;
select * from year_values;

SELECT a.YYYY, b.MM
FROM year_values AS a, month_values AS b
ORDER BY a.YYYY, b.MM;

select year_values.YYYY, month_values.MM
from year_values, month_values
order by year_values.YYYY, month_values.MM;

/* Combining Queries */

/* INTERSECT */

SELECT customer_id FROM sales_2015
INTERSECT
SELECT customer_id FROM customer_20_60
ORDER BY customer_id;

select customer_id from sales_2015
intersect
select customer_id from customer_20_60
order by customer_id;

select customer_id from sales_2015
intersect all
select customer_id from customer_20_60
order by customer_id;

/* EXCEPT */

SELECT customer_id FROM sales_2015 ORDER BY customer_id;
SELECT customer_id FROM customer_20_60 ORDER BY customer_id;

SELECT customer_id
FROM sales_2015
EXCEPT
SELECT customer_id
FROM customer_20_60
ORDER BY customer_id;

select customer_id from sales_2015
except
select customer_id from customer_20_60
order by customer_id;

/* UNION UNION ALL*/

select customer_id from sales_2015 order by customer_id;
select customer_id from customer_20_60 order by customer_id;

select customer_id from sales_2015
union
select customer_id from customer_20_60
order by customer_id;

SELECT customer_id
FROM sales_2015
UNION
SELECT customer_id
FROM customer_20_60
ORDER BY customer_id;

SELECT customer_id
FROM sales_2015
UNION ALL
SELECT customer_id
FROM customer_20_60
ORDER BY customer_id;

/*
Assignment 10
1. Find the total sales done in every state for customer_20_60 and
sales_2015 table
Hint: Use Joins and Group By command
2. Get data containing Product_id, product name, category, total sales
value of that product and total quantity sold. (Use sales and product
table)
*/

select * from customer_20_60;
select * from sales_2015;

-- solution given
select b.state, sum(sales) as total_sales
from sales_2015 as a left join customer_20_60 as b
on a.customer_id = b.customer_id
group by b.state;

-- same sum(sales) = sum(a.sales)
select b.state, sum(a.sales) as total_sales
from sales_2015 as a left join customer_20_60 as b
on a.customer_id = b.customer_id
group by b.state;

select * from sales;
select * from product;

select a.*, sum(b.sales) as total_sales, sum(quantity) as total_quantity
from product as a left join sales as b
on a.product_id = b.product_id
group by a.product_id;

-- same sum(quantity) = sum(b.quantity)
select a.*, sum(b.sales) as total_sales, sum(b.quantity) as total_quantity
from product as a left join sales as b
on a.product_id = b.product_id
group by a.product_id;

/* Subqueries */

-- subquery is in WHERE

SELECT * FROM sales
WHERE customer_ID IN
	(SELECT DISTINCT customer_id
	FROM customer WHERE age >60);

SELECT * FROM sales
WHERE customer_ID IN
	(SELECT customer_id
	FROM customer WHERE age >60);

select * from sales
where customer_id IN
	(select customer_id
	from customer where region = 'South');

select * from customer;

-- subquery is in FROM, quantity is a Alias
SELECT
	a.product_id,
	a.product_name,
	a.category,
	b.quantity
FROM product AS a 
LEFT JOIN (SELECT product_id,
		SUM(quantity) AS quantity
		FROM sales GROUP BY product_id) AS b
ON a.product_id = b.product_id
ORDER BY b.quantity desc;

select * from customer;
select * from product;
select * from sales;

-- same as query above use "Total" as Alias instead of "quantity" as Alias
SELECT
	a.product_id,
	a.product_name,
	a.category,
	b.Total
FROM product AS a 
LEFT JOIN (SELECT product_id,
		SUM(quantity) AS Total
		FROM sales GROUP BY product_id) AS b
ON a.product_id = b.product_id
ORDER BY b.Total desc;

-- Notice SUM(Sales) is created as a new column AS TotalSales Alias and it can be referred to as b.TotalSales
SELECT
	a.customer_id,
	a.customer_name,
	a.age,
	b.TotalSales
FROM customer AS a 
LEFT JOIN (SELECT customer_id,
		SUM(sales) AS TotalSales
		FROM sales GROUP BY customer_id) AS b
ON a.customer_id = b.customer_id
ORDER BY b.TotalSales desc;

/*
b.quantity is added, in the main query it has quantity and TotalSales
So in the subquery it can have more than 1 thing to compare with
*/
SELECT
	a.customer_id,
	a.customer_name,
	a.age,
	b.quantity,
	b.TotalSales
FROM customer AS a 
LEFT JOIN (SELECT customer_id, quantity,
		SUM(sales) AS TotalSales
		FROM sales GROUP BY customer_id, quantity) AS b
ON a.customer_id = b.customer_id
ORDER BY b.TotalSales desc;

-- subquery is in SELECT
SELECT customer_id,
	order_line, (SELECT customer_name
			FROM customer
			WHERE sales.customer_id = customer.customer_id)
FROM sales
ORDER BY customer_id;

-- ERROR:  more than one row returned by a subquery used as an expression, there are multiple people with age > 30
SELECT customer_id,
	order_line, (SELECT customer_name
			FROM customer
			WHERE customer.age > 30)
FROM sales
ORDER BY customer_id;

/* 
Assignment 11
Get data with all columns of sales table, and customer name, customer
age, product name and category are in the same result set. (use JOIN in
subquery)
*/

select
	a.*,
	b.customer_name,
	b.age,
	c.product_name,
	c.category
from ((sales AS a
inner join customer AS b
on a.customer_id = b.customer_id)
inner join product AS c
on a.product_id = c.product_id)
order by a.customer_id;

select
	c.customer_name,
	c.age,
	sp.*
from customer as c
right join (select s.*, p.product_name, p.category
		   from sales AS s
		   left join product AS p
		  on s.product_id = p.product_id) AS sp
		 on c.customer_id = sp.customer_id;
 
/* Views */

CREATE OR REPLACE VIEW logistics as
select a.order_line, a.order_id, b.customer_name, b.city, b.state, b.country
from sales as a
left join customer as b
on a.customer_id = b.customer_id
order by a.order_line;

select * from logistics;
select * from sales;

drop view logistics;

-- It is not advisable to UPDATE a VIEW, it is better to UPDATE the actual data in the TABLEs

/* INDEX */

create index mon_idx
on month_values (MM ASC);

-- same as
create index mon_idx
on month_values (MM);

drop index mon_idx;

create index year_idx
on year_values (YYYY DESC);

drop index year_idx;

drop index if exists mon_idx;

alter index if exists mon_idx RENAME TO month_idx;

/*
Assignment 12
1. Create a View which contains order_line, Product_id, sales and discount
value of the first order date in the sales table and name it as
“Daily_Billing”
2. Delete this View
*/

select * from sales;

-- all required columns are in sales table

create VIEW Daily_Billing AS
select order_line, product_id, sales, discount from sales
where order_date IN (select max (order_date) from sales);

-- max (order_date) will select the latest order date
select * from daily_billing;

select order_date from sales where order_line = 7981;

drop view daily_billing;

create VIEW Daily_Billing AS
select order_line, product_id, sales, discount from sales
where order_date IN (select min (order_date) from sales);

-- Solution

create VIEW Daily_Billing AS
select order_line, product_id, sales, discount from sales
where order_date IN (select max (order_date) from sales);

drop view daily_billing;

/* String Functions */

/* LENGTH */

-- all queries below work, remember AS is used when you want to give a column an Alias

select customer_name, length (customer_name) as character from customer where age > 30;
select customer_name, length (customer_name) as x from customer where age > 30;

select customer_name, length (customer_name) as char_num, customer_id from customer where age > 30;

select customer_name, length (customer_name) as integer from customer where age >30;

select customer_name, length (customer_name) from customer where age >30;

select customer_name, length (customer_name) as character, customer_id
from customer where length (customer_name) > 12 and age > 30;

/* UPPER & LOWER */

select upper ('Start-Tech Academy');
select lower ('Start-Tech Academy');

/* REPLACE */

select customer_name, country, replace (country,'United States', 'US') as country_new from customer;

-- below 1 line won't do anything because it is case sensative
select customer_name, country, replace (country,'united States', 'US') as country_new from customer;

select customer_name, country, replace (country,'United States', 'USA') as country_new, customer_id from customer;

/* TRIM, LTRIM & RTRIM */

/*

When using TRIM, by default, it is BOTH
when deleting a space character beween the quote there must be 1 space ' '
if there is no space between quotes, no change will be made
TRIM can not skip to remove characters
*/

select trim(leading ' ' from '    Start-Tech Academy     ');
select trim(trailing '' from '   Start-Tech Academy    ');

select trim(both ' ' from '   Start-Tech Academy    ');
-- same as
select trim('   Start-Tech Academy    ');

select rtrim('    Start-Tech Academy    ');
select ltrim('    Start-Tech Academy    ');
-- same as
select rtrim('   Start-Tech Academy   ',' ');
select ltrim('   Start-Tech Academy    ', ' ');

select rtrim('A Start-Tech Academy A','A');
select ltrim('A Start-Tech Academy A', 'A');

/* CONCAT */
select * from customer;
select customer_name, city || ',' || state || ','|| country AS address, customer_id from customer;

select customer_name, city || ', ' || state || ', '|| country AS address, customer_id from customer;

select customer_name, city || ' , '  || state || ' , '|| country AS address, customer_id from customer;

/* SUBSTRING */

select customer_id, customer_name from customer;

select customer_id, customer_name, substring(customer_id for 2) AS cust_group
from customer;

select customer_id, customer_name, substring(customer_id for 2) AS cust_group
from customer where substring(customer_id for 2) = 'AB';
-- same as first position is 1
select customer_id, customer_name, substring(customer_id from 1 for 2) AS cust_group
from customer where substring(customer_id for 2) = 'AB';

select customer_id, customer_name, substring(customer_id from 4 for 5) AS cust_number
from customer;

select customer_id, customer_name, substring(customer_id from 4 for 5) AS cust_number
from customer where substring(customer_id for 2) = 'AB';

/* STRING_AGG */

select order_id, product_id from sales
order by order_id;

select order_id, string_agg(product_id, ', ')
from sales
group by order_id;
/* 
1 single order_id can have multiple product_id associated with it
by STRIN_AGG, we are concatanating different cell values within 1 single column
*/

select order_id, string_agg(product_id, ' & ')
from sales
group by order_id;

/*
Assignment 13
1. Find Maximum length of characters in the Product name string from Product table
2. Retrieve product name, sub-category and category from Product table and an
additional column named “product_details” which contains a concatenated string of
product name, sub-category and category
3. Analyze the product_id column and take out the three parts composing the product_id
in three different columns
4. List down comma separated product name where sub-category is either Chairs or
Tables
*/

select * from product;

-- 1
select max(length(product_name)) from product;

-- 2
select product_name, sub_category, category, product_name ||', '|| sub_category ||', '||category AS product_details from product;

-- 3
select product_id, substring(product_id for 3) as category_short, substring(product_id from 5 for 2) as sub_short, substring(product_id from 8) as id from product;

-- 4
select string_agg(product_name,', ') from product where sub_category IN ('Chairs', 'Tables');

/* Mathmatical Functions */

/* CEIL & FLOOR */

select * from sales;

select order_line, sales, ceil(sales), floor(sales) from sales;

select order_line, sales, ceil(sales) as top_integer, floor(sales) as bottom_integer from sales;

/* RANDOM */

/* a = 10, b = 50 */
-- get value between 10 and 50 but 50 is excluded
select random(), random()*40+10, floor(random()*40)+10;

-- Random decimal between a range (a included and b excluded)
select RANDOM () as random_decimal;
select RANDOM ()*10 as random_decimal_0_10;
SELECT RANDOM()*(20-10)+10 as random_decimal_10_20;

-- integer

SELECT floor(RANDOM()*(20-10)+10) as random_bottom_integer;
SELECT ceil(RANDOM()*(20-10)+10) as random_top_integer;


SELECT FLOOR(RANDOM()*(20-10))+10 as random_bottom_integer;

-- Random Integer between a range (both boundaries included) add 1 to include the boundaries

SELECT FLOOR(RANDOM()*(20-10+1))+10 as random_bottom_integer_10_20;

/* SETSEED */

select setseed(0.5);

select random();
select random();

select setseed(0.5);

select random();
select random();

-- to undo use setseed(NULL);

select setseed(null);

select random();
select random();

select setseed(0.5);

select random();
select random();

select setseed(null);

/* ROUND */
select order_line, sales, ROUND(sales) from sales;

select order_line, sales, ROUND(sales) as round_value from sales;

/* POWER */

select power (6, 2);

select age, customer_name from customer order by customer_id;

select age, power(age, 2) from customer order by age;

select age, customer_name, power (age, 2) as Power_of_2 from customer order by customer_id ASC, age ASC;


/*
Assignment 14

1. You are running a lottery for your customers. So, pick a list of 5 Lucky customers from
customer table using random function
2. Suppose you cannot charge the customer in fraction points. So, for sales value of 1.63,
you will get either 1 or 2. In such a scenario, find out
a) Total sales revenue if you are charging the lower integer value of sales always
b) Total sales revenue if you are charging the higher integer value of sales always
c) Total sales revenue if you are rounding-off the sales always

*/

-- 1

select customer_id, random() as rand_number from customer order by rand_number limit 5;

select customer_name, customer_id, random() as rand_number from customer order by rand_number limit 5;

select * from customer;
select * from sales;
select SUM(sales) from sales;

-- 2

select SUM(floor(sales)) from sales;

select SUM(ceil(sales)) from sales;

select SUM(ROUND(sales)) from sales;

-- combine
select SUM(floor(sales)) as lower_int_sales, SUM(ceil(sales)) as higher_int_sales, SUM(ROUND(sales)) as round_int_sales from sales;

-- How to randomly pick 5 rows
select customer_id from customer order by random() limit 5;

select customer_name, customer_id from customer order by random() limit 5;

-- verify
select * from customer where customer_id ='TS-21370';

/* CURRENT DATE & TIME */

-- the precision is used for Seconds
select current_date, current_time, current_time(1), current_time(3), current_timestamp, current_timestamp(1), current_timestamp(3);

select current_date;

select current_time;

select current_time (1);

select current_time (3);

select current_timestamp;

select current_timestamp (1);

select current_timestamp (3);

/* AGE */

select age('2014-04-25', '2014-01-01');

select age('2018-12-27', '2017-06-03');

select order_line, order_date, ship_date, age(ship_date, order_date) as time_taken
from sales order by time_taken desc;

/* EXTRACT */

select extract(day from current_date);

select current_timestamp, extract (hour from current_timestamp);

select order_date, ship_date, extract(epoch from (ship_date - order_date))
from sales; -- error ship_date - order_date is not a date, it is a string

select order_date, ship_date, (extract(epoch from ship_date) - extract(epoch from order_date)) as sec_taken
from sales;

/*

Assignment 15
1. Find out the current age of “Batman” who was born on “April 6, 1939” in Years, months and days
2. Analyze and find out the monthly sales of sub-category chair. Do you observe any seasonality in sales of this sub-category

*/

-- 1
select age(current_date, '1939-04-06');

-- 2
select extract(month from order_date) as month_n,
sum(sales) as total_sales from sales
where product_id in (select product_id from product where sub_category = 'Chairs')
group by month_n
order by month_n;

select * from sales;
select * from product;

select sum(sales) as total_sales from sales
where product_id in (select product_id from product where sub_category = 'Chairs');

/* Pattern Matching */

SELECT * FROM customer_table WHERE first_name LIKE ‘Jo%’;

SELECT * FROM customer_table WHERE first_name LIKE ‘%od%’;

SELECT first_name, last_name FROM customer_table WHERE first_name LIKE ‘Jas_n’;

SELECT first_name, last_name FROM customer_table WHERE last_name NOT LIKE ‘J%’;

SELECT * FROM customer_table WHERE last_name LIKE ‘G\%’;

select * from customer;

SELECT * FROM customer WHERE customer_name LIKE 'G%';

SELECT * FROM customer WHERE customer_name LIKE 'G\%';

SELECT * FROM customer WHERE customer_name NOT LIKE 'J%';

SELECT * FROM customer WHERE customer_name ~* '^a+[a-z\s]+$';

SELECT * FROM customer WHERE customer_name ~* '^(a|b|c|d)+[a-z\s]+$';

SELECT * FROM customer WHERE customer_name ~* '^(a|b|c|d)[a-z]{3}\s[a-z]{4}$';

create table users(id serial primary key, name character varying);

insert into users (name) VALUES ('Alex'), ('Jon Snow'), ('Christopher'), ('Arya'),('Sandip Debnath'), ('Lakshmi'),('alex@gmail.com'),('@sandip5004'), ('lakshmi@gmail.com');

select * from users;

SELECT * FROM users WHERE name ~* '[a-z0-9\.\-\_]+@[a-z0-9\-]+\.[a-z]{2,5}';

-- Identify email addresses

/*
Assignment 16

Find out all customers who have first name and last name of 5 characters each and last name starts with “a/b/c/d”

Create a table “zipcode” and insert the below data in it

PIN/ZIP codes

234432

23345

sdfe4

123&3

67424

7895432

12312

*/

-- 1
select * from customer where customer_name ~* '^[a-z]{5}\s(a|b|c|d)[a-z]{4}$';

-- 2
create table zipcode (zip varchar);

insert into zipcode values ('234432'), ('23345'), ('sdfe4'), ('123&3'), ('67424'), ('7895432'), ('12312');

select * from zipcode;

select * from zipcode where zip ~* '^[0-9]{5,6}$';

/* Conversion */

/* Convert Numbers / Date to String */
/* Convert String to Numbers / Date */

/* CONVERSION TO STRING */

select sales, to_char(sales, '9999.99') from sales;

select sales, to_char(sales, '99999.99') from sales;

select sales, 'Total sales value for this order is' || to_char(sales, '9999.99') as message from sales; -- || is concatenate operator to concatenate 2 or more strings

select sales, 'Total sales value for this order is ' || to_char(sales, '$9999.99') as message from sales;

select sales, 'Total sales value for this order is ' || to_char(sales, '$9,999.99') as message from sales;

select sales, to_char(sales, 'L9999.99') from sales;

select sales, to_char(sales, '$9999.99') from sales;

select sales, to_char(sales, 'Y9999.99') from sales; -- use a different currency symbol 'Y'

select order_date, to_char(order_date, 'MMDDYY') from sales;

select order_date, to_char(order_date, 'Month DD YYYY') from sales;

select order_date, to_char(order_date, 'MONTH DAY YYYY') from sales;

select order_date, to_char(order_date, 'Mon DD YYYY') from sales;


/* CONVERSION TO DATE */

SELECT TO_DATE('2014/04/25', 'YYYY/MM/DD');

select to_date('2019/01/15', 'YYYY/MM/DD');

select order_date from sales;

SELECT TO_DATE('033114', 'MMDDYY');

select to_date('26122018', 'DDMMYYYY');

/* CONVERSION TO NUMBER */

select to_number('2045.876', '9999.999');

select to_number('$2,045.876', '9999.999'); -- $ and , are removed

SELECT TO_NUMBER ('1210.73', '9999.99');

SELECT TO_NUMBER ('$1210.73', 'L9999.99');  -- $ is removed

/* Access Control */

-- CREATE USER starttech WITH PASSWORD ‘academy’;

-- GRANT SELECT, INSERT, UPDATE, DELETE ON products TO starttech;

-- REVOKE DELETE ON products FROM starttech;

-- DROP USER starttech;  this generates an error, because need to drop the tables the user has access to

-- REVOKE ALL on product from starttech;

-- DROP USER starttech; this will work

-- when a user is created, username is stored in the table pg_user

select usename from pg_user;

select * from pg_user;

-- pg_stat_activity table has all users that are logged in

select distinct usename from pg_stat_activity;

select distinct * from pg_stat_activity; -- Will show all different activities done by different users

/* Tablespace */

-- create tablespace NewSpace location 'C:\Program Files\PostgreSQL\14\data\Storage';
-- Error: tablespace location should not be inside the data directory

-- create table customer_test (i int) tablespace NewSpace;

select * from pg_tablespace;
-- take a look at all the tablespaces that are created

-- truncate table customer_20_60;
-- delete all the rows within that table

/* EXPLAIN */

explain select * from customer;

-- aggregate then select
explain select distinct * from customer;

explain VERBOSE select * from customer;

-- aggregate then select
explain verbose select distinct * from customer;

/* data schemas default data schema is public */

-- select all from customer table
Select * from public.customer;

/* data schema */

CREATE SCHEMA testschema;

DROP SCHEMA testschema;

CREATE SCHEMA test;

-- CREATE customer table in testschema data schema

CREATE TABLE test.customer AS SELECT * FROM customer;

select * from test.customer;

-- Table name is a combination of schema name and table name.  testschema.customer
-- If data schema name is not mentioned, table will be created in the public schema

-- the end