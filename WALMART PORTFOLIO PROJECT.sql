create database Walmartsales;
use Walmartsales;
CREATE TABLE IF NOT EXISTS sales(
   invoice_id VARCHAR(30) NOT NULL,
   branch VARCHAR(5) NOT NULL,
   city  VARCHAR(30) NOT NULL,
   customer_type VARCHAR(30) NOT NULL,
   gender VARCHAR(10) NOT NULL,
   prouduct_line VARCHAR(100) NOT NULL,
   unit_price DECIMAL(10,2) NOT NULL,
   quantity INT NOT NULL,
   vat FLOAT(6,4) NOT NULL,
   total DECIMAL(12, 4) NOT NULL,
   date DATETIME NOT NULL,
   time TIME NOT NULL,
   payment_method VARCHAR(15) NOT NULL,
   cogs DECIMAL(10,2) NOT NULL,
   gross_margin_pct FLOAT(11,9),
   gross_income DECIMAL(12,4) NOT NULL,
   rating FLOAT(2,1)
);
drop TABLE SALES;
SELECT * FROM Walmartsales.sales;



-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------- Feature Engiineering-----------------------------------------------------------------------------------------------------------

-- time of day

SELECT
     TIME,
     (CASE
          WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
          WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
          ELSE "Evening"
     END) AS time_of_date
FROM sales;

AlTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);   
UPDATE sales
SET time_of_day = (
    CASE
          WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
          WHEN `time`BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
          ELSE "Evening"
	END
);
SET SQL_SAFE_UPDATES = 0;

--  day_name
SELECT
     date,
     DAYNAME(DATE) AS day_name
FROM sales;

ALTER TABLE SALES ADD COLUMN DAY_NAME VARCHAR(10);
UPDATE sales
SET day_name = DAyNAME(DATE);

-- month_name
SELECT
     date,
     MONTHNAME(date)
