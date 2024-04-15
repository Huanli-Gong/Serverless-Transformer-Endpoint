import tempfile
from transformers import pipeline
import os

# Load the sentiment analysis model
pipe = pipeline("text-classification")

# Set the temporary directory
tempfile.tempdir = "/tmp"
os.environ["TRANSFORMERS_CACHE"] = "/tmp"


def lambda_handler(event, context):
    # Get input text from the event
    input_text = event.get("input_text", "")

    # Perform sentiment analysis
    result = pipe(input_text)

    # Return the result
    return {
        "statusCode": 200,
        "body": result[0],
    }


if __name__ == "__main__":
    import sys

    # Check if any command line argument is provided
    if len(sys.argv) > 1:
        input_text = sys.argv[1]
    else:
        input_text = "Input the text"

    # Setting a dummy context
    context = {}
    # Create an event dictionary
    event = {"input_text": input_text}
    # Call the lambda handler
    result = lambda_handler(event, context)
    print(result)
