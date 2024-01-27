SELECT TOP (1000) [ORDERNUMBER]
      ,[QUANTITYORDERED]
      ,[PRICEEACH]
      ,[ORDERLINENUMBER]
      ,[SALES]
      ,[ORDERDATE]
      ,[STATUS]
      ,[QTR_ID]
      ,[MONTH_ID]
      ,[YEAR_ID]
      ,[PRODUCTLINE]
      ,[MSRP]
      ,[PRODUCTCODE]
      ,[CUSTOMERNAME]
      ,[PHONE]
      ,[ADDRESSLINE1]
      ,[ADDRESSLINE2]
      ,[CITY]
      ,[STATE]
      ,[POSTALCODE]
      ,[COUNTRY]
      ,[TERRITORY]
      ,[CONTACTLASTNAME]
      ,[CONTACTFIRSTNAME]
      ,[DEALSIZE]
  FROM [Sales].[dbo].[sales_data_sample]


SELECT ORDERDATE FROM [dbo].[sales_data_sample]
ORDER BY ORDERDATE DESC;



SELECT distinct status from sales_data_sample; -- NICE
SELECT DISTINCT year_id FROM sales_data_sample;
SELECT DISTINCT PRODUCTLINE FROM sales_data_sample; -- NICE
SELECT DISTINCT COUNTRY FROM sales_data_sample; -- NICE
SELECT DISTINCT DEALSIZE FROM sales_data_sample; -- NICE
SELECT DISTINCT TERRITORY FROM sales_data_sample; -- NICE
SELECT DISTINCT MONTH_ID FROM sales_data_sample -- NICE
WHERE YEAR_ID = 2005;
SELECT DISTINCT ORDERNUMBER FROM sales_data_sample

-- ANALYSIS
-- Let's start by grouping PRODUCTLINE

SELECT PRODUCTLINE, SUM(SALES) AS REVENUE
FROM sales_data_sample
group by PRODUCTLINE
ORDER BY REVENUE DESC;

SELECT YEAR_ID, SUM(SALES) AS REVENUE
FROM sales_data_sample
group by YEAR_ID
ORDER BY REVENUE DESC;

SELECT COUNTRY, SUM(SALES) AS REVENUE
FROM sales_data_sample
group by COUNTRY
ORDER BY REVENUE DESC;


-- WHICH MONTH IS THE BEST FOR SALE 
SELECT MONTH_ID, SUM(SALES) AS REVENUE, COUNT(ORDERNUMBER) AS FREQUENCY
FROM sales_data_sample
WHERE YEAR_ID = 2005 -- WE CAN CHANGE IT AS WE LIKE
GROUP BY MONTH_ID
ORDER BY REVENUE DESC;

-- NOVEMBER IS THE MOST SALES FOR ITEMS IN A MONTH, AND LET'S CHECK THE MOST DEMAND ITEMS IN NOVEMBER
SELECT MONTH_ID, PRODUCTLINE, SUM(SALES) AS REVENUE, COUNT(ORDERNUMBER) AS FREQUENCY
FROM sales_data_sample
WHERE YEAR_ID = 2005 AND MONTH_ID = 5 -- WE CAN CHANGE IT AS WE LIKE
GROUP BY PRODUCTLINE, MONTH_ID
ORDER BY REVENUE DESC;

-- WHO IS OUR BEST CUSTOMER (USING RFM ; RECENCY, FRQUENCY, AND MONETARY)
SELECT MAX(ORDERDATE) FROM sales_data_sample;

DROP TABLE IF EXISTS #rfm;
with rfm as
(
	SELECT
		CUSTOMERNAME, 
		SUM(SALES) as SumOfMoneySpent,
		avg(SALES) as AverageMoneySpent,
		count(ORDERNUMBER) AS FREQUENCY,
		MAX(ORDERDATE) AS LastOrder,
		(SELECT MAX(ORDERDATE) FROM sales_data_sample) as Max_Order_Date,
		datediff(dd, MAX(ORDERDATE), (select MAX(ORDERDATE) FROM sales_data_sample )) as Recency
	FROM sales_data_sample
	GROUP BY CUSTOMERNAME

),
rfm_calc as
(
SELECT r.*,
	NTILE(4) OVER(ORDER BY Recency) rfm_recency,
	NTILE(4) OVER(ORDER BY Frequency) rfm_frequency,
	NTILE(4) OVER(ORDER BY SumOfMoneySpent) rfm_monetary
FROM rfm r
)
SELECT c.*, rfm_recency+ rfm_frequency+rfm_monetary as rfm_cell,
cast(rfm_recency as VARCHAR)+ cast(rfm_frequency as VARCHAR)+ cast(rfm_monetary as VARCHAR) as rfm_cell_string
INTO #rfm
FROM rfm_calc c



SELECT * FROM #rfm;

SELECT CUSTOMERNAME, rfm_recency, rfm_frequency,rfm_monetary,
	CASE
		WHEN rfm_cell_string in (111, 112, 121, 123,132, 211, 212, 114, 141) then 'Lost customer'
		WHEN rfm_cell_string in (133, 134, 143, 244, 334, 343, 344) then 'sliping away, cannot lose'
		WHEN rfm_cell_string in (311, 411, 331) then 'New Customer'
		WHEN rfm_cell_string in (222, 223, 233, 332) then 'Potential Churners'
		WHEN rfm_cell_string in (323, 333, 321, 422, 332, 432) then 'Active'
		WHEN rfm_cell_string in (433, 434, 443, 444) then 'Loyal customers'
	END rfm_segment

FROM #rfm



-- What products are most often sold together?
SELECT distinct ORDERNUMBER, STUFF(

	(SELECT ','+ PRODUCTCODE
	FROM sales_data_sample p
	WHERE ORDERNUMBER IN
		(
			SELECT ORDERNUMBER
			FROM(
					SELECT ORDERNUMBER, COUNT(*) rn
					FROM sales_data_sample
					WHERE STATUS = 'Shipped'
					GROUP BY ORDERNUMBER
					)m
					WHERE rn = 3
			)
			and p.ORDERNUMBER = s.ORDERNUMBER
			for xml path (''))
			,1,1,'') ProductCodes
FROM sales_data_sample s
ORDER BY 2 desc;