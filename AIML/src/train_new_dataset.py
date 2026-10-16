
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.dummy import DummyRegressor
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline

# Load the new dataset
df = pd.read_csv(
    "AIML/data/raw/queue_waiting_time_large_dataset.csv"
)

# Inputs and target
features = [
    "Number_of_People",
    "Counters_Open",
    "Avg_Service_Time",
    "Time_of_Day",
    "Queue_Type"
]
target = "Waiting_Time"

X = df[features]
y = df[target]

# Encode queue type as a categorical feature
preprocessor = ColumnTransformer(
    transformers=[
        ("queue_type", OneHotEncoder(handle_unknown="ignore"),
         ["Queue_Type"])
    ],
    remainder="passthrough"
)

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

models = {
    "Average Baseline": DummyRegressor(strategy="mean"),
    "Linear Regression": Pipeline([
        ("preprocessor", preprocessor),
        ("model", LinearRegression())
    ]),
    "Random Forest": Pipeline([
        ("preprocessor", preprocessor),
        ("model", RandomForestRegressor(
            n_estimators=200,
            min_samples_leaf=5,
            random_state=42
        ))
    ])
}

for name, model in models.items():
    model.fit(X_train, y_train)
    predictions = model.predict(X_test)

    mae = mean_absolute_error(y_test, predictions)
    rmse = np.sqrt(mean_squared_error(y_test, predictions))
    r2 = r2_score(y_test, predictions)

    print(f"\n{name}")
    print(f"MAE:  {mae:.2f}")
    print(f"RMSE: {rmse:.2f}")
    print(f"R²:   {r2:.3f}")

# Compare the mathematical formula on the same test rows
formula_predictions = (
    X_test["Number_of_People"]
    * X_test["Avg_Service_Time"]
    / X_test["Counters_Open"]
)

formula_mae = mean_absolute_error(y_test, formula_predictions)
formula_rmse = np.sqrt(
    mean_squared_error(y_test, formula_predictions)
)
formula_r2 = r2_score(y_test, formula_predictions)

print("\nSimple Queue Formula")
print(f"MAE:  {formula_mae:.2f}")
print(f"RMSE: {formula_rmse:.2f}")
print(f"R²:   {formula_r2:.3f}")
