SHOW DATABASES;

USE PortfolioProject;

SELECT *
FROM covid_deaths
WHERE continent is not null
ORDER BY 3,4;

-- SELECT *
-- FROM covid_vaccinations
-- ORDER BY 3,4;
--

-- Select data that we are going to be using  
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2;

-- Looking at Total Cases vs Total deaths-- 
-- Shows likelihood of dying if you contracted covid in USA
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
FROM covid_deaths
WHERE location like '%states%'
ORDER BY 1,2;

-- Looking at Total cases vs Population
-- Shows what percentage of popularion got covid
SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS Population_that_got_covid
FROM covid_deaths
WHERE location like '%states%'
ORDER BY 1,2;

-- Looking at countries with highest infection rate compared to Population 
SELECT 
	Location, 
    Population,
	MAX(total_cases) AS Highestinfectioncount,
    MAX(total_cases/Population)*100 AS PercentPopulationInfected
FROM covid_deaths
GROUP BY Location,Population
ORDER BY 4 DESC;

-- LET'S BREAK THINGS DOWN BY CONTINENT 
SELECT 
	location,
    max(cast(total_deaths AS DOUBLE)) AS Total_death_count
FROM covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY Total_death_count DESC;


-- Showing countries with highest death count per population 
SELECT 
	Location,
    max(cast(total_deaths AS DOUBLE)) AS Total_death_count
FROM covid_deaths
WHERE continent is not null
GROUP BY 1
ORDER BY Total_death_count DESC;

-- showing continetents with the highest death count per population
SELECT 
	location,
    max(cast(total_deaths AS DOUBLE)) AS Total_death_count
FROM covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY Total_death_count DESC;

-- Global numbers - TOTAL DEATHS/DEATHPERCENTAGE
SELECT
 --    date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths as DOUBLE)) AS total_deaths,
    SUM(CAST(new_deaths as DOUBLE))/SUM(new_cases)*100 AS DEATH_PERCENTAGE
FROM covid_deaths
WHERE continent is not null
-- GROUP BY date
ORDER BY 1,2;



-- Looking at total population vs vaccinations

SELECT 
	dea.continent,
	dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(vac.new_vaccinations, DOUBLE)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rollingPeoplVaccinated,
    
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;



