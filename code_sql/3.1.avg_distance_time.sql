-- Active: 1764408051040@@127.0.0.1@5432@nyc_citybike

---------------------------------
-------- avg_distances ----------
WITH distances_havershine AS (
  SELECT
    tripduration,
    (6170 * ACOS(GREATEST(-1, LEAST(1, COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) * COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) + SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180))))) AS distance_km
  FROM bike_trips_data
  WHERE tripduration < 7200
)
SELECT ROUND(AVG(distance_km)::NUMERIC, 3) AS average_trip_km
FROM distances_havershine;


-------------------------
--- avg trip duration ---

SELECT ROUND((AVG(tripduration)/60), 0) 
AS avg_duration_in_minutes
FROM bike_trips_data
;


