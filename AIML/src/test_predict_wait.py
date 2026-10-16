from predict_wait import predict_wait


def test_normal_prediction():
    result = predict_wait(100, 5, 8)
    assert result == 160.0
    print("PASS: Normal prediction")


def test_zero_people():
    result = predict_wait(0, 5, 8)
    assert result == 0.0
    print("PASS: Zero people")


def test_invalid_inputs():
    try:
        predict_wait(100, 0, 8)
        assert False, "Expected an error for zero counters"
    except ValueError:
        print("PASS: Zero counters rejected")

    try:
        predict_wait(-1, 5, 8)
        assert False, "Expected an error for negative people"
    except ValueError:
        print("PASS: Negative people rejected")


if __name__ == "__main__":
    test_normal_prediction()
    test_zero_people()
    test_invalid_inputs()
    print("All tests completed!")