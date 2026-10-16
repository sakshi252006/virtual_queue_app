# Queueless — AIML Model Evaluation

## 1. Project Objective
Queueless aims to estimate queue waiting time using queue-related information.

## 2. Dataset
The larger dataset contains 5,000 records and includes:
- Number of people
- Number of counters open
- Average service time
- Time of day
- Queue type
- Waiting time

The units and real-world provenance of the waiting-time values still need verification.

## 3. Models Evaluated

| Model | MAE | RMSE | R² |
|---|---:|---:|---:|
| Average baseline | 355.83 | 611.34 | Approximately 0.000 |
| Linear Regression | 271.72 | 431.47 | 0.502 |
| Random Forest | 24.45 | 51.51 | 0.993 |
| Formula-based estimate | 15.28 | 17.10 | 0.999 |

The formula-based estimate is:

Estimated waiting time = (Number of people × Average service time) / Counters open

## 4. Cross-Validation
Five-fold cross-validation produced the following average errors:

- Formula-based estimate MAE: 15.367
- Formula-based estimate RMSE: 17.216
- Random Forest MAE: 24.181
- Random Forest RMSE: 54.250

The formula performed better on this dataset.

## 5. Prediction Function
The Python function is located at `src/predict_wait.py`.

It accepts:
- Number of people
- Number of counters open
- Average service time

It rejects negative people counts, negative service times, and zero or negative counter counts.

## 6. Testing
The following tests passed:
- Normal prediction
- Zero people
- Zero counters rejected
- Negative people rejected

## 7. Limitations
- Waiting-time units have not yet been verified.
- The dataset's real-world provenance has not yet been established.
- Strong performance on this dataset does not guarantee accurate predictions for real queues.
- Further validation is required before real-world deployment.