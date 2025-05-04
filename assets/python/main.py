import pickle
import sys
import json


def main():
    # Get input text from Flutter
    if len(sys.argv) > 1:
        extracted_text = sys.argv[1]
    else:
        # Read from stdin if no arguments provided
        extracted_text = sys.stdin.read().strip()

    # Load the preprocessing function
    with open("preprocess_text.pkl", "rb") as f:
        preprocess_text = pickle.load(f)

    # Process the text
    result = preprocess_text(extracted_text)

    # Return the result as JSON
    print(json.dumps(result))


if __name__ == "__main__":
    main()
