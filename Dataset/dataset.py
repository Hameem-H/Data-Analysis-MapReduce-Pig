import csv, random

N = 1000000

cities = ["Dhaka","Chittagong","Sylhet","Khulna","Rajshahi"]
ride_types = ["Bike","Car","CNG","Premium","Shared"]
payments = ["Cash","Card","Bkash","Nagad"]
days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]

with open("rides_big.csv", "w", newline="") as f:
    writer = csv.writer(f)

    for i in range(1, N + 1):
        city = random.choices(cities, weights=[50,20,10,10,10])[0]
        ride = random.choice(ride_types)

        # distance logic
        if ride == "Bike":
            distance = round(random.uniform(1, 8), 2)
        elif ride == "CNG":
            distance = round(random.uniform(2, 12), 2)
        elif ride == "Car":
            distance = round(random.uniform(3, 20), 2)
        elif ride == "Premium":
            distance = round(random.uniform(5, 25), 2)
        else:
            distance = round(random.uniform(1, 10), 2)

        # fare logic (simple model)
        base = {
            "Bike": 10,
            "CNG": 15,
            "Car": 25,
            "Premium": 40,
            "Shared": 8
        }

        fare = round(distance * base[ride] + random.uniform(2, 10), 2)

        writer.writerow([
            i,                                  # ride_id
            random.randint(1, 50000),           # driver_id
            random.randint(1, 200000),          # user_id
            city,
            ride,
            distance,
            fare,
            random.choice(payments),
            random.randint(0, 23),              # hour
            random.choice(days),
            random.choice([2022, 2023])
        ])