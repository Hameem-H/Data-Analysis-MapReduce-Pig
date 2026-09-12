data = LOAD 'rides_big.csv' USING PigStorage(',')
AS (
    ride_id:long,
    driver_id:int,
    user_id:int,
    city:chararray,
    ride_type:chararray,
    distance:double,
    fare:double,
    payment:chararray,
    hour:int,
    day:chararray,
    year:int
);

grp = GROUP data BY driver_id;

driver_rev = FOREACH grp GENERATE
    group AS driver_id,
    SUM(data.fare) AS total_revenue;

sorted = ORDER driver_rev BY total_revenue DESC;

top10 = LIMIT sorted 10;

DUMP top10;

STORE top10 INTO 'output_folder/top_10_drivers' USING PigStorage(',');