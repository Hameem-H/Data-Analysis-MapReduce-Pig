# Ride-Sharing Big Data Analysis (Hadoop + Pig + MapReduce)

This project performs large-scale data analysis on a synthetic ride-sharing dataset (1 million rows) using Apache Hadoop, Apache Pig, and Hadoop MapReduce (Java).

The dataset is artificially generated to simulate real-world ride-sharing activity across multiple cities, ride types, payment methods, and time patterns.

---

## Project Structure

```
BDA/
│
├── dataset/
│   └── dataset.py
│
├── Pig Scripts/
│   ├── anomaly.pig
│   ├── payment_distribution.pig
│   ├── peak_hour.pig
│   ├── ride_type_diversity.pig
│   └── top_drivers.pig
│
├── MapReduce/
│   ├── PeakHourPerCity.java
│   ├── PaymentByCity.java
│   ├── AvgFareByRideType.java
│   ├── TopDriversRevenue.java
│   ├── HighFareAnomaly.java (optional)
│
└── rides_big.csv
```

---

## Requirements

- Hadoop (configured)
- Apache Pig
- Java JDK 8 or higher
- Python 3

---

## Step 1: Generate Dataset

Navigate to dataset folder and run:

```
cd dataset
python dataset.py
```

This will generate:

```
rides_big.csv (1,000,000 rows)
```

---

## Step 2: Upload Dataset to HDFS

```
hdfs dfs -mkdir /labFinal
hdfs dfs -put rides_big.csv /labFinal/
```

---

## Step 3: Run Pig Scripts

Go to Pig Scripts folder:

```
cd "Pig Scripts"
```

Run any script:

```
pig peak_hour.pig
```

Or in local mode:

```
pig -x local peak_hour.pig
```

Output will be stored in:

```
output_folder/<analysis_name>
```

---

## Step 4: Compile MapReduce Java Files

Go to MapReduce folder:

```
cd MapReduce
```

Compile example:

```
javac -classpath "%HADOOP_HOME%\share\hadoop\common\*;%HADOOP_HOME%\share\hadoop\common\lib\*;%HADOOP_HOME%\share\hadoop\hdfs\*;%HADOOP_HOME%\share\hadoop\mapreduce\*" -d . PeakHourPerCity.java
```

Repeat for all Java files.

---

## Step 5: Create JAR Files

```
jar -cvf PeakHourPerCity.jar -C . .
jar -cvf PaymentByCity.jar -C . .
jar -cvf AvgFareByRideType.jar -C . .
jar -cvf TopDriversRevenue.jar -C . .
jar -cvf HighFareAnomaly.jar -C . .
```

---

## Step 6: Run MapReduce Jobs

Before running any job, delete old output folder:

```
hdfs dfs -rm -r /PeakHourPerCityOutput
```

Run jobs:

Peak Hour Per City:
```
hadoop jar PeakHourPerCity.jar PeakHourPerCity /labFinal/rides_big.csv /PeakHourPerCityOutput
```

Payment Distribution:
```
hadoop jar PaymentByCity.jar PaymentByCity /labFinal/rides_big.csv /PaymentByCityOutput
```

Average Fare:
```
hadoop jar AvgFareByRideType.jar AvgFareByRideType /labFinal/rides_big.csv /AvgFareOutput
```

Top Drivers:
```
hadoop jar TopDriversRevenue.jar TopDriversRevenue /labFinal/rides_big.csv /TopDriversOutput
```

High Fare Anomaly (optional):
```
hdfs dfs -rm -r /HighFareAnomalyOutput
hadoop jar HighFareAnomaly.jar HighFareAnomaly /labFinal/rides_big.csv /HighFareAnomalyOutput
```

---

## View Output

```
hdfs dfs -cat /PeakHourPerCityOutput/part-r-00000
```

---

## Analysis Performed

- Peak ride demand hour per city  
- Payment method distribution  
- Average fare per ride type  
- Top drivers by revenue  
- Ride type diversity (Pig)  
- High fare anomaly detection  

---

## Notes

- Output directory must not exist before running MapReduce
- Pig provides faster and simpler development
- MapReduce provides deeper control over execution
- Dataset is synthetic but designed to resemble real-world patterns

---

## Summary

This project compares two approaches:

- Pig (high-level, SQL-like)
- MapReduce (low-level, Java-based)

Both run on Hadoop and use HDFS for scalable data processing.
