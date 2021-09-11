/*
NBA Data Exploration

Skills used: Joins, CTEs, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

https://www.kaggle.com/justinas/nba-players-data
https://www.basketball-reference.com/players/j/jamesle01.html

*/

--Check tables
SELECT *
FROM PortfolioProjectNBA..[nbastats96-21]
ORDER BY 2

SELECT *
FROM PortfolioProjectNBA..lebronshootingstats
ORDER BY 1,2

--Generate table of major career statistics for LeBron James
SELECT season, team_abbreviation AS team, age, gp, pts, reb, ast
FROM PortfolioProjectNBA..[nbastats96-21]
Where player_name = 'LeBron James'
ORDER BY 1

--Calculate BMI for LeBron James in the 2005-06 season
SELECT season, player_name AS name, team_abbreviation AS team, age, player_height AS height, player_weight AS weight,
	(player_weight)/SQUARE(player_height/100) AS BMI
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE player_name = 'LeBron James'
AND season = '2005-06'

--Calculate total games played, career average points, rebounds and assists for players whose names contain "james"
SELECT player_name AS Name, SUM(gp) AS G, ROUND(SUM(gp*pts)/SUM(gp),1) AS PTS, ROUND(SUM(gp*reb)/sum(gp),1) AS REB, 
	ROUND(SUM(gp*ast)/sum(gp),1) AS AST
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE player_name LIKE '%james%'
GROUP BY player_name
ORDER BY 3 DESC

--Count total number of undrafted players that played at least a game in the NBA
SELECT COUNT(DISTINCT player_name) AS 'No. of Undrafted Players'
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE draft_number IS NULL

--List of colleges ordered by number of NBA players produced
SELECT college, COUNT(DISTINCT player_name) AS 'No. of NBA Players Produced'
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE college <> 'None'
GROUP BY college
ORDER BY 2 DESC

--Percentage of foreign players (Non-USA) in the NBA each year
SELECT season,
	COUNT(DISTINCT CASE WHEN country <> 'USA' THEN player_name END) * 1.0/ COUNT(DISTINCT player_name)*100 AS Foreign_Ratio
FROM PortfolioProjectNBA..[nbastats96-21]
GROUP BY season

--Country Representation
SELECT country, COUNT(DISTINCT(player_name)) AS Players
FROM PortfolioProjectNBA..[nbastats96-21]
GROUP BY country
ORDER BY 'Players' DESC

--Determine the top 20 highest scoring seasons between 1996 and 2021
SELECT TOP 20 player_name AS Name, season AS Season, MAX(pts) AS 'Season Average'
FROM PortfolioProjectNBA..[nbastats96-21]
GROUP BY player_name, season
ORDER BY 3 DESC

--Height, Weight Trends
SELECT season, AVG(player_height), AVG(player_weight)
FROM PortfolioProjectNBA..[nbastats96-21]
GROUP BY season
ORDER BY 1

--Calculate advanced metrics (eFG%, FTR, TS%) for LeBron James by joining shooting statistics
SELECT a.player_name, a.season, a.age, b.Tm, b.Pos, b.G, b.GS, b.MP, a.pts AS PTS, a.reb AS REB, a.ast AS AST, b.[FG%], b.[3P%], 
	ROUND((b.FG + b.[3P] * 0.5) / b.FGA, 3) AS 'eFG%', 
	b.[FT%],
	ROUND(b.[FTA] / b.[FGA], 3) AS 'FTR',
	ROUND(a.pts/(2*(b.[FGA]+b.[FTA]*0.44)), 3) AS 'TS%'
FROM PortfolioProjectNBA..[nbastats96-21] a
JOIN PortfolioProjectNBA..[lebronshootingstats] b
	ON a.season = b.Season
	WHERE a.player_name = 'LeBron James'

--Using CTE to Rank top 3 scorers each season 1996-2021
WITH top3sps AS
(
SELECT player_name AS Name, season AS Season, pts AS PTS, 
	ROW_NUMBER() OVER(PARTITION BY season ORDER BY CAST(pts AS NUMERIC) DESC) AS Rank,
	gp AS 'Games Played'
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE CAST(gp AS NUMERIC)>=(CASE WHEN season='1998-99' THEN 40 ELSE 70 END)
)
SELECT *
FROM top3sps
WHERE RANK<4

--Using Temp Table to perform calculation on Partition By in previous query
DROP TABLE if exists #top3scorers
CREATE TABLE #top3scorers
(
Name nvarchar(255),
Season nvarchar(255),
PTS numeric,
[Rank] numeric,
gp numeric
)
INSERT INTO #top3scorers
SELECT player_name AS Name, season AS Season, pts AS PTS, 
	ROW_NUMBER() OVER(PARTITION BY season ORDER BY CAST(pts AS NUMERIC) DESC) AS [Rank],
	gp AS 'Games Played'
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE CAST(gp AS NUMERIC)>=(CASE WHEN season='1998-99' THEN 40 ELSE 70 END)
SELECT *
FROM #top3scorers
WHERE RANK <6

--Creating view to store data for later visualizations
CREATE VIEW CollegeNBATurnover as
SELECT college, COUNT(DISTINCT player_name) AS 'No. of NBA Players Produced'
FROM PortfolioProjectNBA..[nbastats96-21]
WHERE college <> 'None'
GROUP BY college
--ORDER BY 2 DESC

Select * 
FROM CollegeNBATurnover
ORDER BY 2 DESC