from sales;
Alter TABLE SALES ADD COLUMN MONTH_NAME VARCHAR(10);
UPDATE sales
SET MONTH_NAME = MONTHNAME(DATE);
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------GENERIC------------------------------------------------------------------------------------------------`-------------------------
-- How MANY UNIQUE CITIES DOES THE DATA HAVE? 
SELECT
     DISTINCT city
FROM sales;

-- IN WHICH CITY IS THE EACH BRANCH
SELECT
     DISTINCT city,
     branch
FROM sales;
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------PROUDUCT-------------------------------------------------------------------------------------------------------------------------
-- HOW MANY UNIQUE PROUDUCT LINES DOES DATA HAVE?
SELECT
     COUNT(DISTINCT prouduct_line)
FROM sales;

-- WHAT IS THE MOST COMMON PAYMENT METHOD?
SELECT
     payment_method,
     COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt  DESC;

-- WHAT IS THE MOST SELLING PROUDUCT LINE?
SELECT 
     prouduct_line,
     COUNT(prouduct_line) AS prd_line
FROM sales
GROUP BY prouduct_line
ORDER by prd_line DESC;

-- WHAT IS THE TOTAL REVENUEE OF MONTH?
SELECT
     MONTH_NAME AS month,
     SUM(total) as total_sales
FROM sales
GROUP BY MONTH_NAME
ORDER BY total_sales DESC;

-- WHICH MONTH HAS LARGEST COGS?
SELECT
     MONTH_NAME AS month,
     SUM(cogs) as LARGEST_COGS
     FROM sales
GROUP BY MONTH_NAME
ORDER BY LARGEST_COGS DESC;

-- WHAT PROUDUCT LINE HAS LARGEST REVENUE?
SELECT
     prouduct_line AS PDT_LINE,
     SUM(total) as TOTAL_REVENUE
     FROM sales
GROUP BY prouduct_line
ORDER by TOTAL_REVENUE DESC;
SELECT * FROM SALES;

-- WHAT IS THE CITY WITH THE LARGEST REVENUE?
SELECT
     city,
     branch,
     SUM(total) as TOTAL_REVENUE
     FROM sales
GROUP BY city,branch
ORDER by TOTAL_REVENUE DESC;

-- WHAT PROUDUCT_LINE HAS LARGEST VAT?
select 
     prouduct_line,
     AVG(VAT) AS Largest_vat
     from sales
GROUP BY prouduct_line
ORDER BY Largest_vat DESC;

-- WHICH BRANCH SOLD MORE PROUDUCTS THAN AVERAGE PROJECTS SOLD?
SELECT
     branch,
     SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- WHAT IS THE MOST COMMON PROUDUCT LINE BY GENDER
SELECT
     gender,
     prouduct_line,
     COUNT(gender) AS TOTAL_CNT
     FROM sales
GROUP BY gender,prouduct_line
ORDER BY TOTAL_CNT DESC;


-- WHAT AVG RATING OF EACH PROUDUCT_LINE?
SELECT
     prouduct_line,
     ROUND(AVG(rating),2) AS RATING
     FROM SALES
GROUP BY prouduct_line
ORDER BY RATING DESC;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------SALES-------------------------------------------------------------------------------------------

-- NUMBER OF SALES MADE IN EACH TIME OF THE DAY PER WEEKDAY?
SELECT
     time_of_day,
     COUNT(*) AS total_sales
FROM SALES
WHERE day_name="sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- WHICH OF THE CUSTOMER TYPES BRINGS THE MOST REVENUE?
SELECT
     customer_type,
     SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- WHICH CITY HAS THE LARGEST TAX PERCENT/VAT?
SELECT
     city,
     AVG(vat) as VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;
-- WHICH CUSTOMER TYPE PAYS THE MOST IN VAT?
SELECT
     customer_type,
     AVG(vat) as VAT
FROM sales
GROUP by customer_type
ORDER BY VAT DESC;

-- -------------------------------------------------------------------------------------------------------------------------------
-- -----------------------CUSTOMERS-----------------------------------------------------------------------------------------------

-- HOW MANY UNIQUE CUSTOMER TYPES DOES DAATA HAVE?
SELECT
     DISTINCT customer_type
FROM SALES;

-- HOW MANY UNIQUE PAYMENT METHODS DOES DATA HAVE?
SELECT
     DISTINCT payment_method
FROM SALES;

-- WHAT IS THE MOST COMMON CUSTOMER TYPE?
 SELECT
      customer_type,
      COUNT(*) AS CUSTMR_COUNT
FROM sales
GROUP BY customer_type
ORDER BY CUSTMR_COUNT DESC;

-- WHAT IS THE GENDER OF MOST OF CUSTOMERS?
SELECT
     gender,
     COUNT(*) AS GENDER
FROM sales
GROUP BY gender
ORDER BY GENDER DESC;

-- WHAT IS THE GENDER DISTRIBUTION PER BRANCH?
SELECT
     gender,
     COUNT(*) AS GENDER
FROM sales
WHERE branch="A"
GROUP BY gender
ORDER BY GENDER DESC;
SELECT * FROM SALES;
-- WHICH TIME OF THE DAY CUSTOMERS GIVE MOST RATINGS?
SELECT
     time_of_day,
     AVG(rating) AS AVG_RATING
FROM sales
GROUP BY time_of_day
ORDER BY AVG_RATING DESC;

-- WHICH TIME OF THE DAY CUSTOMER GIVE MOST RATINGS PER BRANCH?
SELECT
     time_of_day,
     AVG(rating) AS AVG_RATING
FROM sales
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY AVG_RATING DESC;
SELECT * FROM SALES;
-- WHICH DAY OF THE WEEK HAS BEST RATINGS?
SELECT
    DAY_NAME,
    AVG(rating) AS RATING
FROM sales
GROUP BY DAY_NAME
ORDER BY RATING DESC;

-- WHICH DAY OF THE WEEK HAS BEST RATINGS  PER BRANCH?
SELECT
    DAY_NAME,
    AVG(rating) AS RATING
FROM sales
WHERE branch = "C"
GROUP BY DAY_NAME
ORDER BY RATING DESC;