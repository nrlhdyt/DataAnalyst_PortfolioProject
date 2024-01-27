Select*
From Portfolio_1..CovidDeaths$
Where continent is not null
order by 3,4


Select*
From Portfolio_1..CovidVaccination$
order by 3,4

--Select Data that we are going to be using

SELECT 
	Location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
From 
	Portfolio_1..CovidDeaths$
order by 1,2


/*For Tableu
*/

---1
SELECT
	SUM(new_cases) as Total_cases,
	SUM(CAST(new_deaths as INT)) as Total_death,
	SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage

FROM
	Portfolio_1..CovidDeaths$
WHERE
	continent IS NOT NULL
ORDER BY
	1,2


---2

SELECT
	location, 
	SUM(CAST(new_deaths as INT)) as TotalDeathCount
FROM
	Portfolio_1..CovidDeaths$
WHERE
	continent IS NULL AND
	location NOT IN ('World','European Union','International')
GROUP BY
	location
ORDER BY
	TotalDeathCount desc

---3

SELECT
	location,
	population,
	MAX(total_cases) as HighestInfectionCount,
	MAX(total_cases)/population*100 as PercentPopulationInfected
FROM
	Portfolio_1..CovidDeaths$
GROUP BY
	location, 
	population
ORDER BY
	PercentPopulationInfected desc



---4
SELECT
	location,
	population,
	date,
	MAX(total_cases) as HighestInfectionCount,
	MAX(total_cases)/population*100 as PercentPopulationInfected
FROM
	Portfolio_1..CovidDeaths$
GROUP BY
	location, 
	population,
	date
ORDER BY
	PercentPopulationInfected desc







-- Looking at Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_1..CovidDeaths$
Where location like '%asia%'
order by 1,2


-- Looking at the Total Cases vs Population
Select Location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From Portfolio_1..CovidDeaths$
--Where location like '%indonesia%'
order by 1,2


--Looking at countries with highest infection rate compared to population

Select Location,population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as PercentPopulationInfection
From Portfolio_1..CovidDeaths$
--Where location like '%Afghanistan%'
Group by population, Location
order by PercentPopulationInfection desc

-- Showing countries with highest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeath
From Portfolio_1..CovidDeaths$
--Where location like '%indonesia%'
Where continent is not null
Group by Location
order by TotalDeath desc


-- Lets break things down by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeath
From Portfolio_1..CovidDeaths$
Where continent is null
Group by location
order by TotalDeath desc


--Showing the continents with highest death counts
Select continent, MAX(cast(total_deaths as int)) as TotalDeath
From Portfolio_1..CovidDeaths$
Where continent is not null
Group by continent
order by TotalDeath desc


-- Global Numbers
Select date, SUM(new_cases) as New_Cases, SUM(cast(new_deaths as int)) as New_Death, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From Portfolio_1..CovidDeaths$
Where continent is not null
Group by date
order by DeathPercentage desc


-- Joining two tables
Select*
From Portfolio_1..CovidDeaths$ dea
Join Portfolio_1..CovidVaccination$ vac
	On dea.location = vac. location
	and dea.date = vac.date


-- Looking at populations vs vaccination
Select dea.location, dea.date, dea.population, vac.new_vaccinations
From Portfolio_1..CovidDeaths$ dea
Join Portfolio_1..CovidVaccination$ vac
	On dea.location = vac. location
	and dea.date = vac.date
Where dea.continent is not null
Order by 1,2,3


-- Looking by the SUM of vaccination

Select dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From Portfolio_1..CovidDeaths$ dea
Join Portfolio_1..CovidVaccination$ vac
	On dea.location = vac. location
	and dea.date = vac.date
Where dea.continent is not null
Order by 1,2



--USE CTE
With PopvsVac (Continent,Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From Portfolio_1..CovidDeaths$ dea
Join Portfolio_1..CovidVaccination$ vac
	On dea.location = vac. location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 1,2
 )
Select*, (RollingPeopleVaccinated/population)*100 as percentage
From PopvsVac
--ORDER BY percentage desc


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From Portfolio_1..CovidDeaths$ dea
Join Portfolio_1..CovidVaccination$ vac
	On dea.location = vac. location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 1,2


Select*, (RollingPeopleVaccinated/population)*100 as percentage
From #PercentPopulationVaccinated


--Creating view to store data for later visualization
Drop View If Exists PercentPopulationVaccinated;
Create View PercentPopulationVaccinated as
Select
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From 
	Portfolio_1..CovidDeaths$ dea
Join 
	Portfolio_1..CovidVaccination$ vac
	On dea.location = vac. location AND dea.date = vac.date
Where 
	dea.continent IS NOT NULL
--Order by 1,2

SELECT *
	FROM PercentPopulationVaccinated