# Use Python 3.9-slim as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Python script and requirements file into the container
COPY app.py requirements.txt /app/

# Install dependencies from the requirements file
RUN pip install --no-cache-dir -r requirements.txt

# Download the AWS Lambda RIE
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Provide execute permissions for the AWS Lambda RIE
RUN chmod +x /usr/local/bin/aws-lambda-rie

# Specify the entrypoint as the AWS Lambda RIE
ENTRYPOINT [ "/usr/local/bin/aws-lambda-rie" ]

# Set the command to invoke the handler using the AWS Lambda RIC
CMD [ "/usr/local/bin/python", "-m", "awslambdaric", "sentiment.lambda_handler" ]

