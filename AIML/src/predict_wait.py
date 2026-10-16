
from pathlib import Path
import pickle
import pandas as pd

MODEL_PATH = (
    Path(__file__).resolve().parents[1]
    / "models"
    / "random_forest_waiting_time.pkl"
)

FEATURES = [
    "Number_of_People",
    "Counters_Open",
    "Avg_Service_Time",
    "Time_of_Day",
    "Queue_Type",
]


def predict_wait(
    number_of_people,
    counters_open,
    avg_service_time,
    time_of_day,
    queue_type,
):
    if number_of_people < 0:
        raise ValueError("Number of people cannot be negative.")
    if counters_open <= 0:
        raise ValueError("At least one counter must be open.")
    if avg_service_time < 0:
        raise ValueError("Service time cannot be negative.")
    if not 0 <= time_of_day <= 23:
        raise ValueError("Time of day must be between 0 and 23.")
    if not isinstance(queue_type, str) or not queue_type.strip():
        raise ValueError("Queue type must be provided.")

    if not MODEL_PATH.exists():
        raise FileNotFoundError(
            f"Trained Random Forest model not found: {MODEL_PATH}"
        )

    with MODEL_PATH.open("rb") as file:
        model = pickle.load(file)

    data = pd.DataFrame([{
        "Number_of_People": number_of_people,
        "Counters_Open": counters_open,
        "Avg_Service_Time": avg_service_time,
        "Time_of_Day": time_of_day,
        "Queue_Type": queue_type,
    }], columns=FEATURES)

    prediction = float(model.predict(data)[0])
    return round(max(0.0, prediction), 2)


if __name__ == "__main__":
    result = predict_wait(
        number_of_people=100,
        counters_open=5,
        avg_service_time=8,
        time_of_day=14,
        queue_type="Hospital",
    )
    print({"estimated_wait": result})
