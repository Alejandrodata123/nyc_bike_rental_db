-- Enhanced Business Insights for NYC CityBike Database
-- This file contains SQL queries to answer key business questions

-- 1. Peak Usage Times: Identify peak hours for bike usage
-- This helps with staffing and maintenance scheduling
SELECT
    EXTRACT(HOUR FROM starttime)  || ':00'  AS hour,
    COUNT(*) AS trip_count
FROM
    trips_time_etc
GROUP BY
    EXTRACT(HOUR FROM starttime)
ORDER BY
    trip_count DESC
LIMIT 10;

-- 2. Daily Usage Patterns: Compare weekday vs weekend usage
SELECT
    CASE
        WHEN EXTRACT(DOW FROM starttime) BETWEEN 1 AND 5 THEN 'WeekDAY'
        ELSE 'WeekEND'
    END AS day_type,
    COUNT(*) AS trip_count
FROM
    trips_time_etc
GROUP BY
    day_type
ORDER BY
    trip_count DESC;

-- 3. User Demographics: Breakdown of users by type and gender
SELECT
    usertype,
    gender,
    COUNT(*) AS user_count
FROM
    trips_time_etc
WHERE
    gender IS NOT NULL
GROUP BY
    usertype, gender
ORDER BY
    user_count DESC;

-- 4. Age Distribution: Average age of subscribers vs customers
WITH age_data AS (
    SELECT
        usertype,
        2023 - birthyear AS age
    FROM
        trips_time_etc
    WHERE
        birthyear IS NOT NULL AND birthyear > 1900
)
SELECT
    usertype,
    ROUND(AVG(age), 0) AS average_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age
FROM
    age_data
GROUP BY
    usertype;

-- 5. Trip Duration Analysis: Average trip duration by user type
SELECT
    usertype,
    ROUND((AVG(tripduration)/ 60), 1) AS avg_duration_minutes,
    ROUND((MIN(tripduration)/ 60), 1) AS min_duration_minutes,
    rOUND((MAX(tripduration)/ 60),1 ) AS max_duration_minutes
FROM
    trips_time_etc

     WHERE tripduration <  7200 /* 2 hours having filter 
     in order to evade outliners thet are not clean data */

GROUP BY
    usertype



-- 6. Station Capacity vs Usage: Stations that frequently exceed capacity
WITH station_usage AS (
    SELECT
        start_station_name,
        COUNT(*) AS start_trip_count
    FROM
        bike_trips_data
    GROUP BY
        start_station_name
)
SELECT
    su.start_station_name,
    su.start_trip_count,
    s.capacity,
    su.start_trip_count * 1.0 / s.capacity AS usage_ratio
FROM
    station_usage su
JOIN
    station_data s ON su.start_station_name = s.name
WHERE
    su.start_trip_count > s.capacity * 0.8
ORDER BY
    usage_ratio DESC;


-- 7. Long-term Usage Trends: Monthly growth in bike usage
SELECT
    EXTRACT(YEAR FROM starttime) AS year,
    EXTRACT(MONTH FROM starttime) AS month,
    COUNT(*) AS trip_count
FROM
    trips_time_etc
GROUP BY
    year, month
ORDER BY
    year, month;
    



-- 8. Popular Routes by Distance: Longest and shortest popular routes
WITH route_distances AS (
    SELECT
        start_station_name,
        end_station_name,
        COUNT(*) AS route_count,
        SQRT(
            POWER(start_station_latitude - end_station_latitude, 2) +
            POWER(start_station_longitude - end_station_longitude, 2)
        ) AS distance
    FROM
        bike_trips_data
    WHERE
        NOT (start_station_name = 'Franklin St & W Broadway' AND end_station_name = 'NYCBS Depot')
    GROUP BY
        start_station_name, end_station_name, start_station_latitude, start_station_longitude, end_station_latitude, end_station_longitude
)
-- Longest popular routes
SELECT
    start_station_name,
    end_station_name,
    route_count,
    distance
FROM
    route_distances
ORDER BY
    distance DESC, route_count DESC
LIMIT 10;

-- 9. Bike Utilization: Most frequently used bikes
SELECT
    bikeid,
    COUNT(*) AS trip_count
FROM
    bike_trips_data
GROUP BY
    bikeid
ORDER BY
    trip_count DESC
LIMIT 10;

-- 10. Seasonal Usage Patterns: Compare usage across different seasons SUMMER FALL SPRING WINTER
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM starttime) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM starttime) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM starttime) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END AS season,
    COUNT(*) AS trip_count
FROM
    trips_time_etc
