-- Creating database for walmart
CREATE DATABASE IF NOT EXISTS WalmartSales;

-- Using the database
USE WalmartSales;

-- Creating table of sales records
CREATE TABLE IF NOT EXISTS sales(
	invoice_ID VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date_ DATETIME NOT NULL,
    time_ TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


--to add csv file into the table:
load data local infile 'C:/Users/Dell/Desktop/Rishi/Sejal/projects/Walmart Analysis Using SQL/WalmartSalesData.csv' into table sales fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows;
-- Adding time_of_day column for morning, afternoon and evening:
SELECT time_,(CASE
	        	WHEN `time_` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
                WHEN `time_` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
                ELSE "Evening"
                END) AS time_of_day FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(30);
--or
UPDATE sales SET time_of_day = (
	CASE
		WHEN `time_` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time_` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Adding day_name column
SELECT date_, DAYNAME(date_) FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
--or
UPDATE sales SET day_name = DAYNAME(date_);


-- Adding month_name column
SELECT date, MONTHNAME(date) FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
--or
UPDATE sales SET month_name = MONTHNAME(date);




-- How many unique cities does the dataset contain?
SELECT 	DISTINCT city FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch FROM sales;

-- How many unique product lines does the dataset have?
SELECT DISTINCT product_line FROM sales;

-- Which is the most-selling product line
SELECT SUM(quantity) as qty,product_line FROM sales GROUP BY product_line ORDER BY qty DESC;

-- What is the total revenue by month
SELECT month_name AS month,SUM(total) AS total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT month_name AS month,	SUM(cogs) AS cogs FROM sales GROUP BY month_name ORDER BY cogs;

-- Which product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue FROM sales GROUP BY product_line ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT branch,city,SUM(total) AS total_revenue FROM sales GROUP BY city, branch ORDER BY total_revenue;

-- What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as avg_tax FROM sales GROUP BY product_line ORDER BY avg_tax DESC;



SELECT AVG(quantity) AS avg_qnty FROM sales;
SELECT product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 	branch, SUM(quantity) AS qnty FROM sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender
SELECT gender,product_line,COUNT(gender) AS total_cnt FROM sales GROUP BY gender, product_line ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT  ROUND(AVG(rating), 2) as avg_rating,  product_line FROM sales GROUP BY product_line ORDER BY avg_rating DESC;

-- How many unique customer types does the dataset contain?
SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM sales;


-- What is the most common customer type?
SELECT customer_type,count(*) as count FROM sales GROUP BY customer_type ORDER BY count DESC;

-- Which customer type buys the most?
SELECT customer_type,COUNT(*) FROM sales GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender,COUNT(*) as gender_cnt FROM sales GROUP BY gender ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT gender,COUNT(*) as gender_cnt FROM sales WHERE branch = "C" GROUP BY gender ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales GROUP BY time_of_day ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales WHERE branch = "A" GROUP BY time_of_day ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating FROM sales GROUP BY day_name ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name,COUNT(day_name) total_sales FROM sales WHERE branch = "C" GROUP BY day_name ORDER BY total_sales DESC;

-- Number of sales made in each time of the day per weekday 
SELECT time_of_day, COUNT(*) AS total_sales FROM sales WHERE day_name = "Sunday" GROUP BY time_of_day  ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT	city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct FROM sales GROUP BY city ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT	customer_type,	AVG(tax_pct) AS total_tax FROM sales GROUP BY customer_type ORDER BY total_tax;

k