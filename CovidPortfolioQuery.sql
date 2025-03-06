Select *
	From PortfolioProject..CovidDeaths
	order by 3, 4

-- Select data to work on
Select Location, date, total_cases, new_cases, total_deaths, population
	From PortfolioProject..CovidDeaths
	order by 1,2



--Looking at Total Cases vs Total Deaths
-- Shows chances of dying if you contract covid in the United States of America.

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
	From PortfolioProject..CovidDeaths
	Where location = 'United States'
	order by 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of US population got Covid.

Select Location, date, total_cases, Population, (total_cases/Population)*100 as PositivePercentage
	From PortfolioProject..CovidDeaths
	Where location = 'United States' 

	order by 1,2

-- Looking at Countries with Highest Infection Rate compared to population

Select Location, MAX(total_cases)as HighestInfectionCount, Population, MAX((total_cases/Population))*100 as PositivePercentage
	From PortfolioProject..CovidDeaths
	
	Group by Location, Population

	order by PositivePercentage desc

--Showing countries with the Highest Death Count in Countries
Select Location, MAX(cast(total_deaths as int)) as HighestDeathCount
	From PortfolioProject..CovidDeaths
	Where continent is not null
	Group by Location
	order by HighestDeathCount desc

	
--Showing continets with the highest death count

Select Location, MAX(cast(total_deaths as int)) as HighestDeathCount
	From PortfolioProject..CovidDeaths
	Where continent is  null
	Group by Location
	order by HighestDeathCount desc


--Shows chances of dying after getting covid

Select Location, MAX(cast(total_deaths as int)) as HighestDeathCount, Population, MAX((total_deaths/Population))*100 as DeathRate
	From PortfolioProject..CovidDeaths

	Group by Location, Population
	order by DeathRate desc



--GLOBAL NUMBERS

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int))as total_death,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
	From PortfolioProject..CovidDeaths
	Where continent is not null

	group by date
	
	order by 1,2

-- Looking at Total Population vs Vaccinations(CTE)

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *, (RollingPeopleVaccinated/Population)*100 as PeopleVaccinatedPercentage
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


