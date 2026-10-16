
import json
import sys

from predict_wait import predict_wait


def main():
    try:
        request = json.load(sys.stdin)

        result = predict_wait(
            number_of_people=request["number_of_people"],
            counters_open=request["counters_open"],
            avg_service_time=request["avg_service_time"],
        )

        print(json.dumps({"estimated_wait": result}))

    except (KeyError, TypeError, ValueError) as error:
        print(json.dumps({"error": str(error)}))
        sys.exit(1)


if __name__ == "__main__":
    main()
