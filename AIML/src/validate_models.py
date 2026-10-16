
import pandas as pd
import numpy as np

from sklearn.model_selection import KFold
from sklearn.ensemble import RandomForestRegressor
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

df = pd.read_csv(
    "AIML/data/raw/queue_waiting_time_large_dataset.csv"
)

features = [
    "Number_of_People",
    "Counters_Open",
    "Avg_Service_Time",
    "Time_of_Day",
    "Queue_Type"
]

X = df[features]
y = df["Waiting_Time"]

# Simple mathematical estimate
formula = (
    X["Number_of_People"]
    * X["Avg_Service_Time"]
    / X["Counters_Open"]
)

preprocessor = ColumnTransformer(
    transformers=[
        ("queue_type", OneHotEncoder(handle_unknown="ignore"),
         ["Queue_Type"])
    ],
    remainder="passthrough"
)

def make_model():
    return Pipeline([
        ("preprocessor", preprocessor),
        ("model", RandomForestRegressor(
            n_estimators=200,
            min_samples_leaf=5,
            random_state=42
        ))
    ])

cv = KFold(n_splits=5, shuffle=True, random_state=42)

results = {"Formula": [], "Random Forest": []}

for train_idx, test_idx in cv.split(X):
    X_train, X_test = X.iloc[train_idx], X.iloc[test_idx]
    y_train, y_test = y.iloc[train_idx], y.iloc[test_idx]

    # Formula evaluated on the same test rows
    formula_predictions = formula.iloc[test_idx]

    # Random Forest evaluated on the same test rows
    model = make_model()
    model.fit(X_train, y_train)
    rf_predictions = model.predict(X_test)

    for name, predictions in [
        ("Formula", formula_predictions),
        ("Random Forest", rf_predictions)
    ]:
        results[name].append({
            "MAE": mean_absolute_error(y_test, predictions),
            "RMSE": np.sqrt(
                mean_squared_error(y_test, predictions)
            ),
            "R2": r2_score(y_test, predictions)
        })

for name, folds in results.items():
    scores = pd.DataFrame(folds)

    print(f"\n{name} — 5-fold results")
    print(scores.round(3).to_string(index=False))
    print("\nMean scores:")
    print(scores.mean().round(3).to_string())
