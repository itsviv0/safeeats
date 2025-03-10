import sys
import json
import pickle


def process_ingredients(ingredients):
    # Load your pickle model
    with open("lib/models/ingredients_split.pkl", "rb") as f:
        model = pickle.load(f)

    # Process ingredients using your model
    processed = model.predict(ingredients)  # Modify according to your model

    return processed


if __name__ == "__main__":
    # Read ingredients from JSON file
    input_file = sys.argv[1]
    with open(input_file, "r") as f:
        ingredients = json.load(f)

    # Process ingredients
    processed = process_ingredients(ingredients)

    # Output results as JSON
    print(json.dumps(processed))
