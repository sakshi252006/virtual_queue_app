
import pandas as pd

df = pd.read_csv("AIML/data/raw/queue_data.csv")

df["arrival_time"] = pd.to_datetime(
    df["arrival_time"],
    format="%d-%m-%Y %H.%M",
    errors="coerce"
)

df["start_time"] = pd.to_datetime(
    df["start_time"],
    format="%d-%m-%Y %H.%M",
    errors="coerce"
)

df["actual_wait"] = (
    df["start_time"] - df["arrival_time"]
).dt.total_seconds() / 60

df = df.dropna(
    subset=["queue_length", "actual_wait"]
)
df = df[df["actual_wait"] >= 0]

print("Waiting time by queue length:")
summary = df.groupby("queue_length")["actual_wait"].agg(
    ["count", "mean", "std", "min", "max"]
)

print(summary.to_string())

print("\nOverall waiting-time standard deviation:")
print(round(df["actual_wait"].std(), 2), "minutes")

print("\nUnique queue lengths:")
print(df["queue_length"].nunique())

# Compare smaller and larger queues
df["queue_group"] = pd.cut(
    df["queue_length"],
    bins=[-float("inf"), 20, 35, float("inf")],
    labels=["Small (<=20)", "Medium (21-35)", "Large (>35)"]
)

print("\nWaiting time by queue group:")
print(
    df.groupby("queue_group", observed=False)["actual_wait"]
    .agg(["count", "mean", "median", "std"])
    .round(2)
)

# Save initial findings for the project report
report = """
QUEULESS - INITIAL DATA ANALYSIS

Dataset size: 560 records
Unique queue lengths: 18

Target:
Actual waiting time = start_time - arrival_time

Overall waiting-time standard deviation: 3.31 minutes

Average waiting time by queue group:
Small queues (<=20): 4.27 minutes
Medium queues (21-35): 4.63 minutes
Large queues (>35): 4.56 minutes

Model evaluation:
Average baseline MAE: 3.11 minutes
Linear Regression MAE: 3.13 minutes
Random Forest MAE: 3.21 minutes

Conclusion:
The tested features do not provide enough predictive
information for these models to outperform the baseline.
Further data investigation and additional features are needed.
"""

with open("AIML/initial_analysis_report.txt", "w", encoding="utf-8") as file:
    file.write(report.strip())

print("\nReport saved to AIML/initial_analysis_report.txt")
