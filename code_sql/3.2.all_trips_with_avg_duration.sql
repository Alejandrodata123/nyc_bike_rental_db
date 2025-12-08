
--------------------------------------------------------------
------------------ all trip routes - 81 k results ------------

SELECT
    start_station_name || ' TO ' || end_station_name AS route,
    COUNT(*) as num_trips,
    -- Format duration as MM:SS
    LPAD(FLOOR(AVG(tripduration) / 60)::text, 2, '0') || ':' ||
    LPAD(FLOOR(AVG(tripduration) % 60)::text, 2, '0') AS avg_duration
FROM bike_trips_data
GROUP BY start_station_name, end_station_name
ORDER BY num_trips DESC;

---------------------------------------------------------------
