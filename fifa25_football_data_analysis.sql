/* 
====================================================
 FIFA 25 Player Ratings Analysis Project - SQL Script
====================================================

 Overview:
This project explores FIFA 25 player ratings using Microsoft SQL Server. 
The dataset includes player name, position, team, league, age, nation, 
and overall rating (OVR). 

Key analysis goals:
- Clean raw data for accurate insights
- Identify top players overall and by position
- Explore team, league, and national trends
- Highlight rising young talent
- Uncover rating distribution across age and positions

Sections:
1. Data Cleaning
2. Rating Analysis
3. Group & Position Rankings
4. Team & League Analysis
5. Youth & Nation Analysis
6. Distribution Insights

*/

-- ================================================
-- 1. DATA CLEANING
-- ================================================

-- Dropping unnecessary column
-- ALTER TABLE fifa25_cleaned
-- DROP COLUMN Unnamed_0;

-- ================================================
-- 2. RATING ANALYSIS
-- ================================================

-- Top 10 Overall Rated Players
SELECT TOP 10 * 
FROM fifa25_cleaned
ORDER BY OVR DESC;

-- Average Rating by Position
SELECT Position, AVG(OVR) AS avg_rating
FROM fifa25_cleaned
GROUP BY Position
ORDER BY avg_rating DESC;

-- ================================================
-- 3. GROUP & POSITION RANKINGS
-- ================================================

-- Top Attackers (ST, LW, RW)
WITH RankedAttackers AS (
 SELECT TOP 200
	Position, Name, Team, OVR,
	ROW_NUMBER() OVER (ORDER BY OVR DESC) AS rank
 FROM fifa25_cleaned
 WHERE Position IN ('ST', 'LW', 'RW')
)
SELECT Rank, Position, Name, Team, OVR 
FROM RankedAttackers;

-- Top Midfielders (CM, CDM, CAM, LM, RM)
WITH RankedMidfielders AS (
 SELECT TOP 200
	Position, Name, Team, OVR,
	ROW_NUMBER() OVER (ORDER BY OVR DESC) AS rank
 FROM fifa25_cleaned
 WHERE Position IN ('CM', 'CDM', 'CAM', 'LM', 'RM')
)
SELECT Rank, Position, Name, Team, OVR 
FROM RankedMidfielders;

-- Top Defenders (CB, LB, RB)
WITH RankedDefenders AS (
 SELECT TOP 200
	Position, Name, Team, OVR,
	ROW_NUMBER() OVER (ORDER BY OVR DESC) AS rank
 FROM fifa25_cleaned
 WHERE Position IN ('CB', 'LB', 'RB')
)
SELECT Rank, Position, Name, Team, OVR 
FROM RankedDefenders;

-- Top Goalkeepers (GK)
WITH RankedGoalkeepers AS (
 SELECT TOP 200
	Position, Name, Team, OVR,
	ROW_NUMBER() OVER (ORDER BY OVR DESC) AS rank
 FROM fifa25_cleaned
 WHERE Position = 'GK'
)
SELECT Rank, Position, Name, Team, OVR 
FROM RankedGoalkeepers;

-- ================================================
-- 4. TEAM & LEAGUE ANALYSIS
-- ================================================

-- Average Rating by League
SELECT League, AVG(OVR) AS avg_league_rating
FROM fifa25_cleaned
GROUP BY League
ORDER BY avg_league_rating DESC;

-- Top Teams by Average Rating (with 10+ players)
SELECT Team, COUNT(*) AS player_count, AVG(OVR) AS avg_team_rating
FROM fifa25_cleaned
GROUP BY Team
HAVING COUNT(*) >= 10
ORDER BY avg_team_rating DESC;

-- ================================================
-- 5. YOUTH & NATION ANALYSIS
-- ================================================

-- Best Young Talents (Age <= 21)
SELECT Name, Age, OVR, Team, Position
FROM fifa25_cleaned
WHERE Age <= 21
ORDER BY OVR DESC;

-- Compare Nations by Avg Rating (20+ players)
SELECT Nation, COUNT(*) AS players, AVG(OVR) AS avg_rating
FROM fifa25_cleaned
GROUP BY Nation
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC;

-- Top 5 Players by Each Nation
SELECT *
FROM (
  SELECT Name, Nation, OVR,
         ROW_NUMBER() OVER (PARTITION BY Nation ORDER BY OVR DESC) AS rank
  FROM fifa25_cleaned
) AS ranked
WHERE rank <= 5
ORDER BY Nation, OVR DESC;

-- Best Value Players (Young + High Rating)
SELECT Name, Age, OVR, Team, Position
FROM fifa25_cleaned
WHERE Age <= 24 AND OVR >= 80
ORDER BY OVR DESC, Age;

-- ================================================
-- 6. DISTRIBUTION INSIGHTS
-- ================================================

-- Position Distribution
SELECT Position, COUNT(*) AS player_count
FROM fifa25_cleaned
GROUP BY Position
ORDER BY player_count DESC;

-- Age Distribution
SELECT Age, COUNT(*) AS num_players
FROM fifa25_cleaned
GROUP BY Age
ORDER BY Age;

