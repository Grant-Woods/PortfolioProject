SELECT
  *
FROM 
  CovidDeaths
order by 3,4

SELECT 
  location, date, total_cases, new_cases, total_deaths, population
FROM 
  CovidDeaths
Order by
  1,2

-- Total Cases vs Total Deaths in the United States

SELECT 
  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage
FROM 
  CovidDeaths
WHERE
  location LIKE 'United States'
Order by
  1,2

-- Total Cases vs Population in the United States

SELECT 
  location, date, total_cases, population, (total_cases/population)*100 AS Infection_percent
FROM 
  CovidDeaths
WHERE
  location LIKE 'United States'
Order by
  1,2

-- Countries wtih highest infection rate per population sorted by highest infection

SELECT 
  location, population, MAX(total_cases), MAX((total_cases/population))*100 AS Infection_percent
FROM 
  CovidDeaths
GROUP BY
  population, location
Order by
  Infection_percent DESC

-- Countires with highest death count per population

SELECT 
  location, population, MAX(total_deaths) AS Total_death_count, MAX((total_deaths/population))*100 AS Death_percent
FROM 
  CovidDeaths
GROUP BY
  population, location
Order by
  Death_percent DESC

-- Continents with highest death count

SELECT 
  continent, MAX(cast(Total_deaths as int)) AS Total_death_count
FROM
  CovidDeaths
WHERE continent is not null
GROUP BY
  continent
Order by
  Total_death_count DESC

-- Global percentage by date

SELECT 
  date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS Death_percentage
FROM 
  CovidDeaths
WHERE
  continent is not null
GROUP BY date
Order by
  1,2

--Total Population vs Vaccinations

SELECT 
  Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations,
  SUM(CAST(Vac.new_vaccinations AS int)) OVER (Partition by Death.location ORDER BY Death.location, Death.date) AS people_vaccinated
FROM CovidDeaths AS Death
JOIN CovidVaccinations AS Vac
  ON Death.location = Vac.location
  AND Death.date = Vac.date
WHERE Death.continent is not null
ORDER BY 
  2, 3

-- USE CTE

With PopvsVac AS
(
  SELECT 
  Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations,
  SUM(CAST(Vac.new_vaccinations AS int))
  OVER (Partition by Death.location ORDER BY Death.location, Death.date) AS people_vaccinated
FROM CovidDeaths AS Death
JOIN CovidVaccinations AS Vac
  ON Death.location = Vac.location
  AND Death.date = Vac.date
WHERE Death.continent is not null
)
SELECT *, (people_vaccinated/Population)*100
FROM PopvsVac
