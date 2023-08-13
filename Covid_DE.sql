SELECT* from PortfolioProject.dbo.CovidDeaths
order by 3,4

--select* from PortfolioProject.dbo.CovidVaccination
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population from
PortfolioProject.dbo.CovidDeaths
order by 1,2

-- Total Cases vs total deaths

select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from
PortfolioProject.dbo.CovidDeaths
where Location = 'India'
order by 1,2

-- Total Cases vs Population



select Location, date, total_cases,  total_deaths, population,  (total_deaths/population) as cast(Death_Percentage as float) from
PortfolioProject.dbo.CovidDeaths
where Location = 'India'
order by 1,2

--Highest Infection count vs Country
Select location, max(total_cases)
as HighInfectionCount from PortfolioProject.dbo.CovidDeaths
group by location
order by HighInfectionCount

--Highest Death count vs Country
Select location, max(total_deaths)
as HighestDeathCount from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by location 
order by HighestDeathCount desc


-- Breaking content by continent (death count)

Select continent, max(total_deaths)
as HighestDeathCount from PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
group by continent
order by HighestDeathCount desc


-- Continents with highest cases count
Select continent, max(total_cases)
as HighInfectionCount from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by HighInfectionCount desc

--global numbers
select date, sum(new_cases) as sum_of_newcases, sum(new_deaths) as sum_of_newdeaths
--(total_cases/total_deaths) *100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases) as sum_of_newcases, sum(new_deaths) as sum_of_newdeaths
--(total_cases/total_deaths) *100 as DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 1,2




SELECT *
FROM PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date


	-- total population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location)
FROM PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	and dea.location = 'India'
	order by 1,2,3

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
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 




