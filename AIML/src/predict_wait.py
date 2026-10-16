
def predict_wait(number_of_people, counters_open, avg_service_time):
    """Estimate waiting time using a simple queue formula."""

    if number_of_people < 0:
        raise ValueError("Number of people cannot be negative.")

    if counters_open <= 0:
        raise ValueError("At least one counter must be open.")

    if avg_service_time < 0:
        raise ValueError("Service time cannot be negative.")

    estimated_wait = (
        number_of_people * avg_service_time / counters_open
    )

    return round(estimated_wait, 2)


if __name__ == "__main__":
    result = predict_wait(
        number_of_people=100,
        counters_open=5,
        avg_service_time=8
    )

    print({"estimated_wait": result})
