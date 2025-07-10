-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
		);

		
SELECT *  FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM retail_sales

-- Data Cleaning
SELECT *  FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR 
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL

--
DELETE FROM retail_Sales
WHERE
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	category is NULL
	OR 
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS retail_sale FROM retail_sales

-- How many unique customers we have ?
SELECT COUNT(distinct customer_id) as total_customer FROM retail_sales

-- Total Categories of Products
SELECT distinct Category FROM retail_sales

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrive all columns for sales made on 2022-11-05.

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrive all transactions where the category is 'clothing' and the Quantity sold is more than 4 in the month of nov-2022

SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) For each Category.

SELECT 
	category,
	sum(total_sale) AS net_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

-- Q.4 Write a SQL Query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find total number of Transactions( transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(transactions_id) as Total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY category

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT 
	year,
	month,
	avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		ROUND(avg(total_sale)::numeric,2) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY avg(total_sale) DESC) AS rank
	FROM retail_sales 
	GROUP BY year,month
)
WHERE rank = 1

-- Q.8 Write a SQL Query to find the top 5 customers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items for each category

SELECT 
	category,
	COUNT(distinct customer_id) as Count_of_Unique_Customers
FROM retail_sales
GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders(Example Morning <12 ,Afternoon Between 12 & 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT  *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(transactions_id) as Number_of_orders
FROM hourly_sale
GROUP BY 1

