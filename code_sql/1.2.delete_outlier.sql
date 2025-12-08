-- Script to delete the outlier row with distance 8393.311565177677 km and duration 147 seconds

-- First, let's identify the row
SELECT *
FROM bike_trips_data
WHERE tripduration = 147
  AND (
    -- Calculate Haversine distance and check if it matches the outlier value
    (6170 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) = 8393.311565177677
  )
LIMIT 1;

-- After verifying the row, delete it
DELETE FROM bike_trips_data
WHERE tripduration = 147
  AND (
    -- Calculate Haversine distance and check if it matches the outlier value
    (6170 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) = 8393.311565177677
  )
;

-- Verify the deletion
SELECT COUNT(*)
FROM bike_trips_data
WHERE tripduration = 147
  AND (
    -- Calculate Haversine distance and check if it matches the outlier value
    (6170 * ACOS(GREATEST(-1, LEAST(1,
      COS(start_station_latitude * ACOS(-1) / 180) * COS(end_station_latitude * ACOS(-1) / 180) *
      COS((end_station_longitude - start_station_longitude) * ACOS(-1) / 180) +
      SIN(start_station_latitude * ACOS(-1) / 180) * SIN(end_station_latitude * ACOS(-1) / 180)
    )))) = 8393.311565177677
  );
