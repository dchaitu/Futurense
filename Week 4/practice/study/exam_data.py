import pandas as pd, numpy as np

# Part A
s1 = pd.Series([1, 2, 3], index=["a", "b", "c"])
s2 = pd.Series([10, 20, 30], index=["b", "c", "d"])
t = pd.Series([5, 6, 7, 8], index=[3, 2, 1, 0])
g = pd.DataFrame({"k": ["A", "A", None, "B", None], "v": [1, 2, 3, 4, 5]})
m = pd.Series([1, 2, 3])

# Part B
employees = pd.DataFrame({
    "emp_id": range(1, 13),
    "name":   ["Asha", "Ravi", "Meera", "Kiran", "Neha", "Arjun", "Divya", "Sana", "Vikram", "Isha", "Rohan", "Tara"],
    "dept":   ["Eng", "Eng", "Eng", "Eng", "HR", "HR", "HR", "Sales", "Sales", "Sales", "Sales", "Ops"],
    "salary": [90, 120, 120, 70, 50, 65, 65, 60, 80, 80, 55, 48],
})
orders = pd.DataFrame({"order_id": range(1, 9), "cust_id": [1, 1, 2, 3, 3, 3, 5, 9],
                       "amount": [100, 250, 80, 300, 120, 60, 500, 40]})
customers = pd.DataFrame({"cust_id": [1, 2, 3, 4, 6], "cname": ["Asha", "Ravi", "Meera", "Kiran", "Neha"]})
logins = pd.DataFrame({
    "user": ["u1"] * 5 + ["u2"] * 4 + ["u3"] * 4,
    "date": ["2024-01-01", "2024-01-02", "2024-01-03", "2024-01-05", "2024-01-06",
             "2024-01-01", "2024-01-03", "2024-01-05", "2024-01-07",
             "2024-01-10", "2024-01-11", "2024-01-11", "2024-01-12"],
})
daily = pd.DataFrame({
    "date": pd.date_range("2024-01-01", periods=14, freq="D"),
    "rev":  [10, 12, 9, 15, 20, 18, 25, 30, 28, 22, 19, 35, 40, 38],
}).set_index("date")
sales = pd.DataFrame({
    "region":  ["N", "N", "N", "S", "S", "S", "E", "E"],
    "product": ["A", "B", "A", "A", "C", "C", "B", "A"],
    "units":   [5, 3, 2, 7, 4, 6, 8, 1],
})
wide = pd.DataFrame({"id": [1, 2], "math": [90, 80], "sci": [70, 60]})

# Part C
messy = pd.DataFrame({
    "name":   [" Asha ", "RAVI", "ravi", "Meera", None, "Kiran"],
    "age":    ["25", "thirty", "30", "-5", "41", "200"],
    "salary": ["₹50,000", "60000", "60000", "N/A", "75,000", "1,00,000"],
    "joined": ["2023-01-15", "15/02/2023", "15/02/2023", "2023-02-30", "2023-03-10", "2023-04-01"],
})

# Part D
events = pd.DataFrame({"user": list("aabbbc"), "status": list("xypqrz"), "ts": [1, 3, 2, 5, 4, 9]})
scores = pd.DataFrame({"team": list("AAABBB"), "score": [10, np.nan, 20, np.nan, np.nan, 30]})
tags = pd.DataFrame({"id": [1, 2, 3], "tags": ["a,b", "b", "c,a,b"]})
ages = pd.Series([5, 17, 18, 35, 64, 65, 90])
