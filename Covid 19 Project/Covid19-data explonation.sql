--Table 1:
-- Global number: total case, total death -> % death/ case;
-- total population, % infection/population
-- total people vaccinated (at least 1 vacc) -> % vaccinated/population
SELECT dea.population, MAX(CAST(total_cases AS float)) AS [Total cases], MAX(CAST(total_deaths AS float)) AS [Total deaths],
MAX(CAST(people_vaccinated AS float)) AS [People vaccinated],
(MAX(CAST(total_deaths AS float))/MAX(CAST(total_cases AS float)))*100 AS [Death rate (%)],
(MAX(CAST(total_cases AS float))/dea.population)*100 AS [Infected rate (%)],
(MAX(CAST(people_vaccinated AS float))/dea.population)*100 AS [Vaccinated rate (%)]
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.location = 'World'
GROUP BY dea.population


-- Table 2: 
-- Continent number: total case (each continent), total death (each continent) -> % death
-- total population, % infection/population
-- total people vaccinated (at least 1 vacc) -> % vaccinated/population
WITH Continent (continent, [Population], [Total cases], [Total deaths], [People vaccinated], [Death rate (%)],
[Infected rate (%)], [Vaccinated rate (%)])
AS
(
SELECT dea.continent, SUM(CAST(dea.population AS float)) OVER (Partition by dea.continent) AS [Population],
MAX(CAST(dea.total_cases AS float)) AS [Total cases],MAX(CAST(dea.total_deaths AS float)) AS [Total deaths],
MAX(CAST(vac.people_vaccinated AS float)) AS [People vaccinated],
(MAX(CAST(dea.total_deaths AS float))/MAX(CAST(dea.total_cases AS float)))*100 AS [Death rate (%)],
(MAX(CAST(dea.total_cases AS float))/dea.population)*100 AS [Infected rate (%)],
(MAX(CAST(people_vaccinated AS float))/dea.population)*100 AS [Vaccinated rate (%)]
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.population
)

SELECT continent, AVG([Population]) AS [Population], SUM([Total cases]) AS [Total cases], 
SUM([Total deaths]) AS [Total deaths], SUM([People vaccinated]) AS [People vaccinated],
AVG([Death rate (%)]) AS [Death rate (%)], AVG([Infected rate (%)]) AS [Infected rate (%)],
AVG([Vaccinated rate (%)]) AS [Vaccinated rate (%)]
FROM Continent
GROUP BY continent

-- Table 3:
-- countries number: total case, total death -> % death/ case;
-- total population, % infection/population
-- total people vaccinated (at least 1 vacc) -> % vaccinated/population
SELECT dea.location, population, MAX(CAST(dea.total_cases AS float)) AS [Total cases], MAX(CAST(dea.total_deaths AS float)) AS [Total Deaths], 
MAX(CAST(vac.people_vaccinated AS float)) AS [People Vaccinated],
(MAX(CAST(dea.total_deaths AS float))/MAX(CAST(dea.total_cases AS float)))*100 AS [Death rate (%)],
(MAX(CAST(dea.total_cases AS float))/population)*100 AS [ Infected rate (%)],
(MAX(CAST(vac.people_vaccinated AS float))/dea.population)*100 AS [ Vaccinated rate (%)]
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE NOT dea.location = 'World' AND NOT dea.location LIKE '%income%'
GROUP BY dea.location, dea.population
ORDER BY 1

-- Table 4:
-- countries number by time.
SELECT dea.location, dea.date, dea.population, MAX(CAST(dea.total_cases AS float)) AS [Total cases], MAX(CAST(dea.total_deaths AS float)) AS [Total Deaths], 
MAX(CAST(vac.people_vaccinated AS float)) AS [People Vaccinated],
(MAX(CAST(dea.total_deaths AS float))/MAX(CAST(dea.total_cases AS float)))*100 AS [Death rate (%)],
(MAX(CAST(dea.total_cases AS float))/population)*100 AS [ Infected rate (%)],
(MAX(CAST(vac.people_vaccinated AS float))/dea.population)*100 AS [ Vaccinated rate (%)]
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE NOT dea.location = 'World' AND NOT dea.location LIKE '%income%'
GROUP BY dea.location, dea.date, dea.population
ORDER BY 1,2

--Table 5: as income level
SELECT dea.location, population, MAX(CAST(dea.total_cases AS float)) AS [Total cases], MAX(CAST(dea.total_deaths AS float)) AS [Total Deaths], 
MAX(CAST(vac.people_vaccinated AS float)) AS [People Vaccinated],
(MAX(CAST(dea.total_deaths AS float))/MAX(CAST(dea.total_cases AS float)))*100 AS [Death rate (%)],
(MAX(CAST(dea.total_cases AS float))/population)*100 AS [ Infected rate (%)],
(MAX(CAST(vac.people_vaccinated AS float))/dea.population)*100 AS [ Vaccinated rate (%)]
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.location LIKE '%income%'
GROUP BY dea.location, dea.population
ORDER BY 1