
------------------------------------------------------------
---  distances --------------------------------------------


WITH haversine_distances_km AS (
  SELECT
    tripduration,
    -- Haversine formula calculation (using kilometers)
    (6170 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) AS distance_km
  FROM bike_trips_data
  WHERE tripduration < 7200
)
SELECT
  tripduration,
  distance_km AS distance
FROM haversine_distances_km
ORDER BY distance DESC;

------------AVG distance of trips ---------------------------
--- 1.75 km is the average of trips -------------------------

WITH haversine_distances_km AS (
  SELECT
    tripduration,
    -- Haversine formula calculation (using kilometers)
    (6170 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) AS distance_km
  FROM bike_trips_data
  WHERE tripduration < 7200
)
SELECT
  'Kilometers' AS unit,
  ROUND(AVG(distance_km)::NUMERIC, 3) AS average_trip_distance
FROM haversine_distances_km;

--