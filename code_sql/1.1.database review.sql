                                  -- PROJECT REVIEW AND INITIALIZATION --


/* 
This project will perform an Analysis of the NYC rental bike system giving insights in patters that can may be considered
and how this insights cam lead to performs optimizations that would improve the client experience 
*/


/*
 SOURCES : I found the databse in BigQuery public databses and download the tables as csv files, I have and I'll manage 
it with postgresql of pgadmin
*/


-- bike_station_info table :  All bike stations with information such as 
SELECT * FROM station_data LIMIT 100;



-- bike_trip_big_data_500k :  500k records of trips with company bikes 
SELECT * FROM bike_trips_data LIMIT 100;




