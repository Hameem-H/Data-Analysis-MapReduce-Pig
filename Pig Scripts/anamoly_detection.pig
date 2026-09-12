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

calc = FOREACH data GENERATE
    ride_id,
    city,
    ride_type,
    fare,
    distance,
    (fare / distance) AS fare_per_km;

grp = GROUP calc ALL;

stats = FOREACH grp GENERATE
    AVG(calc.fare_per_km) AS avg_fpk;

joined = CROSS calc, stats;

anomaly = FILTER joined BY calc::fare_per_km > (stats::avg_fpk * 2);

result = FOREACH anomaly GENERATE
    calc::ride_id,
    calc::city,
    calc::ride_type,
    calc::fare_per_km;

DUMP result;
STORE result INTO 'output_folder/anamoly' USING PigStorage(',');