SELECT 
    name AS nearest_station,
    latitude,
    longitude,s
    -- Distance in kilometers (rounded to 2 decimals)
   
       6371 * ACOS(
            COS(RADIANS(40.9128)) * 
            COS(RADIANS(latitude)) * 
            COS(RADIANS(longitude) - RADIANS(-74.0060)) + 
            SIN(RADIANS(40.7128)) * 
            SIN(RADIANS(latitude))
        )
     AS distance_km
FROM station_data
ORDER BY distance_km ASC
LIMIT 1;


----------------------------------------------------------


-- STATION WWITHIN A RADIO OF 500 m OR LESS 
WITH station_distances AS (
    SELECT 
        s.*,
        (6371 * ACOS(
            COS(RADIANS(40.7128)) * 
            COS(RADIANS(s.latitude)) * 
            COS(RADIANS(s.longitude) - RADIANS(-74.0060)) + 
            SIN(RADIANS(40.7128)) * 
            SIN(RADIANS(s.latitude))
        )) AS distance_km
    FROM station_data s
)
SELECT 
    name,
    latitude,
    longitude,
    ROUND(distance_km::numeric, 3) AS distance_km
FROM station_distances
WHERE distance_km <= 0.5  -- Within 500 m
ORDER BY distance_km ASC;