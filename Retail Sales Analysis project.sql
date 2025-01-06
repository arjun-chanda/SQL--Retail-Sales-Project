CREATE DATABASE retailsales;
use  retailsales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * FROM retail_sales;

-- DATA CLEANING --

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Data Exploration--

-- How Many sales we have ?--

SELECT count(*) AS total_sale FROM retail_sales;

-- how many unique customers we have --

SELECT count(DISTINCT customer_id) AS total_sale FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;


-- Solving Business Related Problems--

-- 1. write a SQL query to retrive all colums for sales msde on "2022-11-05" --
 
 SELECT * FROM retail_sales
 WHERE sale_date  = '2022-11-05';

-- 2.write a SQL query to retrive all transactions where the category is "colthing" and the quamtity sold is more than 4 in the month of nov-2022 ? 

SELECT category,
SUM(quantity)
FROM retail_sales
WHERE category = "Clothing"
GROUP bY 1;

SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND
sale_date >= '2022-11-01'
  AND 
  sale_date < '2022-12-01'
  AND quantity >= 4;

-- 3. write a SQL query to calculate the total sales for each category  ? --

SELECT category,
SUM(total_sale) AS net_sale, 
COUNT(*) AS total_order
FROM retail_sales
GROUP BY 1;

-- 4. write a SQL query to find the average age of customers who purchased items from "beauty" category ?--

SELECT 
ROUND(AVG(age), 2) AS avg_age 
FROM  retail_sales
WHERE category = 'Beauty';

-- 5. write a SQL query to find all transactions where the total_sale is greater than 1000 ? --

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- 6. write a SQL query to find the toatl number of tarnsaction made by each gender in each category ? --

SELECT 
   category,
   gender, 
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 
category,
gender 
ORDER BY 1;

-- 7.write a SQL query to calculate the avg sale for each month. Find out best selling month in each year ? --
 
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_val
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_sales
WHERE rank_val = 1;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales ?-- 

SELECT 
customer_id,
sum(total_sale)AS total_sale
 FROM retail_sales
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 5;
 
 -- 9.Write a SQL query to find the number of unique customers who purchased items from each category ? --
 
 SELECT 
        category,
        COUNT( DISTINCT customer_id) AS unique_customers
        FROM retail_sales
        GROUP BY category;
        
 -- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) ?
   WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT -- 


