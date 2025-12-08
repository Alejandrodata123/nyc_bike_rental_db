-- Business Insights for NYC CityBike Database




-- 1. Popular Routes: Most frequently used routes between stations
-- This query identifies the top 10 most popular routes between stations
-- so we can see if the capacity suply is enough

--

WITH cte AS (
    SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS route_count
FROM
    bike_trips_data
GROUP BY
    start_station_name, end_station_name
ORDER BY
    route_count DESC
)
SELECT start_station_name,
    end_station_name,
     route_count,
     s.capacity AS capacity_of_the_start_st
FROM cte
INNER JOIN station_data AS s 
ON cte.start_station_name = s.name
ORDER BY route_count DESC, capacity_of_the_start_st DESC

;


-- having this results we can adjust the 










-- 2. Station Usage Analysis: Which stations are most popular
-- This query shows the top 10 stations by number of trips starting from them
SELECT
    start_station_name,
    COUNT(*) AS start_trip_count
FROM
    bike_trips_data
GROUP BY
    start_station_name
ORDER BY
    start_trip_count DESC
LIMIT 10;



