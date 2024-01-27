SELECT *
FROM SalesHistory

SELECT
    ORDERDATE,
    YEAR(ORDERDATE) AS extracted_year
FROM
    SalesHistory;

SELECT
    ORDERDATE,
    MONTH(ORDERDATE) AS extracted_month
FROM
    SalesHistory;

-- Assuming your table is named 'your_table' and the date column is 'your_date_column'
ALTER TABLE SalesHistory
ADD extracted_month INT;

-- Update the new column with the extracted month
UPDATE SalesHistory
SET extracted_month = MONTH(ORDERDATE);

-- Assuming your table is named 'your_table' and the date column is 'your_date_column'
ALTER TABLE SalesHistory
ADD extracted_year INT;

-- Update the new column with the extracted month
UPDATE SalesHistory
SET extracted_year = YEAR(ORDERDATE);



-- WHICH MONTH IS THE BEST FOR SALE 
SELECT extracted_year, extracted_month, SUM(TOTALAMOUNT) AS REVENUE
FROM SalesHistory
GROUP BY extracted_month
ORDER BY extracted_year DESC;

SELECT DISTINCT CUSTOMERS FROM SalesHistory;

--CHECK LOYAL CUSTOMER
SELECT
		CUSTOMERS, 
		SUM(TOTALAMOUNT) as SumOfMoneySpent,
		avg(TOTALAMOUNT) as AverageMoneySpent
FROM SalesHistory
GROUP BY CUSTOMERS
ORDER BY SumOfMoneySpent desc