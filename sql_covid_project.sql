--Skills used below: Select, From, Where, Order by, Group by, Join, Windows Functions, MAX, SUM, Cast, Convert, Views

--Data Exploration from the 2 tables

select *
from PortfolioProject..CovidDeaths
order by 3,4;

select *
from PortfolioProject..CovidVaccinations
order by 3,4;

--Select first data to use from CovidDeaths table

select continent,
       location,
	   date,
	   convert(numeric, total_cases) as total_cases,
	   convert(numeric, new_cases) as new_cases, 
	   convert(numeric, total_deaths) as total_deaths, 
	   convert(numeric, population) as population
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
order by 2,3;

--Global numbers in LAC
--Query shows sum of total cases, deaths and death percentage in all LAC region

select SUM(convert(numeric, new_cases)) as total_cases,
       SUM(convert(numeric, new_deaths)) as total_deaths,
	   SUM(convert(numeric, new_deaths))/SUM(convert(numeric, new_cases))*100 as DeathPercentageinLAC
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
order by 1,2;


--Total Cases vs Total Deaths
--Query indicates throughout time, the % of death for cases of positive Covid-19 in LAC countries

select continent,
	   location,
	   date,
	   convert(numeric, total_cases) as total_cases,
	   convert(numeric, total_deaths) as total_deaths,
	   (convert(numeric, total_deaths)/(convert(numeric, total_cases)))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
order by 2,3;

--Total Cases vs Population
--Query shows % of population got Covid-19 in LAC countries

select continent,
	   location,
	   date,
	   convert(numeric, population) as population,
	   convert(numeric, total_cases) as total_cases,
	   (convert(numeric, total_cases)/(convert(numeric, population)))*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
order by 2,3;

--Countries with highest infection rate compared to population

select location,
	   convert(numeric, population) as population,
	   MAX(convert(numeric, total_cases)) as HighestInfectionCount,
	   MAX((convert(numeric, total_cases)/(convert(numeric, population))))*100 as MaxPercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
group by location, population
order by MaxPercentagePopulationInfected desc;

--Countries with highest death count compared to population

select location,
	   max(cast(total_deaths as numeric)) as total_deaths_count
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
group by location
order by total_deaths_count desc;

--SUM of total cases, total deaths and death % in LAC countries

select location,
	   sum(cast(new_cases as numeric)) as total_cases,
	   sum(cast(new_deaths as numeric)) as total_deaths,
	   sum(cast(new_deaths as numeric))/sum(cast(new_cases as numeric))*100 as deathpercentage
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
group by location
order by 2,3;

--SUM of people with 1 shot, sum of people fully vaccinated and sum of total vaccines in LAC region

select location,
	   date,
	   sum(cast(people_vaccinated as numeric)) as people_with_one_shot,
	   sum(cast(people_fully_vaccinated as numeric)) as people_fully_vaccinated,
	   sum(cast(total_vaccinations as numeric)) as total_vaccinations
	   from PortfolioProject..CovidVaccinations
where continent = 'South America'
and continent is not null
group by location,date
order by 1,2;

--Joining the two tables from project

select *
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
order by 3,4;

--Total populations vs vaccinations per day in LAC region

select cd.location, 
	   cd.date,
	   cast(cd.population as numeric) as population, 
	   cast(cv.new_vaccinations as numeric) as new_vaccinations_per_day,
	   sum(cast(cv.new_vaccinations as numeric)) over (partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent = 'South America'
and cd.continent is not null
order by 1,2;

--Creating views

Create View OverallInformationCovid as
select continent,
       location,
	   date,
	   convert(numeric, total_cases) as total_cases,
	   convert(numeric, new_cases) as new_cases, 
	   convert(numeric, total_deaths) as total_deaths, 
	   convert(numeric, population) as population
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
--order by 2,3;

Create View DeathPercentageinLAC as
select SUM(convert(numeric, new_cases)) as total_cases,
       SUM(convert(numeric, new_deaths)) as total_deaths,
	   SUM(convert(numeric, new_deaths))/SUM(convert(numeric, new_cases))*100 as DeathPercentageinLAC
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
--order by 1,2;

Create View DeathPercentageThroughTime as
select continent,
	   location,
	   date,
	   convert(numeric, total_cases) as total_cases,
	   convert(numeric, total_deaths) as total_deaths,
	   (convert(numeric, total_deaths)/(convert(numeric, total_cases)))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
--order by 2,3;

Create View PercentagePopulationInfected as 
select continent,
	   location,
	   date,
	   convert(numeric, population) as population,
	   convert(numeric, total_cases) as total_cases,
	   (convert(numeric, total_cases)/(convert(numeric, population)))*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
--order by 2,3;

Create View MaxPercentagePopulationInfected as
select location,
	   convert(numeric, population) as population,
	   MAX(convert(numeric, total_cases)) as HighestInfectionCount,
	   MAX((convert(numeric, total_cases)/(convert(numeric, population))))*100 as MaxPercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
group by location, population
--order by MaxPercentagePopulationInfected desc;

Create View TotalDeathCount as
select location,
	   max(cast(total_deaths as numeric)) as total_deaths_count
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
group by location
--order by total_deaths_count desc;

Create View Total_Cases_Deaths_Percentage as
select location,
	   sum(cast(new_cases as numeric)) as total_cases,
	   sum(cast(new_deaths as numeric)) as total_deaths,
	   sum(cast(new_deaths as numeric))/sum(cast(new_cases as numeric))*100 as deathpercentage
from PortfolioProject..CovidDeaths
where continent = 'South America'
and continent is not null
group by location
--order by 2,3;

Create View TotalPopulationvsVaccination as
select cd.location, 
	   cd.date,
	   cast(cd.population as numeric) as population, 
	   cast(cv.new_vaccinations as numeric) as new_vaccinations_per_day,
	   sum(cast(cv.new_vaccinations as numeric)) over (partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent = 'South America'
and cd.continent is not null
--order by 1,2;