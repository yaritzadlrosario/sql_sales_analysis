-- Data Cleaning

ALTER TABLE sales_analysis_utf
CHANGE COLUMN `ï»¿transactions_id` transactions_id INT;

SET SQL_SAFE_UPDATES = 0;
UPDATE sales_analysis_utf
SET sale_date = STR_TO_DATE(sale_date, '%m/%d/%Y');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE sales_analysis_utf
MODIFY COLUMN sale_date DATE;
--
SELECT * FROM sales_analysis_utf LIMIT 5;

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE sales_analysis_utf
MODIFY COLUMN sale_time TIME;
SET SQL_SAFE_UPDATES = 1;

DESCRIBE sales_analysis_utf;

SELECT *
FROM sales_analysis_utf;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM sales_analysis_utf;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM sales_analysis_utf;

-- How many unique categories do we have?
SELECT DISTINCT category FROM sales_analysis_utf;

-- Data Analysis & Business Key Problems & As
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM sales_analysis_utf 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select transactions_id , category,sale_date,quantiy 
from sales_analysis_utf
where category ='Clothing' 
and quantiy > 3
and sale_date
between '2022-11-01' and '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as total_sales
FROM sales_analysis_utf
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age) as average_age
FROM sales_analysis_utf
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM sales_analysis_utf
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category, COUNT(transactions_id) as total_transactions
FROM sales_analysis_utf
GROUP BY gender, category
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- This questions actually ask for two differents this! lets see:

-- Part 1: Average Sale per Month
SELECT 
    YEAR(sale_date) as year, 
    MONTH(sale_date) as month, 
    AVG(total_sale) as avg_sales
FROM sales_analysis_utf
GROUP BY year, month
ORDER BY year, month;

-- Part 2: Best Selling Month in Each Year
SELECT * FROM (
    SELECT 
        YEAR(sale_date) as year,
        MONTH(sale_date) as month,
        SUM(total_sale) as total_revenue,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) as ranking
    FROM sales_analysis_utf
    GROUP BY year, month
) as ranked_table
WHERE ranking = 1;

-- another way to look at the problem:
SELECT 
    YEAR(sale_date) as year, 
    MONTH(sale_date) as month, 
    SUM(total_sale) as total_revenue
FROM sales_analysis_utf
GROUP BY year, month
ORDER BY year ASC, total_revenue DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) as total_spent
FROM sales_analysis_utf
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as unique_customers
FROM sales_analysis_utf
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
    CASE 
        WHEN sale_time <= '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:01' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END as shift,
    COUNT(*) as total_orders
FROM sales_analysis_utf
GROUP BY shift
ORDER BY total_orders DESC;

-- END OF PROJECT