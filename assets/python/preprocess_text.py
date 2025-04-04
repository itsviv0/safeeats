import pickle
import sys
import json


def process_text(text):
    # Load the pickle file
    with open("preprocess_text.pkl", "rb") as f:
        preprocess_text = pickle.load(f)

    # Process the text
    output = preprocess_text(text)

    print(json.dumps(output))


if __name__ == "__main__":
    # Get input text from command line arguments
    if len(sys.argv) > 1:
        process_text(sys.argv[1])
