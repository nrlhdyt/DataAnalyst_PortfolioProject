SELECT *
  FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]

-- Which station has the most passanger --
-- Which station has the lowest passanger --
-- Which year has the most passanger entry and exit --
-- Which month has the highest passanger's traffic --


--------- Create new columns for the Year ------------------
ALTER TABLE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
ADD MonthOfTheYear VARCHAR(50)

ALTER TABLE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
ADD YearNo INT

UPDATE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
SET MonthOfTheYear = 
	CASE
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 1 THEN 'January'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 2 THEN'February'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 3 THEN 'March'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 4 THEN 'April'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 5 THEN 'May'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 6 THEN 'June'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 7 THEN 'July'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 8 THEN 'August'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 9 THEN 'September'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 10 THEN 'October'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 11 THEN 'November'
		WHEN MONTH(CONVERT(Date, MonthYear + '-01')) = 12 THEN 'December'
	END

UPDATE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
SET YearNo = YEAR(CONVERT(Date, MonthYear + '-01'))


-- Which station has the most passengers --

SELECT DISTINCT Station
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024] --There are 320 stations

SELECT COUNT(DISTINCT Station)
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024] --There are 320 stations


-- Turn all Trip column change it's type into Int --

UPDATE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
SET Trip = 
	CASE
		WHEN ISNUMERIC(Trip) = 1 THEN CAST(Trip as INT)
		ELSE NULL
	END

-- Alter the 'Trip' column to be of type INT
ALTER TABLE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
ALTER COLUMN Trip INT


SELECT Station, SUM(Trip) as NumberofPassengers20162024
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
GROUP BY Station
Order BY 2 DESC

-- Which station has the lowest passanger --
SELECT Station, SUM(Trip) as NumberofPassengers20162024
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
GROUP BY Station
Order BY 2 ASC


-- Which year has the most passanger entry and exit --
-- by station
SELECT YearNo, Station, SUM(Trip) as NumberofPassengers20162024
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
GROUP BY Station, YearNo
Order BY 3 DESC


--by year
SELECT YearNo, SUM(Trip) as NumberofPassengers20162024
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
GROUP BY YearNo
Order BY 2 DESC 

-- Which month has the highest passanger's traffic --

-- by station
SELECT MonthOfTheYear, Station, SUM(Trip) as NumberofPassengers20162024
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
GROUP BY Station, MonthOfTheYear
Order BY 3 DESC

--by month
SELECT MonthOfTheYear, SUM(Trip) as NumberofPassengers20162024
FROM [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
GROUP BY MonthOfTheYear
Order BY 2 DESC


---- CREATE PROCEDURE TO CHECK THE NUMBER OF PASSENGERS BASED ON THE YEAR AND STATION
UPDATE [AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
SET YearNo = CAST(YearNo as INT)

-- DROP PROC dbo.GetPassengerCountByStationAndYear
CREATE PROCEDURE dbo.GetPassengerCountByStationAndYear
	@Station VARCHAR(50), 
	@YearNo INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		YearNo, 
		Station, 
		SUM(Trip) as NumberofPassengers20162024
	FROM 
		[AustralianPassengerTrain].[dbo].[monthly_usage_pattern_train_data-april-2024]
	WHERE 
		Station = @Station
		AND YearNo = @YearNo
	GROUP BY Station, YearNo
	Order BY NumberofPassengers20162024 DESC
END;
GO

EXEC dbo.GetPassengerCountByStationAndYear
	@Station = 'Adamstown Station', 
	@YearNo = 2019

