-- Data Cleansing
-- We are going to delete unrelated data from Column "Entity"
SELECT DISTINCT Entity
FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]

-- Clean the data
DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'Upper-middle-income countries'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'Lower-middle-income countries'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'High-income countries'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'World'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'Europe'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'European Union (27)'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'Asia'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'Africa'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'South America'

DELETE FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'North America'



SELECT DISTINCT Entity
FROM 
	[Data Cleaning].[dbo].[co2-emissions-transport]

SELECT entity, SUM(Carbon_dioxide_emissions_from_transport)
FROM
	[Data Cleaning].[dbo].[co2-emissions-transport]
WHERE
	Entity = 'Russia'
	And Year = 1990
GROUP BY Entity

