/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

/* Select all columns from the CovidDeaths table where continent is not null,
   and order the results by the third and fourth columns. */
Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

/* Select basic details like location, date, total cases, new cases, total deaths, and population
   from the CovidDeaths table where continent is not null, and order the results by location and date. */
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

/* Calculate the death percentage for each location on each date by dividing total deaths by total cases,
   then multiplying by 100. Filter for locations containing 'states' and where continent is not null.
   Order the results by location and date. */
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

/* Calculate the percentage of the population infected with Covid for each location on each date
   by dividing total cases by population, then multiplying by 100. Order the results by location and date. */
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

/* Find the maximum total cases and calculate the percentage of the population infected with Covid
   for each location by grouping the data by location and population, then ordering the results
   by the percentage of the population infected in descending order. */
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

/* Calculate the total death count for each location by casting the total deaths to integer,
   grouping by location, and ordering the results by the total death count in descending order. */
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

/* Calculate the total death count for each continent by casting the total deaths to integer,
   grouping by continent, and ordering the results by the total death count in descending order. */
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

/* Calculate the global total cases, total deaths, and death percentage by summing new cases and new deaths,
   then dividing the total deaths by total cases and multiplying by 100. Filter the data where continent is not null. */
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine

/* Join the CovidDeaths and CovidVaccinations tables on location and date,
   then calculate the rolling total of new vaccinations for each location.
   Order the results by location and date. */
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

/* Use a CTE to calculate the rolling total of new vaccinations for each location,
   then select all columns and calculate the percentage of the population vaccinated. */
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
    Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
    From PortfolioProject..CovidDeaths dea
    Join PortfolioProject..CovidVaccinations vac
        On dea.location = vac.location
        and dea.date = vac.date
    where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

/* Drop the temporary table if it exists, then create a new temp table to store the calculated data.
   Insert data into the temp table by joining the CovidDeaths and CovidVaccinations tables,
   and calculate the rolling total of new vaccinations for each location. */
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

/* Select all columns from the temp table and calculate the percentage of the population vaccinated. */
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

/* Create a view to store the calculated data for later visualizations.
   The view joins the CovidDeaths and CovidVaccinations tables and calculates the rolling total of new vaccinations for each location. */
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null 
