
from flask import Flask, request, jsonify

from predict_wait import predict_wait

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Queueless Waiting Time Prediction API is running"
    })


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return jsonify({"error": "Request body must be a JSON object."}), 400

    required_fields = [
        "number_of_people",
        "counters_open",
        "avg_service_time",
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
        values = [
            data["number_of_people"],
            data["counters_open"],
            data["avg_service_time"],
        ]

        if any(
            isinstance(value, bool)
            or not isinstance(value, (int, float))
            for value in values
        ):
            raise ValueError("All input values must be numbers.")

        result = predict_wait(*values)

        return jsonify({"estimated_wait": result})

    except (ValueError, TypeError) as error:
        return jsonify({"error": str(error)}), 400


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
