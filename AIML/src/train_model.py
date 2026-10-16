
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Load dataset
df = pd.read_csv("AIML/data/raw/queue_data.csv")

# Parse timestamps
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



# Calculate actual waiting time
df["actual_wait"] = (
    df["start_time"] - df["arrival_time"]
).dt.total_seconds() / 60

# Check relationships with actual waiting time
df["arrival_minutes"] = (
    df["arrival_time"].dt.hour * 60
    + df["arrival_time"].dt.minute
)

# Check how features relate to actual waiting time
df["arrival_minutes"] = (
    df["arrival_time"].dt.hour * 60
    + df["arrival_time"].dt.minute
)

print("\nCorrelation with actual waiting time:")
print(
    df[[
        "queue_length",
        "arrival_minutes",
        "actual_wait"
    ]].corr()["actual_wait"]
)


# Clean invalid rows
df = df.dropna(subset=[
    "arrival_time", "start_time", "queue_length", "actual_wait"
])
df = df[df["actual_wait"] >= 0].copy()
df = df.dropna(subset=[
    "arrival_time", "start_time", "queue_length", "actual_wait"
])
df = df[df["actual_wait"] >= 0].copy()
# Create arrival-time features
df["arrival_hour"] = df["arrival_time"].dt.hour
df["arrival_minute"] = df["arrival_time"].dt.minute

# Input features and prediction target
X = df[["queue_length", "arrival_hour", "arrival_minute"]]
y = df["actual_wait"]

# Split into training and testing data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Baseline: always predict the training-set average
baseline_predictions = np.full(
    len(y_test), y_train.mean()
)

baseline_mae = mean_absolute_error(
    y_test, baseline_predictions
)

baseline_rmse = np.sqrt(
    mean_squared_error(y_test, baseline_predictions)
)

baseline_r2 = r2_score(
    y_test, baseline_predictions
)

print("\nAverage-Wait Baseline")
print(f"MAE:  {baseline_mae:.2f} minutes")
print(f"RMSE: {baseline_rmse:.2f} minutes")
print(f"R²:   {baseline_r2:.3f}")

# Models to compare
models = {
    "Linear Regression": LinearRegression(),
    "Random Forest": RandomForestRegressor(
        n_estimators=200,
        random_state=42,
        min_samples_leaf=5
    )
}

# Train and evaluate
for name, model in models.items():
    model.fit(X_train, y_train)
    predictions = model.predict(X_test)

    mae = mean_absolute_error(y_test, predictions)
    rmse = np.sqrt(mean_squared_error(y_test, predictions))
    r2 = r2_score(y_test, predictions)

    print(f"\n{name}")
    print(f"MAE:  {mae:.2f} minutes")
    print(f"RMSE: {rmse:.2f} minutes")
    print(f"R²:   {r2:.3f}")
