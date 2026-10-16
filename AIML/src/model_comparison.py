
import pandas as pd

results = pd.DataFrame([
    {
        "Approach": "Average Baseline",
        "MAE": 355.83,
        "RMSE": 611.34,
        "R2": -0.000
    },
    {
        "Approach": "Linear Regression",
        "MAE": 271.72,
        "RMSE": 431.47,
        "R2": 0.502
    },
    {
        "Approach": "Random Forest",
        "MAE": 24.45,
        "RMSE": 51.51,
        "R2": 0.993
    },
    {
        "Approach": "Simple Queue Formula",
        "MAE": 15.28,
        "RMSE": 17.10,
        "R2": 0.999
    }
])

print(results.to_string(index=False))

results.to_csv(
    "AIML/model_comparison_results.csv",
    index=False
)

print("\nResults saved to AIML/model_comparison_results.csv")
