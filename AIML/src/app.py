
from flask import Flask, request, jsonify

from predict_wait import predict_wait

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Queueless Random Forest Waiting Time Prediction API is running"
    })


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return jsonify({
            "error": "Request body must be a JSON object."
        }), 400

    required_fields = [
        "number_of_people",
        "counters_open",
        "avg_service_time",
        "time_of_day",
        "queue_type",
    ]

    missing_fields = [
        field for field in required_fields if field not in data
    ]

    if missing_fields:
        return jsonify({
            "error": "Missing required fields",
            "fields": missing_fields
        }), 400

    try:
        numeric_fields = [
            "number_of_people",
            "counters_open",
            "avg_service_time",
            "time_of_day",
        ]

        for field in numeric_fields:
            value = data[field]

            if isinstance(value, bool) or not isinstance(value, (int, float)):
                raise ValueError(f"{field} must be a number.")

        if not isinstance(data["queue_type"], str):
            raise ValueError("queue_type must be text.")

        result = predict_wait(
            number_of_people=data["number_of_people"],
            counters_open=data["counters_open"],
            avg_service_time=data["avg_service_time"],
            time_of_day=data["time_of_day"],
            queue_type=data["queue_type"],
        )

        return jsonify({
            "estimated_wait": result,
            "model": "Random Forest Regressor",
            "unit": "minutes"
        })

    except (ValueError, TypeError, FileNotFoundError) as error:
        return jsonify({"error": str(error)}), 400


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
