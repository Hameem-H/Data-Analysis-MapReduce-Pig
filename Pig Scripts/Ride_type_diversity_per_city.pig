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

grp = GROUP data BY (city, ride_type);

counts = FOREACH grp GENERATE
    group.city AS city,
    group.ride_type AS ride_type,
    COUNT(data) AS cnt;

city_total = GROUP counts BY city;

totals = FOREACH city_total GENERATE
    group AS city,
    SUM(counts.cnt) AS total;

joined = JOIN counts BY city, totals BY city;

share = FOREACH joined GENERATE
    counts::city AS city,
    counts::ride_type AS ride_type,
    (double)counts::cnt / totals::total AS p;

sq = FOREACH share GENERATE
    city,
    p * p AS sq_val;

grp2 = GROUP sq BY city;

hhi = FOREACH grp2 GENERATE
    group AS city,
    SUM(sq.sq_val) AS hhi_index;

DUMP hhi;
STORE hhi INTO 'output_folder/ride_type_diversity' USING PigStorage(',');