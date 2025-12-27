# 📊 Retail Sales Analysis - SQL Project

## Project Overview
This project demonstrates a comprehensive data analysis of a retail dataset using **MySQL**. The goal was to transform raw sales data into actionable insights, focusing on customer demographics, sales trends, and product performance.

The project involves **Data Cleaning**, **Data Transformation**, and **Exploratory Data Analysis (EDA)** to answer critical business questions.

## Technology Stack
* **Database:** MySQL
* **Tool:** MySQL Workbench
* **Language:** SQL (DDL, DML, DQL)

## Data Structure
The dataset (`sales_analysis_utf`) contains transaction records with the following key attributes:
* `transactions_id`: Unique identifier for each sale.
* `sale_date`: Date of the transaction.
* `sale_time`: Time of the transaction.
* `customer_id`: Unique identifier for the customer.
* `gender`: Customer gender.
* `age`: Customer age.
* `category`: Product category (e.g., Clothing, Beauty).
* `quantity`: Number of units sold.
* `price_per_unit`: Price of a single item.
* `cogs`: Cost of Goods Sold.
* `total_sale`: Total revenue generated from the transaction.

## Data Cleaning & Preparation
Before analysis, the raw data required significant cleaning and formatting to ensure accuracy.
1.  **Header Repair:** Fixed the "Byte Order Mark" (BOM) artifact (`ï»¿`) in the `transactions_id` column.
2.  **Date Formatting:** The `sale_date` was imported as text (e.g., `11/5/2022`). I used `STR_TO_DATE()` to convert it to MySQL's standard `YYYY-MM-DD` format and updated the column data type to `DATE`.
3.  **Time Formatting:** Converted `sale_time` to the `TIME` data type.
4.  **Column Corrections:** Fixed a typo in the column name `quantiy` → `quantity` and ensured all numeric columns (Integer/Decimal) were strictly typed for calculation.

## Key Analysis & Insights
The following business questions were solved using SQL queries:

### 1. Sales Performance Analysis
* **Total Sales per Category:** Calculated revenue aggregation (`SUM`) grouping by product category.
* **High-Value Transactions:** Filtered for all transactions exceeding 1000 in revenue.
* **Best Selling Month:** Analyzed monthly sales data to identify peak revenue periods per year.

### 2. Customer Demographics
* **Average Age:** Determined the average customer age for specific categories (e.g., 'Beauty') using `AVG()`.
* **Gender Distribution:** Counted transactions broken down by gender and category.
* **Top Customers:** Identified the top 5 customers based on total spending.
* **Unique Customers:** Used `COUNT(DISTINCT ...)` to find the actual number of unique shoppers per category.

### 3. Time-Based Analysis
* **Sales Filtering:** Retrieved transactions for specific dates and ranges (e.g., November 2022).
* **Shift Analysis:** Created a dynamic categorization of sales into **Morning**, **Afternoon**, and **Evening** shifts using SQL `CASE` statements to identify peak trading hours.

## Example Code Snippet
*Categorizing transactions into shifts using `CASE`:*
```sql
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
