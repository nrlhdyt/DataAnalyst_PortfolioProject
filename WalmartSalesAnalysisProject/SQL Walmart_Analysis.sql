SELECT TOP (1000) [Invoice_ID]
      ,[Branch]
      ,[City]
      ,[Customer_type]
      ,[Gender]
      ,[Product_line]
      ,[Unit_price]
      ,[Quantity]
      ,[Tax_5]
      ,[Total]
      ,[Date]
      ,[Time]
      ,[Payment]
      ,[cogs]
      ,[gross_margin_percentage]
      ,[gross_income]
      ,[Rating]
  FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]

  -- Data cleaning
SELECT
	*
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];


-- Add the time_of_day column
ALTER TABLE [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
ADD Time_Of_Day VARCHAR(50);

UPDATE [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
SET Time_Of_Day =
CASE 
        WHEN CAST(TIME AS Time) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN CAST(TIME AS Time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;
	

-- Add day names into column
SELECT
    Date,
    DATENAME(DW, Date) AS DayName        -- 'DW' specifies that you want to get the day of the week.
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

ALTER TABLE [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
ADD DayName VARCHAR(50);

UPDATE [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
SET DayName = DATENAME(DW, Date)       -- 'DW' specifies that you want to get the day of the week.




-- Add month column
SELECT 
	Date,
	DATENAME(Month, Date) AS MonthName
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

ALTER TABLE [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
ADD MonthName VARCHAR(50);

UPDATE [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
SET MonthName = DATENAME(Month, Date)




-- Check how many cities walmart located
SELECT 
	DISTINCT City
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

-- In which cities which branch

SELECT
	DISTINCT City, 
	Branch
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT 
	DISTINCT Product_line
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

-- What is the most selling product line
SELECT
	Product_line, 
	SUM(Quantity) Qty
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY Qty Desc;

-- What is the total revenue by month
SELECT
	MonthName,
	SUM(Total) Revenue
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY MonthName
ORDER BY Revenue Desc;

-- What month had the largest COGS? COGS - Cost Of Goods Sold
SELECT
	MonthName,
	SUM(cogs) COGS
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY MonthName
ORDER BY COGS Desc;

-- What product line had the largest revenue?
SELECT
	Product_line,
	SUM(Total) Revenue_per_Products
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY Revenue_per_Products Desc;

-- What is the city with the largest revenue?
SELECT
	City,
	SUM(Total) Revenue_per_City
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY City
ORDER BY Revenue_per_City Desc;

-- What product line had the largest VAT?
SELECT
	Product_line,
	AVG(Tax_5) VAT
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY VAT Desc;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(Quantity) AS avg_qnty
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

SELECT
		Product_line, 
		AVG(Quantity) as No_Remark,
		CASE	
			WHEN AVG(Quantity) > 5 THEN 'Good'
		ELSE 'Bad'
	END AS Remark
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Product_line;

-- Which branch sold more products than average product sold?
SELECT 
	Branch, 
    SUM(quantity) AS qnty
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]);

-- What is the most common product line by gender
SELECT
	Product_line,
	Gender,
	COUNT(Gender) as count_gender
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Gender, Product_line
ORDER BY count_gender desc

-- What is the average rating of each product line
SELECT
	Product_line,
	ROUND(AVG(Rating), 2) as Average_Rating
FROM  [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY Average_Rating desc;



-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT Customer_type
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];


-- How many unique payment methods does the data have?
SELECT
	DISTINCT Payment
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];

-- What is the most common customer type?
SELECT
	Customer_type,
	COUNT(*) as amount -- you can use COUNT(Customer_type) too
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY amount desc

-- Which customer type buys the most?

SELECT
	customer_type,
    COUNT(*)
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	Gender,
	COUNT(Gender) as qty_cust
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Gender

-- What is the gender distribution per branch?
SELECT 
	Gender,
	COUNT(Gender) as qty_gender
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
WHERE Branch ='c'
GROUP BY Gender

-- Which time of the day do customers give most ratings?
SELECT
	Time_Of_Day,
	AVG(Rating) as avg_rating
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Time_Of_Day
ORDER BY avg_rating desc;

-- Which time of the day do customers give most ratings per branch?
SELECT
	Time_Of_Day,
	AVG(Rating) as avg_rating
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
WHERE Branch ='c'
GROUP BY Time_Of_Day
ORDER BY avg_rating desc;

-- Which day fo the week has the best avg ratings?
SELECT
	DayName,
	AVG(Rating) as avg_rating
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY DayName
ORDER BY avg_rating desc;

-- Which day fo the week has the best avg ratings? Per branch
SELECT
	DayName,
	AVG(Rating) as avg_rating
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
WHERE Branch = 'C'
GROUP BY DayName
ORDER BY avg_rating desc;	



-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	Time_of_day,
	COUNT(*) as SalesMade
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
WHERE DayName = 'Saturday'
GROUP BY Time_of_Day
ORDER BY SalesMade Desc

--Most customers do purchasing on evening every day



-- Which of the customer types brings the most revenue?
SELECT
	Customer_type,
	SUM(Total)as Revenue
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY Revenue DESC;


-- Which city has the largest tax/VAT percent?
SELECT
	City, 
	ROUND(AVG(Tax_5), 2)as Tax_percentage
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY City
ORDER BY Tax_percentage;


-- Which customer type pays the most in VAT?

SELECT
	Customer_type,
	AVG(Tax_5) as Avg_tax
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY Avg_tax desc;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------


SELECT *
FROM [WalmartAnalysis].[dbo].[WalmartSalesData.csv];



