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

grp = GROUP data BY (city, payment);

counts = FOREACH grp GENERATE
    group.city AS city,
    group.payment AS payment,
    COUNT(data) AS total;

sorted = ORDER counts BY city, total DESC;

DUMP sorted;

STORE sorted INTO 'output_folder/payment_method_distribution' USING PigStorage(',');