
import json
import sys

from predict_wait import predict_wait


def main():
    try:
        data = json.load(sys.stdin)

        required = [
            "number_of_people",
            "counters_open",
            "avg_service_time",
            "time_of_day",
            "queue_type",
        ]

        missing = [key for key in required if key not in data]
        if missing:
            raise ValueError(
                "Missing required fields: " + ", ".join(missing)
            )

        result = predict_wait(
            number_of_people=data["number_of_people"],
            counters_open=data["counters_open"],
            avg_service_time=data["avg_service_time"],
            time_of_day=data["time_of_day"],
            queue_type=data["queue_type"],
        )

        print(json.dumps({"estimated_wait": result}))

    except (ValueError, TypeError, KeyError, FileNotFoundError) as exc:
        print(json.dumps({"error": str(exc)}))
        sys.exit(1)


if __name__ == "__main__":
    main()
