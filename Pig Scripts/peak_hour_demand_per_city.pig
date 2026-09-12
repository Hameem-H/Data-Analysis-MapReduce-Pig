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
grp = GROUP data BY (city, hour);

counts = FOREACH grp GENERATE
    group.city AS city,
    group.hour AS hour,
    COUNT(data) AS total;

by_city = GROUP counts BY city;

peak = FOREACH by_city {
    sorted = ORDER counts BY total DESC;
    top = LIMIT sorted 1;
    GENERATE FLATTEN(top);
};

DUMP peak;

STORE peak INTO 'output_folder/peak_hour' USING PigStorage(',');