--Ctrl shift R

Select * 
from corona..CovidDeath
Where continent is not null
order by 3,4

Select * 
from corona..CovidVacina
order by 3,4

--seleção de dados para uso

Select Location, date, total_cases, new_cases, total_deaths, population
from corona..CovidDeath
order by 1,2

-- Seleção de Casos vs Mortes totais no Brasil

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from corona..CovidDeath
Where location like '%Brazil%'
order by 1,2


-- Caso total x População
Select Location, date, total_cases, population, (total_cases/population)*100 as populacao
from corona..CovidDeath
Where location like '%Brazil%'
order by 1,2


-- casos de maior casos em comparação de população
Select Location,population, MAX(total_cases)as Maiorcasos , Max((total_cases/population))*100 as percentualdeinfectados
from corona..CovidDeath
--Where location like '%Brazil%'
Group by Location, Population
order by percentualdeinfectados 

-- Continentes com maiores contagem de morte
Select location, MAX(cast(total_deaths as int)) as contagemdemorte
from corona..CovidDeath
--Where location like '%Brazil%'
Where continent is null
Group by Location, Population
order by contagemdemorte desc 



-- Paises com maior contagem de morte 
Select Location, MAX(cast(total_deaths as int)) as contagemdemorte
from corona..CovidDeath
--Where location like '%Brazil%'
Where continent is not null
Group by Location, Population
order by contagemdemorte desc 



--Numeros Globais

Select SUM(new_cases) as caso_total, SUM(cast(new_deaths as int)) as Morte_total,
SUM(cast(new_deaths as int))/Sum(New_Cases)*100 as Mortepercentual
-- date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from corona..CovidDeath
Where continent is not null
--Group By date
order by 1,2



With popvsVac (Continent, Locaition, Date, Population, New_Vaccinations, contagemdevacinado)
as
(

-- população total x vacinados

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location
, dea.date) as contagemdevacinado
--,(contagemdevacinado/population)*100
From corona..CovidDeath dea
join corona..CovidVacina vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
AND dea.new_vaccinations is not null
--order by 2,3
)
Select *, (contagemdevacinado/Population)*100
From popvsVac


--Table temporario

DROP Table if exists #PercentualVacinado
CREATE TABLE #PercentualVacinado (
    Continent nvarchar(255),
    Location nvarchar(255),
    Date date,
    Population bigint,
    New_Vaccinations bigint,
    ContagemDeVacinado bigint
);

Insert into #PercentualVacinado 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location
, dea.date) as contagemdevacinado
--,(contagemdevacinado/population)*100
From corona..CovidDeath dea
join corona..CovidVacina vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
AND dea.new_vaccinations is not null
--order by 2,3

Select *, (contagemdevacinado/Population)*100
From #percentualvacinado


Create View percentualvacinado as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location Order by dea.location
, dea.date) as contagemdevacinado
--,(contagemdevacinado/population)*100
From corona..CovidDeath dea
join corona..CovidVacina vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * 
from percentualvacinado