GROUP BY
    season
ORDER BY
    trip_count DESC;


-- 11. Station Connectivity: Most connected stations (highest number of unique routes)
WITH station_connections AS (
    SELECT
        start_station_name,
        COUNT(DISTINCT end_station_name) AS unique_destinations
    FROM
        bike_trips_data
    GROUP BY
        start_station_name
)
SELECT
    start_station_name,
    unique_destinations
FROM
    station_connections
ORDER BY
    unique_destinations DESC
LIMIT 10;


-- 12. Station Popularity by User Type: Which stations are popular among different user types
WITH station_user_types AS (
    SELECT
        startstationname,
        usertype,
        COUNT(*) AS trip_count
    FROM
        trips_time_etc
    GROUP BY
        startstationname, usertype
)
SELECT
    startstationname,
    usertype,
    trip_count
FROM
    station_user_types
ORDER BY
    trip_count DESC
LIMIT 20;


-- 13 Monthly Station Usage Ratio: Calculate usage ratio for a specific month
-- This query calculates the average trips per month for each station
-- and compares it to the station's capacity to determine usage ratio
WITH monthly_station_usage AS (
    SELECT
        startstationname,
        EXTRACT(YEAR FROM starttime) AS year,
        EXTRACT(MONTH FROM starttime) AS month,
        COUNT(*) AS trip_count
    FROM
        trips_time_etc
    GROUP BY
        startstationname, year, month
)
SELECT
    msu.startstationname,
    msu.year,
    msu.month,
    msu.trip_count,
    s.capacity,
    ROUND((msu.trip_count * 100.0 / s.capacity), 1) || '%' AS usage_ratio
FROM
    monthly_station_usage msu
JOIN
    station_data s ON msu.startstationname = s.name
ORDER BY
    msu.year, msu.month, usage_ratio DESC;



-- 14 Operational Efficiency: Average trips per bike
SELECT
    COUNT(*) AS total_trips,
    COUNT(DISTINCT bikeid) AS unique_bikes,
    ROUND(COUNT(*) * 1.0 / NULLIF(COUNT(DISTINCT bikeid), 0), 1 )     AS avg_trips_per_bike
FROM
    bike_trips_data;

-- 15 Station Balance: Stations with most imbalanced traffic (start vs end trips)
WITH station_balance AS (
    SELECT
        start_station_name,
        COUNT(*) AS start_trips
    FROM
        bike_trips_data
    GROUP BY
        start_station_name
)
SELECT
    s.name AS station_name,
    s.capacity,
    COALESCE(sb.start_trips, 0) AS start_trips,
    COALESCE(eb.start_trips, 0) AS end_trips,
    ABS(COALESCE(sb.start_trips, 0) - COALESCE(eb.start_trips, 0)) AS imbalance
FROM
    station_data s
LEFT JOIN
    station_balance sb ON s.name = sb.start_station_name
LEFT JOIN
    station_balance eb ON s.name = eb.start_station_name
ORDER BY
    imbalance DESC
LIMIT 10;



-- 16 Peak Hour Stations: Stations with highest usage during peak hours
WITH peak_hours AS (
    SELECT
        startstationname,
        EXTRACT(HOUR FROM starttime) AS hour,
        COUNT(*) AS trip_count
    FROM
        trips_time_etc
    WHERE
        EXTRACT(HOUR FROM starttime) IN (8, 9, 17, 18, 19) -- Morning and evening peak hours
    GROUP BY
        startstationname, hour
)
SELECT
    startstationname,
    SUM(trip_count) AS total_peak_trips
FROM
    peak_hours
GROUP BY
    startstationname
ORDER BY
    total_peak_trips DESC
LIMIT 10;




-- 17 Distance Analysis: Average trip distance by station
WITH station_distances AS (
    SELECT
        start_station_name,
        AVG(SQRT(
            POWER(start_station_latitude - end_station_latitude, 2) +
            POWER(start_station_longitude - end_station_longitude, 2)
        )) AS avg_distance
    FROM
        bike_trips_data
    GROUP BY
        start_station_name
)
SELECT
    start_station_name,
    avg_distance
FROM
    station_distances
ORDER BY
    avg_distance DESC
LIMIT 10;


-- 18 Heatmap Data: Station usage density for visualization
-- This query can be used to create a heatmap of station usage
SELECT
    start_station_name,
    start_station_latitude,
    start_station_longitude,
    COUNT(*) AS trip_count
FROM
    bike_trips_data
GROUP BY
    start_station_name, start_station_latitude, start_station_longitude
ORDER BY
    trip_count DESC;
