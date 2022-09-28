--SELECT DISTINCT location
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NULL
--ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVaccination
ORDER BY 3,4

-- Looking at the rate Death Percentage: Total deaths/ Total cases 
SELECT location, date, CAST(total_cases AS float) AS total_cases, CAST(total_deaths AS float) AS total_deaths, (total_deaths/CAST(total_cases AS float))*100 AS [Death Percentage]
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at the rate: Percent Population Infected: total cases/population
SELECT location, population, date, CAST(total_cases AS float) AS total_cases, (CAST(total_cases AS float)/population)*100 AS [Percent Population Infected]
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(CAST(total_cases AS float)) AS [Total Infection Count], (MAX(CAST(total_cases AS float))/population)*100 AS [Highest Infection Rate]
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY [Highest Infection Rate] DESC

-- Showing Countries with Highest Death Count per population
SELECT location, population, MAX(CAST(total_deaths AS float)) AS [Total Death Count], (MAX(CAST(total_deaths AS float))/population)*100 AS [Highest Death Rate]
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY [Total Death Count] DESC

--Showing continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths AS float)) AS [Total Death Count]
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY [Total Death Count] DESC

--Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS [Rolling People Vaccinated]
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
	AND vac.new_vaccinations IS NOT NULL
--GROUP BY continent, location, date, population
ORDER BY 2,3

SELECT dea.location, dea.population, SUM(CAST(vac.new_vaccinations AS float)) AS total_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
	AND vac.new_vaccinations IS NOT NULL
GROUP BY dea.location, dea.population
ORDER BY 1