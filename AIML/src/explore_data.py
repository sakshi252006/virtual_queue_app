
import pandas as pd

df = pd.read_csv("AIML/data/raw/queue_data.csv")

# Parse timestamps
for column in ["arrival_time", "start_time"]:
    normalized = df[column].astype(str).str.replace(
        r" (\d{1,2})\.(\d{2})$",
        r" \1:\2",
        regex=True
    )
    df[column] = pd.to_datetime(
        normalized,
        format="%d-%m-%Y %H:%M",
        errors="coerce"
    )

df["finish_time"] = pd.to_datetime(
    df["finish_time"],
    errors="coerce"
)

# Calculate elapsed time from timestamps
df["calculated_wait"] = (
    df["start_time"] - df["arrival_time"]
).dt.total_seconds() / 60

print("\n--- WAIT TIME DISTRIBUTION ---")
print(df["wait_time"].describe())

print("\n--- WAIT TIME BY QUEUE LENGTH ---")
print(
    df.groupby("queue_length")["wait_time"]
    .agg(["count", "mean", "median", "min", "max"])
    .round(2)
    .to_string()
)

print("\n--- ROWS PER ARRIVAL TIME ---")
print(
    df.groupby("arrival_time").size()
    .sort_values(ascending=False)
    .head(10)
    .to_string()
)

print("\n--- WAITING TIME CORRELATIONS ---")
print(
    df[["wait_time", "queue_length", "calculated_wait"]]
    .corr()
    .round(3)
    .to_string()
)

print("\n--- VALIDATION COMPLETE ---")
print("Original CSV was not modified.")
