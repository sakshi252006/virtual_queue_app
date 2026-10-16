
from pathlib import Path
import pickle

import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.dummy import DummyRegressor
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline


# Locate files relative to this Python script
AIML_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = AIML_DIR / "Data" / "raw" / "queue_waiting_time_large_dataset.csv"
MODEL_DIR = AIML_DIR / "models"
MODEL_PATH = MODEL_DIR / "random_forest_waiting_time.pkl"

FEATURES = [
    "Number_of_People",
    "Counters_Open",
    "Avg_Service_Time",
    "Time_of_Day",
    "Queue_Type",
]
TARGET = "Waiting_Time"


def main():
    if not DATA_PATH.exists():
        raise FileNotFoundError(f"Dataset not found: {DATA_PATH}")

    df = pd.read_csv(DATA_PATH)

    required_columns = FEATURES + [TARGET]
    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing dataset columns: {missing}")

    df = df[required_columns].dropna().copy()

    if df.empty:
        raise ValueError("No complete rows remain after removing missing values.")

    if (df["Counters_Open"] <= 0).any():
        raise ValueError("Counters_Open must be greater than zero.")

    X = df[FEATURES]
    y = df[TARGET]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    def make_pipeline(model):
        preprocessor = ColumnTransformer(
            transformers=[
                (
                    "queue_type",
                    OneHotEncoder(handle_unknown="ignore"),
                    ["Queue_Type"],
                )
            ],
            remainder="passthrough",
        )
        return Pipeline([
            ("preprocessor", preprocessor),
            ("model", model),
        ])

    # Evaluate against a simple baseline on the same test rows
    baseline = DummyRegressor(strategy="mean")
    baseline.fit(X_train, y_train)
    baseline_predictions = baseline.predict(X_test)

    # Evaluate Random Forest
    rf = make_pipeline(
        RandomForestRegressor(
            n_estimators=200,
            min_samples_leaf=5,
            random_state=42,
            n_jobs=-1,
        )
    )
    rf.fit(X_train, y_train)
    predictions = rf.predict(X_test)

    print(f"Dataset rows used: {len(df)}")
    print(f"Training rows: {len(X_train)}")
    print(f"Test rows: {len(X_test)}")

    print("\nBaseline (mean prediction)")
    print(f"MAE:  {mean_absolute_error(y_test, baseline_predictions):.2f}")
    print(f"RMSE: {np.sqrt(mean_squared_error(y_test, baseline_predictions)):.2f}")
    print(f"R2:   {r2_score(y_test, baseline_predictions):.3f}")

    print("\nRandom Forest Regressor")
    print(f"MAE:  {mean_absolute_error(y_test, predictions):.2f}")
    print(f"RMSE: {np.sqrt(mean_squared_error(y_test, predictions)):.2f}")
    print(f"R2:   {r2_score(y_test, predictions):.3f}")

    # Train the final model on all available rows before saving
    final_model = make_pipeline(
        RandomForestRegressor(
            n_estimators=200,
            min_samples_leaf=5,
            random_state=42,
            n_jobs=-1,
        )
    )
    final_model.fit(X, y)

    MODEL_DIR.mkdir(parents=True, exist_ok=True)
    with MODEL_PATH.open("wb") as file:
        pickle.dump(final_model, file)

    print(f"\nSaved trained Random Forest model to:\n{MODEL_PATH}")


if __name__ == "__main__":
    main()

