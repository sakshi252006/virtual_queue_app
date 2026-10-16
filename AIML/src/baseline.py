
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.dummy import DummyRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Load dataset
df = pd.read_csv("AIML/data/raw/queue_data.csv")

# Keep only the columns available for a basic arrival-time prediction
df = df[["queue_length", "wait_time"]].copy()

# Exclude impossible target values for this initial experiment.
# Keep the original CSV unchanged.
df = df[df["wait_time"] >= 0].dropna()

X = df[["queue_length"]]
y = df["wait_time"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Baseline predicts the training-set mean for every row
model = DummyRegressor(strategy="mean")
model.fit(X_train, y_train)

predictions = model.predict(X_test)

print("Rows used:", len(df))
print("Training rows:", len(X_train))
print("Test rows:", len(X_test))
print("Baseline MAE:", round(mean_absolute_error(y_test, predictions), 2), "minutes")
print(
    "Baseline RMSE:",
    round(np.sqrt(mean_squared_error(y_test, predictions)), 2),
    "minutes"
)
print("Baseline R2:", round(r2_score(y_test, predictions), 3))
