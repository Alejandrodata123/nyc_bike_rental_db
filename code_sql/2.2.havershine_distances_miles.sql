-------------------------------------------------------------------------
---all ride distances in miles calculated with the havershine formula ---

WITH haversine_distances_miles AS (
  SELECT
    tripduration,
    -- Haversine formula calculation (using miles)
    (3950 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) AS distance_miles
  FROM bike_trips_data
  WHERE tripduration < 7200
)
SELECT
  tripduration,
  distance_miles AS distance
FROM haversine_distances_miles
ORDER BY distance DESC;

------------------------------------------------
--- average distance of trips in miles --------


WITH haversine_distances_miles AS (
  SELECT
    tripduration,
    -- Haversine formula calculation (using miles)
    (3950 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) AS distance_miles
  FROM bike_trips_data
  WHERE tripduration < 7200
)
SELECT
  'Miles' AS unit,
  ROUND(AVG(distance_miles)::NUMERIC, 3) AS average_trip_distance
FROM haversine_distances_miles;
