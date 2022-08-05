/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Company]
      ,[Location]
      ,[Date]
      ,[Time]
      ,[Rocket]
      ,[Mission]
      ,[RocketStatus]
      ,[Price]
      ,[MissionStatus]
  FROM [ExploratoryData].[dbo].[space_missions]

  -- Count row for space_missions table
  SELECT COUNT(*) FROM space_missions;

  -- Select distint Company from space_missions
  SELECT COUNT(DISTINCT Company) FROM space_missions;

  -- Select distinct MissionStatus 
  SELECT DISTINCT MissionStatus FROM dbo.space_missions;

  -- Group MissionStatus
  SELECT MissionStatus, COUNT(*) AS MissionStatus
  FROM dbo.space_missions
  GROUP BY MissionStatus
  ORDER BY COUNT(*) DESC;

  -- Count each MissionStatus by company
  SELECT
    [Company],
	COUNT(CASE WHEN MissionStatus = 'Success' THEN MissionStatus ELSE NULL END) AS Success,
	COUNT(CASE WHEN MissionStatus = 'Partial Failure' THEN MissionStatus ELSE NULL END) AS Partial_Failure,
	COUNT(CASE WHEN MissionStatus = 'Prelaunch Failure' THEN MissionStatus ELSE NULL END) AS Prelaunch_Failure,
	COUNT(CASE WHEN MissionStatus = 'Failure' THEN MissionStatus ELSE NULL END) AS Failure
  FROM dbo.space_missions
  GROUP BY Company
  ORDER BY 2 DESC,3 DESC,4 DESC,5 DESC;

  -- Select Top 10 Company with highest Success Mission
  SELECT TOP 10
	Company,
	COUNT(MissionStatus) AS Mission_Success
  FROM dbo.space_missions
  WHERE MissionStatus = 'Success'
  GROUP BY Company
  ORDER BY Mission_Success DESC;

  -- Count Rocket by Status
  SELECT
	RocketStatus,
	COUNT(RocketStatus) AS Rocket_by_Status
  FROM dbo.space_missions
  GROUP BY RocketStatus
  ORDER BY Rocket_by_Status DESC;

-- Select DISTINCT TOP 10 Rocket by Rocket Name
WITH CTE AS(
 SELECT
	DISTINCT Company,
	Rocket,
	price
 FROM dbo.space_missions)

 SELECT 
	TOP 10 
	Company,
	Rocket,
	price
 FROM CTE
 ORDER BY price DESC;

 -- Count Missions Status by Year
 SELECT
	YEAR(date) AS mission_year,
	COUNT(CASE WHEN MissionStatus = 'Success' THEN MissionStatus ELSE NULL END) AS Success,
	COUNT(CASE WHEN MissionStatus = 'Partial Failure' THEN MissionStatus ELSE NULL END) AS Partial_Failure,
	COUNT(CASE WHEN MissionStatus = 'Prelaunch Failure' THEN MissionStatus ELSE NULL END) AS Prelaunch_Failure,
	COUNT(CASE WHEN MissionStatus = 'Failure' THEN MissionStatus ELSE NULL END) AS Failure
 FROM dbo.space_missions
 GROUP BY YEAR(date)
 ORDER BY YEAR(date) ASC;
 
 -- Group MissionStatus by year
 SELECT
	YEAR(date) AS mission_year,
	COUNT(MissionStatus) AS MissionStatus
 FROM dbo.space_missions
 WHERE MissionStatus = 'Success'
 GROUP BY YEAR(date)
 ORDER BY YEAR(date) ASC;

 SELECT 
	location, TRIM(value), TRIM(value)
 FROM dbo.space_missions
 CROSS APPLY STRING_SPLIT(location,',');

 -- Create CTE Split Delimited Location into Columns 
 WITH location_split AS(
 SELECT
	DISTINCT Location,
    JSON_VALUE(x.obj, '$[0]') name1,
    JSON_VALUE(x.obj, '$[1]') name2,
    COALESCE(JSON_VALUE(x.obj, '$[2]'),JSON_VALUE(x.obj, '$[1]')) name3,
    json_value(x.obj, '$[3]') name4
FROM dbo.space_missions t
CROSS APPLY(VALUES('["' + REPLACE(Location, ',', '", "') + '"]')) x(obj)
)

SELECT space_missions.*, 
	location_split.name3 AS country 
FROM dbo.space_missions
	LEFT JOIN location_split 
		ON dbo.space_missions.Location = location_split.Location;




  




