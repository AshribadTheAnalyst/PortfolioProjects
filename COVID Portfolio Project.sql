select * from CovidDeaths
order by 3,4;

--select * from CovidVaccinations
--order by 3,4;

select location,date, total_cases,new_cases, total_deaths, population
from CovidDeaths
where continent is not null
order by 1,2;

-- Total Cases Vs Total Deaths

select location, date, total_cases, total_deaths, (cast(total_deaths as float))/ (cast(total_cases as float))*100 as deathpercentage
from CovidDeaths
where location like '%india'
and continent is not null
order by 1,2;

-- Totalcases Vs Population

select location, date, total_cases, Population, (total_cases/population)*100 as totalpercentage
from CovidDeaths
where continent is not null
order by 1,2;

-- Countries with highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as TotalPercentage
from CovidDeaths
where continent is not null
group by population, location
order by TotalPercentage desc;

-- Countries with highest death countper population

select location, MAX(cast(total_deaths as int)) as TotalDeathcount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathcount desc;

-- Drilldown by Continent

-- Showing Continents with Highest Deathcount by Population

select continent, MAX(cast(total_deaths as int)) as TotalDeathcount
from CovidDeaths
where continent is not null 
group by continent
order by TotalDeathcount desc;

select location, continent from CovidDeaths
where location like '%world%';


-- Global Numbers

--select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float)*100) as DeathPercentage
--from CovidDeaths
--where continent is not null
--order by 1,2;

SET ANSI_WARNINGS OFF
GO

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,  sum(new_deaths)/nullif(SUM(new_cases),0)*100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by 1,2;


select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,  sum(new_deaths)/nullif(SUM(new_cases),0)*100 as DeathPercentage
from coviddeaths
where continent is not null
order by 1,2;

--Join 2 tables
-- Total Population Vs Vaccinations

select * 
from CovidDeaths dea
join covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;



select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea
join CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location, dea.date ) as People_Vaccinated
from CovidDeaths dea
join CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
order by 2,3

----Use CTE

with popvsvac(continent,location, date, population, new_vaccinations, People_Vaccinated)
as
(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location, dea.date) as People_Vaccinated
from CovidDeaths dea
join CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
--order by 2,3  
)
select *, (People_Vaccinated/population)*100 as new_vaccinated
from popvsvac;


--Temp Table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
People_Vaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location, dea.date) as People_Vaccinated
from CovidDeaths dea
join CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date


select *, (People_Vaccinated/population)*100 as new_vaccinated
from #PercentPopulationVaccinated;

--Create View to store data for later use  

create view PercentPopulationVaccinated as 
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over(partition by dea.location order by dea.location, dea.date) as People_Vaccinated
from CovidDeaths dea
join CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null


select * from PercentPopulationVaccinated;


 