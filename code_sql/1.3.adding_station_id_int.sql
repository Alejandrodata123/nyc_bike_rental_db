--


ALTER TABLE station_data 
ADD COLUMN station_id_integer_num INTEGER;



-- NEW ID INTEGER COLUMN: Using row_number() with a CTE (safer for large tables)
WITH numbered_rows AS (
    SELECT ctid, 
           ROW_NUMBER() OVER (ORDER BY ctid) as row_num
    FROM station_data
)
UPDATE station_data sd
SET station_id_integer_num = nr.row_num
FROM numbered_rows nr
WHERE sd.ctid = nr.ctid;


--  VERIFICATION -- Check the range of values

SELECT * FROM station_data
ORDER BY station_id_integer_num

SELECT MIN(station_id_integer_num), 
       MAX(station_id_integer_num), 
       COUNT(*) 
FROM station_data;

-- Check for any NULL values
SELECT COUNT(*) 
FROM station_data 
WHERE station_id_integer_num IS NULL;